defmodule Familiada.GameChannel do
  use Familiada.Web, :channel
  alias Familiada.GameState

  # This room_id is available under socket.topic
  def join(room_id, p, socket) do
    # TODO: authentication
    # Assigns user to socket - It will be recognized by this
    socket = assign(socket, :player, p["player"])
    game_state = GameState.update(socket.topic, player(socket)["id"], "player_joined", [player(socket)])
    send(self, :after_join)
    {:ok, game_state, socket}
  end

  def handle_info(:after_join, socket) do
   game_state = GameState.get_room(socket.topic)
   broadcast socket, "back:modelUpdate", %{ model: game_state }
   {:noreply, socket}
 end

  def leave(_reason, socket) do
    game_state = GameState.update(socket.topic, player(socket)["id"], "player_left")
    broadcast socket, "back:modelUpdate", %{ model: game_state }
    {:ok, socket}
  end

  def handle_in("modelUpdateCmd", cmd, socket) do
    # TODO: Check if action authorized given user and state - which layer?
    game_state = GameState.update(socket.topic, player(socket)["id"], cmd["cmd"], cmd["params"])
    broadcast socket, "back:modelUpdate", %{ model: game_state }
    {:noreply, socket}
  end

  #### #### #### #### ####

  defp player(socket) do
    socket.assigns.player
  end

  defp authorized?(_payload) do
    true
  end
end

defmodule Familiada.GameState do
  import Exredis
  alias Familiada.GameActions

  def update(room_id, player_id, action_name, action_params \\ []) do
    IO.puts "^^^^^^^^^ #{action_name}"
    # NOTE: You should never symbolize user provided strings
    room = get_room(room_id)
    # This is required because from Elm we get actions in CamelizedFormat
    underscored_action = Mix.Utils.underscore(action_name)
    if Enum.member?(allowed_actions, underscored_action) do
      action = String.to_atom(underscored_action) # change to symbol so can be dynamically called
      new_room = apply(GameActions, action, [room | [player_id | action_params]]) # dynamic action call
      set_room(new_room, room_id)
      new_room
    else
      room
    end
  end

  # This uses Redis as depencency so I would need to change it probably
  def get_room(room_id) do
     room = start_link |> elem(1) |> query ["GET", room_id]
     room != :undefined && Poison.decode!(room) || initial_model
  end
  # NOTE: This should be in sync with BackendActions in Elm
  defp allowed_actions do
    [ "player_joined",
      "player_left",
      "toogle_player_ready",
      "start_game"
    ]
  end
  #### #### #### #### ####
  defp set_room(room, room_id) do
    start_link |> elem(1) |> query ["SET", room_id, Poison.encode!(room)]
  end

  defp initial_model do
    %{
      mode: "WaitingForPlayers",
      user: %{id: 1, name: "Anonymouse", ready: false},
      playersList: [],
      readyQueue: []
    }
  end
end

defmodule Familiada.GameActions do
  # Here we should have GameActions which should be similar to game actions on Frontend
  # Although here we are concerned about authorization and changing game model only
  # On frontend we are concerned about displaying this model and dispatching actions as update_cmd
  alias Familiada.Utils

  def player_joined(model, player_id, player) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList", Utils.uniq_add(playersList, player))
  end

  def player_left(model, player_id, player) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList",  Utils.without(playersList, player))
  end

  def toogle_player_ready(model, player_id) do
    playersList = Dict.get(model, "playersList", [])
    set_ready = fn(p) ->
      if p["id"] == player_id do
        Dict.put(p, "ready", !Dict.get(p, "ready"))
      else
        p
      end
    end
    nplayersList = Enum.map(playersList, set_ready)
    Dict.put(model, "playersList", nplayersList)
  end

  defp get_game_id(model) do
    next_game_id = Dict.get(model, "nextGameId", 0)
    Dict.put(model, "nextGameId", next_game_id + 1)
  end

  def start_game(model, player_id) do
    readyQueue = Dict.get(model, "readyQueue", []) # rigid 2 players
    if [red_team_player, blue_team_player] = readyQueue do
      Dict.put(model, "redTeam", [red_team_player]) |> Dict.put("blueTeam", [blue_team_player])
    else
      model
    end
  end
end

defmodule Familiada.Utils do
  # Required
  def uniq_add(list, x) do
    ids = Enum.map(list, fn(r) -> r["id"] end)
    if Enum.member?(ids, x["id"] || x) do
      list
    else
      [x | list]
    end
  end

  def without(enumerable, to_remove) do
    Enum.filter(enumerable, fn(x) -> x != to_remove end)
  end
end

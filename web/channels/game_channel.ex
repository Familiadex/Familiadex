defmodule Familiada.GameChannel do
  use Familiada.Web, :channel
  alias Familiada.GameState

  # This room_id is available under socket.topic
  def join(room_id, p, socket) do
    # TODO: authentication
    # Assigns user to socket - It will be recognized by this
    socket = assign(socket, :player_id, p["player_id"])
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
   game_state = GameState.update(socket.topic, "player_joined", [player_id(socket)])
   broadcast socket, "back:modelUpdate", %{ model: game_state }
   {:noreply, socket}
 end

  def leave(_reason, socket) do
    game_state = GameState.update(socket.topic, "player_left", [player_id(socket)])
    broadcast socket, "back:modelUpdate", %{ model: game_state }
    {:ok, socket}
  end

  def handle_in("modelUpdateCmd", cmd, socket) do
    # TODO: Check if action authorized given user and state - which layer?
    game_state = GameState.update(socket.topic, cmd["cmd"], cmd["params"])
    broadcast socket, "back:modelUpdate", %{ model: game_state }
    {:noreply, socket}
  end

  #### #### #### #### ####

  defp player_id(socket) do
    socket.assigns.player_id
  end

  defp authorized?(_payload) do
    true
  end
end

defmodule Familiada.GameState do
  import Exredis
  alias Familiada.GameActions

  def update(room_id, action_name, action_params) do
    # NOTO: You should never symbolize user provided strings
    room = get_room(room_id)
    if Enum.member?(allowed_actions, action_name) do
      new_room = apply(GameActions, String.to_atom(action_name), [room | action_params])
      set_room(new_room, room_id)
      new_room
    else
      room
    end
  end

  # This uses redis as depencency so I would need to change it probably
  def get_room(room_id) do
     room = start_link |> elem(1) |> query ["GET", room_id]
     room != :undefined && Poison.decode!(room) || %{}
  end
  # TODO: me
  defp allowed_actions do
    [ "player_joined",
      "player_left",
      "set_player_ready",
      "set_player_not_ready",
      "start_game"
    ]
  end
  #### #### #### #### ####
  defp set_room(room, room_id) do
    start_link |> elem(1) |> query ["SET", room_id, Poison.encode!(room)]
  end
end

defmodule Familiada.GameActions do
  # Here we should have GameActions which should be similar to game actions on Frontend
  # Although here we are concerned about authorization and changing game model only
  # On frontend we are concerned about displaying this model and dispatching actions as update_cmd
  alias Familiada.Utils

  def player_joined(model, player_id) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList", Utils.uniq_add(playersList, player_id))
  end

  def player_left(model, player_id) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList",  Utils.without_id(playersList, player_id))
  end

  def set_player_ready(model, player_id) do
    readyQueue = Dict.get(model, "readyQueue", [])
    Dict.put(model, "readyQueue", Utils.uniq_add(readyQueue, player_id))
  end

  def set_player_not_ready(model, player_id) do
    readyQueue = Dict.get(model, "readyQueue", [])
    Dict.put(model, "readyQueue", Utils.without_id(readyQueue, player_id))
  end

  defp get_game_id(model) do
    next_game_id = Dict.get(model, "nextGameId", 0)
    Dict.put(model, "nextGameId", next_game_id + 1)
  end

  def start_game(model) do
    readyQueue = Dict.get(model, "readyQueue", []) # rigid 2 players
    if [red_team_player, blue_team_player] = readyQueue do
      Dict.put(model, "redTeam", [red_team_player]) |> Dict.put("blueTeam", [blue_team_player])
    else
      model
    end
  end
end

defmodule Familiada.Utils do
  def uniq_add(list, id) do
    if Enum.member?(list, id) do
      list
    else
      [id | list]
    end
  end

  def without_id(enumerable, id_to_remove) do
    Enum.filter(enumerable, fn(id) -> id != id_to_remove end)
  end
end

# DOCS: http://www.phoenixframework.org/docs/channels
defmodule Familiada.GameChannel do
  # TODO: This is macro that add some properties to module changing into PhoenixChannel
  use Familiada.Web, :channel
  # We can refer to Familiada.Gamestate with just GameState in this Familiada.GameChannel module
  alias Familiada.GameState

  # This room_id is available under socket.topic
  # This is called when users uses "join" on channel
  # In our case we connect to game channel in "web/static/js/app.js"
  # Where we import import socket from "./socket" that contains socket connecting API
  # ex. let game = socket.channel("games:GAME_ID", {player: currentUser});
  # This is then routed here based on "web/channels/user_socket.ex" routing
  # ex. channel "games:*", Familiada.GameChannel # routes games:GAME_ID here as room_id
  def join(room_id, payload, socket) do
    # TODO: authentication
    # http://hexdocs.pm/phoenix/Phoenix.Socket.html#assign/3
    # Assign user sent from frontend to given socket connection
    socket = assign(socket, :player, payload["player"])
    # FIXME: Adding ready to play in
    proper_player = Dict.put(player(socket), "ready", :false)
    game_state = GameState.update(socket.topic, player(socket)["id"], "player_joined", [proper_player])
    game_state = Dict.put(game_state, "user_id", player(socket)["id"])
    # Callback to action that should happen after users join game room
    send(self, :after_join)
    {:ok, game_state, socket}
  end
  # Dunno why we have to do this, but basically it's because of internal socket implementation
  # First connection must be enstablished before we can broadcast, so this is just action that
  # is called after we establish connection with join http://hexdocs.pm/phoenix/Phoenix.Channel.html#c:handle_info/2
  def handle_info(:after_join, socket) do
   game_state = GameState.get_room(socket.topic)
   broadcast socket, "back:modelUpdate", %{ model: game_state }
   {:noreply, socket}
  end

  # We intercept "back:modelUpdate" action that's broadcasted to all open sockets
  # This way we can customize this action with handle_out
  # http://hexdocs.pm/phoenix/Phoenix.Channel.html#intercept/1
  intercept ["back:modelUpdate"]
  def handle_out("back:modelUpdate", msg, socket) do
    model = Dict.get(msg, :model)
    IO.puts "HANDLE_OUT ***** #{Poison.encode! model}"
    user_model = Dict.put(model, "user_id", player(socket)["id"])
    customized_msg = Dict.put(msg, :model, user_model)
    push socket, "back:modelUpdate", customized_msg
    {:noreply, socket}
  end

  # TO CONFIRM: Action that happens when users leaves socket ?
  def leave(_reason, socket) do
    game_state = GameState.update(socket.topic, player(socket)["id"], "player_left")
    broadcast socket, "back:modelUpdate", %{ model: game_state }
    {:ok, socket}
  end

  # There we handle actions from frontend
  # They send us cmd = %{cmd: cmdName, params[strings]}
  def handle_in("modelUpdateCmd", cmd, socket) do
    # TODO: Check if action authorized given user and state - which layer?
    game_state = GameState.update(socket.topic, player(socket)["id"], cmd["cmd"], cmd["params"])
    broadcast socket, "back:modelUpdate", %{ model: game_state }
    {:noreply, socket}
  end

  #### #### HELPERS #### ####
  # Retrive player from socke
  defp player(socket) do
    socket.assigns.player
  end
  # TODO: Implement this
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
      user_id: 0,
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

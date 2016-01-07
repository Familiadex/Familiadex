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
    game_state = GameState.update(socket.topic, player(socket), "player_joined")
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
    user_model = Dict.put(model, "user_id", player(socket)["id"])
    customized_msg = Dict.put(msg, :model, user_model)
    push socket, "back:modelUpdate", customized_msg
    {:noreply, socket}
  end

  # TO CONFIRM: Action that happens when users leaves socket ?
  def terminate(_reason, socket) do
    game_state = GameState.update(socket.topic, player(socket), "player_left")
    broadcast socket, "back:modelUpdate", %{ model: game_state }
    {:ok, socket}
  end

  # There we handle actions from frontend
  # They send us cmd = %{cmd: cmdName, params[strings]}
  def handle_in("modelUpdateCmd", cmd, socket) do
    # TODO: Check if action authorized given user and state - which layer?
    if cmd["cmd"] == "NoAction" do
      {:noreply, socket}
    else
      game_state = GameState.update(socket.topic, player(socket), cmd["cmd"], cmd["params"])
      broadcast socket, "back:modelUpdate", %{ model: game_state }
      {:noreply, socket}
    end
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
  alias Familiada.GameModel
  alias Familiada.Actions
  alias Familiada.Reactions

  def update(room_id, player, action_name, action_params \\ []) do
    IO.puts "^^^^^^^^^ #{action_name}"
    # NOTE: You should never symbolize user provided strings
    game_model = get_room(room_id)
    # This is required because from Elm we get actions in CamelizedFormat
    underscored_action = Mix.Utils.underscore(action_name)
    if Actions.allowed(underscored_action, game_model) do
      action = String.to_atom(underscored_action) # change to symbol so can be dynamically called
      updated_model = apply(Reactions, action, [game_model | [player | action_params]]) # dynamic action call
      set_room(updated_model, room_id)
      updated_model
    else
      game_model
    end
  end

  # This uses Redis as depencency so I would need to change it probably
  def get_room(room_id) do
     room = start_link |> elem(1) |> query ["GET", room_id]
     room != :undefined && Poison.decode!(room) || GameModel.initial_model
  end

  #### #### #### #### ####
  defp set_room(room, room_id) do
    start_link |> elem(1) |> query ["SET", room_id, Poison.encode!(room)]
  end
end

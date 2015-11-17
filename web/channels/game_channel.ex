defmodule Familiada.GameChannel do
  use Familiada.Web, :channel
  alias Familiada.GameState

  def join(room_id, p, socket) do
    GameState.player_joined(room_id, p["player_id"])
    socket = assign(socket, :player_id, p["player_id"])
    {:ok, GameState.get_players_list(room_id), socket}
  end

  def leave(_reason, socket) do
    GameState.player_left(socket.topic, player_id(socket))
    {:ok, socket}
  end

  def handle_in("set_player_ready", _, socket) do
    readyQueue = GameState.set_player_ready(socket.topic, player_id(socket))
    broadcast socket, "back:readyQueue", %{ readyQueue: readyQueue }
    {:noreply, socket}
  end

  def handle_in("set_player_not_ready", _, socket) do
    readyQueue = GameState.set_player_not_ready(socket.topic, player_id(socket))
    broadcast socket, "back:readyQueue", %{ readyQueue: readyQueue }
    {:noreply, socket}
  end

  defp player_id(socket) do
    socket.assigns.player_id
  end

  defp authorized?(_payload) do
    true
  end
end

defmodule Familiada.GameState do
  import Exredis
  alias Familiada.RoomState

  def get_players_list(room_id) do
    get_room(room_id) |> Dict.get "playersList", []
  end

  def get_ready_queue(room_id) do
    get_room(room_id) |> Dict.get "readyQueue", []
  end

  # I can probably macro all this shit :)
  def player_joined(room_id, player_id) do
    get_room(room_id)
    |> (RoomState.player_joined player_id)
    |> (set_room room_id)
  end

  def player_left(room_id, player_id) do
    get_room(room_id)
    |> (RoomState.player_left player_id)
    |> (set_room room_id)
  end

  def set_player_ready(room_id, player_id) do
    room = get_room(room_id)
    new_room = RoomState.set_player_ready room, player_id
    set_room new_room, room_id
    new_room["readyQueue"]
  end

  def set_player_not_ready(room_id, player_id) do
    room = get_room(room_id)
    new_room = RoomState.set_player_not_ready room, player_id
    set_room new_room, room_id
    new_room["readyQueue"]
  end

  defp get_room(room_id) do
     room = start_link |> elem(1) |> query ["GET", room_id]
     room != :undefined && Poison.decode!(room) || %{}
  end

  defp set_room(room, room_id) do
    start_link |> elem(1) |> query ["SET", room_id, Poison.encode!(room)]
  end
end

defmodule Familiada.RoomState do
  alias Familiada.Utils

  def player_joined(room, player_id) do
    playersList = Dict.get(room, "playersList", [])
    Dict.put(room, "playersList", Utils.uniq_add(playersList, player_id))
  end

  def player_left(room, player_id) do
    playersList = Dict.get(room, "playersList", [])
    Dict.put(room, "playersList",  Utils.without_id(playersList, player_id))
  end

  def set_player_ready(room, player_id) do
    readyQueue = Dict.get(room, "readyQueue", [])
    Dict.put(room, "readyQueue", Utils.uniq_add(readyQueue, player_id))
  end

  def set_player_not_ready(room, player_id) do
    readyQueue = Dict.get(room, "readyQueue", [])
    Dict.put(room, "readyQueue", Utils.without_id(readyQueue, player_id))
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

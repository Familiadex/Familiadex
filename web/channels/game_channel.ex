defmodule Familiada.GameChannel do
  use Familiada.Web, :channel
  alias Familiada.GameState

  def join(room_id, p, socket) do
    IO.puts "****** join(#{room_id}, #{p["player_id"]}, socket)"
    GameState.player_joined(room_id, p["player_id"])
    {:ok, %{}, socket}
  end

  def handle_in("set_player_ready", p, socket) do
    GameState.set_player_ready(p.room_id, p.player_id)
    broadcast socket, "back:readyQueue", GameState.get_players_list(p.room_id)
    {:noreply, socket}
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
    IO.puts "&&&& player_joined(#{room_id}, #{player_id})"
    room = get_room(room_id)
    IO.puts "&&&&& room = #{Poison.encode!(room)}"
    new_room = RoomState.player_joined room, player_id
    set_room new_room, room_id
  end

  def player_left(room_id, player_id) do
    get_room(room_id)
    |> RoomState.player_left player_id
    |> set_room room_id
  end

  def set_player_ready(room_id, player_id) do
    get_room(room_id)
    |> RoomState.set_player_ready player_id
    |> set_room room_id
  end

  def set_player_not_ready(room_id, player_id) do
    get_room(room_id)
    |> RoomState.set_player_not_ready player_id
    |> set_room room_id
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
    IO.puts "**** player_joined(#{Poison.encode!(room)}, #{player_id})"
    playersList = Dict.get(room, "playersList", [])
    Dict.put(room, "playersList", [player_id | playersList])
  end

  def player_left(player_id, room) do
    playersList = Dict.get(room, "playersList", [])
    Dict.put(room, "playersList",  Utils.without_id(playersList, player_id))
  end

  def set_player_ready(player_id, room) do
    readyQueue = Dict.get(room, "readyQueue", [])
    Dict.put(room, "readyQueue", [player_id | readyQueue])
  end

  def set_player_not_ready(player_id, room) do
    readyQueue = Dict.get(room, "readyQueue", [])
    Dict.put(room, "readyQueue", Utils.without_id(readyQueue, player_id))
  end
end

defmodule Familiada.Utils do
  def without_id(enumerable, id_to_remove) do
    Enum.filter(enumerable, fn(id) -> id != id_to_remove end)
  end
end

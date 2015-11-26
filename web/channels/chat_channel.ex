defmodule Familiada.ChatUsers do
  import Exredis

  defp add_user(userlist, username) do
    users = userlist || []
    if Enum.member?(users, username) do
      users
    else
      if username do
        [username | users]
      else
        users
      end
    end
  end

  defp remove_user([], username), do: []
  defp remove_user([username| t], username), do: t
  defp remove_user([h| t], un), do: [h | remove_user(t, un)]

  def add(room_id, username) do
    room = get_room(room_id)
    room |> Dict.put("chat_userlist", add_user(room["chat_userlist"], username))
    |> set_room(room_id)
  end

  def remove(room_id, username) do
    room = get_room(room_id)
    room |> Dict.put("chat_userlist", remove_user(room["chat_userlist"], username))
    |> set_room(room_id)
  end

  def get(room_id) do
    get_room(room_id)["chat_userlist"]
  end

  #### #### #### #### ####
  defp get_room(room_id) do
     room = start_link |> elem(1) |> query ["GET", room_id]
     room != :undefined && Poison.decode!(room) || %{chat_userlist: []}
  end
  defp set_room(room, room_id) do
    start_link |> elem(1) |> query ["SET", room_id, Poison.encode!(room)]
  end
end

defmodule Familiada.ChatChannel do

  use Familiada.Web, :channel
  alias Familiada.ChatUsers

  def join(room_id, p, socket) do
    socket = assign(socket, :user, p["user"])
    ChatUsers.add(room_id, p["user"]["name"])
    send(self, :after_join)
    {:ok, %{ userlist: ChatUsers.get(socket.topic) }, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast socket, "back:userlist", %{ userlist: ChatUsers.get(socket.topic) }
    {:noreply, socket}
  end

  def leave(_reason, socket) do
    ChatUsers.remove(socket.topic, socket.assigns.user["name"])
    broadcast socket, "back:userlist", %{ userlist: ChatUsers.get(socket.topic) }
    {:ok, socket}
  end

  def handle_in("front:msg", message, socket) do
    broadcast socket, "back:msg", %{content: message["content"], username: socket.assigns.user["name"]}
    {:noreply, socket}
  end
end

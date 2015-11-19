defmodule Familiada.ChatUsers do
  defp add_user(userlist, username) do
    users = userlist || []
    newUsers = [username] ++ users
    newUsers
  end

  defp remove_user(userlist, username) do
    users = userlist || []
    # TODO: real remove
    users
  end

  def new do
    Agent.start_link(fn -> %{} end)
  end

  def add(pid, room_id, username) do
    Agent.update(pid, fn(h) -> Dict.put(h, room_id, add_user(h[room_id], username)) end)
  end

  def remove(pid, room_id, username) do
    Agent.update(pid, fn(h) -> Dict.remove(h, room_id, remove_user(h[room_id], username)) end)
  end

  def get(pid, room_id) do
    Agent.get(pid, fn(h) -> h[room_id] || [] end)
  end
end

defmodule Familiada.ChatChannel do

  use Familiada.Web, :channel
  alias Familiada.ChatUsers

  def join(room_id, p, socket) do
    socket = assign(socket, :user, p["user"])
    store = get_user_store
    ChatUsers.add(store, room_id, p["user"]["name"])
    send(self, :after_join)
    {:ok, %{ userlist: ChatUsers.get(store, socket.topic) }, socket}
  end

  def handle_info(:after_join, socket) do
    store = get_user_store
    broadcast socket, "back:userlist", %{ userlist: ChatUsers.get(store, socket.topic) }
    {:noreply, socket}
  end

  def leave(_reason, socket) do
    store = get_user_store
    ChatUsers.remove(store, socket.topic, socket.assigns.user["name"])
    broadcast socket, "back:userlist", %{ userlist: ChatUsers.get(store, socket.topic) }
    {:ok, socket}
  end

  def handle_in("front:msg", message, socket) do
    broadcast socket, "back:msg", %{content: message["content"], username: socket.assigns.user["name"]}
    {:noreply, socket}
  end

  defp get_user_store do
    store_pid = Process.whereis(:kv)
    store = if store_pid do
      store_pid
    else
      {:ok, store} = Familiada.ChatUsers.new
      Process.register(store, :kv)
      store
    end
  end
end

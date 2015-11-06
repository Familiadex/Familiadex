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

  def join(room_id, message, socket) do
    {:ok, store} = Familiada.ChatUsers.new
    :ok = Familiada.ChatUsers.add(store, room_id, "Hello")
    IO.puts "JOIN #{socket.channel}:#{socket.topic}"
    {:ok, %{username: message["username"], content: "Hello I've just joinded this chat!"}, socket}
  end

  def handle_in("front:msg", message, socket) do
    broadcast socket, "back:msg", %{content: message["content"], username: message["username"]}
    {:noreply, socket}
  end

  def handle_in("front:joined", message, socket) do
    broadcast socket, "back:userlist", %{
      # content: Familiada.ChatUsers.get(self, message["room_id"]),
      username: "chat"
    }
    {:noreply, socket}
  end
end

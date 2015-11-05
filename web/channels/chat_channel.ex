defmodule Familiada.ChatChannel do

  use Familiada.Web, :channel

  def join(room_id, message, socket) do
    IO.puts "JOIN #{socket.channel}:#{socket.topic}"
    {:ok, %{username: message["username"], content: "Hello I've just joinded this chat!"}, socket}
  end

  def handle_in("front:msg", message, socket) do
    broadcast socket, "back:msg", %{content: message["content"],
                                     username: message["username"] }

    socket
  end

  def handle_in("front:joined", message, socket) do
    broadcast socket, "back:userlist", %{content: message["content"],
                                     username: message["username"] }

    socket
  end
end

defmodule Familiada.RoomChannel do
  use Familiada.Web, :channel

  def join("rooms:lobby", message, socket) do
    IO.puts "JOIN #{socket.channel}:#{socket.topic}"
    {:ok, %{username: message["username"], content: "Hello I've just joinded this chat!"}, socket}
  end

  def handle_in("new:msg", message, socket) do
    broadcast socket, "new:msg", %{content: message["content"],
                                     username: message["username"] }

    socket
  end
end

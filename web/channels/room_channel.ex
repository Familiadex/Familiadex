defmodule Familiada.Channels.Rooms do
  use Phoenix.Channel

  def join("rooms:lobby", message, socket) do
    IO.puts "JOIN #{socket.channel}:#{socket.topic}"
    broadcast socket, "user:entered", username: message["username"]
    {:ok, socket}
  end

  def event("new:message", message, socket) do
    broadcast socket, "new:message", content: message["content"],
                                     username: message["username"]

    socket
  end
end

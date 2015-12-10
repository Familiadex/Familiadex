defmodule Familiada.PageController do
  use Familiada.Web, :controller

  plug :authenticate, :login when action in [:game]

  def public(conn, _params) do
    render conn, "public.html"
  end

  def game(conn, _params) do
    render conn, "game.html", game_env: "var GameEnv = { currentUser: #{Familiada.User.to_json(current_user(conn))} };"
  end

  defp authenticate(conn, :login) do
    if logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:info, "Please log in first")
      |> redirect(to: "/")
      |> halt
    end
  end

end

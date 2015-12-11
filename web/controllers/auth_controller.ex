defmodule Familiada.AuthController do
  use Familiada.Web, :controller

  alias Ueberauth.Strategy.Helpers

  # new user form?
  # def request(conn, _params) do
  #   render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  # end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
    conn
    |> put_flash(:error, fails)
    |> redirect(to: "/")
  end

  def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn, _params) do
    case Familiada.User.find_fb_user(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user_id, user.id)
        |> redirect(to: "/game")
      {:new_user, _} ->
        conn
        |> put_session(:fb_auth, auth)
        |> redirect(to: "/register_fb")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end

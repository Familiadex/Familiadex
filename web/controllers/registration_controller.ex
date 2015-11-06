defmodule Familiada.RegistrationController do
  use Familiada.Web, :controller
  alias Familiada.User


  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    if changeset.valid? do
      case Familiada.Registration.create(changeset, Familiada.Repo) do
        {:ok, user} ->
          conn
          |> put_session(:current_user, user.id)
          |> put_flash(:info, "Your account was created")
          |> redirect(to: "/")
        {:error, _changeset} ->
          conn
          # FIXME: display error message
          |> put_flash(:error, "FIXME: Wiadomosc do wyswietlenia, email zajety itp")
          |> render("new.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:info, "Unable to create account")
      |> render("new.html", changeset: changeset)
    end
  end

end

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
          |> put_flash(:success, "Your account was created")
          |> redirect(to: "/")
        {:error, changeset} ->
          conn
          |> render("new.html", changeset: changeset)
      end
    else
      conn
      |> render("new.html", changeset: changeset)
    end
  end

end

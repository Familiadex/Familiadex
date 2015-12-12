defmodule Familiada.RegistrationController do
  use Familiada.Web, :controller
  alias Familiada.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def fb_new(conn, _params) do
    auth = get_session(conn, :fb_auth)
    fb_uid = String.to_integer(auth.uid)
    avatar = auth.info.image

    changeset = User.changeset(%User{}, %{fb_uid: fb_uid, avatar: avatar}) #fb true
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    create_aux(conn, user_params, "new.html")
  end

  def fb_create(conn, %{"user" => user_params}) do
    create_aux(conn, user_params, "fb_new.html")
  end

  defp create_aux(conn, user_params, template) do
    changeset = User.changeset(%User{}, user_params)

    if changeset.valid? do
      case Familiada.Registration.create(changeset, Familiada.Repo) do
        {:ok, user} ->
          conn
          |> put_session(:current_user_id, user.id)
          |> put_flash(:success, "Your account was created")
          |> redirect(to: "/game")
        {:error, changeset} ->
          conn
          |> render(template, changeset: changeset)
      end
    else
      conn
      |> render(template, changeset: changeset)
    end
  end

end

defmodule Familiada.Session do
  alias Familiada.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true  -> {:ok, user}
      _     -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def logged_in?(conn), do: !!Plug.Conn.get_session(conn, :current_user)

end
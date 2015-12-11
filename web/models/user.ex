defmodule Familiada.User do
  use Familiada.Web, :model
  import Ecto.Query

  schema "users" do
    field :email,                 :string,  unique:   true
    field :crypted_password,      :string
    field :password,              :string,  virtual:  true
    field :password_confirmation, :string,  virtual:  true
    field :fb,                    :boolean
    field :fb_uid,                :integer
    field :avatar,                :string

    timestamps
  end

  @required_fields ~w(email password password_confirmation)
  @optional_fields ~w(fb fb_uid avatar)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 3)
    |> validate_confirmation(:password, message: "does not match")
  end

  def to_json(model) do
    Poison.encode! %{
      id: model.id,
      name: String.split(model.email, "@") |> Enum.at(0) }
  end

  # Ueberauth:

  alias Ueberauth.Auth
  # alias Ueberauth.Auth.Credentials

  # def find_or_create(%Auth{provider: :identity} = auth) do
  #   case validate_password(auth.credentials) do
  #     :ok ->
  #       {:ok, %{id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image}}
  #     { :error, reason } -> {:error, reason}
  #   end
  # end

  def find_fb_user(%Auth{} = auth) do
    uid = String.to_integer(auth.uid)
    query = from u in Familiada.User,
            where: u.fb == true and u.fb_uid == ^uid,
            limit: 1

    case Familiada.Repo.all(query) do
      [] -> {:new_user, []}
      query_result -> {:ok, hd query_result}
    end

    # {:ok, %{id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image}}
  end

  # defp name_from_auth(auth) do
  #   if auth.info.name do
  #     auth.info.name
  #   else
  #     name = [auth.info.first_name, auth.info.last_name]
  #     |> Enum.filter(&(&1 != nil and &1 != ""))
  #     if length(name) == 0, do: auth.info.nickname, else: name = Enum.join(name, " ")
  #   end
  # end

  # defp validate_password(%Credentials{other: %{password: ""}}), do: {:error, "Password required"}
  # defp validate_password(%Credentials{other: %{password: pw, password_confirmation: pw}}), do: :ok
  # defp validate_password(%Credentials{other: %{password: _}}), do: { :error, "Passwords do not match" }
  # defp validate_password(_), do: {:error, "Password Required"}

end

defmodule Familiada.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # add :fb,     :bool, default: false
      add :fb_uid, :bigint
      add :avatar, :string
    end
  end
end

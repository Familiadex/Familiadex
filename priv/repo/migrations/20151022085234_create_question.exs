defmodule Familiada.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question, :string

      timestamps
    end

  end
end

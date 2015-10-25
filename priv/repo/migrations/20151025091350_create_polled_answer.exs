defmodule Familiada.Repo.Migrations.CreatePolledAnswer do
  use Ecto.Migration

  def change do
    create table(:polled_answers) do
      add :answer, :string
      add :points, :integer
      add :question_id, references(:questions)

      timestamps
    end
    create index(:polled_answers, [:question_id])

  end
end

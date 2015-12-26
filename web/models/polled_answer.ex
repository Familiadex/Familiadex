defmodule Familiada.PolledAnswer do
  use Familiada.Web, :model
  use Ecto.Schema

  schema "polled_answers" do
    field :answer, :string
    field :points, :integer
    belongs_to :question, Familiada.Question

    timestamps
  end

  @required_fields ~w(answer points)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

defimpl Poison.Encoder, for: Familiada.PolledAnswer do
  def encode(model, opts) do
    %{answer: model.answer,
      points: model.points} |> Poison.Encoder.encode(opts)
  end
end

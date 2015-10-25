defmodule Familiada.Question do
  use Familiada.Web, :model

  schema "questions" do
    field :question, :string

    has_many :polled_answers, Familiada.PolledAnswer
    timestamps
  end

  @required_fields ~w(question)
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

defimpl Poison.Encoder, for: Familiada.Question do
  def encode(model, opts) do
    %{id: model.id,
      question: model.question} |> Poison.Encoder.encode(opts)
  end
end

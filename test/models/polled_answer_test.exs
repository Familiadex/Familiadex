defmodule Familiada.PolledAnswerTest do
  use Familiada.ModelCase

  alias Familiada.PolledAnswer

  @valid_attrs %{answer: "some content", points: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PolledAnswer.changeset(%PolledAnswer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PolledAnswer.changeset(%PolledAnswer{}, @invalid_attrs)
    refute changeset.valid?
  end
end

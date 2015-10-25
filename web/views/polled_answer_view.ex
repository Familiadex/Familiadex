defmodule Familiada.PolledAnswerView do
  use Familiada.Web, :view

  def render("polled_answer.json", %{polled_answer: polled_answer}) do
    %{id: polled_answer.id,
      answer: polled_answer.answer,
      points: polled_answer.points}
  end
end

defmodule Familiada.QuestionView do
  use Familiada.Web, :view

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, Familiada.QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, Familiada.QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{id: question.id,
      question: question.question}
  end
end

defmodule Familiada.QuestionController do
  use Familiada.Web, :controller

  alias Familiada.Question

  plug :scrub_params, "question" when action in [:create, :update]

  def index(conn, _params) do
    questions = Question |> Repo.all |> Repo.preload [:polled_answers]
    render(conn, "index.json", questions: questions)
  end

  def create(conn, %{"question" => question_params}) do
    changeset = Question.changeset(%Question{}, question_params)

    case Repo.insert(changeset) do
      {:ok, question} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", question_path(conn, :show, question))
        |> render("show.json", question: question)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Familiada.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Repo.get!(Question, id)
    changeset = Question.changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        render(conn, "show.json", question: question)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Familiada.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(question)

    send_resp(conn, :no_content, "")
  end
end

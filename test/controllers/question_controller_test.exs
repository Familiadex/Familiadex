defmodule Familiada.QuestionControllerTest do
  use Familiada.ConnCase

  alias Familiada.Question
  @valid_attrs %{question: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, question_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = get conn, question_path(conn, :show, question)
    assert json_response(conn, 200)["data"] == %{"id" => question.id,
      "question" => question.question}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, question_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, question_path(conn, :create), question: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Question, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, question_path(conn, :create), question: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = put conn, question_path(conn, :update, question), question: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Question, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = put conn, question_path(conn, :update, question), question: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = delete conn, question_path(conn, :delete, question)
    assert response(conn, 204)
    refute Repo.get(Question, question.id)
  end
end

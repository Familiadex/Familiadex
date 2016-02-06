# Model -> Player -> [..] -> Model
defmodule Familiada.Reactions do
  # Here we should have GameActions which should be similar to game actions on Frontend
  # Although here we are concerned about authorization and changing game model only
  # On frontend we are concerned about displaying this model and dispatching actions as update_cmd
  import Ecto
  import Ecto.Query
  alias Familiada.Utils
  # This is temporary
  alias Familiada.Repo
  alias Familiada.PolledAnswer

  def restart_game(_model, _player) do
    Familiada.GameModel.initial_model
  end

  def player_joined(model, player) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList", Utils.uniq_add(playersList, player))
  end

  def player_left(model, player) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList",  Utils.without(playersList, player))
  end

  def toogle_player_ready(model, player) do
    playersList = Dict.get(model, "playersList", [])
    set_ready = fn(p) ->
      if p["id"] == player["id"] do
        Dict.put(p, "ready", !Dict.get(p, "ready"))
      else
        p
      end
    end
    nplayersList = Enum.map(playersList, set_ready)
    Dict.put(model, "playersList", nplayersList)
  end

  defp sits_already(model, player) do
    model["redTeam"]["p1"]["id"] == player["id"] && ["redTeam", "p1"] ||
    model["redTeam"]["p2"]["id"] == player["id"] && ["redTeam", "p2"]||
    model["redTeam"]["p3"]["id"] == player["id"] && ["redTeam", "p3"] ||
    model["blueTeam"]["p1"]["id"] == player["id"] && ["blueTeam", "p1"] ||
    model["blueTeam"]["p2"]["id"] == player["id"] && ["blueTeam", "p2"] ||
    model["blueTeam"]["p3"]["id"] == player["id"] && ["blueTeam", "p3"]
  end

  def sit_down(model, player, team_id, position) do
    if sits_already(model, player) != false do
      model
    else
      team = model[team_id]
      seated = Dict.put(team, position, player)
      Dict.put(model, team_id, seated)
    end
  end

  def stand_up(model, player) do
    seated_at = sits_already(model, player)
    if seated_at != false do
      [team_id, position] = seated_at
      team = model[team_id]
      without = Dict.put(team, position, %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"})
      Dict.put(model, team_id, without)
    else
      model
    end
  end

  def sample_question(id) do
    questions = Familiada.Question |> Repo.all
    number_of_questions = questions |> Enum.count
    :random.seed(:erlang.now)
    chosen = :random.uniform(number_of_questions)
    Familiada.Question |> Repo.all |> Enum.at(chosen)
  end
  def top_answers(question_id) do
    PolledAnswer
    |> where(question_id: ^question_id)
    |> order_by(:points)
    |> limit(6)
    |> Repo.all
  end
  defp set_new_question(model, qid) do
    question = sample_question(qid)
    answers = top_answers(question.id)
    answers_hash = %{
      a1: answers |> Enum.at(0),
      a2: answers |> Enum.at(1),
      a3: answers |> Enum.at(2),
      a4: answers |> Enum.at(3),
      a5: answers |> Enum.at(4),
      a6: answers |> Enum.at(5),
    }
    model = Dict.put(model, "currentQuestion", question.question)
    model = Dict.put(model, "answersBoard", answers_hash)
    model = Dict.put(model, "answeringTeam", "NONE")
  end
  def start_game(model, player) do
    model = Dict.put(model, "mode", "RoundFight")
    set_new_question(model, 1)
  end

  # The team who first answer takes round
  defp answer_exists(model, answer_text) do
    IO.puts "answer_text = #{answer_text}"
    answers_board = model["answersBoard"]
    correct_answer = Enum.filter ["a1","a2", "a3", "a4", "a5", "a6"], fn (x) ->
      IO.puts "ODP##{x} #{answers_board[x]["answer"]}"
      answers_board[x]["answer"] == answer_text
    end
    correct_answer |> Enum.at(0)
  end
  # NOTE: this should be in action_authorization.ex
  defp answer_allowed(model, player) do
    # Either it's fight or answers round
    model["answeringPlayer"]["id"] == 0 || model["answeringPlayer"]["id"] == player["id"]
  end
  defp update_team_points(model, player, answer) do
    ptm = player_team_name(model, player) <> "Points"
    # NOTE: hack possible from client side if answer not from DB by id
    current_points = model[ptm]
    Dict.put(model, ptm, current_points + answer["points"])
  end
  defp player_team_name(model, player) do
    red_team = Enum.any? (Enum.map ["p1", "p2", "p3"], fn (x) -> model["redTeam"][x]["id"] == player["id"] end)
    if red_team do
      "redTeam"
    else
      "blueTeam"
    end
  end
  defp reset_teams_errors(model) do
    model
    |> Dict.put("redTeamErrors", 0)
    |> Dict.put("blueTeamErrors", 0)
  end
  defp next_player(team_players, current) do
    next = %{"p1" => "p2", "p2" => "p3", "p3" => "p1"}
    current = next[current]
    if team_players[current]["id"] != 0 do
      current
    else
      next_player(team_players, next[current])
    end
  end
  defp next_answering_player(model) do
    if model["mode"] == "RoundFight" do
      model
    else
      team_players = model[model["answeringTeam"]]
      answering_before = model["answeringPlayerId"]
      next_answering = next_player(team_players, model["answeringPlayerId"])
      model = Dict.put(model, "answeringPlayerId", next_answering)
      model = Dict.put(model, "answeringPlayer", team_players[next_answering])
    end
  end
  defp end_possible_fight(model, player) do
    # Fight is ended only by correct answer
    if model["mode"] == "RoundFight" do
      model = Dict.put(model, "mode", "InGameRound")
      model = reset_teams_errors(model)
      ptn = player_team_name(model, player)
      model = Dict.put(model, "answeringTeam", ptn)
    else
      model
    end
  end
  defp opposite_team(model) do
    team_change = %{"redTeam" => "blueTeam", "blueTeam" => "redTeam"}
    team_change[model["answeringTeam"]]
  end
  defp change_answering_team(model) do
    currently_answering = model["answeringTeam"]
    now_answering = opposite_team(model)
    model = Dict.put(model, "answeringTeam", now_answering)
    # Reset anwsering player
    model = Dict.put(model, "answeringPlayerId", "p3")
  end
  defp set_round_fight(model) do
    model = reset_teams_errors(model)
    model = Dict.put(model, "answeringPlayerId", "p3")
    model = Dict.put(model, "answeringTeam", "NONE")
    model = Dict.put(model, "answeringPlayer", %{"id" => 0, "name" => "X", "avatar" => "Z"})
    model = Dict.put(model, "mode", "RoundFight")
    model = set_new_question(model, 2)
  end
  defp add_error_unless_fight(model, player) do
    # NOTE: having this embbeded in model.player.team would simplify things
    ptn = player_team_name(model, player)
    if model["answeringTeam"] == "NONE" do
      model
    else
      errors = ptn <> "Errors"
      current_errors = model[errors]
      new_errors = current_errors + 1
      model = Dict.put(model, errors, new_errors)
      if new_errors == 3 do
        opposite_team_errors = model[opposite_team(model) <> "Errors"]
        if opposite_team_errors > 0 do
          set_round_fight(model)
        else
          change_answering_team(model)
        end
      else
        model
      end
    end
  end
  def send_answer(model, player, answer_text) do
    good_answer = answer_exists(model, answer_text)
    if answer_allowed(model, player) do
      model = if good_answer do
        IO.puts "GOOD ANSWER"
        answersBoard = model["answersBoard"]
        answer = answersBoard[good_answer]
        # NOTE: player could be embeded in model it would clarify this code
        model = end_possible_fight(model, player)
        model = update_team_points(model, player, answer)
        answer = Dict.put(answer, "show", true)
        answersBoard = Dict.put(answersBoard, good_answer, answer)
        Dict.put(model, "answersBoard", answersBoard)
      else
        IO.puts "BAD ANSWER"
        add_error_unless_fight(model, player)
      end
      model = next_answering_player(model)
    else
      model
    end
  end

  defp get_game_id(model) do
    next_game_id = Dict.get(model, "nextGameId", 0)
    Dict.put(model, "nextGameId", next_game_id + 1)
  end
end

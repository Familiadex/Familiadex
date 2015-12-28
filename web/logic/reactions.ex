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
      without = Dict.put(team, position, %{id: 0, name: "FREE SLOT"})
      Dict.put(model, team_id, without)
    else
      model
    end
  end

  def sample_question do
    Familiada.Question |> Repo.all |> Enum.at(1)
  end
  def top_answers(question_id) do
    PolledAnswer
    |> where(question_id: ^question_id)
    |> order_by(:points)
    |> limit(6)
    |> Repo.all
  end
  def start_game(model, player) do
    model = Dict.put(model, "mode", "InGameRound")
    question = sample_question
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
  end

  # The team who first answer takes round
  defp answer_exists(model, answer) do
    Enum.filter [:a1,:a2, :a3, :a4, :a5, :a6], fn (x) ->
      model[x].show == false && model[x].answer == answer
    end |> Enum.at(0)
  end
  # NOTE: this should be in action_authorization.ex
  defp answer_allowed(model, player) do
    ptn = player_team_name(model, player)
    # Either it's fight or answers round
    model["answeringTeam"] == nil || model["answeringTeam"] == ptn
  end
  defp update_team_points(model, player, answer) do
    ptm = player_team_name(model, player) <> "Points"
    # NOTE: hack possible from client side if answer not from DB by id
    current_points = model[ptm]
    Dict.put(model, ptm, current_points + answer["points"])
  end
  defp player_team_name(model, player) do
    red_team = Enum.any (Enum.map ["p1", "p2", "p3"], (x) -> model["redTeam"][x]["id"] == player["id"])
    if red_team do
      "redTeam"
    else
      "blueTeam"
    end
  end
  defp end_possible_fight(model, player) do
    # Fight is ended only by correct answer
    model = Dict.put(model, "mode", "InGameRound")
    ptn = player_team_name(model, player)
    model = Dict.put(model, "answeringTeam", ptn)
  end
  defp add_error_unless_fight(model, player) do
    # NOTE: having this embbeded in model.player.team would simplify things
    ptn = player_team_name(model, player)
    if model["answeringTeam"] == nil do
      model
    else
      errors = ptn <> "Errors"
      current_errors = model[errors]
      Dict.put(model, errors, current_errors + 1)
    end
  end
  def send_answer(model, player, answer) do
    if answer_allowed(model, player) do
      if good_answer do
        # NOTE: player could be embeded in model it would clarify this code
        model = end_possible_fight(model, player)
        model = update_team_points(model, player, answer)
        answer = Dict.put(answer, "show", true)
        model = Dict.put(model, good_answer, answer)
      else
        # FIXME: should notify user somehow about wrong answer
        model
      end
    else # Answer not allowed
      if good_answer do
        model
      else
        add_error_unless_fight(model, player)
      end
    end
    good_answer = answer_exists(model, answer)

  end

  defp get_game_id(model) do
    next_game_id = Dict.get(model, "nextGameId", 0)
    Dict.put(model, "nextGameId", next_game_id + 1)
  end
end

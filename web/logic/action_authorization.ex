# ActionName -> Model -> Bool
defmodule Familiada.ActionAuthorization do
  def player_joined(model) do
    model.mode == "WaitingForPlayers"
  end

  def player_left(_model) do
    true # allways possible
  end

  def sit_down(model) do
    # TODO: only when not sitting_down && free slot
    true
  end

  def stand_up(model) do
    # TODO: Only when sitting_down
    true
  end

  def start_game(model) do
    # All slots taken
    model["redReam"]["p1"] &&
    model["redReam"]["p2"] &&
    model["redReam"]["p3"] &&
    model["blueTeam"]["p1"] &&
    model["blueTeam"]["p2"] &&
    model["blueTeam"]["p3"]
  end
end

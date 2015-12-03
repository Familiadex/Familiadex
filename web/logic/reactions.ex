# Model -> Player -> [..] -> Model
defmodule Familiada.Reactions do
  # Here we should have GameActions which should be similar to game actions on Frontend
  # Although here we are concerned about authorization and changing game model only
  # On frontend we are concerned about displaying this model and dispatching actions as update_cmd
  alias Familiada.Utils

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

  def start_game(model, player) do
    Dict.put(model, "mode", "InGameRound")
  end

  defp get_game_id(model) do
    next_game_id = Dict.get(model, "nextGameId", 0)
    Dict.put(model, "nextGameId", next_game_id + 1)
  end
end

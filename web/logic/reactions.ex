# Model -> Player -> [..] -> Model
defmodule Familiada.Reactions do
  # Here we should have GameActions which should be similar to game actions on Frontend
  # Although here we are concerned about authorization and changing game model only
  # On frontend we are concerned about displaying this model and dispatching actions as update_cmd
  alias Familiada.Utils

  def player_joined(model, player_id, player) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList", Utils.uniq_add(playersList, player))
  end

  def player_left(model, player_id, player) do
    playersList = Dict.get(model, "playersList", [])
    Dict.put(model, "playersList",  Utils.without(playersList, player))
  end

  def toogle_player_ready(model, player_id) do
    playersList = Dict.get(model, "playersList", [])
    set_ready = fn(p) ->
      if p["id"] == player_id do
        Dict.put(p, "ready", !Dict.get(p, "ready"))
      else
        p
      end
    end
    nplayersList = Enum.map(playersList, set_ready)
    Dict.put(model, "playersList", nplayersList)
  end

  defp get_game_id(model) do
    next_game_id = Dict.get(model, "nextGameId", 0)
    Dict.put(model, "nextGameId", next_game_id + 1)
  end

  def start_game(model, player_id) do
    readyQueue = Dict.get(model, "readyQueue", []) # rigid 2 players
    if [red_team_player, blue_team_player] = readyQueue do
      Dict.put(model, "redTeam", [red_team_player]) |> Dict.put("blueTeam", [blue_team_player])
    else
      model
    end
  end
end

defmodule Familiada.Actions do
  def allowed(action_name, model) do
    # This should also use ActioonAuthorization
    Enum.member?(model[model.mode], action_name)
  end

  # This should be called actions tree
  defp allowed_actions do
    %{
     "WaitingForPlayers" => [
       "player_joined",
       "player_left",
       "sit_down",
       "stand_up",
       "toogle_player_ready"
     ],
     "EveryoneReady" => [
       "stand_up",
       "toggle_player_ready",
       "start_game",
       "player_left",
       "player_joined"
     ],
     "InGameRound1" => [
       "answer",
       "player_left"
     ],
     "InGameRound2" => [
     ],
     "InGameRound3" => [
     ],
     "InGameRound4" => [
     ],
     "InGameRound5" => [
     ],
     "InGameRoundGrandFinale" => [
       "ready",
       "answer",
       "pass",
       "player_left"
     ]
    }
  end
end

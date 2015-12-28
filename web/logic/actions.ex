defmodule Familiada.Actions do
  def allowed(action_name, model) do
    # This should also use ActioonAuthorization
    current_mode = model[:mode] || model["mode"]
    Enum.member?(allowed_actions[current_mode], action_name)
  end

  # This should be called actions tree
  defp allowed_actions do
    basic_actions  = [
      "restart_game",
      "player_left"
    ]
    %{
     "WaitingForPlayers" => [
       "restart_game",
       "player_joined",
       "player_left",
       "sit_down",
       "stand_up",
       "start_game" # Temp
     ],
     "EveryoneReady" => [
       "restart_game",
       "stand_up",
       "start_game",
       "player_left",
       "player_joined"
     ],
     "RoundFight" => basic_actions ++ [
       "send_answer",
     ],
     "InGameRound" => basic_actions ++ [
       "send_answer",
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

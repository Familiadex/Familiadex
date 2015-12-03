defmodule Familiada.GameModel do
  def initial_model do
    %{
      "user_id" => 0,
      "mode" => "WaitingForPlayers",
      "playerList" => [],
      "readyQueue" => [],
      "redTeam" => %{
        "id" => "redTeam",
        "p1" => %{id: 0, name: "FREE SLOT"},
        "p2" => %{id: 0, name: "FREE SLOT"},
        "p3" => %{id: 0, name: "FREE SLOT"},
      },
      "blueTeam" => %{
        "id" => "blueTeam",
        "p1" => %{id: 0, name: "FREE SLOT"},
        "p2" => %{id: 0, name: "FREE SLOT"},
        "p3" => %{id: 0, name: "FREE SLOT"},
      },
      redTeamPoints: 0,
      blueTeamPoints: 0,
      currentQuestion: "To jest currentQuestion?",
      answersBoard: %{
        a1: "???",  a4: "???",
        a2: "???",  a5: "???",
        a3: "???",  a6: "???",
      },
      whoAnswering: %{id: 0, name: "ImieXYZ"},
      # roomSize: 6,
      # pointsToTake: 0,
      # redTeamErrors: 0,
      # blueTeamErrors: 0,
      # whoNextNoError: "?",
      # whoNextError: "?"
    }
  end
end

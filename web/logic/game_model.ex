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
      # roomSize: 6,
      # pointsToTake: 0,
      # redTeamPoints: 0,
      # blueTeamPoints: 0,
      # redTeamErrors: 0,
      # blueTeamErrors: 0,
      # boardAnswers: %{
      #   a1: "",  a4: "",
      #   a2: "",  a5: "",
      #   a3: "",  a6: "",
      # },
      # currentQuestion: "?",
      # whoAnswering: "?",
      # whoNextNoError: "?",
      # whoNextError: "?"
    }
  end
end

defmodule Familiada.GameModel do
  def initial_model do
    %{
      "user_id" => 0,
      "mode" => "WaitingForPlayers",
      "playerList" => [],
      "readyQueue" => [],
      "redTeam" => %{
        "id" => "redTeam",
        "p1" => %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"},
        "p2" => %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"},
        "p3" => %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"},
      },
      "blueTeam" => %{
        "id" => "blueTeam",
        "p1" => %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"},
        "p2" => %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"},
        "p3" => %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"},
      },
      redTeamPoints: 0,
      blueTeamPoints: 0,
      redTeamErrors: 0,
      blueTeamErrors: 0,
      currentQuestion: "To jest currentQuestion?",
      answersBoard: %{
        a1: %{answer: "???", points: 33, show: false},  a4: %{answer: "???", points: 33, show: false},
        a2: %{answer: "???", points: 33, show: false},  a5: %{answer: "???", points: 33, show: false},
        a3: %{answer: "???", points: 33, show: false},  a6: %{answer: "???", points: 33, show: false},
      },
      whoAnswering: %{id: 0, name: "ImieXYZ", avatar: "images/karol.jpg"},
      answerValue: "",
      answeringTeam: "NONE",
      # roomSize: 6,
      # pointsToTake: 0,
      # redTeamErrors: 0,
      # blueTeamErrors: 0,
      # whoNextNoError: "?",
      # whoNextError: "?"
    }
  end
end

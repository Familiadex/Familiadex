defmodule Familiada.GameModel do
  def initial_model do
    sample_player = %{id: 0, name: "FREE SLOT", avatar: "images/karol.jpg"}
    %{
      "user_id" => 0,
      "mode" => "WaitingForPlayers",
      "playerList" => [],
      "readyQueue" => [],
      "redTeam" => %{
        "id" => "redTeam",
        "p1" => sample_player,
        "p2" => sample_player,
        "p3" => sample_player,
      },
      "blueTeam" => %{
        "id" => "blueTeam",
        "p1" => sample_player,
        "p2" => sample_player,
        "p3" => sample_player,
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
      answeringPlayer: sample_player,
      answeringPlayerId: "p3",
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

defmodule Familiada.GameModel do
  def initial_model do
    %{
      user_id: 0,
      mode: "WaitingForPlayers",
      playerList: [],
      readyQueue: [],
      # roomSize: 6,
      # redTeam: %{
      #   p1: %{}, # player
      #   p2: %{},
      #   p3: %{},
      # },
      # blueTeam: %{
      #   p1: %{},
      #   p2: %{},
      #   p3: %{},
      # },
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

module FamiliadaTypes where

type alias Model =
    { mode: String
    , user_id : Int
    , playersList : List Player
    , readyQueue : List Int
    , redTeam : Team
    , blueTeam : Team
    , redTeamPoints: Int
    , blueTeamPoints: Int
    , currentQuestion: String
    , answersBoard : AnswersBoard
    , whoAnswering : Player
    , answerValue: String
    }

type alias BoardAnswer =
    { answer: String,
      points: Int
    }

type alias AnswersBoard =
    { a1 : BoardAnswer
    , a2 : BoardAnswer
    , a3 : BoardAnswer
    , a4 : BoardAnswer
    , a5 : BoardAnswer
    , a6 : BoardAnswer
    }

type alias Player =
    { id : Int
    , name : String
    }

type alias Team =
    { id : String
    , p1 : Player
    , p2 : Player
    , p3 : Player
    }

type alias Question =
    { id : Int
    , question : String
    -- , answers : AnswersList.Model
    }

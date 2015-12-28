module FamiliadaTypes where

type alias Model =
    { mode: String
    , user_id : Int -- each player gets this customized -- should be caled current_user_id
    , playersList : List Player
    , readyQueue : List Int
    , redTeam : Team
    , blueTeam : Team
    , redTeamPoints: Int
    , blueTeamPoints: Int
    , redTeamErrors: Int
    , blueTeamErrors: Int
    , currentQuestion: String
    , answersBoard : AnswersBoard
    , whoAnswering : Player
    , answerValue: String
    , myTeamAnswering: Bool -- each player get's this customized
    }

type alias BoardAnswer =
    { answer: String,
      points: Int,
      show: Bool
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

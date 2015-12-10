module FamiliadaTypes where

type alias Model =
    { mode: String
    , user_id : Int
    , playersList : List Player
    , readyQueue : List Int
    , redTeam : Team
    , blueTeam : Team
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

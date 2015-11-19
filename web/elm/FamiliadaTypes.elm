module FamiliadaTypes where

type alias Model =
    { mode: String
    , user_id : Int
    , playersList : List Player
    , readyQueue : List Int
    }

type alias Player =
    { id : Int
    , name : String
    , ready : Bool
    }

type alias Team =
    { id: Int
    , name: String
    , players: List Player
    }

type alias Question =
    { id : Int
    , question : String
    -- , answers : AnswersList.Model
    }

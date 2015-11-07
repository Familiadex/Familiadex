module FamiliadaGame where

import AnswersList exposing (Answer)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy, lazy2, lazy3)
import Json.Decode as Json
import Signal exposing (Signal, Address)
import String
import Window

---- MODEL ----

-- The full application state of our todo app.
-- maximum 4 players per room
-- in queue can be arbitrary number
type alias Model =
    { currentQuestion: Question
    , playersReady : Int
    , teamA: Team
    , teamB: Team
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

mkPlayer id name = { id = id, name = name, ready = False}

type alias Question =
    { id : Int
    , question : String
    , answers : AnswersList.Model
    }

createAnswer : Int -> Bool -> Answer
createAnswer id shown =
  {
    id = id,
    answer = "Odpowiedz1",
    points = 12,
    visible = shown
  }

sampleQuestion : Question
sampleQuestion =
  {
    id = 1,
    question = "pytanie 1",
    answers = [(createAnswer 1 True), (createAnswer 2 False)]
  }


initialModel : Model
initialModel =
    { currentQuestion = sampleQuestion
    , playersReady = 0
    , teamA = { id = 1
              , name = "TeamA"
              , players = [(mkPlayer 1 "TeamA player1"), (mkPlayer 2 "TeamA player2")]
              }
    , teamB = { id = 2
              , name = "TeamB"
              , players = [(mkPlayer 3 "TeamB player1"), (mkPlayer 4 "TeamB player2")]
              }
    }


---- UPDATE ----

-- A description of the kinds of actions that can be performed on the model of
-- our application. See the following post for more info on this pattern and
-- some alternatives: http://elm-lang.org/learn/Architecture.elm
type Action
    = NoOp
    | AnswersListAction AnswersList.Action

-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model
      AnswersListAction act ->
        let currentQuestion = model.currentQuestion
            updatedCurrentQuestions = { currentQuestion | answers <- (AnswersList.update act currentQuestion.answers) }
        in
         { model | currentQuestion <- updatedCurrentQuestions }
---- VIEW ----


view : Address Action -> Model -> Html
view address model =
    div []
      [ (boardView address model)
      ]

boardView: Address Action -> Model -> Html
boardView address model =
    div [ class "row row-list" ]
      [ div [class "col-xs-3"] [(viewTeamPlayers model.teamA)]
      , div [class "col-xs-6"]
          [ text "Odpowiedzi"
          , (AnswersList.view (Signal.forwardTo address AnswersListAction) model.currentQuestion.answers)
          ]
      , div [class "col-xs-3"] [(viewTeamPlayers model.teamB)]
      ]

viewTeamPlayers : Team -> Html
viewTeamPlayers team =
  let viewPlayer p = li [] [text p.name]
  in
    div []
    [
      text (team.name ++ " " ++ "players"),
      ul [] (List.map viewPlayer team.players)
    ]


---- INPUTS ----

-- wire the entire application together
main : Signal Html
main =
  Signal.map (view actions.address) model


-- manage the model of our application over time
model : Signal Model
model =
  Signal.foldp update initialModel actions.signal


-- actions from user input
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

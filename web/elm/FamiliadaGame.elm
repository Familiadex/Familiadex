module FamiliadaGame where

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
type alias Model =
    {
      currentQuestion: Question
    }

type alias Answer =
    { id : Int
    , answer : String
    , points : Int
    , visible : Bool
    }

type alias Question =
    { id : Int
    , question : String
    , answers : List Answer
    }

sampleAnswer : Answer
sampleAnswer =
  {
    id = 1,
    answer = "Odpowiedz1",
    points = 12,
    visible = True
  }

sampleQuestion : Question
sampleQuestion =
  {
    id = 1,
    question = "pytanie 1",
    answers = [sampleAnswer]
  }


initialModel : Model
initialModel =
    {
      currentQuestion = sampleQuestion
    }


---- UPDATE ----

-- A description of the kinds of actions that can be performed on the model of
-- our application. See the following post for more info on this pattern and
-- some alternatives: http://elm-lang.org/learn/Architecture.elm
type Action
    = NoOp
    | ChangeVisibility Answer Bool


-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model

      -- ShowAnswer aid ->
      --   let showAnswer a = if a.id == aid then { a | visible <- True } else a
      --   in
      --     { model | currentQuestion.answers <- List.map showAnswer currentQuestion.answers }


---- VIEW ----

view : Address Action -> Model -> Html
view address model =
    div
      [ class "jumbotron" ]
      [ text "elo elo 3 5 0",
        div [] [text "lista odpowiedzi" ],
        ul [] (answersList model.currentQuestion.answers)
      ]

answersList : List Answer -> List Html
answersList answers =
  let answerHTML a = li [] [text a.answer]
  in
    List.map answerHTML answers

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

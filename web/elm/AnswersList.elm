module AnswersList (Model, Action, update, view, Answer) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)

type alias Answer =
    { id : Int
    , answer : String
    , points : Int
    , visible : Bool
    }

type alias Model = List Answer

-- actions
type Action = ShowAnswer Int

update action model =
  case action of
    ShowAnswer aid ->
      let newAnswer a = if a.id == aid then { a | visible <- True } else a
      in
        List.map newAnswer model

-- view

view : Signal.Address Action -> Model -> Html
view address model =
      div [class "list-group"]
      (List.map (viewAnswer address) model)

viewAnswer : Signal.Address Action -> Answer -> Html
viewAnswer address answer =
  let answerText = if answer.visible then answer.answer else "........"
  in
    div [class "list-group-item", onClick address (ShowAnswer answer.id) ] [text answerText]

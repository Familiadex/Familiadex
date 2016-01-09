module ViewAnswersBoard where

import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)
import Signal exposing (Address)
import FamiliadaTypes exposing (Model, Action)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import ViewTeamErrors exposing(viewBlueTeamErrors, viewRedTeamErrors)
import ViewTeamPoints exposing(viewBlueTeamPoints, viewRedTeamPoints)

viewAnswersBoard: Address Action -> Address BackendCmd -> Model -> Html
viewAnswersBoard address ba model =
  let answerText answer = if answer.show then answer.answer else "................................."
      answerView boardAnswer = li [class "list-group-item"] [text (answerText boardAnswer)]
      questionView question = li [class "list-group-item"] [text question]
      sendAnswer backendCmd key =
        if key == 13 then backendCmd else (mkBackendCmd FBA.NoAction [])
      answerBox model = input
                  [ class "answer-input"
                  , value model.answerValue
                  , on "input" targetValue (Signal.message address << FamiliadaTypes.InputAnswer)
                  , onKeyUp ba (mkBackendCmd FBA.SendAnswer [model.answerValue] |> sendAnswer)
                  ] []
      answersBoard = div []
        [ ul [class "list-group"]
          [ questionView model.currentQuestion
          , answerView model.answersBoard.a1
          , answerView model.answersBoard.a2
          , answerView model.answersBoard.a3
          , answerView model.answersBoard.a4
          , answerView model.answersBoard.a5
          , answerView model.answersBoard.a6
          , answerBox model
          ]
        ]
  in
    div [class "row row-list"]
    [
      div [class "col col-xs-2"] [
        viewRedTeamPoints model
      , viewRedTeamErrors model
      ]
    , div [class "col-xs-7"] [
        answersBoard
      ]
    , div [class "col-xs-2"] [
        viewBlueTeamPoints model
      , viewBlueTeamErrors model
      ]
    ]

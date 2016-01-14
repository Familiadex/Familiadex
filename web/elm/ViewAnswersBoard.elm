module ViewAnswersBoard where

import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)
import Signal exposing (Address)
import FamiliadaTypes exposing (Model, Action)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import ViewTeamErrors exposing(viewBlueTeamErrors, viewRedTeamErrors)
import ViewTeamPoints exposing(viewBlueTeamPoints, viewRedTeamPoints)
import ViewTeamPlayers exposing(viewBlueTeamPlayers, viewRedTeamPlayers)

viewAnswersBoard: Address Action -> Address BackendCmd -> Model -> Html
viewAnswersBoard address ba model =
  let answerText answer = if answer.show then answer.answer else "................................."
      answerView n boardAnswer = li [class "list-group-item blackbg"] [text (toString(n) ++ " " ++ (answerText boardAnswer))]
      questionView question = li [class "list-group-item blackbg"] [text question]
      sendAnswer backendCmd key =
        if key == 13 then backendCmd else (mkBackendCmd FBA.NoAction [])
      answerBox model = input
                  [ class "answer-input"
                  , value model.answerValue
                  , on "input" targetValue (Signal.message address << FamiliadaTypes.InputAnswer)
                  , onKeyUp ba (mkBackendCmd FBA.SendAnswer [model.answerValue] |> sendAnswer)
                  ] []
      answersBoard = div [class "answers-board"]
        [ ul [class "list-group"]
          [ questionView model.currentQuestion
          , answerView 1 model.answersBoard.a1
          , answerView 2 model.answersBoard.a2
          , answerView 3 model.answersBoard.a3
          , answerView 4 model.answersBoard.a4
          , answerView 5 model.answersBoard.a5
          , answerView 6 model.answersBoard.a6
          , if model.mode == "RoundFight" || model.user_id == model.answeringPlayer.id then answerBox model else span [] []
          ]
        ]
      showRedAnswering = if model.answeringTeam == "redTeam" then
          span [class "glyphicon glyphicon-phone-alt btn-danger"] []
        else
          text ""
      showBlueAnswering = if model.answeringTeam == "blueTeam" then
          span [class "glyphicon glyphicon-phone-alt btn-info"] []
        else
          text ""
      showFight = if model.mode == "RoundFight" then text "FIGHT" else text ("answering: " ++ model.answeringTeam)
  in
    div [class "row row-list"]
    [
      div [class "col-xs-2 alert-danger text-center"] [
        viewRedTeamPoints model
      , viewRedTeamPlayers model
      , showRedAnswering
      , viewRedTeamErrors model
      ]
    , div [class "col-xs-7"] [
        div [class "text-center"] [showFight]
      , answersBoard
      ]
    , div [class "col-xs-2 alert-info text-center"] [
        viewBlueTeamPoints model
      , viewBlueTeamPlayers model
      , showBlueAnswering
      , viewBlueTeamErrors model
      ]
    ]

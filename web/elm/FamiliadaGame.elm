module FamiliadaGame where
import FamiliadaTypes exposing(Model, Player, Team, Question)
import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)

import AnswersList exposing (Answer)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)
import Maybe

---- UPDATE ----

-- A description of the kinds of actions that can be performed on the model of
-- our application. See the following post for more info on this pattern and
-- some alternatives: http://elm-lang.org/learn/Architecture.elm
type Action
    = NoOp
    | AnswersListAction AnswersList.Action
    | BackendAction

allPlayersReady model = List.all (\x -> x.ready == True) model.playersQueue

-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model
      -- AnswersListAction act ->
      --   let currentQuestion = model.currentQuestion
      --       updatedCurrentQuestions = { currentQuestion | answers <- (AnswersList.update act currentQuestion.answers) }
      --   in
      --    { model | currentQuestion <- updatedCurrentQuestions }
---- VIEW ----

view : Address Action -> Model -> Html
view address model = case model.mode of
    "WaitingForPlayers" -> queueView address model
    -- "Started" -> boardView address model

queueView: Address Action -> Model -> Html
queueView address model =
  viewPlayerQueue address model

-- boardView: Address Action -> Model -> Html
-- boardView address model =
--     div [ class "row row-list" ]
--       [ div [class "col-xs-3"] [(viewTeamPlayers model.teamA)]
--       , div [class "col-xs-6"]
--           [ text "Odpowiedzi"
--           , (AnswersList.view (Signal.forwardTo address AnswersListAction) model.currentQuestion.answers)
--           ]
--       , div [class "col-xs-3"] [(viewTeamPlayers model.teamB)]
--       ]

viewPlayerQueue : Address Action -> Model -> Html
viewPlayerQueue address model =
  let readyClass p = if p then class "alert alert-success pointer" else class "alert alert-danger pointer"
      readyText p = if p then " READY" else " NOT READY"
      viewPlayer p = li [] [ div
                             [onClick address (FBA.SetPlayerReady)
                             , readyClass p.ready
                             ] [text (p.name ++ " - "++ (readyText p.ready))]
                           ]
      startButton = if allPlayersReady model
        then
          div [onClick address (FBA.StartGame), class "btn btn-success"] [text "Start Game"]
        else
          div [] [text "Waiting for all players ready..."]
  in
    div []
    [ text "Players in Que"
    , ul [] (List.map viewPlayer model.playersQueue)
    , startButton
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
port backendModel : Signal Model
port modelUpdateCmd : Signal BackendCmd
port modelUpdateCmd =
  let cmdOnly a =
      case a of
        BackendAction -> Just (mkBackendCmd a [])
        _ -> Nothing
  in
    Signal.filterMap cmdOnly {msg = "x", params = [1]} actions.signal

-- wire the entire application together
main : Signal Html
main =
  Signal.map (view actions.address) model

-- manage the model of our application over time
model : Signal Model
model = backendModel
--  Signal.foldp update initialModel actions.signal

-- actions from user input
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

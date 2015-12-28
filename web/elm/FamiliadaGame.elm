module FamiliadaGame where
import FamiliadaTypes exposing(Model, Player, Team, Question)
import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)

import AnswersList exposing (Answer)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)

---- UPDATE ----

-- A description of the kinds of actions that can be performed on the model of
-- our application. See the following post for more info on this pattern and
-- some alternatives: http://elm-lang.org/learn/Architecture.elm
type Action
    = NoOp
    | InputAnswer String
    | AnswersListAction AnswersList.Action

allPlayersReady : Model -> Bool
allPlayersReady model =
  model.redTeam.p1.id /= 0 &&
  model.redTeam.p2.id /= 0 &&
  model.redTeam.p3.id /= 0 &&
  model.blueTeam.p1.id /= 0 &&
  model.blueTeam.p2.id /= 0 &&
  model.blueTeam.p3.id /= 0

-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model
      InputAnswer answer -> { model | answerValue <- answer }
      -- AnswersListAction act ->
      --   let currentQuestion = model.currentQuestion
      --       updatedCurrentQuestions = { currentQuestion | answers <- (AnswersList.update act currentQuestion.answers) }
      --   in
      --    { model | currentQuestion <- updatedCurrentQuestions }
---- VIEW ----

view : Address Action -> Address BackendCmd -> Model -> Html
view address ba model = case model.mode of
    "WaitingForPlayers" -> viewTeamBoards address ba model
    "RoundFight" -> viewAnswersBoard address ba model
    "InGameRound" -> viewAnswersBoard address ba model
    -- "Started" -> boardView address model

-- queueView: Address Action -> Address BackendAction -> Model -> Html
-- queueView address ba model =
--   viewPlayersList address ba model

viewAnswersBoard: Address Action -> Address BackendCmd -> Model -> Html
viewAnswersBoard address ba model =
  let answerText answer = if answer.show then answer.answer else "?"
      answerView boardAnswer = li [class "list-group-item"] [text (answerText boardAnswer)]
      questionView question = li [class "list-group-item"] [text question]
      sendAnswer backendCmd key =
        if key == 13 then backendCmd else (mkBackendCmd FBA.NoAction [])
      answerBox model = input
                  [ value model.answerValue
                  , onKeyUp ba ((mkBackendCmd FBA.SendAnswer [model.answerValue]) |> sendAnswer)
                  , on "input" targetValue (Signal.message address << InputAnswer)
                  ] []
  in
    div []
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
-- boardView: Address Action -> Adress BackendCmd -> Model -> Html
-- boardView address ba model =
--     div [ class "row row-list" ]
--       [ div [class "col-xs-3"] [(viewTeamPlayers model.teamA)]
--       , div [class "col-xs-6"]
--           [ text "Odpowiedzi"
--           , (AnswersList.view (Signal.forwardTo address AnswersListAction) model.currentQuestion.answers)
--           ]
--       , div [class "col-xs-3"] [(viewTeamPlayers model.teamB)]
--       ]

currentPlayer : Model -> Maybe Player
currentPlayer model =
  List.filter (\x -> x.id == model.user_id) model.playersList |> List.head

viewTeamBoards : Address Action -> Address BackendCmd -> Model -> Html
viewTeamBoards address ba model =
  let playerView p = div [class "btn"] [text p.name]
      teamView t = ul [class "list-group"]
                   [ li [onClick ba (mkBackendCmd FBA.SitDown [t.id, "p1"]), class "list-group-item"] [playerView t.p1]
                   , li [onClick ba (mkBackendCmd FBA.SitDown [t.id, "p2"]), class "list-group-item"] [playerView t.p2]
                   , li [onClick ba (mkBackendCmd FBA.SitDown [t.id, "p3"]), class "list-group-item"] [playerView t.p3]
                   ]
  in
    div [class "row row-lis"]
      [ div [class "col-xs-6 alert-danger"] [teamView model.redTeam]
      , div [class "col-xs-6 alert-info"] [teamView model.blueTeam]
      , button [onClick ba (mkBackendCmd FBA.StandUp [])] [text "Free My Slot"]
      , button [onClick ba (mkBackendCmd FBA.StartGame [])] [text "Start Game"]
      ]

-- viewPlayersList : Address Action -> Address BackendAction -> Model -> Html
-- viewPlayersList address ba model =
--   let readyClass p = if p then class "alert alert-success pointer" else class "alert alert-danger pointer"
--       readyText p = if p then " READY" else " NOT READY"
--       viewPlayer p = li [] [ div
--                              [readyClass p.ready] [text (p.name ++ " - "++ (readyText p.ready))]
--                            ]
--       startButton = if allPlayersReady model
--         then
--           div [onClick ba FBA.TooglePlayerReady, class "btn btn-success"] [text "Start Game"]
--         else
--           div [] [text "Waiting for all players ready..."]
--       toogleButton = case (currentPlayer model) of
--         Just p ->
--           let toogleText = if p.ready then "I'm not ready" else "I'm ready"
--           in
--             div [onClick ba FBA.TooglePlayerReady, class "btn btn-info"] [text toogleText]
--   in
--     div []
--     [ text "Players in Que"
--     , ul [] (List.map viewPlayer model.playersList)
--     , toogleButton
--     , startButton
--     ]


---- INPUTS ----
port backendModel : Signal Model
port modelUpdateCmd : Signal BackendCmd
port modelUpdateCmd = baBox.signal

-- wire the entire application together
main : Signal Html
main =
  Signal.map (view actions.address baBox.address) model

-- manage the model of our application over time
model : Signal Model
model = backendModel
--  Signal.foldp update initialModel actions.signal

-- actions from user input
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

baBox : Signal.Mailbox BackendCmd
baBox = Signal.mailbox (mkBackendCmd FBA.NoAction [])

module FamiliadaGame where
import FamiliadaTypes exposing(Model, Player, Team, Question)
import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)

import AnswersList exposing (Answer)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)

---- UPDATE ----
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

update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model
      InputAnswer answer -> { model | answerValue <- answer }

---- INPUTS ----
port backendModel : Signal Model
port modelUpdateCmd : Signal BackendCmd
port modelUpdateCmd = baBox.signal

-- wire the entire application together
main : Signal Html
main = Signal.map (view actions.address baBox.address) model

-- manage the model of our application over time
model : Signal Model
model = backendModel

-- actions from user input
actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp

baBox : Signal.Mailbox BackendCmd
baBox = Signal.mailbox (mkBackendCmd FBA.NoAction [])

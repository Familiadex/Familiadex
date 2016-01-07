module FamiliadaGame where
import FamiliadaTypes exposing(Model, Player, Team, Question, Action)
import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)

import Signal exposing (Signal)
import ViewMain exposing (view)
import Html exposing(Html)

update : Action -> Model -> Model
update action model =
    case action of
      FamiliadaTypes.NoOp -> model
      FamiliadaTypes.InputAnswer answer -> { model | answerValue <- answer }

---- INPUTS ----
port backendModel : Signal Model
port modelUpdateCmd : Signal BackendCmd
port modelUpdateCmd = baBox.signal

-- wire the entire application together
main : Signal Html
main = Signal.map (view actions.address baBox.address) model

-- manage the model of our application over time
mainModel : Signal Model
mainModel = Signal.map2 (\m a -> update a m) backendModel actions.signal

model : Signal Model
model = mainModel

-- actions from user input
actions : Signal.Mailbox Action
actions = Signal.mailbox FamiliadaTypes.NoOp

baBox : Signal.Mailbox BackendCmd
baBox = Signal.mailbox (mkBackendCmd FBA.NoAction [])

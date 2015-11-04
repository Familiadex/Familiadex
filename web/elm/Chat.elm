module Chat where

import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Html.Events exposing (onClick, on, targetValue)

type alias Msg = {
  username: String,
  content: String
}

type alias Model = {
  inputMsg: String,
  msgList : List Msg,
  users : List String
}

type Action = NoOp
            | NewMsg Msg
            | InputMsg String
            | SendMsg

-- ports
port incMsg : Signal Msg
-- port outMsg : Signal Msg

incMsgActions : Signal Action
incMsgActions =
  Signal.map (\m -> (NewMsg m)) incMsg

model : Model
model = { msgList = [{username = "Chat", content = "Welcome!"}]
        , users = ["Chat"]
        , inputMsg = ""
        }

mainSignal : Signal Action
mainSignal =
  Signal.mergeMany
    [ actions.signal
    , incMsgActions
    ]

mergedModel =
  Signal.foldp update model mainSignal

update action model =
    case action of
      NoOp -> model
      InputMsg s -> { model | inputMsg <- (model.inputMsg ++ s) }
      SendMsg -> { model |
        msgList <- (model.msgList ++ [{username = "Me", content = model.inputMsg}]),
        inputMsg <- "" }

view : Signal.Address Action -> Model -> Html
view address model =
    div []
    [ (viewMsgList model.msgList)
    , div []
      [ input [on "input" targetValue (Signal.message address << InputMsg)] []
      , button [class "btn-primary", onClick address SendMsg ] [text "Send"]
      ]
    ]

viewMsgList msgList =
  let msgView m = div [class "list-group"] [text (m.username ++ ": " ++ m.content)]
  in
    div [class "list-group-item"] (List.map msgView msgList)

---- INPUTS ----

-- wire the entire application together
main : Signal Html
main =
  Signal.map (view actions.address) mergedModel

-- actions from user input
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

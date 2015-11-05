module Chat where

import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Html.Events exposing (onClick, on, targetValue, onKeyUp)

type alias Msg = {
  username: String,
  content: String
}

type alias Model = {
  inputMsg: String,
  msgList : List Msg,
  users : List String,
  currentUser : String
}

type Action = NoOp
            | NewMsg Msg
            | InputMsg String
            | SendMsg Msg

-- ports
port incMsg : Signal Msg
port outMsg : Signal Msg
port outMsg =
  let msgOnly a =
      case a of
        SendMsg _ -> True
        _ -> False
      onlySendMsg = Signal.filter msgOnly NoOp actions.signal
      mapToMsg action = case action of
        SendMsg msg -> msg
        _ -> {username= "Error", content ="WTF?"}
  in Signal.map mapToMsg onlySendMsg


incMsgActions : Signal Action
incMsgActions =
  Signal.map (\m -> (NewMsg m)) incMsg

model : Model
model = { msgList = [{username = "Chat", content = "Welcome!"}]
        , users = ["Chat", "Player1", "Player2"]
        , inputMsg = ""
        , currentUser = "Me"
        }

mainSignal : Signal Action
mainSignal =
  Signal.mergeMany
    [ actions.signal
    , incMsgActions
    ]

mergedModel : Signal Model
mergedModel =
  Signal.foldp update model mainSignal

update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model
      InputMsg s -> { model | inputMsg <- s }
      SendMsg msg -> { model |
        msgList <- (model.msgList ++ [msg]),
        inputMsg <- "" }
      NewMsg msg -> { model | msgList <- (model.msgList ++ [msg]) }


mkMessage : Model -> Msg
mkMessage m =
  { username = m.currentUser
  , content = m.inputMsg
  }

view : Signal.Address Action -> Model -> Html
view address model =
    div []
    [ div [class "row row-list"]
      [ div [class "col-xs-9"] [(viewMsgList model.msgList)]
      , div [class "col-xs-3"] [(viewUserList model.users)]
      ]
    , div [class "row row-list"]
      [ input
        [ class "col-xs-9"
        , value model.inputMsg
        , on "input" targetValue (Signal.message address << InputMsg)
        , onKeyUp address (mkMessage model |> sendMessage)
        ] []
      , button
        [ class "col-xs-3"
        , onClick address ((mkMessage model |> sendMessage) 13)
          ] [text "Send"]
      ]
    ]

sendMessage : Msg -> Int -> Action
sendMessage msg key =
  if key == 13 then SendMsg msg else NoOp

viewMsgList : List Msg -> Html
viewMsgList msgList =
  let msgView m = div [class "list-group"] [text (m.username ++ ": " ++ m.content)]
  in
    div [class "list-group-item"] (List.map msgView msgList)

viewUserList : List String -> Html
viewUserList userList =
  let userView u = div [class "list-group"] [text u]
      header = a [class "list-group-item active"] [text "Users in chat:"]
  in
      div [class "list-group-item"] (header :: (List.map userView userList))

---- INPUTS ----

-- wire the entire application together
main : Signal Html
main =
  Signal.map (view actions.address) mergedModel

-- actions from user input
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

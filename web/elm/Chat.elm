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
            | InputUsername {oldUsername: String, newUsername: String}
            | UserListUpdate (List String)

-- ports
port incMsg : Signal Msg
incMsgActions : Signal Action
incMsgActions = Signal.map (\m -> (NewMsg m)) incMsg
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

port userListUpdate : Signal {userlist: List String}
userListUpdates : Signal Action
userListUpdates = Signal.map (\m -> (UserListUpdate m.userlist)) userListUpdate
-- /\/\/\/\/\/\/\/\/\/\/\/\/\
port newUser : Signal {oldUsername: String, newUsername: String}
port newUser =
  let onlyThis a =
      case a of
        InputUsername _ -> True
        _ -> False
      goodSignal = Signal.filter onlyThis NoOp actions.signal
      mapToSth action = case action of
        InputUsername usr -> usr
        _ -> {oldUsername = "WTF?", newUsername = "WTF?"}
  in Signal.map mapToSth goodSignal


model : Model
model = { msgList = [{username = "Chat", content = "Welcome!"}]
        , users = ["Anonymous"]
        , inputMsg = ""
        , currentUser = "Anonymous"
        }

mainSignal : Signal Action
mainSignal =
  Signal.mergeMany
    [ actions.signal
    , incMsgActions
    , userListUpdates
    ]

mergedModel : Signal Model
mergedModel =
  Signal.foldp update model mainSignal

update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model
      InputMsg s -> { model | inputMsg <- s }
      SendMsg msg -> { model | inputMsg <- "" }
      NewMsg msg -> { model | msgList <- (model.msgList ++ [msg]) }
      InputUsername u -> { model | currentUser <- u.newUsername }
      UserListUpdate ul -> { model | users <- ul}


mkMessage : Model -> Msg
mkMessage m =
  { username = m.currentUser
  , content = m.inputMsg
  }

view : Signal.Address Action -> Model -> Html
view address model =
    div [class "chat"]
    [ div [class "row row-list"]
      [ div [class "col-xs-9 msglist"] [(viewMsgList model.msgList)]
      , div [class "col-xs-3"] [(viewUserList model.users)]
      ]
    , div [class "row"]
      [ input
        [ class "col-xs-3"
        , value model.currentUser
        , on "input" targetValue (Signal.message address << (buildUsernameInput model))
        ] [text "Send"]
      , input
        [ class "col-xs-9"
        , value model.inputMsg
        , on "input" targetValue (Signal.message address << InputMsg)
        , onKeyUp address (mkMessage model |> sendMessage)
        ] []
      ]
    ]

buildUsernameInput model newName = InputUsername {oldUsername = model.currentUser, newUsername = newName}


sendMessage : Msg -> Int -> Action
sendMessage msg key =
  if key == 13 then SendMsg msg else NoOp

viewMsgList : List Msg -> Html
viewMsgList msgList =
  let msgView m = div [] [text (m.username ++ ": " ++ m.content)]
  in
    div [] (List.map msgView msgList)

viewUserList : List String -> Html
viewUserList userList =
  let userView u = div [] [text u]
      header = a [] [text "Users in chat:"]
  in
      div [class "userlist"] (header :: (List.map userView userList))

---- INPUTS ----

-- wire the entire application together
main : Signal Html
main =
  Signal.map (view actions.address) mergedModel

-- actions from user input
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

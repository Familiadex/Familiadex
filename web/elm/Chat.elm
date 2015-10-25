module Chat where

import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp


main =
  StartApp.start { model = model, view = view, update = update }


type alias Msg = {
  username: String,
  content: String
}

type alias Model = {
  msgList : List Msg,
  users : List String
}

type Action = NoOp
            | NewMsg Msg

model : Model
model = { msgList = [{username = "Chat", content = "Welcome!"}]
        , users = ["Chat"]
        }

update action model =
    case action of
      NoOp -> model

view address model =
    div [] [text "To bedzie czat"]

-- ports
-- port incMsg : Signal (String, String)
-- port outMsg : Signal (String, String)
-- port userEntered : Signal (String)

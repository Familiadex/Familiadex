module ViewTeamErrors where

import FamiliadaTypes exposing (Model, Action)

import Html exposing (..)
import Html.Attributes exposing (class)
-- import Html.Events exposing (..)

viewErrors : Int -> Html
viewErrors n = case n of
  0 -> text ""
  1 -> text "X"
  2 -> div [] [text "X", br [] [], text "X"]
  3 -> div [] [text "X", br [] [], text "X", br [] [], text "X"]

viewBlueTeamErrors : Model -> Html
viewBlueTeamErrors model = div [class "team-errors text-center"] [viewErrors model.blueTeamErrors]

viewRedTeamErrors : Model -> Html
viewRedTeamErrors model = div [class "team-errors text-center"] [viewErrors model.redTeamErrors]

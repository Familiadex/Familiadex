module ViewTeamPoints where

import FamiliadaTypes exposing (Model, Action)

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events exposing (..)

viewRedTeamPoints : Model -> Html
viewRedTeamPoints model = div [class "team-points"] [toString model.redTeamPoints |> text]

viewBlueTeamPoints : Model -> Html
viewBlueTeamPoints model = div [class "team-points"] [toString model.blueTeamPoints |> text]

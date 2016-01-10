module ViewTeamPlayers where

import FamiliadaTypes exposing (Model, Player, Action)

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events exposing (..)

playerView : Player -> Html
playerView player = if player.id /= 0 then realPlayer player else div [] []

realPlayer : Player -> Html
realPlayer player = div [class "player-info"]
  [ img [src player.avatar, class "avatar img-circle"] []
  , text player.name
  ]

viewRedTeamPlayers : Model -> Html
viewRedTeamPlayers model = div [class "team-players"]
  [ playerView model.redTeam.p1
  , playerView model.redTeam.p2
  , playerView model.redTeam.p3
  ]

viewBlueTeamPlayers : Model -> Html
viewBlueTeamPlayers model = div [class "team-players"]
  [ playerView model.blueTeam.p1
  , playerView model.blueTeam.p2
  , playerView model.blueTeam.p3
  ]

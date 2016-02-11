module ViewTeamPlayers where

import FamiliadaTypes exposing (Model, Player, Action)

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events exposing (..)

playerView : Player -> Player -> Html
playerView player answering =
  if player.id /= 0 then
    if player.id == answering.id then
      answeringPlayer player
    else
      realPlayer player
  else
    div [] []

realPlayer : Player -> Html
realPlayer player = div [class "player-info"]
  [ div [] [img [src player.avatar, class "avatar img-circle"] []]
  , div [] [span [class "badge"] [text player.name]]
  ]

answeringPlayer : Player -> Html
answeringPlayer player = div [class "player-info alert-success"]
  [ div [] [img [src player.avatar, class "avatar img-circle"] []]
  , div [] [span [class "badge"] [text player.name]]
  ]

viewRedTeamPlayers : Model -> Html
viewRedTeamPlayers model = div [class "team-players"]
  [ playerView model.redTeam.p1 model.answeringPlayer
  , playerView model.redTeam.p2 model.answeringPlayer
  , playerView model.redTeam.p3 model.answeringPlayer
  ]

viewBlueTeamPlayers : Model -> Html
viewBlueTeamPlayers model = div [class "team-players"]
  [ playerView model.blueTeam.p1 model.answeringPlayer
  , playerView model.blueTeam.p2 model.answeringPlayer
  , playerView model.blueTeam.p3 model.answeringPlayer
  ]

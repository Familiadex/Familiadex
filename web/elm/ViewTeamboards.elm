module ViewTeamboards where

import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)
import Signal exposing (Address)
import FamiliadaTypes exposing (Model, Action)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

viewTeamboards : Address Action -> Address BackendCmd -> Model -> Html
viewTeamboards address ba model =
  let playerView p = div [class "btn"] [text p.name]
      teamView t = ul [class "list-group"]
                   [ li [onClick ba (mkBackendCmd FBA.SitDown [t.id, "p1"]), class "list-group-item"] [playerView t.p1]
                   , li [onClick ba (mkBackendCmd FBA.SitDown [t.id, "p2"]), class "list-group-item"] [playerView t.p2]
                   , li [onClick ba (mkBackendCmd FBA.SitDown [t.id, "p3"]), class "list-group-item"] [playerView t.p3]
                   ]
  in
    div [class "row row-list"]
      [ div [class "col-xs-6 alert-danger"] [teamView model.redTeam]
      , div [class "col-xs-6 alert-info"] [teamView model.blueTeam]
      , button [onClick ba (mkBackendCmd FBA.StandUp [])] [text "Free My Slot"]
      , button [onClick ba (mkBackendCmd FBA.StartGame [])] [text "Start Game"]
      ]

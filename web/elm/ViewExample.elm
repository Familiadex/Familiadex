module ViewExample where

import FamiliadaBackendActions as FBA exposing(BackendAction, BackendCmd, mkBackendCmd)
import Signal exposing (Address)
import FamiliadaTypes exposing (Model, Action)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


viewExample : Address Action -> Address BackendCmd -> Model -> Html
viewExample address ba model = div [] [text "this is view example"]

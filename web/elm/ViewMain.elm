module ViewMain where

import ViewTeamboards exposing(viewTeamboards)
import ViewAnswersBoard exposing(viewAnswersBoard)
import FamiliadaTypes exposing(Model, Action)
import FamiliadaBackendActions exposing (BackendCmd)
import Signal exposing (Address)
import Html exposing (Html)

view : Address Action -> Address BackendCmd -> Model -> Html
view address ba model = case model.mode of
    "WaitingForPlayers" -> viewTeamboards address ba model
    "RoundFight" -> viewAnswersBoard address ba model
    "InGameRound" -> viewAnswersBoard address ba model
    -- "Started" -> boardView address model

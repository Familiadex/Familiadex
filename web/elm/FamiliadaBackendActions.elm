module FamiliadaBackendActions where

type BackendAction = PlayerJoined
                   | PlayerLeft
                   | SetPlayerReady
                   | SetPlayerNotReady
                   | StartGame
                   | NoAction

type alias BackendCmd = {cmd: String, params: List Int}

mkBackendCmd : BackendAction -> List Int -> BackendCmd
mkBackendCmd action params = {cmd = toString action, params = params}

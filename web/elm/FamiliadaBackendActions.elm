module FamiliadaBackendActions where

type BackendAction = PlayerJoined
                   | PlayerLeft
                   | SitDown
                   | StandUp
                   | StartGame
                   | NoAction

type alias BackendCmd = {cmd: String, params: List String}

mkBackendCmd : BackendAction -> List String -> BackendCmd
mkBackendCmd action params = {cmd = toString action, params = params}

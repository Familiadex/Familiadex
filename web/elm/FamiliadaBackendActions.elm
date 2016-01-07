module FamiliadaBackendActions where

type BackendAction = PlayerJoined
                   | PlayerLeft
                   | SitDown
                   | StandUp
                   | StartGame
                   | SendAnswer
                   | NoAction

type alias BackendCmd = {cmd: String, params: List String}

mkBackendCmd : BackendAction -> List String -> BackendCmd
mkBackendCmd action params = {cmd = toString action, params = params}

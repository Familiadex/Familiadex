// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import initElmChat from "./elm_chat"

var elmDiv = document.getElementById('elm-main'),
    elmChatDiv = document.getElementById('elm-chat'),
    elmGlobalChatDiv = document.getElementById('elm-chat-global'),
    elmFamiliadaGame,
    elmGlobalChat = initElmChat(elmGlobalChatDiv, "global");
    // elmChat = initElmChat(elmChatDiv, "game");

// TODO: we have to init elm game & channel with proper auth token (encoded player_id)
let game = socket.channel("games:ID_GRY", {player_id: 123})
game.join()
  .receive("ok", initialModel => {
    console.log("Joined game channel successfully", initialModel)
    elmFamiliadaGame = Elm.embed(Elm.FamiliadaGame, elmDiv, {backendModel: initialModel})
    game.push("modelUpdateCmd", {cmd: "SetPlayerReady", params: [123]})
  })
  .receive("error", resp => { console.log("Joined game channel successfully", resp)})
// Push model updates into Elm Game
game.on("back:modelUpdate", model => {
  console.log("back:modelUpdate", model)
  elmFamiliadaGame.ports.backendModel.send(model)
})
// Send actions to backend
elmFamiliadaGame.ports.modelUpdateCmd.subscribe((cmd) => {
  console.log("modelUpdateCmd", cmd)
  game.push("modelUpdateCmd", cmd)
})

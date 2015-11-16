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
    elmApp = Elm.embed(Elm.FamiliadaGame, elmDiv),
    elmGlobalChat = initElmChat(elmGlobalChatDiv, "global");
    // elmChat = initElmChat(elmChatDiv, "game");

let games = socket.channel("games:someGame11", {player_id: 111})
games.join()
  .receive("ok", resp => { console.log("Joined games successfully", resp) })
  .receive("error", resp => { console.log("Unable to join games", resp) })

games.push("set_player_ready", {room_id: "someGame11", player_id: 1})

games.on("back:readyQueue", readyQueue => { console.log("readyQueue", readyQueue)})

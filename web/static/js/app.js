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

var elmDiv = document.getElementById('elm-main'),
    elmChatDiv = document.getElementById('elm-chat'),
    elmApp = Elm.embed(Elm.FamiliadaGame, elmDiv),
    elmChat = Elm.embed(Elm.Chat, elmChatDiv, {
      incMsg: {username: "Chat", content: "Welcome!"}
    });

// Now that you are connected, you can join channels with a topic:
// let channel = socket.channel("questions:index", {})
// channel.join()
//   .receive("ok", resp => { console.log("Joined questions successfully", resp) })
//   .receive("error", resp => { console.log("Unable to join questions", resp) })
//
let chats = socket.channel("rooms:lobby", {})
chats.join()
  .receive("ok", resp => { console.log("Joined chats successfully", resp) })
  .receive("error", resp => { console.log("Unable to join chats", resp) })

chats.on("new:msg", msg => {
  console.log("backend:new:msg", msg);
  elmChat.ports.incMsg.send(msg)
})
//
// chats.on("user:entered", msg => {
//   elmChat.ports.userEntered.send(msg)
// })
//
elmChat.ports.outMsg.subscribe(sendMsg);

function sendMsg(msg){
  console.log("new:msg", msg)
  chats.push("new:msg", msg)
}
//
// sendMsg("dev", "wiadomosc powitalna");

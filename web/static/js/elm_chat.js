import socket from "./socket"

function initElmChat (domElement){
  let elmChat = Elm.embed(Elm.Chat, domElement,  {
    incMsg: {username: "Chat", content: "Welcome!"}
  });

  let chats = socket.channel("chats:lobby", {})
  chats.join()
    .receive("ok", resp => { console.log("Joined chats successfully", resp) })
    .receive("error", resp => { console.log("Unable to join chats", resp) })

  chats.on("new:msg", msg => {
    console.log("backend:new:msg", msg);
    elmChat.ports.incMsg.send(msg)
  })

  elmChat.ports.outMsg.subscribe(sendMsg);
  function sendMsg(msg){
    console.log("new:msg", msg)
    chats.push("new:msg", msg)
  }

  return elmChat;
}

export default initElmChat

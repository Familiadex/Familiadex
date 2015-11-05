import socket from "./socket"

function initElmChat (domElement, chatUUID){
  let channelName = "chats:" + chatUUID;
  let elmChat = Elm.embed(Elm.Chat, domElement,  {
    incMsg: {username: "Chat", content: "Welcome!"}
  });

  let chats = socket.channel(channelName, {})
  chats.join()
    .receive("ok", resp => { console.log(`Joined ${channelName} successfully`, resp) })
    .receive("error", resp => { console.log(`Unable to join ${channelName}`, resp) })

  // Push into elm ports
  chats.on("back:msg", msg => {
    console.log("back:msg", msg);
    elmChat.ports.incMsg.send(msg)
  })

  chats.on("back:userlist", ul => {
    elmChat.ports.incMsg.send(msg)
  })

  // Subsribe to elm ports
  elmChat.ports.outMsg.subscribe(function(msg){
    console.log("front:msg", msg)
    chats.push("front:msg", msg)
  })

  // elmChat.ports.joinChat.subscribe(function(username){
  //   chats.push("front:joined", username);
  // })

  return elmChat;
}

export default initElmChat

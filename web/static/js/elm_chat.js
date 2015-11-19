import socket from "./socket"

function initElmChat (domElement, chatUUID){
  let room_id = "chats:" + chatUUID;
  let elmChat = Elm.embed(Elm.Chat, domElement,  {
    incMsg: {username: "Chat", content: "Welcome!"},
    userListUpdate: {userlist: ["Anonymous"]}
  });

  let chats = socket.channel(room_id, {})
  chats.join()
    .receive("ok", resp => {
      console.log(`Joined ${room_id} successfully`, resp)
    })
    .receive("error", resp => { console.log(`Unable to join ${room_id}`, resp) })

  // Push into elm ports
  chats.on("back:msg", msg => {
    console.log("back:msg", msg)
    elmChat.ports.incMsg.send(msg)
  })

  chats.on("back:userlist", ul => {
    console.log("back:userlist", ul)
    elmChat.ports.userListUpdate.send(ul)
  })

  // Subsribe to elm ports
  elmChat.ports.outMsg.subscribe(function(msg){
    console.log("front:msg", msg)
    chats.push("front:msg", msg)
  })

  elmChat.ports.newUser.subscribe(function(nameChange){
    console.log("front:joined", nameChange)
    chats.push("front:joined", {
      room_id: room_id,
      newUsername: nameChange.newUsername,
      oldUsername: nameChange.oldUsername
    })
  })

  return elmChat;
}

export default initElmChat

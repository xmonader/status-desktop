import NimQml
import json
import ../../status/chat as status_chat
import view
import messages
import ../signals/types
import ../../status/utils

var sendMessage = proc (view: ChatsView, chatId: string, msg: string): string =
  echo "sending public message!"
  var sentMessage = status_chat.sendChatMessage(chatId, msg)
  var parsedMessage = parseJson(sentMessage)["result"]["chats"][0]["lastMessage"]

  let chatMessage = newChatMessage()
  chatMessage.userName = parsedMessage["alias"].str
  chatMessage.message = msg
  chatMessage.timestamp = $parsedMessage["timestamp"]
  chatMessage.identicon = parsedMessage["identicon"].str
  chatMessage.isCurrentUser = true
  view.pushMessage(chatMessage)
  sentMessage

type ChatController* = ref object of SignalSubscriber
  view*: ChatsView
  variant*: QVariant

proc newController*(): ChatController =
  result = ChatController()
  result.view = newChatsView(sendMessage)
  result.view.names = @[]
  result.variant = newQVariant(result.view)

proc delete*(self: ChatController) =
  delete self.view
  delete self.variant

proc init*(self: ChatController) =
  discard

proc join*(self: ChatController, chatId: string) =
  # TODO: check whether we have joined a chat already or not
  # TODO: save chat list in the db
  echo "Joining chat: ", chatId
  let oneToOne = isOneToOneChat(chatId)
  echo "Is one to one? ", oneToOne
  status_chat.loadFilters(chatId, oneToOne)
  status_chat.saveChat(chatId, oneToOne)
  status_chat.chatMessages(chatId)
  # self.chatsModel.addNameTolist(channel.name)
  self.view.addNameTolist(chatId)

proc load*(self: ChatController): seq[string] =
  # TODO: retrieve chats from DB
  self.join("test")
  result = @["test"]

method onSignal(self: ChatController, data: Signal) =
  var chatSignal = cast[ChatSignal](data)
  for message in chatSignal.messages:
    let chatMessage = newChatMessage()
    chatMessage.userName = message.alias
    chatMessage.message = message.text
    chatMessage.timestamp = message.timestamp #TODO convert to date/time?
    chatMessage.identicon = message.identicon
    chatMessage.isCurrentUser = message.isCurrentUser #TODO: Determine who originated the message
    self.view.pushMessage(chatMessage)
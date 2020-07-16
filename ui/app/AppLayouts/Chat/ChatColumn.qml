import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../../../shared"
import "../../../imports"
import "./components"
import "./ChatColumn"

StackLayout {
    id: chatColumnLayout
    property int chatGroupsListViewCount: 0
    property bool isReply: false
    property var appSettings
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.minimumWidth: 300

    currentIndex:  chatsModel.activeChannelIndex > -1 && chatGroupsListViewCount > 0 ? 0 : 1

    ColumnLayout {
        spacing: 0

        RowLayout {
            id: chatTopBar
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            z: 60
            spacing: 0
            TopBar {}
        }

        RowLayout {
            id: chatContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            spacing: 0
            ChatMessages {
                id: chatMessages
                messageList: chatsModel.messageList
                appSettings: chatColumnLayout.appSettings
            }
       }


        ProfilePopup {
            id: profilePopup
        }

        PopupMenu {
            id: messageContextMenu
            Action {
                id: viewProfileAction
                text: qsTr("View profile")
                onTriggered: profilePopup.open()
            }
            Action {
                text: qsTr("Reply to")
                onTriggered: {
                    isReply = true;
                    replyAreaContainer.setup()
                }
            }
        }
 
        ListModel {
            id: suggestions
        }

        Connections {
            target: chatsModel
            onActiveChannelChanged: {
              suggestions.clear()
              for (let i = 0; i < chatsModel.suggestionList.rowCount(); i++) {
                suggestions.append({
                  alias: chatsModel.suggestionList.rowData(i, "alias"),
                  ensName: chatsModel.suggestionList.rowData(i, "ensName"),
                  address: chatsModel.suggestionList.rowData(i, "address"),
                  identicon: chatsModel.suggestionList.rowData(i, "identicon"),
                  ensVerified: chatsModel.suggestionList.rowData(i, "ensVerified")
                });
              }
            }
        }

        SuggestionBox {
            id: suggestionsBox
            model: suggestions
            width: chatContainer.width
            anchors.bottom: inputArea.top
            anchors.left: inputArea.left
            filter: chatInput.textInput.text
            property: "alias"
            onItemSelected: function (item) {
              let currentText = chatInput.textInput.text
              let lastAt = currentText.lastIndexOf("@")
              let left = currentText.slice(0, lastAt + 1)
              let right = currentText.substring(lastAt + 1)

              let text = left + item + " " + right
              let rawText = text.replace(/<[^>]+>/g, '').replace('p, li { white-space: pre-wrap; }', '').trim()
              chatInput.textInput.text = text

              chatInput.textInput.cursorPosition = rawText.length + 1
              suggestionsBox.suggestionsModel.clear()


              /* let currentText = chatInput.textInput.text.replace(/<[^>]+>/g, '').replace('p, li { white-space: pre-wrap; }', '').trim() */

              /* let user; */

              /* for (let i = 0; i < suggestions.count; i++) { */
              /*   let suggestion = suggestions.get(i) */
              /*   if (suggestion.pubKey == item) { */
              /*     user = suggestion */
              /*     break; */
              /*   } */
              /* } */

              /* let lastAt = currentText.lastIndexOf("@") */
              /* let mention = '<a name="'+item+'">@'+user.aliasName+'</a>' */
              /* let nameLen = user.aliasName.length + 2 // We're doing a +2 here because of the `@` and the trailing whitespace */
              /* let position = 0; */
              /* let text = "" */

              /* if (currentText.length == 1) { */
              /*   position = nameLen */
              /*   text = mention + " " */
              /* } else { */
              /*   let left = currentText.slice(0, lastAt) */
              /*   position = left.length + nameLen */
              /*   text = left + mention + " " */
              /* } */

              /* chatInput.textInput.text = text */
              /* chatInput.textInput.cursorPosition = position */
              /* suggestionsBox.suggestionsModel.clear() */
            }
        }

        Rectangle {
            id: inputArea
            color: Style.current.background
            border.width: 1
            border.color: Style.current.border
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            height: !isReply ? 70 : 140
            Layout.preferredHeight: height

            
            ReplyArea {
                id: replyAreaContainer
                visible: isReply
            }

            ChatInput {
                id: chatInput
                height: 40
                anchors.top: !isReply ? inputArea.top : replyAreaContainer.bottom
                anchors.topMargin: 4
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }

        }
    }

    EmptyChat {}
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";height:770;width:800}
}
##^##*/

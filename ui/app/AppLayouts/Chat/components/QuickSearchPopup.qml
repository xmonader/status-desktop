import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml.Models 2.3
import "../../../../imports"
import "../../../../shared"
import "../ContactsColumn"
import "../data/channelList.js" as ChannelJSON
import "./"

ModalPopup {
    property string searchString: ""
    property string searchStringLowercase: searchString.toLowerCase()
    property var suggestions: []
    function doJoin() {
        if(channelName.text === "") return;

        chatsModel.joinChat(channelName.text, Constants.chatTypePublic);
        popup.close();
    }

    id: searchPopup
    //% "Search"
    title: qsTrId("search-chat")

    onOpened: {
        channelName.text = "";
        channelName.forceActiveFocus(Qt.MouseFocusReason)
        searchPopup.suggestions = chatsModel.chats
    }

    function onEnter(event){
        if (event.modifiers === Qt.NoModifier && (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
            console.log("=========")
            console.log(chatGroupsListView.currentIndex)
            return
//            if (emojiSuggestions.visible) {
//                emojiSuggestions.addEmoji();
//                event.accepted = true;
//                return
//            }
//            sendMsg(event);
        }

        if ((event.key === Qt.Key_V) && (event.modifiers & Qt.ControlModifier)) {
            paste = true;
        }

        if (event.key === Qt.Key_Down) {
            console.log("--------")
            console.log(filterModel)
            console.log(filterModel.model)
            console.log(filterModel.items)
            console.log(filterModel.items.count)
            // console.log(filterModel.items.get(0))
            // console.log(filterModel.items.get(0).model)
            // console.log(filterModel.items.get(0).model.name)
            // console.log(filterModel.items.get(0).model.index)
            // console.log(filterModel.items.get(0).model.inVisible)
            console.log("--------")
            return chatGroupsListView.incrementCurrentIndex()
        }
        if (event.key === Qt.Key_Up) {
            return chatGroupsListView.decrementCurrentIndex()
        }

        // isColonPressed = (event.key === Qt.Key_Colon) && (event.modifiers & Qt.ShiftModifier);
    }

    function onRelease(event) {
        // the text doesn't get registered to the textarea fast enough
        // we can only get it in the `released` event
//        if (paste) {
//            paste = false;
//            interrogateMessage();
//        }

//        emojiEvent = emojiHandler(event);
//        if (!emojiEvent) {
//            emojiSuggestions.close()
//        }
    }

    Row {
        id: description
        Layout.fillHeight: false
        Layout.fillWidth: true
        width: parent.width

        StyledText {
            width: parent.width
            font.pixelSize: 15
            //% "Type the channel you're looking for."
            text: qsTrId("type-channel")
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignTop
        }
    }

    Input {
        id: channelName
        anchors.top: description.bottom
        anchors.topMargin: Style.current.padding
        //% "chat-name"
        placeholderText: qsTrId("chat-name")
        // Keys.onEnterPressed: {}
//        Keys.onReturnPressed: {}
        onTextChanged: function() {
            searchPopup.searchString = channelName.text
            console.log(searchPopup.searchString)
            filterModel.update()
            // searchPopup.emojis = chatsModel.chats.filter(function (channel) {
                // return channel.name.includes(channelName.text)
            // })
        }

        Keys.onPressed: onEnter(event)
        Keys.onReleased: onRelease(event) // gives much more up to date cursorPosition
//        Keys.onEnterPressed: doJoin()
//        Keys.onReturnPressed: doJoin()
//        icon: "../../../img/hash.svg"
//        Shortcut {
//            sequence: "Enter"
//            onActivated: console.log("hello")
//        }
    }
    
    ScrollView {
        id: sview
        clip: true

        anchors.top: channelName.bottom
        anchors.topMargin: Style.current.smallPadding
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        Layout.fillHeight: true
        Layout.fillWidth: true
        contentHeight: {
            var totalHeight = 0
            for (let i = 0; i < chatGroupsListView.count; i++) {
                totalHeight += chatGroupsListView.itemAt(i).height + Style.current.padding
            }
            return totalHeight + Style.current.padding
        }

        FilterModel {
            id: filterModel
            model: chatsModel.chats
            filterAcceptsItem: function(item) {
                // console.log("--- filtering")
                // console.log(channelName.text)
                // console.log(item.name)
                // console.log(item.name.includes(channelName.text))
                return item.name.includes(channelName.text)
            }
            lessThan: function(left, right) {
                console.log("sorting")
                console.log(left.index)
                console.log(right.index)
                console.log(left.index < right.index)
                return left.index < right.index
//                if (sortByName.checked) {
//                    var leftVal = left.name;
//                    var rightVal = right.name;
//                } else {
//                    leftVal = left.team;
//                    rightVal = right.team;
//                }
//                return leftVal < rightVal ? -1 : 1;
            }

            delegate: Rectangle {
                id: rectangle
//                visible: channelName.text == "" || model.name.includes(channelName.text)
                color: chatGroupsListView.currentIndex === index ? Style.current.inputBorderFocus : Style.current.transparent
                border.width: 0
                width: parent.width
//                height: this.visible ? 42 : 0
                height: 42
                radius: 8

//                SVGImage {
//                    id: emojiImage
//                    source: `../../../../imports/twemoji/26x26/${modelData.unicode}.png`
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.left: parent.left
//                    anchors.leftMargin: Style.current.smallPadding
//                }

                StyledText {
                    text: model.name
//                    color: emojiList.currentIndex === index ? Style.current.currentUserTextColor : Style.current.textColor
                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.left: emojiImage.right
                    anchors.left: parent.left
                    anchors.leftMargin: Style.current.smallPadding
                    font.pixelSize: 15
                    Keys.onPressed: onEnter(event)
                    Keys.onReleased: onRelease(event) // gives much more up to date cursorPosition
                }

                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        chatGroupsListView.currentIndex = index
                    }
                    onClicked: {
                        console.log("==========")
                        console.log(index)
//                        emojiSuggestions.addEmoji(index)
                    }
                }
            }


        }

        ListView {
            id: chatGroupsListView
            keyNavigationEnabled: true
            anchors.top: parent.top
            height: childrenRect.height
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.rightMargin: Style.current.padding
            anchors.leftMargin: Style.current.padding
            interactive: false
            model: filterModel

            onCurrentIndexChanged: {
                console.log("index changed")
                console.log(chatGroupsListView.currentIndex)
            }

//            delegate: Channel {
//                name: model.name
//                muted: model.muted
//                lastMessage: model.lastMessage
//                timestamp: model.timestamp
//                chatType: model.chatType
//                identicon: model.identicon
//                unviewedMessagesCount: model.unviewedMessagesCount
//                hasMentions: model.hasMentions
//                contentType: model.contentType
//                searchStr: channelName.text
//                chatId: model.id
//            }
//            onCountChanged: {
//                if (count > 0 && chatsModel.activeChannelIndex > -1) {
//                    // If a chat is added or removed, we set the current index to the first value
//                    chatsModel.activeChannelIndex = 0;
//                    currentIndex = 0;
//                } else {
//                    if(chatsModel.activeChannelIndex > -1){
//                        chatGroupsListView.currentIndex = 0;
//                    } else {
//                        // Initial state. No chat has been selected yet
//                        chatGroupsListView.currentIndex = -1;
//                    }
//                }
//            }
        }

    }

    footer: Button {
        width: 44
        height: 44
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        background: Rectangle {
            color: "transparent"
        }
        SVGImage {
            source: channelName.text == "" ? "../../../img/arrow-button-inactive.svg" : "../../../img/arrow-btn-active.svg"
            width: 50
            height: 50
        }
        MouseArea {
            id: btnMAJoinChat
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked : doJoin()
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

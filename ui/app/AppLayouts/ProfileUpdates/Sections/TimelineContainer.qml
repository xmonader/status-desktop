import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import "../../Chat/ChatColumn"
import "../../../../imports"
import "../../../../shared"

RowLayout {
    height: parent.height
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
    spacing: 0

    ChatMessages {
        id: chatMessages
        messageList: chatsModel.messageList
    }
}

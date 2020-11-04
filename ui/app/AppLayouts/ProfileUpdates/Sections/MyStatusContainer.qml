import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import "../../../../imports"
import "../../../../shared"
import "../../../../shared/status"

Item {
    height: parent.height
    Layout.fillWidth: true

    StyledText {
        id: title
        text: qsTr("MyStatus")
        anchors.top: parent.top
        anchors.topMargin: Style.current.padding
        anchors.horizontalCenter: parent.horizontalCenter
        font.weight: Font.Bold
        font.pixelSize: 17
    }

    StatusRoundButton {
        id: btn
        icon.name: "plusSign"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.current.padding
        onClicked: {
            chatsModel.sendMessage("Status update!", "", Constants.messageType, true)
        }
    }
}

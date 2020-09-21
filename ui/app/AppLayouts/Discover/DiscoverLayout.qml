import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../../../imports"
import "../../../shared"
import "../Chat/components"
import "./data"
import "./data/channelList.js" as ChannelJSON

ColumnLayout {
    id: discoverLayout
    Layout.fillHeight: true
    Layout.fillWidth: true

    Channels {
        id: suggestChannelsModel
    }

    Text {
        id: discoverTitle
        text: qsTr("Discover")
        font.bold: true
        font.pixelSize: 28
        anchors.left: parent.left
        anchors.leftMargin: 35
        anchors.top: discoverLayout.top
        anchors.topMargin: 10
    }
    Flickable {
        Layout.fillHeight: true
        Layout.fillWidth: true
        anchors.right: parent.right
        anchors.rightMargin: 35
        anchors.left: parent.left
        anchors.leftMargin: 35
        anchors.top: discoverTitle.bottom
        anchors.topMargin: 10
        width: parent.width
        height: parent.height

        Repeater {
            model: ChannelJSON.categories
            ColumnLayout {
                Layout.fillWidth: true
                anchors.top: parent.children[index - 1].bottom
                anchors.topMargin: 20
                anchors.left: discoverLayout.left
                anchors.leftMargin: 0
                anchors.right: discoverLayout.left
                anchors.rightMargin: 50
                width: parent.width
                Text {
                    text: modelData.name
                    font.pixelSize: 15
                }
                Flow {
                    Layout.fillHeight: false
                    Layout.fillWidth: true
                    anchors.top: parent.children[0].bottom
                    anchors.topMargin: 5
                    width: parent.width
                    spacing: 20
                    Repeater {
                        model: modelData.channels
                        SuggestedChannel { channel: modelData }
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

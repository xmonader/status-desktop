import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../../../imports"
import "../../../shared"
import "../Profile/LeftTab/components/"
import "./Sections"
import "./menu-data.js" as MenuData

SplitView {
    id: walletView
    Layout.fillHeight: true
    Layout.fillWidth: true

    handle: SplitViewHandle {}

    Item {
        id: leftTab
        SplitView.preferredWidth: Style.current.leftTabPrefferedSize
        SplitView.minimumWidth: Style.current.leftTabMinimumWidth
        SplitView.maximumWidth: Style.current.leftTabMaximumWidth
        property alias currentTab: profileUpdatesMenu.profileUpdatesCurrentIndex

        StyledText {
            id: title
            text: qsTr("Profile Updates")
            anchors.top: parent.top
            anchors.topMargin: Style.current.padding
            anchors.horizontalCenter: parent.horizontalCenter
            font.weight: Font.Bold
            font.pixelSize: 17
        }

        ScrollView {
            property int profileUpdatesCurrentIndex: MenuData.TIMELINE
            readonly property int btnheight: 42
            readonly property int w: 340
            property var changeProfileSection: function (sectionId) {
                profileUpdatesCurrentIndex = sectionId
            }
            anchors.right: parent.right
            anchors.rightMargin: Style.current.smallPadding
            anchors.left: parent.left
            anchors.leftMargin: Style.current.smallPadding
            anchors.top: title.bottom
            anchors.topMargin: Style.current.bigPadding
            anchors.bottom: parent.bottom

            id: profileUpdatesMenu

            Column {
                anchors.fill: parent
                spacing: 8

                Repeater {
                    model: MenuData.menu
                    delegate: MenuButton {
                        menuItemId: modelData.id
                        text: modelData .text
                        active: profileUpdatesMenu.profileUpdatesCurrentIndex === modelData.id
                        Layout.fillWidth: true
                        onClicked: function () {
                            profileUpdatesMenu.profileUpdatesCurrentIndex = modelData.id
                            switch(modelData.id) {
                                case MenuData.TIMELINE:
                                  chatsModel.setActiveChannelToTimeline()
                                  break;
                                case MenuData.MY_STATUS:
                                  chatsModel.setActiveChannelToStatusUpdates()
                                  break;

                            }
                        }
                    }
                }
            }
        }
    }

    StackLayout {
        id: profileUpdatesContainer
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: Style.current.padding
        anchors.left: leftTab.right
        anchors.leftMargin: Style.current.padding
        currentIndex: leftTab.currentTab

        TimelineContainer {

        }

        MyStatusContainer {

        }
    }
}


import QtQuick 2.12
import "../../../../imports"
import "../../../../shared"
import "../../../../shared/status"

ModalPopup {
    property var members: []

    id: popup

    onClosed: {
        popup.destroy();
    }

    header: Item {
        height: 60
        width: parent.width

        StyledText {
            id: titleText
            text: qsTr("Membership requests")
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            font.bold: true
            font.pixelSize: 17
            wrapMode: Text.WordWrap
        }

        StyledText {
            id: nbRequestsText
            text: members.length.toString()
            width: 160
            anchors.left: titleText.left
            anchors.top: titleText.bottom
            anchors.topMargin: 2
            font.pixelSize: 15
            color: Style.current.darkGrey
        }

        Separator {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: -Style.current.padding
            anchors.leftMargin: -Style.current.padding
        }
    }

    ListView {
        model: chatsModel.activeCommunity.communityMembershipRequests
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: -Style.current.xlPadding
        anchors.leftMargin: -Style.current.xlPadding
        height: parent.height


        delegate: Item {
            property int contactIndex: profileModel.contacts.list.getContactIndexByPubkey(publicKey)
            property string identicon: utilsModel.generateIdenticon(publicKey)
            property string profileImage: contactIndex === -1 ? identicon :
                                                                profileModel.contacts.list.rowData(contactIndex, 'thumbnailImage') || identicon
            property string displayName: {
                if (contactIndex === -1) {
                    return utilsModel.generateAlias(publicKey)
                }
                const ensVerified = profileModel.contacts.list.rowData(contactIndex, 'ensVerified')
                if (!ensVerified) {
                    const nickname = profileModel.contacts.list.rowData(contactIndex, 'localNickname')
                    if (nickname) {
                        return nickname
                    }
                }
                return profileModel.contacts.list.rowData(contactIndex, 'name')
            }

            id: requestLine
            height: 52
            width: parent.width

            StatusImageIdenticon {
                id: accountImage
                width: 36
                height: 36
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: requestLine.profileImage
                anchors.leftMargin: Style.current.padding
            }

            StyledText {
                text: requestLine.displayName
                anchors.left: accountImage.right
                anchors.leftMargin: Style.current.padding
                anchors.right: thumbsUp.left
                anchors.rightMargin: Style.current.padding
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15
                color: Style.current.darkGrey
            }

            SVGImage {
                id: thumbsUp
                source: "../../../img/thumbsUp.svg"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: thumbsDown.left
                anchors.rightMargin: Style.current.padding
                width: 28

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log('Approve')
                }
            }

            SVGImage {
                id: thumbsDown
                source: "../../../img/thumbsDown.svg"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Style.current.padding
                width: 28

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log('Reject')
                }
            }
        }

    }

    footer: StatusIconButton {
        id: backArrow
        icon.name: "arrow-right"
        iconRotation: 180
        iconColor: Style.current.inputColor
        anchors.left: parent.left
        onClicked: popup.close()
    }
}

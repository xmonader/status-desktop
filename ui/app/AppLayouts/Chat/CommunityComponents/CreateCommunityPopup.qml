import QtQuick 2.12
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.13
import QtQuick.Dialogs 1.3
import "../../../../imports"
import "../../../../shared"
import "../../../../shared/status"

ModalPopup {
    readonly property int maxDescChars: 140
    property string nameValidationError: ""
    property string colorValidationError: ""
    property string selectedImageValidationError: ""
    property string selectedImage: ""
    property QtObject community: chatsModel.activeCommunity

    property bool isEdit: false

    id: popup
    height: 600

    onOpened: {
        nameInput.text = isEdit ? community.name : "";
        descriptionTextArea.text = isEdit ? community.description : "";
        nameValidationError = "";
        colorValidationError = "";
        selectedImageValidationError = "";
        // TODO: add color and profile pic
        // TODO: can privacy be changed?
        nameInput.forceActiveFocus(Qt.MouseFocusReason)
    }

    function validate() {
        nameValidationError = ""
        colorValidationError = ""
        selectedImageValidationError = ""

        if (nameInput.text === "") {
            nameValidationError = qsTr("You need to enter a name")
        } else if (!(/^[a-z0-9\-\ ]+$/i.test(nameInput.text))) {
            nameValidationError = qsTr("Please restrict your name to letters, numbers, dashes and spaces")
        } else if (nameInput.text.length > 100) {
            nameValidationError = qsTr("Your name needs to be 100 characters or shorter")
        }

        if (selectedImage === "") {
            selectedImageValidationError = qsTr("You need to select an image")
        }

        if (colorPicker.text === "") {
            colorValidationError = qsTr("You need to enter a color")
        } else if (!Utils.isHexColor(colorPicker.text)) {
            colorValidationError = qsTr("This field needs to be an hexadecimal color (eg: #4360DF)")
        }

        return !nameValidationError && !descriptionTextArea.validationError && !colorValidationError
    }

    title: isEdit ?
            qsTr("Edit community") :
            qsTr("New community")

    ScrollView {
        property ScrollBar vScrollBar: ScrollBar.vertical

        id: scrollView
        anchors.fill: parent
        rightPadding: Style.current.bigPadding
        anchors.rightMargin: - Style.current.bigPadding
        leftPadding: Style.current.bigPadding
        anchors.leftMargin: - Style.current.bigPadding
        contentHeight: content.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true

        function scrollBackUp() {
            vScrollBar.setPosition(0)
        }

        Item {
            id: content
            height: childrenRect.height
            width: parent.width

            Input {
                id: nameInput
                label: qsTr("Name your community")
                placeholderText: qsTr("A catchy name")
                validationError: popup.nameValidationError
            }

            StyledTextArea {
                id: descriptionTextArea
                label: qsTr("Give it a short description")
                placeholderText: qsTr("What your community is about")
                validationError: descriptionTextArea.text.length > maxDescChars ? qsTr("The description cannot exceed 140 characters") : ""
                anchors.top: nameInput.bottom
                anchors.topMargin: Style.current.bigPadding
                customHeight: 88
                textField.selectByMouse: true
                textField.wrapMode: TextEdit.Wrap
            }

            StyledText {
                id: charLimit
                text: `${descriptionTextArea.text.length}/${maxDescChars}`
                anchors.top: descriptionTextArea.bottom
                anchors.topMargin: !descriptionTextArea.validationError ? 5 : - Style.current.smallPadding
                anchors.right: descriptionTextArea.right
                font.pixelSize: 12
                color: !descriptionTextArea.validationError ? Style.current.textColor : Style.current.danger
            }

            StyledText {
                id: thumbnailText
                text: qsTr("Thumbnail image")
                anchors.top: descriptionTextArea.bottom
                anchors.topMargin: Style.current.smallPadding
                font.pixelSize: 15
                color: Style.current.secondaryText
            }


            Rectangle {
                id: addImageButton
                color: imagePreview.visible ? "transparent" : Style.current.inputBackground
                width: 128
                height: width
                radius: width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: thumbnailText.bottom
                anchors.topMargin: Style.current.padding

                FileDialog {
                    id: imageDialog
                    //% "Please choose an image"
                    title: qsTrId("please-choose-an-image")
                    folder: shortcuts.pictures
                    nameFilters: [
                        //% "Image files (*.jpg *.jpeg *.png)"
                        qsTrId("image-files----jpg---jpeg---png-")
                    ]
                    onAccepted: {
                        selectedImage = imageDialog.fileUrls[0]
                    }
                }

                Image {
                    id: imagePreview
                    visible: !!popup.selectedImage
                    source: popup.selectedImage
                    fillMode: Image.PreserveAspectCrop
                    width: parent.width
                    height: parent.height

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            anchors.centerIn: parent
                            width: imagePreview.width
                            height: imagePreview.height
                            radius: imagePreview.width / 2
                        }
                    }
                }

                Item {
                    id: addImageCenter
                    visible: !imagePreview.visible
                    width: uploadText.width
                    height: childrenRect.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    SVGImage {
                        id: imageImg
                        source: "../../../img/images_icon.svg"
                        width: 20
                        height: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    StyledText {
                        id: uploadText
                        text: qsTr("Upload")
                        anchors.top: imageImg.bottom
                        anchors.topMargin: 5
                        font.pixelSize: 15
                        color: Style.current.secondaryText
                    }
                }

                Rectangle {
                    color: Style.current.primary
                    width: 40
                    height: width
                    radius: width / 2
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Style.current.halfPadding

                    SVGImage {
                        source: "../../../img/plusSign.svg"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: 13
                        height: 13
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: imageDialog.open()
                }
            }

            Input {
                id: colorPicker
                label: qsTr("Community color")
                placeholderText: qsTr("Pick a color")
                anchors.top: addImageButton.bottom
                anchors.topMargin: Style.current.smallPadding
                validationError: popup.colorValidationError

                StatusIconButton {
                    icon.name: "caret"
                    iconRotation: -90
                    iconColor: Style.current.textColor
                    icon.width: 13
                    icon.height: 7
                    anchors.right: parent.right
                    anchors.rightMargin: Style.current.smallPadding
                    anchors.top: parent.top
                    anchors.topMargin: colorPicker.textField.height / 2 - height / 2 + Style.current.bigPadding
                    onClicked: colorDialog.open()
                }

                ColorDialog {
                    id: colorDialog
                    title: qsTr("Please choose a color")
                    onAccepted: {
                        colorPicker.text = colorDialog.color
                    }
                }
            }

            Separator {
                id: separator1
                anchors.top: colorPicker.bottom
                anchors.topMargin: isEdit ? 0 : Style.current.bigPadding
                visible: !isEdit
            }

            StatusSettingsLineButton {
                id: membershipRequirementSetting
                anchors.top: separator1.bottom
                anchors.topMargin: Style.current.halfPadding
                text: qsTr("Membership requirement")
                currentValue: {
                    switch (membershipRequirementSettingPopup.checkedMembership) {
                    case Constants.communityChatInvitationOnlyAccess: return qsTr("Require invite from another member")
                    case Constants.communityChatOnRequestAccess: return qsTr("Require approval")
                    default: return qsTr("No requirement")
                    }
                }
                onClicked: {
                    membershipRequirementSettingPopup.open()
                }
            }

            StyledText {
                visible: !isEdit
                height: visible ? 50 : 0
                id: privateExplanation
                anchors.top: membershipRequirementSetting.bottom
                wrapMode: Text.WordWrap
                anchors.topMargin: isEdit ? 0 : Style.current.smallPadding * 2
                width: parent.width
                text: qsTr("You can require new members to meet certain criteria before they can join. This can be changed at any time")
            }
        }

        MembershipRequirementPopup {
            id: membershipRequirementSettingPopup
        }
    }

    footer: StatusButton {
        text: isEdit ?
              qsTr("Edit") :
              qsTr("Create")
        anchors.right: parent.right
        onClicked: {
            if (!validate()) {
                scrollView.scrollBackUp()
                return
            }

            let error = false;
            if(isEdit) {
                console.log("TODO: implement this (not available in status-go yet)");
            } else {
                error = chatsModel.createCommunity(Utils.filterXSS(nameInput.text),
                                                   Utils.filterXSS(descriptionTextArea.text),
                                                   colorPicker.text,
                                                   popup.selectedImage)
            }

            if (error) {
                creatingError.text = error
                return creatingError.open()
            }

            // TODO Open the community once we have designs for it
            popup.close()
        }

        MessageDialog {
            id: creatingError
            title: qsTr("Error creating the community")
            icon: StandardIcon.Critical
            standardButtons: StandardButton.Ok
        }
    }
}


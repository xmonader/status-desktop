import QtQuick 2.13
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Qt.labs.platform 1.1
import QtQuick.Window 2.3
import QtQml.StateMachine 1.14 as DSM
import "./onboarding"
import "./app"
import "./imports"

ApplicationWindow {
    id: applicationWindow
    width: 1232
    height: 770
    title: "Nim Status Client"
    visible: true
    property int titlebar_wrapper_size:40
    property int bw: 5

    signal navigateTo(string path)

//    flags: Qt.MSWindowsFixedSizeDialogHint | Qt.FramelessWindowHint
//    flags: Qt.FramelessWindowHint |
//           Qt.WindowMinimizeButtonHint |
//           Qt.Window

//    flags: Qt.Window | Qt.WindowCloseButtonHint | Qt.FramelessWindowHint
//    flags: Qt.Window | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint | Qt.FramelessWindowHint

    color: "#99000000"


    flags: Qt.FramelessWindowHint

    function toggleMaximized() {
        if (applicationWindow.visibility === Window.Maximized) {
            applicationWindow.showNormal();
        } else {
            applicationWindow.showMaximized();
        }
    }

    // The mouse area is just for setting the right cursor shape
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw + 10; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.x >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.NoButton // don't handle actual events
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            const b = bw + 10; // Increase the corner size slightly
            let e = 0;
            if (p.x < b) { e |= Qt.LeftEdge }
            if (p.x >= width - b) { e |= Qt.RightEdge }
            if (p.y < b) { e |= Qt.TopEdge }
            if (p.y >= height - b) { e |= Qt.BottomEdge }
            applicationWindow.startSystemResize(e);
        }
    }


    Page {
        anchors.fill: parent
        anchors.margins: applicationWindow.visibility === Window.Windowed ? bw : 0
        //    footer: ToolBar {
        header: ToolBar {
//            contentHeight: toolButton.implicitHeight
            contentHeight: 40
            Item {
                anchors.fill: parent
                TapHandler {
                    onTapped: if (tapCount === 2) toggleMaximized()
                    gesturePolicy: TapHandler.DragThreshold
                }
                DragHandler {
                    grabPermissions: TapHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { applicationWindow.startSystemMove(); }
                }

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 3
                    Layout.fillWidth: true
                    TabBar {
                        spacing: 0
//                        Repeater {
//                            model: ["Google", "GitHub - johanhelsing/qt-csd-demo", "Unicode: Arrows"]
//                            TabButton {
//                                id: tab
//                                implicitWidth: 150
//                                text: modelData
//                                padding: 0
//                                contentItem: Item {
//                                    implicitWidth: 120
//                                    implicitHeight: 20
//                                    clip: true
//                                    Label {
//                                        id: tabIcon
//                                        text: "↻"
//                                        anchors.top: parent.top
//                                        anchors.bottom: parent.bottom
//                                        horizontalAlignment: Text.AlignHCenter
//                                        verticalAlignment: Text.AlignVCenter
//                                        width: 30
//                                    }
//                                    Text {
//                                        anchors.left: tabIcon.right
//                                        anchors.top: parent.top
//                                        anchors.bottom: parent.bottom
//                                        text: tab.text
//                                        font: tab.font
//                                        opacity: enabled ? 1.0 : 0.3
//                                        horizontalAlignment: Text.AlignHCenter
//                                        verticalAlignment: Text.AlignVCenter
//                                        elide: Text.ElideRight
//                                    }
//                                    Rectangle {
//                                        anchors.top: parent.top
//                                        anchors.bottom: parent.bottom
//                                        anchors.right: tab.checked ? closeButton.left : parent.right
//                                        width: 20
//                                        gradient: Gradient {
//                                            orientation: Gradient.Horizontal
//                                            GradientStop { position: 0; color: "transparent" }
//                                            //GradientStop { position: 1; color: palette.button }
//                                            GradientStop { position: 0.7; color: tab.background.color }
//                                        }
//                                    }
//                                    Button {
//                                        id: closeButton
//                                        anchors.right: parent.right
//                                        anchors.bottom: parent.bottom
//                                        anchors.top: parent.top
//                                        visible: tab.checked
//                                        text: "🗙"
//                                        contentItem: Text {
//                                            text: closeButton.text
//                                            font: closeButton.font
//                                            opacity: enabled ? 1.0 : 0.3
//                                            color: "black"
//                                            horizontalAlignment: Text.AlignHCenter
//                                            verticalAlignment: Text.AlignVCenter
//                                            elide: Text.ElideRight
//                                        }
//                                        background: Rectangle {
//                                            implicitWidth: 10
//                                            implicitHeight: 10
//                                            opacity: enabled ? 1 : 0.3
//                                            color: tab.background.color
//                                        }
//                                    }
//                                }
//                            }
//                        }
                    }
                    RowLayout {
                        spacing: 0
                        ToolButton { text: "+" }
                        Item { Layout.fillWidth: true }
                        ToolButton {
                            text: "🗕"
                            onClicked: applicationWindow.showMinimized();
                        }
                        ToolButton {
                            text: applicationWindow.visibility === Window.Maximized ? "🗗" : "🗖"
                            onClicked: applicationWindow.toggleMaximized()
                        }
                        ToolButton {
                            text: "🗙"
                            onClicked: applicationWindow.close()
                        }
                    }
                }
            }
        }

//        Page {
//            anchors.fill: parent
//            header: ToolBar {
//                RowLayout {
//                    spacing: 0
//                    anchors.fill: parent
//                    ToolButton { text: "←" }
//                    ToolButton { text: "→" }
//                    ToolButton { text: "↻" }
//                    TextField {
//                        text: "https://google.com"
//                        Layout.fillWidth: true
//                    }
//                    ToolButton {
//                        id: toolButton
//                        text: "\u2630"
//                        onClicked: drawer.open()
//                    }
//                }
//            }
//        }

        Drawer {
            id: drawer
            width: applicationWindow.width * 0.66
            height: applicationWindow.height
            edge: Qt.LeftEdge
            interactive: applicationWindow.visibility !== Window.Windowed || position > 0
        }

    }
//    property int previousY

//    Rectangle{
//        id:titlebar
//        width: parent.width
//        Rectangle{
//            id:appclose
//            height: 40
//            y:0
//            width: 40
//            anchors.right: parent.left
//            anchors.rightMargin: 20
//            Text{
//                //text: awesome.loaded ? awesome.icons.fa_money : "x"
//                text: "×"
//                anchors.horizontalCenter: parent.horizontalCenter
//                font.pointSize: 20
//            }
//            MouseArea{
//                width: parent.width
//                height: parent.height
//                hoverEnabled: true
//                onEntered: appclose.color="#ddd"
//                onExited: appclose.color="#fff"
//                onClicked: Qt.quit()
//            }
//        }
//    }

//    MouseArea {
//        height: 5
//        anchors {
//            top: parent.top
//            left: parent.left
//            right: parent.right
//        }

//        cursorShape: Qt.SizeVerCursor

//        onPressed: previousY = mouseY

//        onMouseYChanged: {
//            var dy = mouseY - previousY
//            applicationWindow.setY(applicationWindow.y + dy)
//            applicationWindow.setHeight(applicationWindow.height - dy)

//        }
//    }

//    MouseArea {
//        id:dragparentwindow
//        width: parent.width
//        height: 57
//        property real lastMouseX: 0
//        property real lastMouseY: 0
//        onPressed: {
//            lastMouseX = mouseX
//            lastMouseY = mouseY
//        }
//        onMouseXChanged: registerWindow.x += (mouseX - lastMouseX)
//        onMouseYChanged: registerWindow.y += (mouseY - lastMouseY)
//    }
//    Rectangle{
//        id:titlebar
//        width: parent.width
//        Rectangle{
//            id:appclose
//            height: titlebar_wrapper_size
//            y:0
//            width: titlebar_wrapper_size
//            anchors.right: parent.right
//            Text{
//                //text: awesome.loaded ? awesome.icons.fa_money : "x"
//                text: "×"
//                anchors.horizontalCenter: parent.horizontalCenter
//                font.pointSize: 20
//            }
//            MouseArea{
//                width: parent.width
//                height: parent.height
//                hoverEnabled: true
//                onEntered: appclose.color="#ddd"
//                onExited: appclose.color="#fff"
//                onClicked: Qt.quit()
//            }
//        }
//        Rectangle{
//        id:appminimize
//        height: titlebar_wrapper_size
//        y:0
//        width: titlebar_wrapper_size
//        anchors.right: appclose.left
//        Text{
//            text: '🗕'
//            font.family: segoe_light.name
//            anchors.horizontalCenter: parent.horizontalCenter
//            font.pointSize: 15
//        }
//        MouseArea{
//            width: parent.width
//            height: parent.height
//            hoverEnabled: true
//            onEntered: appminimize.color="#ddd"
//            onExited: appminimize.color="#fff"
//            onClicked: registerWindow.visibility = Window.Minimized
//        }
//    }
//}

    SystemTrayIcon {
        visible: true
        icon.source: "shared/img/status-logo.png"
        menu: Menu {
            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }

//        Component.onCompleted: showMessage("Message title", "Something important came up. Click this to know more.")

        onActivated: {
            applicationWindow.show()
            applicationWindow.raise()
            applicationWindow.requestActivate()
//            showMessage("Message title", "Something important came up. Click this to know more.")
        }
    }

    DSM.StateMachine {
        id: stateMachine
        initialState: onboardingState
        running: true

        DSM.State {
            id: onboardingState
            initialState: loginModel.rowCount() ? stateLogin : stateIntro

            DSM.State {
                id: stateIntro
                onEntered: loader.sourceComponent = intro

                DSM.SignalTransition {
                    targetState: keysMainState
                    signal: applicationWindow.navigateTo
                    guard: path === "KeysMain"
                }
            }

            DSM.State {
                id: keysMainState
                onEntered: loader.sourceComponent = keysMain

                DSM.SignalTransition {
                    targetState: genKeyState
                    signal: applicationWindow.navigateTo
                    guard: path === "GenKey"
                }
            }

            DSM.State {
                id: existingKeyState
                onEntered: loader.sourceComponent = existingKey

                DSM.SignalTransition {
                    targetState: appState
                    signal: onboardingModel.loginResponseChanged
                    guard: !error
                }
            }

            DSM.State {
                id: genKeyState
                onEntered: loader.sourceComponent = genKey

                DSM.SignalTransition {
                    targetState: appState
                    signal: onboardingModel.loginResponseChanged
                    guard: !error
                }
            }

            DSM.State {
                id: stateLogin
                onEntered: loader.sourceComponent = login

                DSM.SignalTransition {
                    targetState: appState
                    signal: loginModel.loginResponseChanged
                    guard: !error
                }

                DSM.SignalTransition {
                    targetState: genKeyState
                    signal: applicationWindow.navigateTo
                    guard: path === "GenKey"
                }
            }

            DSM.SignalTransition {
                targetState: loginModel.rowCount() ? stateLogin : stateIntro
                signal: applicationWindow.navigateTo
                guard: path === "InitialState"
            }

            DSM.SignalTransition {
                targetState: existingKeyState
                signal: applicationWindow.navigateTo
                guard: path === "ExistingKey"
            }

            DSM.FinalState {
                id: onboardingDoneState
            }
        }
        
        DSM.State {
            id: appState
            onEntered: loader.sourceComponent = app

            DSM.SignalTransition {
                targetState: stateLogin
                signal: loginModel.onLoggedOut
            }
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
    }

    Component {
        id: app
        AppMain {}
    }

    Component {
        id: intro
        Intro {
            btnGetStarted.onClicked: applicationWindow.navigateTo("KeysMain")
        }
    }

    Component {
        id: keysMain
        KeysMain {
            btnGenKey.onClicked: applicationWindow.navigateTo("GenKey")
            btnExistingKey.onClicked: applicationWindow.navigateTo("ExistingKey")
        }
    }

    Component {
        id: existingKey
        ExistingKey {
            onClosed: function () {
                applicationWindow.navigateTo("InitialState")
            }
        }
    }

    Component {
        id: genKey
        GenKey {
            onClosed: function () {
                applicationWindow.navigateTo("InitialState")
            }
        }
    }

    Component {
        id: login
        Login {
            onGenKeyClicked: function () {
                applicationWindow.navigateTo("GenKey")
            }
            onExistingKeyClicked: function () {
                applicationWindow.navigateTo("ExistingKey")
            }
        }
    }
}

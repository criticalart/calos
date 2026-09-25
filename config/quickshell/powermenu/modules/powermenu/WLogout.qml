import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../common"

Scope {
    id: root

    readonly property color background: Theme.background
    readonly property color foreground: Theme.foreground
    readonly property color accent: Theme.accent
    readonly property color selectedText: Theme.selectedText
    readonly property color border: Theme.border

    property int selectedIndex: -1
    property bool mouseSelection: false
    property string currentTime: Qt.formatTime(new Date(), "HH:mm:ss")

    default property list<LogoutButton> buttons

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.currentTime = Qt.formatTime(new Date(), "HH:mm:ss")
        }
    }

    function selectButton(index) {
        if (buttons.length === 0)
            return

        mouseSelection = false
        selectedIndex = (index + buttons.length) % buttons.length
    }

    function close() {
        Qt.quit()
    }

    function activateButton(button) {
        button.exec()
        Qt.quit()
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: w

            required property var modelData

            screen: modelData

            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            color: "transparent"

            contentItem {
                focus: true

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        root.close()
                        event.accepted = true
                    }

                    else if (event.key === Qt.Key_Left) {
                        root.selectButton(root.selectedIndex - 1)
                        event.accepted = true
                    }

                    else if (event.key === Qt.Key_Right) {
                        root.selectButton(root.selectedIndex + 1)
                        event.accepted = true
                    }

                    else if (
                        event.key === Qt.Key_Return ||
                        event.key === Qt.Key_Enter
                    ) {
                        if (
                            root.selectedIndex >= 0 &&
                            root.selectedIndex < root.buttons.length
                        ) {
                            root.activateButton(
                                root.buttons[root.selectedIndex]
                            )
                        }

                        event.accepted = true
                    }

                    else if (event.modifiers === Qt.ControlModifier) {
                        for (let i = 0; i < root.buttons.length; i++) {
                            let button = root.buttons[i]

                            if (event.key === button.keybind) {
                                root.activateButton(button)
                                event.accepted = true
                                return
                            }
                        }
                    }
                }
            }

            anchors {
                top: true
                left: true
                bottom: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: "#000000"
                opacity: 0.80
            }

            MouseArea {
                anchors.fill: parent

                onClicked: root.close()

                GridLayout {
                    anchors.centerIn: parent

                    columns: 4
                    columnSpacing: 40
                    rowSpacing: 0

                    Repeater {
                        model: root.buttons

                        delegate: Rectangle {
                            required property LogoutButton modelData
                            required property int index

                            readonly property bool selected:
                                root.selectedIndex === index &&
                                (!root.mouseSelection || ma.containsMouse)

                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 200

                            radius: 12

                            color: selected
                                   ? Qt.alpha(root.accent, 0.5)
                                   : Qt.alpha(root.background, 0.7)

                            border.width: 0

                            border.color: selected
                                          ? root.accent
                                          : root.border

                            scale: selected ? 1.08 : 1.0

                            Behavior on scale {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            MouseArea {
                                id: ma

                                anchors.fill: parent
                                hoverEnabled: true

                                onEntered: {
                                    root.mouseSelection = true
                                    root.selectedIndex = index
                                }

                                onClicked: {
                                    root.activateButton(modelData)
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 12

                                Image {
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    source: `icons/${modelData.icon}.png`

                                    width: 50
                                    height: 50

                                    opacity: selected ? 1.0 : 0.25

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 150
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    text: modelData.text
                                    font.pointSize: 20

                                    color: selected
                                           ? root.selectedText
                                           : root.foreground

                                    opacity: selected ? 1.0 : 0.55

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 180
                                            easing.type: Easing.OutCubic
                                        }
                                    }

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    text: "CTRL + " +
                                          String.fromCharCode(modelData.keybind)

                                    font.pointSize: 11

                                    color: root.foreground
                                    opacity: selected ? 0.70 : 0.35

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 150
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Text {
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: 30
                }

                text: root.currentTime

                color: root.foreground
                font.pointSize: 32
                opacity: 0.70
            }
        }
    }
}

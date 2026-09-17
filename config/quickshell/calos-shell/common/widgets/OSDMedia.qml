import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property string artist: ""
    property string title: ""
    property bool playing: false

    implicitHeight: 68

    function resetTitleScroll() {
        titleScrollTimer.stop()
        titleScrollAnimation.stop()
        mediaTitleText.x = 0
        titleScrollTimer.restart()
    }

    RowLayout {
        id: mediaLayout
        anchors.fill: parent
        anchors.leftMargin: 26
        anchors.rightMargin: 26
        anchors.topMargin: 14
        anchors.bottomMargin: 20
        spacing: 20

        Rectangle {
            Layout.preferredWidth: 68
            Layout.preferredHeight: 68
            radius: 16
            color: Qt.alpha(Theme.accent, 0.13)
            border.width: 1
            border.color: Qt.alpha(Theme.accent, 0.28)

            Text {
                anchors.centerIn: parent
                text: root.playing ? "󰝚" : "󰝛"
                color: Theme.accent
                font.pixelSize: 34
                renderType: Text.NativeRendering
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            spacing: 3

            Text {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                text: root.playing ? "󰐊 NOW PLAYING" : "󰏤 PAUSED"
                color: Theme.foreground
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.DemiBold
                font.letterSpacing: 1.2
                elide: Text.ElideRight
            }

            Item {
                id: titleViewport
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                Layout.preferredHeight: mediaTitleText.implicitHeight
                clip: true

                Text {
                    id: mediaTitleText
                    text: root.title !== "" ? root.title : "NO TITLE"
                    color: Theme.selectedText
                    font.family: "Iosevka"
                    font.pixelSize: 26
                    font.weight: Font.Bold
                    width: implicitWidth
                    height: implicitHeight

                    onTextChanged: root.resetTitleScroll()
                    onImplicitWidthChanged: root.resetTitleScroll()
                }

                Timer {
                    id: titleScrollTimer
                    interval: 900
                    repeat: false

                    onTriggered: {
                        if (mediaTitleText.width > titleViewport.width)
                            titleScrollAnimation.restart()
                    }
                }

                SequentialAnimation {
                    id: titleScrollAnimation
                    loops: Animation.Infinite

                    PauseAnimation { duration: 900 }

                    NumberAnimation {
                        target: mediaTitleText
                        property: "x"
                        to: -Math.max(0, mediaTitleText.width - titleViewport.width)
                        duration: Math.max(
                            1400,
                            (mediaTitleText.width - titleViewport.width) * 18
                        )
                        easing.type: Easing.Linear
                    }

                    PauseAnimation { duration: 1200 }

                    NumberAnimation {
                        target: mediaTitleText
                        property: "x"
                        to: 0
                        duration: 900
                        easing.type: Easing.Linear
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                text: root.artist !== "" ? root.artist : "UNKNOWN ARTIST"
                color: Theme.foreground
                font.family: "Inter"
                font.pixelSize: 14
                elide: Text.ElideRight
            }
        }
    }

    Component.onCompleted: resetTitleScroll()
}

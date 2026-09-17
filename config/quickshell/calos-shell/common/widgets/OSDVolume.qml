import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property int volume: 0
    property bool muted: false
    property int leftMargin: 26
    property int rightMargin: 26
    property int topMargin: 20
    property int bottomMargin: 20

    implicitHeight: 68

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.leftMargin
        anchors.rightMargin: root.rightMargin
        anchors.topMargin: root.topMargin
        anchors.bottomMargin: root.bottomMargin
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
                text: root.muted ? "󰖁" : "󰕾"
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
                text: "VOLUME"
                color: Theme.foreground
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.DemiBold
                font.letterSpacing: 1.2
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                text: root.muted ? "MUTE" : root.volume + "%"
                color: Theme.selectedText
                font.family: "Iosevka"
                font.pixelSize: 28
                font.weight: Font.Bold
                elide: Text.ElideRight
            }

            Item {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                Layout.preferredHeight: 3
                Layout.topMargin: 5

                Rectangle {
                    width: 160
                    height: parent.height
                    anchors.left: parent.left
                    radius: height / 2
                    color: Qt.alpha(Theme.foreground, 0.10)

                    Rectangle {
                        width: parent.width * Math.min(root.volume / 100, 1)
                        height: parent.height
                        radius: height / 2
                        color: Theme.accent

                        Behavior on width {
                            NumberAnimation {
                                duration: 180
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }
}

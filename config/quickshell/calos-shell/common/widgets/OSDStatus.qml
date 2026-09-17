import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property string icon: ""
    property string title: ""
    property string value: ""
    property bool active: true
    property bool showProgress: true
    property real progress: active ? 1 : 0.28
    property int titleSize: 15
    property int valueSize: 28
    property real titleLetterSpacing: 1.2
    property real valueLetterSpacing: 0
    property int leftMargin: 26
    property int rightMargin: 26
    property int topMargin: 20
    property int bottomMargin: 20
    property int spacing: 20

    implicitHeight: 68

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.leftMargin
        anchors.rightMargin: root.rightMargin
        anchors.topMargin: root.topMargin
        anchors.bottomMargin: root.bottomMargin
        spacing: root.spacing

        Rectangle {
            Layout.preferredWidth: 68
            Layout.preferredHeight: 68
            radius: 16
            color: Qt.alpha(Theme.accent, 0.13)
            border.width: 1
            border.color: Qt.alpha(Theme.accent, 0.28)

            Text {
                anchors.centerIn: parent
                text: root.icon
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
                text: root.title
                color: Theme.foreground
                font.family: "Inter"
                font.pixelSize: root.titleSize
                font.weight: Font.DemiBold
                font.letterSpacing: root.titleLetterSpacing
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                text: root.value
                color: root.active ? Theme.selectedText : Theme.foreground
                font.family: "Iosevka"
                font.pixelSize: root.valueSize
                font.weight: Font.Bold
                font.letterSpacing: root.valueLetterSpacing
                elide: Text.ElideRight

                Behavior on color {
                    ColorAnimation { duration: 120 }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                Layout.preferredHeight: 3
                Layout.topMargin: 5
                radius: height / 2
                color: Qt.alpha(Theme.foreground, 0.10)
                visible: root.showProgress

                Rectangle {
                    width: parent.width * Math.max(0, Math.min(root.progress, 1))
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

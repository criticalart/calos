import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Variants {
	id: root
	property color backgroundColor: "#e60c0c0c"
	property color buttonColor: "transparent"
	property color buttonHoverColor: "transparent"
	default property list<LogoutButton> buttons

	model: Quickshell.screens
	PanelWindow {
		id: w

		property var modelData
		screen: modelData

		exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    property string currentTime: Qt.formatTime(new Date(), "hh:mm:ss")
		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    color: "transparent"

    Timer {
    interval: 1000
    running: true
    repeat: true

    onTriggered: {
        w.currentTime = Qt.formatTime(new Date(), "hh:mm:ss")
        }
    }

		contentItem {
			focus: true
			Keys.onPressed: event => {
				if (event.key == Qt.Key_Escape) Qt.quit();
				else {
					for (let i = 0; i < buttons.length; i++) {
						let button = buttons[i];
						if (event.key == button.keybind) button.exec();
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
			color: backgroundColor;
      anchors.fill: parent

      Text {
        text: "-caliburnOS-"

        anchors {
          right: parent.right
          bottom: parent.bottom
          rightMargin: 25
          bottomMargin: 20
        }

        color: "white"
        opacity: 0.35
        font.pointSize: 18
      }

      Text {
        text: w.currentTime

        anchors {
          top: parent.top
          horizontalCenter: parent.horizontalCenter
          topMargin: 20
        }

        color: "white"
        opacity: 0.65
        font.pointSize: 18
      }

			MouseArea {
				anchors.fill: parent
				onClicked: Qt.quit()

				GridLayout {
					anchors.centerIn: parent

					width: parent.width * 0.25
					height: parent.height * 0.25

					columns: 3
					columnSpacing: 10
					rowSpacing: 0

			Repeater {
				model: buttons
				delegate: Rectangle {
          required property LogoutButton modelData

          Layout.preferredWidth: 200
          Layout.preferredHeight: 200

          color: "transparent"

          scale: ma.containsMouse ? 1.08 : 1.0

          Behavior on scale {
            NumberAnimation {
              duration: 150
              easing.type: Easing.OutCubic
              }
           }

      MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true

        onClicked: modelData.exec()
      }

      Image {
        id: icon
        anchors.centerIn: parent

        source: `icons/${modelData.icon}.png`

        width: parent.width * 0.25
        height: parent.width * 0.25

        opacity: ma.containsMouse ? 1.0 : 0.25

        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
          }
      }

      Text {
    anchors {
        top: icon.bottom
        topMargin: 20
        horizontalCenter: parent.horizontalCenter
    }

    text: modelData.text
    font.pointSize: 20
    color: "white"

    opacity: ma.containsMouse ? 1.0 : 0.55

    Behavior on opacity {
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
	}
}

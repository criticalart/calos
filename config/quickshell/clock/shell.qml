import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: window

			property var modelData
			property date currentTime: new Date()
			property bool ready: false

			screen: modelData

			anchors {
				top: true
				bottom: true
				left: true
				right: true
			}

			exclusionMode: ExclusionMode.Ignore

			color: "#80000000"

			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.namespace: "clock"
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

			Timer {
				id: startupTimer

				interval: 150
				repeat: false
				running: true

				onTriggered: {
					window.ready = true
				}
			}

			Timer {
				interval: 1000
				running: true
				repeat: true

				onTriggered: {
					window.currentTime = new Date()
				}
      }

      Item {
	      id: keyboardHandler

	      width: 1
	      height: 1

	      focus: true

	      Keys.onPressed: function(event) {
		      if (event.key === Qt.Key_Escape) {
			      Qt.quit()
			      event.accepted = true
		      }
	      }
      }

			Column {
				anchors.centerIn: parent
				spacing: 0

				Text {
					anchors.horizontalCenter: parent.horizontalCenter

					text: Qt.formatDateTime(
						window.currentTime,
						"dddd, MMMM d, yyyy"
					)

					color: "#80ffffff"
          font.pointSize: 18
          font.family: "Jet Brains Mono"
				}

				Text {
					anchors.horizontalCenter: parent.horizontalCenter

					text: Qt.formatDateTime(
						window.currentTime,
						"hh:mm:ss"
					)

					color: "#ffffff"
					font.pointSize: 68
          font.bold: true
          font.family: "Inter"
				}
			}

			MouseArea {
				anchors.fill: parent

				enabled: window.ready
				acceptedButtons: Qt.LeftButton

				onClicked: {
					Qt.quit()
				}
			}
		}
	}
}

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

			Timer {
				interval: 1000
				running: true
				repeat: true

				onTriggered: window.currentTime = new Date()
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
				}

				Text {
					anchors.horizontalCenter: parent.horizontalCenter

					text: Qt.formatDateTime(
						window.currentTime,
						"hh:mm:ss"
					)

					color: "#ffffff"
					font.pointSize: 64
					font.bold: true
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: Qt.quit()
			}
		}
	}
}

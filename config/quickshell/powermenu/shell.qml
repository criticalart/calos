import QtQuick
import Quickshell

ShellRoot {
	WLogout {
		LogoutButton {
			command: "calos-logoff"
			keybind: Qt.Key_L
			text: "Logout  "
			icon: "logout"
		}

		LogoutButton {
			command: "calos-shutdown"
			keybind: Qt.Key_S
			text: "Shutdown"
			icon: "shutdown"
		}

		LogoutButton {
			command: "calos-bios-reboot"
			keybind: Qt.Key_R
			text: "BIOS Reboot"
			icon: "reboot"
		}
	}
}

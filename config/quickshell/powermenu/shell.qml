//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QPA_PLATFORMTHEME=

import QtQuick
import Quickshell
import "./modules/powermenu"

ShellRoot {
    WLogout {
        LogoutButton {
            command: "calos-cmd-lockscreen"
            keybind: Qt.Key_L
            text: "Lock"
            icon: "lock"
        }

        LogoutButton {
            command: "calos-logoff"
            keybind: Qt.Key_E
            text: "Logout"
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

//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QPA_PLATFORMTHEME=

import "./modules/overview/"
import "./modules/wallselect/"
import "./modules/theme/"
import "./services"
import QtQuick

import Quickshell
import Quickshell.Io

ShellRoot {
    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
    }

    IpcHandler {
        target: "wallselect"

        function open(): void {
            GlobalStates.wallselectOpen = true;
        }
    }

    IpcHandler {
        target: "theme"

        function open(): void {
            GlobalStates.themeOpen = true;
        }
    }

    Overview {}
    OSD {}

    LazyLoader {
        active: GlobalStates.wallselectOpen
        Wallselect {}
    }

    LazyLoader {
        active: GlobalStates.themeOpen
        Theme {}
    }
}

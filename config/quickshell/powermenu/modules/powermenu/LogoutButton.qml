import QtQuick
import Quickshell.Io

QtObject {
    id: button

    required property string command
    required property string text
    required property string icon
    property var keybind: null

    readonly property var process: Process {
        command: ["sh", "-c", button.command]
    }

    function exec() {
        process.startDetached()
    }
}

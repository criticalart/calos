pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property color background: "#121212"
    property color foreground: "#D9D9D9"
    property color accent: "#C97827"
    property color selectedText: "#F2A33A"
    property color border: "#4A2F1A"

    readonly property string themePath:
        Quickshell.env("HOME") +
        "/.config/calos/current/theme/quickshell.json"

    FileView {
        id: themeFile

        path: root.themePath

        onTextChanged: {
            root.applyTheme(text());
        }
    }

    function applyTheme(jsonText) {
        try {
            const theme = JSON.parse(jsonText);

            if (typeof theme.background === "string")
                root.background = theme.background;

            if (typeof theme.foreground === "string")
                root.foreground = theme.foreground;

            if (typeof theme.accent === "string")
                root.accent = theme.accent;

            if (typeof theme.selectedText === "string")
                root.selectedText = theme.selectedText;

            if (typeof theme.border === "string")
                root.border = theme.border;
        } catch (error) {
            console.warn("Failed to parse Quickshell theme:", error);
        }
    }

    function reload() {
        themeFile.reload();
    }
}

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
        "/.config/calos/current/theme/walker.css"

    FileView {
        id: themeFile

        path: root.themePath

        onTextChanged: {
            root.applyTheme(text());
        }
    }

    function applyTheme(css) {
        function getColor(name) {
            const regex = new RegExp(
                "@define-color\\s+" +
                name.replace("-", "\\-") +
                "\\s+(#[0-9A-Fa-f]{6})"
            );

            const match = css.match(regex);

            return match ? match[1] : null;
        }

        const newBackground = getColor("background");
        const newForeground = getColor("text");
        const newAccent = getColor("accent");
        const newSelectedText = getColor("selected-text");
        const newBorder = getColor("border");

        if (newBackground)
            root.background = newBackground;

        if (newForeground)
            root.foreground = newForeground;

        if (newAccent)
            root.accent = newAccent;

        if (newSelectedText)
            root.selectedText = newSelectedText;

        if (newBorder)
            root.border = newBorder;
    }

    function reload() {
        themeFile.reload();
    }
}

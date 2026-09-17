import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "./common"
import "./common/widgets"

Scope {
    id: root

    readonly property color background: Theme.background
    readonly property color foreground: Theme.foreground
    readonly property color accent: Theme.accent
    readonly property color selectedText: Theme.selectedText
    readonly property color border: Theme.border

    readonly property int osdWidth: 320
    readonly property int mediaWidth: 480
    readonly property int logWidth: 480
    readonly property int osdHeight: 112
    readonly property real bottomPosition: 0.80

    readonly property int animationInDuration: 400
    readonly property int animationOutDuration: 240

    property real cardWidth: 0
    property real cardHeight: 10
    property real cardRadius: 2

    property real contentOpacity: 0
    property real contentScale: 0.88
    property real contentX: 0

    property string mode: ""
    property string volumePosition: "bottom"
    property bool capsLock: false
    property bool visibleState: false

    property int volume: 0
    property bool volumeMuted: false

    property string mediaArtist: ""
    property string mediaTitle: ""
    property bool mediaPlaying: false

    property bool blueLightEnabled: false
    property bool waybarEnabled: false
    property bool gameModeEnabled: false

    function widthForMode() {
        return root.mode === "media" ||
            root.mode === "logout" ||
            root.mode === "login"
            ? root.mediaWidth
            : root.osdWidth
    }

    function resizeForMode() {
        if (!root.visibleState)
            return

        const targetWidth = root.widthForMode()

        if (root.cardWidth === targetWidth)
            return

        mediaResizeAnimation.stop()
        mediaResizeAnimation.to = targetWidth
        mediaResizeAnimation.restart()
    }

    function showCapsLock() {
        root.mode = "caps"
        capsStateProcess.running = false
        capsStateProcess.running = true
    }

    function showVolumeUp(position = "bottom") {
        root.volumePosition = position
        root.mode = "volume"
        volumeProcess.action = "up"
        volumeProcess.querying = false
        volumeProcess.running = false
        volumeProcess.running = true
        root.show()
    }

    function showVolumeDown(position = "bottom") {
        root.volumePosition = position
        root.mode = "volume"
        volumeProcess.action = "down"
        volumeProcess.querying = false
        volumeProcess.running = false
        volumeProcess.running = true
        root.show()
    }

    function showMute(position = "bottom") {
        root.volumePosition = position
        root.mode = "volume"
        volumeProcess.action = "mute"
        volumeProcess.querying = false
        volumeProcess.running = false
        volumeProcess.running = true
        root.show()
    }

    function showNext() {
        root.mode = "media"
        mediaProcess.action = "next"
        mediaProcess.querying = false
        mediaProcess.running = false
        mediaProcess.running = true
        root.show()
    }

    function showPrevious() {
        root.mode = "media"
        mediaProcess.action = "previous"
        mediaProcess.querying = false
        mediaProcess.running = false
        mediaProcess.running = true
        root.show()
    }

    function showPlayPause() {
        root.mode = "media"
        mediaProcess.action = "play-pause"
        mediaProcess.querying = false
        mediaProcess.running = false
        mediaProcess.running = true
        root.show()
    }

    function showBlueLight(enabled) {
        root.mode = "bluelight"
        root.blueLightEnabled = enabled
        root.show()
    }

    function showGameMode(enabled) {
        root.mode = "game"
        root.gameModeEnabled = enabled
        root.show()
    }

    function showWaybar(enabled) {
        root.mode = "waybar"
        root.waybarEnabled = enabled
        root.show()
    }

    function showSteam() {
        root.mode = "steam"
        root.show()
    }

    function showScreenRecord() {
        root.mode = "screenrecord"
        root.show()
    }

    function showLogout() {
        root.mode = "logout"
        root.show()
    }

    function showLogin() {
        root.mode = "login"
        root.show()
    }

    function updateDisplay() {
        if (root.visibleState) {
            root.resizeForMode()
            hideTimer.restart()
        } else {
            root.show()
        }
    }

    function show() {
        hideTimer.stop()

        if (root.visibleState) {
            outroAnimation.stop()
            root.cardHeight = root.osdHeight
            root.cardRadius = 2
            root.contentOpacity = 1
            root.contentScale = 1
            root.contentX = 0
            root.resizeForMode()
            hideTimer.restart()
            return
        }

        mediaResizeAnimation.stop()
        root.visibleState = true
        root.cardWidth = 0
        root.cardHeight = 10
        root.cardRadius = 2
        root.contentOpacity = 0
        root.contentScale = 0.88
        root.contentX = 10
        introAnimation.restart()
        hideTimer.restart()
    }

    function hide() {
        hideTimer.stop()
        mediaResizeAnimation.stop()
        outroAnimation.restart()
    }

    Timer {
        id: hideTimer
        interval:
            root.mode === "caps" ||
            root.mode === "logout" ||
            root.mode === "login"
                ? 1250
                : root.mode === "media"
                    ? 3500
                    : 2000
        repeat: false
        onTriggered: root.hide()
    }

    ParallelAnimation {
        id: introAnimation

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "cardWidth"
                from: 0
                to: root.widthForMode()
                duration: root.animationInDuration
                easing.type: Easing.OutCubic
                easing.overshoot: 1.12
            }

            NumberAnimation {
                target: root
                property: "cardHeight"
                from: 10
                to: root.osdHeight
                duration: root.animationInDuration
                easing.type: Easing.OutCubic
            }
        }

        SequentialAnimation {
            PauseAnimation { duration: 150 }

            ParallelAnimation {
                NumberAnimation {
                    target: root
                    property: "contentOpacity"
                    from: 0
                    to: 1
                    duration: 260
                    easing.type: Easing.OutCubic
                }

                NumberAnimation {
                    target: root
                    property: "contentScale"
                    from: 0.88
                    to: 1
                    duration: 340
                    easing.type: Easing.OutCubic
                }

                NumberAnimation {
                    target: root
                    property: "contentX"
                    from: 10
                    to: 0
                    duration: 320
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    NumberAnimation {
        id: mediaResizeAnimation
        target: root
        property: "cardWidth"
        duration: 280
        easing.type: Easing.OutCubic
    }

    SequentialAnimation {
        id: outroAnimation

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "contentOpacity"
                from: 1
                to: 0
                duration: root.animationOutDuration
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: root
                property: "contentScale"
                from: 1
                to: 0.92
                duration: 160
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: root
                property: "cardHeight"
                from: root.cardHeight
                to: 10
                duration: root.animationOutDuration
                easing.type: Easing.InCubic
            }
        }

        ScriptAction {
            script: root.visibleState = false
        }
    }

    IpcHandler {
        target: "osd"

        function caps(): void { root.showCapsLock() }

        function volumeUp(): void {
            root.showVolumeUp()
        }

        function volumeDown(): void {
            root.showVolumeDown()
        }

        function mute(): void {
            root.showMute()
        }

        function volumeUpTopRight(): void {
            root.showVolumeUp("topRight")
        }

        function volumeDownTopRight(): void {
            root.showVolumeDown("topRight")
        }

        function muteTopRight(): void {
            root.showMute("topRight")
        }

        function next(): void { root.showNext() }
        function previous(): void { root.showPrevious() }
        function playPause(): void { root.showPlayPause() }
        function bluelight(enabled: bool): void { root.showBlueLight(enabled) }
        function waybar(enabled: bool): void { root.showWaybar(enabled) }
        function steam(): void { root.showSteam() }
        function screenrecord(): void { root.showScreenRecord() }
        function logout(): void { root.showLogout() }
        function login(): void { root.showLogin() }
        function refreshTheme(): void { Theme.reload() }
        function game(enabled: bool): void { root.showGameMode(enabled) }
        function hide(): void { root.hide() }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                required property var modelData

                screen: modelData
                visible: root.visibleState

                anchors.bottom: !(root.mode === "volume" && root.volumePosition === "topRight")
                anchors.top: root.mode === "volume" && root.volumePosition === "topRight"
                anchors.right: root.mode === "volume" && root.volumePosition === "topRight"

                margins.bottom:
                    root.mode === "volume" && root.volumePosition === "topRight"
                        ? 0
                        : Math.round(modelData.height * root.bottomPosition)

                margins.top:
                    root.mode === "volume" && root.volumePosition === "topRight"
                        ? 4
                        : 0

                margins.right:
                    root.mode === "volume" && root.volumePosition === "topRight"
                        ? 25
                        : 0

                implicitWidth: root.mediaWidth + 20
                implicitHeight: root.osdHeight + 12

                exclusiveZone: 0
                aboveWindows: true
                focusable: false

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

                color: "transparent"

                Rectangle {
                    anchors.centerIn: parent
                    width: root.cardWidth
                    height: root.cardHeight
                    radius: root.cardRadius
                    clip: true
                    color: root.background
                    opacity: 0.92
                    border.width: 1
                    border.color: Qt.alpha(root.border, 0.75)

                    Loader {
                        anchors.fill: parent
                        opacity: root.contentOpacity
                        scale: root.contentScale
                        transform: Translate { x: root.contentX }

                        sourceComponent: {
                            switch (root.mode) {
                            case "caps": return capsComponent
                            case "volume": return volumeComponent
                            case "media": return mediaComponent
                            case "bluelight": return bluelightComponent
                            case "game": return gameComponent
                            case "waybar": return waybarComponent
                            case "steam": return steamComponent
                            case "screenrecord": return screenRecordComponent
                            case "logout": return logoutComponent
                            case "login": return loginComponent
                            default: return null
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: capsComponent

        OSDStatus {
            icon: "󰪛"
            title: "CAPS LOCK"
            value: root.capsLock ? "ON" : "OFF"
            active: root.capsLock
        }
    }

    Component {
        id: volumeComponent

        OSDVolume {
            volume: root.volume
            muted: root.volumeMuted
        }
    }

    Component {
        id: mediaComponent

        OSDMedia {
            artist: root.mediaArtist
            title: root.mediaTitle
            playing: root.mediaPlaying
        }
    }

    Component {
        id: bluelightComponent

        OSDStatus {
            icon: root.blueLightEnabled ? "󰖔" : "󰖙"
            title: "BLUELIGHT FILTER"
            value: root.blueLightEnabled ? "ENABLED" : "DISABLED"
            active: root.blueLightEnabled
        }
    }

    Component {
        id: gameComponent

        OSDStatus {
            icon: root.gameModeEnabled ? "󰊴" : "󰊵"
            title: "GAME MODE"
            value: root.gameModeEnabled ? "ENABLED" : "DISABLED"
            active: root.gameModeEnabled
            titleSize: 14
        }
    }

    Component {
        id: waybarComponent

        OSDStatus {
            icon: ""
            title: "Waybar Off"
            value: root.waybarEnabled
                ? "ENABLED"
                : "SUPER+CTRL+W to re-enable"
            active: root.waybarEnabled
            titleSize: 24
            valueSize: 12
        }
    }

    Component {
        id: steamComponent

        OSDStatus {
            icon: "󰓓"
            title: "Big Picture Mode"
            value: "Launching..."
            titleSize: 20
            valueSize: 18
            showProgress: true
            progress: 1
        }
    }

    Component {
        id: screenRecordComponent

        OSDStatus {
            icon: "󰯜"
            title: "RECORDING"
            value: "SUPER + PRINT to Stop"
            titleSize: 24
            valueSize: 14
            showProgress: true
            progress: 1
        }
    }

    Component {
        id: logoutComponent

        OSDStatus {
            icon: ""
            title: "TERMINATING SHELL"
            value: "SEE YA LATER!"
            leftMargin: 40
            rightMargin: 80
            titleSize: 15
            valueSize: 28
            valueLetterSpacing: 1.2
        }
    }

    Component {
        id: loginComponent

        OSDStatus {
            icon: ""
            title: "INITIALIZING SHELL"
            value: "WELCOME BACK!"
            leftMargin: 20
            rightMargin: 40
            titleSize: 15
            valueSize: 28
            valueLetterSpacing: 1.2
        }
    }

    Process {
        id: capsStateProcess

        command: [
            "bash",
            "-c",
            "cat /sys/class/leds/*::capslock/brightness | head -n1"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.capsLock = this.text.trim() === "1"
                root.show()
            }
        }
    }

    Process {
        id: volumeProcess

        property string action: "up"
        property bool querying: false

        command: querying
            ? ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
            : action === "up"
                ? ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]
                : action === "down"
                    ? ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
                    : ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!volumeProcess.querying)
                    return

                const output = this.text.trim()
                const match = output.match(/Volume:\s+([0-9.]+)/)

                if (match)
                    root.volume = Math.round(parseFloat(match[1]) * 100)

                root.volumeMuted = output.includes("[MUTED]")
                root.updateDisplay()
            }
        }

        onExited: {
            if (!querying) {
                querying = true
                running = true
            } else {
                querying = false
            }
        }
    }

    Process {
        id: mediaProcess

        property string action: "next"
        property bool querying: false

        command: querying
            ? ["playerctl", "metadata", "--format", "{{artist}}|||{{title}}"]
            : action === "next"
                ? ["playerctl", "next"]
                : action === "previous"
                    ? ["playerctl", "previous"]
                    : ["playerctl", "play-pause"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!mediaProcess.querying)
                    return

                const output = this.text.trim()
                const metadata = output.split("|||")

                root.mediaArtist = metadata.length > 0
                    ? metadata[0]
                    : ""

                root.mediaTitle = metadata.length > 1
                    ? metadata[1]
                    : ""

                mediaStatusProcess.running = false
                mediaStatusProcess.running = true
            }
        }

        onExited: {
            if (!querying) {
                mediaQueryTimer.restart()
            } else {
                querying = false
            }
        }
    }

    Timer {
        id: mediaQueryTimer

        interval: mediaProcess.action === "play-pause" ? 50 : 100
        repeat: false

        onTriggered: {
            mediaProcess.querying = true
            mediaProcess.running = true
        }
    }

    Process {
        id: mediaStatusProcess

        command: ["playerctl", "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.mediaPlaying = this.text.trim() === "Playing"
                root.updateDisplay()
            }
        }
    }
}

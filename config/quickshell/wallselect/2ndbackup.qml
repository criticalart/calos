import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
    id: main

    // Full-screen panel
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    property int speed: 5000

    aboveWindows: true
    exclusionMode: "Ignore"
    exclusiveZone: 1

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Component.onCompleted: {
        Quickshell.execDetached([
            "bash",
            Quickshell.shellPath("cache.sh"),
            Quickshell.shellDir
        ])

        console.log(Quickshell.shellDir)
    }

    FileView {
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: configs

            property string wallpaper_path
            property string cache_path
            property int number_of_pictures
            property string border_color
        }
    }

    FolderListModel {
        id: folderModel

        folder: "file://" + configs.wallpaper_path

        showDirs: false
        nameFilters: ["*.png", "*.jpg"]
        sortField: FolderListModel.Name
    }

    MouseArea {
        id: backgroundArea

        anchors.fill: parent
        z: 0

        onClicked: {
            Qt.quit()
        }
    }

    ListView {
        id: list

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        height: 500

        z: 1

        focus: true

        model: folderModel
        orientation: ListView.Horizontal

        spacing: 4
        clip: true

        cacheBuffer: width

        property int selectedIndex: 0
        property real tileWidth: width / configs.number_of_pictures - 10

        // Mouse wheel scrolling
        property real wheelTargetX: contentX
        property bool wheelScrolling: false

        function clampIndex(i) {
            return Math.max(0, Math.min(i, count - 1))
        }

        function activateCurrent() {
            const path = folderModel.get(selectedIndex, "filePath")

            Quickshell.execDetached([
                "bash",
                Quickshell.shellPath("commands.sh"),
                path
            ])

            Qt.quit()
        }

        function clampX(x) {
            return Math.max(
                0,
                Math.min(x, contentWidth - width)
            )
        }

        /*
         * Move the view so the selected item is visible.
         *
         * Keyboard navigation uses a dedicated NumberAnimation,
         * making movement quick and predictable even when the
         * selected item reaches the edge of the screen.
         */
        function ensureVisibleAnimated(i) {
            const step = tileWidth + spacing
            const itemStart = i * step
            const itemEnd = itemStart + tileWidth + 20

            let target = contentX

            if (itemStart < contentX) {
                target = itemStart
            } else if (itemEnd > contentX + width) {
                target = itemStart - (width - step)
            }

            target = clampX(target)

            if (target !== contentX) {
                keyboardScrollAnimation.stop()

                keyboardScrollAnimation.from = contentX
                keyboardScrollAnimation.to = target

                keyboardScrollAnimation.start()
            }
        }

        /*
         * Smooth keyboard scrolling.
         *
         * 110ms keeps keyboard navigation responsive while
         * still giving the movement a nice glide.
         */
        NumberAnimation {
            id: keyboardScrollAnimation

            target: list
            property: "contentX"

            duration: 110

            easing.type: Easing.OutCubic
        }

        /*
         * Smooth mouse wheel scrolling.
         */
        NumberAnimation {
            id: wheelAnimation

            target: list
            property: "contentX"

            duration: 150

            easing.type: Easing.OutCubic

            onFinished: {
                list.wheelScrolling = false
            }
        }

        Component.onCompleted: {
            wheelTargetX = contentX
        }

        delegate: Item {
            id: delegateItem

            required property int index

            property bool active: index === list.selectedIndex
            property real entranceOffset: 25

            // Selected image is slightly wider.
            width: active ? list.tileWidth * 1.50 : list.tileWidth
            height: 500

            // Entrance animation starts invisible.
            opacity: 0

            // Start slightly below the final position.
            transform: Translate {
                y: delegateItem.entranceOffset
            }

            // Smoothly expand/contract when selection changes.
            Behavior on width {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            // Stagger each wallpaper's entrance.
            Timer {
                id: entranceTimer

                interval: index * 30
                repeat: false
                running: true

                onTriggered: {
                    entranceAnimation.start()
                }
            }

            ParallelAnimation {
                id: entranceAnimation

                // Fade in.
                NumberAnimation {
                    target: delegateItem
                    property: "opacity"

                    from: 0
                    to: 1

                    duration: 300

                    easing.type: Easing.OutCubic
                }

                // Slide upward.
                NumberAnimation {
                    target: delegateItem
                    property: "entranceOffset"

                    from: 25
                    to: 0

                    duration: 300

                    easing.type: Easing.OutCubic
                }
            }

            Text {
                id: alt

                visible: img.status === Image.Error

                text: "Caching"
                color: configs.border_color

                anchors.centerIn: parent

                font.pixelSize: 16

                transform: Shear {
                    xFactor: -0.25
                }
            }

            Image {
                id: img

                anchors.fill: parent

                fillMode: Image.PreserveAspectCrop

                asynchronous: true
                cache: true
                smooth: true

                source:
                    "file://" +
                    configs.cache_path +
                    folderModel.get(index, "fileName")

                sourceSize.width: list.tileWidth * 1.25
                sourceSize.height: height

                transform: Shear {
                    xFactor: -0.25
                }

                Timer {
                    id: retryTimer

                    interval: 1000
                    repeat: false

                    onTriggered: {
                        let s = img.source

                        img.source = ""

                        img.source = s
                    }
                }

                onStatusChanged: {
                    if (status === Image.Error) {
                        retryTimer.start()
                    }
                }
            }

            Rectangle {
                id: border

                anchors.fill: parent

                z: 10

                color: "transparent"

                border.width: 2
                border.color: configs.border_color

                radius: 8

                opacity: parent.active ? 1 : 0

                transform: Shear {
                    xFactor: -0.25
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                hoverEnabled: true

                Timer {
                    id: hoverTimer

                    interval: 40
                    repeat: false

                    onTriggered: {
                        list.selectedIndex = index
                    }
                }

                onEntered: {
                    hoverTimer.start()
                }

                onExited: {
                    hoverTimer.stop()
                }

                onClicked: {
                    hoverTimer.stop()

                    list.selectedIndex = index
                    list.activateCurrent()
                }

                onWheel: function(wheel) {
                    list.wheelScrolling = true

                    /*
                     * If this is a new wheel movement, sync the
                     * target with the current position.
                     */
                    if (!wheelAnimation.running) {
                        list.wheelTargetX = list.contentX
                    }

                    /*
                     * Accumulate wheel movement.
                     *
                     * The value of 2 controls how far each
                     * wheel event moves.
                     */
                    list.wheelTargetX = list.clampX(
                        list.wheelTargetX -
                        wheel.angleDelta.y * 2
                    )

                    wheelAnimation.stop()

                    wheelAnimation.from = list.contentX
                    wheelAnimation.to = list.wheelTargetX

                    wheelAnimation.start()

                    wheel.accepted = true
                }
            }
        }

        Keys.onPressed: function(event) {
            const step = 1
            const big = configs.number_of_pictures

            if (
                event.key === Qt.Key_L ||
                event.key === Qt.Key_Right
            ) {
                selectedIndex =
                    clampIndex(selectedIndex + step)

                ensureVisibleAnimated(selectedIndex)

            } else if (
                event.key === Qt.Key_H ||
                event.key === Qt.Key_Left
            ) {
                selectedIndex =
                    clampIndex(selectedIndex - step)

                ensureVisibleAnimated(selectedIndex)

            } else if (
                event.key === Qt.Key_J ||
                event.key === Qt.Key_Down
            ) {
                selectedIndex =
                    clampIndex(selectedIndex + big)

                ensureVisibleAnimated(selectedIndex)

            } else if (
                event.key === Qt.Key_K ||
                event.key === Qt.Key_Up
            ) {
                selectedIndex =
                    clampIndex(selectedIndex - big)

                ensureVisibleAnimated(selectedIndex)

            } else if (
                event.key === Qt.Key_Space ||
                event.key === Qt.Key_Return
            ) {
                activateCurrent()

            } else if (event.key === Qt.Key_Escape) {
                Qt.quit()

            } else {
                return
            }

            event.accepted = true
        }
    }
}

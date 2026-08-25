import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
    id: main

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

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

    HoverHandler {
        id: mouseMovementHandler

        onPointChanged: {
            const position = point.position

            if (
                list.keyboardMode &&
                (
                    position.x !== list.lastMousePosition.x ||
                    position.y !== list.lastMousePosition.y
                )
            ) {
                list.keyboardMode = false
            }

            list.lastMousePosition = position
        }
    }

    ListView {
        id: list

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        height: 650

        z: 1

        focus: true

        model: folderModel
        orientation: ListView.Horizontal

        spacing: 0
        clip: true

        cacheBuffer: width

        property int selectedIndex: 0
        property int previousSelectedIndex: 0

        property bool keyboardMode: false
        property point lastMousePosition: Qt.point(0, 0)

        property real tileWidth:
            configs.number_of_pictures > 0
            ? Math.max(
                1,
                width / configs.number_of_pictures - 10
            )
            : 0

        property real wheelTargetX: contentX

        function selectIndex(index) {
            index = clampIndex(index)

            if (index === selectedIndex)
                return

            previousSelectedIndex = selectedIndex
            selectedIndex = index
        }

        function keyboardSelect(index) {
            keyboardMode = true
            lastMousePosition = mouseMovementHandler.point.position

            selectIndex(index)
            ensureVisibleAnimated(selectedIndex)
        }

        function clampIndex(i) {
            return Math.max(0, Math.min(i, count - 1))
        }

        function activateCurrent() {
            const path = folderModel.get(
                selectedIndex,
                "filePath"
            )

            Quickshell.execDetached([
                "bash",
                Quickshell.shellPath("commands.sh"),
                path
            ])

            Qt.quit()
        }

        function clampX(x) {
            const maxX = Math.max(0, contentWidth - width)

            return Math.max(
                0,
                Math.min(x, maxX)
            )
        }

        function ensureVisibleAnimated(i) {
            const item = list.itemAtIndex(i)

            if (!item)
                return

            const itemStart = item.x
            const itemEnd = item.x + item.width

            let target = contentX

            if (itemStart < contentX) {
                target = itemStart
            } else if (itemEnd > contentX + width) {
                target = itemEnd - width
            }

            target = clampX(target)

            if (target !== contentX) {
                keyboardScrollAnimation.stop()

                keyboardScrollAnimation.from = contentX
                keyboardScrollAnimation.to = target

                keyboardScrollAnimation.start()
            }
        }

        NumberAnimation {
            id: keyboardScrollAnimation

            target: list
            property: "contentX"

            duration: 110

            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: wheelAnimation

            target: list
            property: "contentX"

            duration: 150

            easing.type: Easing.OutCubic
        }

        Component.onCompleted: {
            wheelTargetX = contentX
        }

        delegate: Item {
            id: delegateItem

            required property int index

            property bool active:
                index === list.selectedIndex

            property real entranceOffset: 25

            width: list.tileWidth
            height: 650

            z: {
                if (index === list.selectedIndex)
                    return 10

                if (index === list.previousSelectedIndex)
                    return 9

                return 0
            }

            opacity: 0

            Item {
                id: wallpaperItem

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                width: active
                       ? list.tileWidth * 1.50 + 40
                       : list.tileWidth

                height: active ? 650 : 500

                transform: Translate {
                    y: delegateItem.entranceOffset
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 150
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

                    sourceSize.width:
                        list.tileWidth * 1.50

                    sourceSize.height: 650

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

                    opacity: delegateItem.active ? 1 : 0

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
            }

            MouseArea {
                id: hitArea

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                width: wallpaperItem.width
                height: wallpaperItem.height

                z: 20

                hoverEnabled: true

                transform: Shear {
                    xFactor: -0.25
                }

                Timer {
                    id: hoverTimer

                    interval: 40
                    repeat: false

                    onTriggered: {
                        if (!list.keyboardMode)
                            list.selectIndex(index)
                    }
                }

                onEntered: {
                    if (!list.keyboardMode)
                        hoverTimer.start()
                }

                onExited: {
                    hoverTimer.stop()
                }

                onClicked: {
                    hoverTimer.stop()

                    list.keyboardMode = false

                    list.selectIndex(index)
                    list.activateCurrent()
                }

                onWheel: function(wheel) {
                    hoverTimer.stop()

                    list.keyboardMode = false

                    if (!wheelAnimation.running) {
                        list.wheelTargetX = list.contentX
                    }

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

                NumberAnimation {
                    target: delegateItem
                    property: "opacity"

                    from: 0
                    to: 1

                    duration: 300

                    easing.type: Easing.OutCubic
                }

                NumberAnimation {
                    target: delegateItem
                    property: "entranceOffset"

                    from: 25
                    to: 0

                    duration: 300

                    easing.type: Easing.OutCubic
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
                keyboardSelect(selectedIndex + step)

            } else if (
                event.key === Qt.Key_H ||
                event.key === Qt.Key_Left
            ) {
                keyboardSelect(selectedIndex - step)

            } else if (
                event.key === Qt.Key_J ||
                event.key === Qt.Key_Down
            ) {
                keyboardSelect(selectedIndex + big)

            } else if (
                event.key === Qt.Key_K ||
                event.key === Qt.Key_Up
            ) {
                keyboardSelect(selectedIndex - big)

            } else if (
                event.key === Qt.Key_Space ||
                event.key === Qt.Key_Return
            ) {
                activateCurrent()

            } else if (
                event.key === Qt.Key_Escape
            ) {
                Qt.quit()

            } else {
                return
            }

            event.accepted = true
        }
    }
}

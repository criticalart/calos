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

    FileView {
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: configs

            property string theme_path
            property string cache_path
            property int number_of_themes
            property string border_color
        }
    }

    Loader {
        id: themeModelLoader

        active: configs.theme_path.length > 0

        sourceComponent: FolderListModel {
            folder: "file://" + configs.theme_path + "/"

            showDirs: true
            showFiles: false

            sortField: FolderListModel.Name
        }
    }

    MouseArea {
        id: backgroundArea

        anchors.fill: parent
        z: -1

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

    Rectangle {
    id: dimOverlay

    anchors.fill: parent

    z: 0

    color: "#000000"
    opacity: 0.45

    MouseArea {
        anchors.fill: parent

        onClicked: {
            Qt.quit()
        }
    }
}

    ListView {
        id: list

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        height: 900
        leftMargin: 100

        z: 1
        focus: true

        model: themeModelLoader.item
        orientation: ListView.Horizontal

        spacing: 0
        clip: true

        cacheBuffer: width

        property int selectedIndex: 0
        property int previousSelectedIndex: 0

        property bool keyboardMode: false
        property point lastMousePosition: Qt.point(0, 0)

        property real tileWidth:
            themeModelLoader.item &&
            themeModelLoader.item.count > 0
            ? Math.max(
                1,
                width / Math.max(
                    1,
                    configs.number_of_themes > 0
                    ? configs.number_of_themes
                    : themeModelLoader.item.count
                ) - 10
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
            const item = list.itemAtIndex(selectedIndex)

            if (!item || !item.themeName)
                return

            Quickshell.execDetached([
                "calos-theme-set",
                item.themeName
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
            required property string fileName

            property bool active:
                index === list.selectedIndex

            property real entranceOffset: 25

            property string themeName: fileName

            property string displayName: {
                let name = fileName.replace(/-/g, " ")

                return name
                    .split(" ")
                    .map(function(word) {
                        if (word.length === 0)
                            return word

                        return word.charAt(0).toUpperCase() +
                               word.slice(1)
                    })
                    .join(" ")
            }

            property string cachedPreview:
                "file://" +
                configs.cache_path +
                "/" +
                themeName +
                ".png"

            width: list.tileWidth
            height: 900

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
                       ? list.tileWidth * 1.65 + 50
                       : list.tileWidth

                height: active ? 810 : 610

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

                Image {
                    id: img

                    anchors.fill: parent

                    fillMode: Image.PreserveAspectCrop

                    asynchronous: true
                    cache: true
                    smooth: true

                    source: delegateItem.cachedPreview

                    sourceSize.width:
                        list.tileWidth * 1.65

                    sourceSize.height: 1200

                    transform: Shear {
                        xFactor: -0.25
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

                    opacity:
                        delegateItem.active
                        ? 1
                        : 0

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

            Text {
                id: themeLabel

                anchors {
                    horizontalCenter: wallpaperItem.horizontalCenter
                    horizontalCenterOffset: -200
                    top: wallpaperItem.bottom
                    topMargin: -6
                }

                z: 30

                text: delegateItem.displayName

                color: configs.border_color

                font.pixelSize: 38

                horizontalAlignment: Text.AlignHCenter

                opacity:
                    delegateItem.active
                    ? 1
                    : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
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

            const big =
                configs.number_of_themes > 0
                ? configs.number_of_themes
                : (
                    themeModelLoader.item
                    ? themeModelLoader.item.count
                    : 1
                )

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

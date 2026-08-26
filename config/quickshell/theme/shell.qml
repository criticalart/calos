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

        height: 960

        z: 1

        focus: true

        model: themeModelLoader.item

        orientation: ListView.Horizontal

        spacing: 0
        clip: true

        cacheBuffer: width

        property int selectedIndex: 0
        property int previousSelectedIndex: 0

        property int themeCount:
            configs.number_of_themes > 0
            ? configs.number_of_themes
            : (themeModelLoader.item?.count ?? 0)

        property real tileWidth:
            themeCount > 0
            ? Math.max(1, width / themeCount - 10)
            : 0

        property real centerPadding:
            Math.max(
                0,
                (width - tileWidth) / 2
            )

        header: Item {
            width: list.centerPadding
            height: list.height
        }

        footer: Item {
            width: list.centerPadding
            height: list.height
        }

        function clampIndex(index) {
            return Math.max(
                0,
                Math.min(index, count - 1)
            )
        }

        function centeredContentX(index) {
            const item = list.itemAtIndex(index)

            if (!item)
                return contentX

            return item.x +
                   item.width / 2 -
                   list.width / 2
        }

        function centerSelected(animated) {
            const target = centeredContentX(selectedIndex)

            if (!animated) {
                contentX = target
                return
            }

            centerAnimation.stop()

            centerAnimation.from = contentX
            centerAnimation.to = target

            centerAnimation.start()
        }

        function selectIndex(index) {
            index = clampIndex(index)

            if (index === selectedIndex)
                return false

            previousSelectedIndex = selectedIndex
            selectedIndex = index

            centerSelected(true)

            return true
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

        NumberAnimation {
            id: centerAnimation

            target: list
            property: "contentX"

            duration: 180

            easing.type: Easing.OutCubic
        }

        Timer {
            id: wheelTimer

            interval: 100
            repeat: false
        }

        Component.onCompleted: {
            Qt.callLater(function() {
                if (list.count > 0)
                    list.centerSelected(false)
            })
        }

        delegate: Item {
            id: delegateItem

            required property int index
            required property string fileName

            width: list.tileWidth
            height: list.height

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
                    horizontalCenterOffset: 115
                    verticalCenter: parent.verticalCenter
                }

                width:
                    delegateItem.active
                    ? list.tileWidth * 1.65 + 50
                    : list.tileWidth

                height:
                    delegateItem.active
                    ? 810
                    : 610

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

                    radius: 4

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
                    horizontalCenterOffset: -180
                    top: wallpaperItem.bottom
                    topMargin: 10
                }

                z: 30

                text: delegateItem.displayName

                color: configs.border_color

                font.family: "Noto Sans"
                font.pixelSize: 34
                font.weight: Font.Medium

                style: Text.Outline
                styleColor: "#000000"

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

                onClicked: {
                    if (!list.selectIndex(index))
                        list.activateCurrent()
                }

                onWheel: function(wheel) {
                    if (wheelTimer.running) {
                        wheel.accepted = true
                        return
                    }

                    wheelTimer.start()

                    if (wheel.angleDelta.y < 0)
                        list.selectIndex(list.selectedIndex + 1)
                    else
                        list.selectIndex(list.selectedIndex - 1)

                    wheel.accepted = true
                }
            }

            Timer {
                id: entranceTimer

                interval:
                    index < 15
                    ? index * 30
                    : 0

                repeat: false
                running: index < 15

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

            if (
                event.key === Qt.Key_L ||
                event.key === Qt.Key_Right
            ) {
                list.selectIndex(selectedIndex + 1)

            } else if (
                event.key === Qt.Key_H ||
                event.key === Qt.Key_Left
            ) {
                list.selectIndex(selectedIndex - 1)

            } else if (
                event.key === Qt.Key_J ||
                event.key === Qt.Key_Down
            ) {
                list.selectIndex(selectedIndex + 3)

            } else if (
                event.key === Qt.Key_K ||
                event.key === Qt.Key_Up
            ) {
                list.selectIndex(selectedIndex - 3)

            } else if (
                event.key === Qt.Key_Space ||
                event.key === Qt.Key_Return
            ) {
                list.activateCurrent()

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

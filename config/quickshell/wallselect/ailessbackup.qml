import Quickshell
import Quickshell.Io // for Process
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland



PanelWindow {
    id: main
    implicitHeight: 500
    implicitWidth: Screen.width
    color: "transparent"
    property int speed: 5000

    aboveWindows: true
    exclusionMode: "Ignore"
    exclusiveZone: 1

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Component.onCompleted: {
        Quickshell.execDetached(["bash", Quickshell.shellPath("cache.sh"), Quickshell.shellDir])
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
        nameFilters: ["*.png","*.jpg"]
        sortField: FolderListModel.Name
    }

    ListView {
        id: list
        anchors.fill: parent
        focus: true

        model: folderModel
        orientation: ListView.Horizontal
        spacing: 4
        clip: true
        // reuseItems: true
        cacheBuffer: width * 2

        property int selectedIndex: 0
        property real tileWidth: width / configs.number_of_pictures - 10

        function clampIndex(i) {
            return Math.max(0, Math.min(i, count - 1))
        }

        function activateCurrent() {
            const path = folderModel.get(selectedIndex, "filePath")
            Quickshell.execDetached(["bash", Quickshell.shellPath("commands.sh"), path])
            Qt.quit()
        }

        function clampX(x) {
            return Math.max(0, Math.min(x, contentWidth - width))
        }

        function ensureVisibleAnimated(i) {
            const step = tileWidth + spacing
            const itemStart = i * step
            const itemEnd = itemStart + tileWidth + 20

            if (itemStart < contentX)
                contentX = clampX(itemStart)
            else if (itemEnd > contentX + width)
                contentX = clampX(itemStart - (width - step))
        }

        Behavior on contentX {
            SmoothedAnimation {
                id: anim
                property int v: 10
                // velocity: v
                duration: 100
            }
        }
        Component.onCompleted:{
            anim.v = main.speed
        }


delegate: Item {
    required property int index

    property bool active: index === list.selectedIndex

    // Selected image is slightly wider.
    width: active ? list.tileWidth * 1.50 : list.tileWidth
    height: 500

    // Smoothly expand/contract when selection changes.
    Behavior on width {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }

    
Text {
    id: alt

    // Keep this hidden during normal image loading so a brief
    // resize/reload doesn't flash "Loading..." over the image.
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

    // Keep the decoded image at a fixed size larger than the
    // normal tile. The delegate can expand without changing
    // the requested image size.
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
          list.contentX = list.clampX(
          list.contentX - wheel.angleDelta.y * 18
        )
        wheel.accepted = false
      }
}
}

        Keys.onPressed: function(event) {
            const step = 1
            const big = configs.number_of_pictures

            if (event.key === Qt.Key_L || event.key == Qt.Key_Right) {
                anim.v = main.speed
                selectedIndex = clampIndex(selectedIndex + step)
                ensureVisibleAnimated(selectedIndex)

            } else if (event.key === Qt.Key_H || event.key == Qt.Key_Left) {
                anim.v = main.speed
                selectedIndex = clampIndex(selectedIndex - step)
                ensureVisibleAnimated(selectedIndex)

            } else if (event.key === Qt.Key_D || event.key == Qt.Key_Down) {
                anim.v = main.speed * big
                selectedIndex = clampIndex(selectedIndex + big)
                ensureVisibleAnimated(selectedIndex)

            } else if (event.key === Qt.Key_U || event.key == Qt.Key_Up) {
                anim.v = main.speed * big
                selectedIndex = clampIndex(selectedIndex - big)
                ensureVisibleAnimated(selectedIndex)

            } else if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
                activateCurrent()

            } else if (event.key === Qt.Key_Escape) {
                Qt.quit()

            } else return

            event.accepted = true
        }
    }
}

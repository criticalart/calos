import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
	id: main

	property int imageHeight: 650
	property int inactiveImageHeight: 500

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

		initialEntranceTimer.start()
	}

	Component.onDestruction: {
		cacheRetryTimer.stop()
		initialEntranceTimer.stop()
	}

	Timer {
		id: initialEntranceTimer

		interval: 50
		repeat: false

		onTriggered: {
			list.startEntranceAnimation()
		}
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

		property point lastPosition: point.position

		onPointChanged: {
			if (
				point.position.x === lastPosition.x &&
				point.position.y === lastPosition.y
			) {
				return
			}

			lastPosition = point.position

			list.mouseEnabled = true
			list.keyboardMode = false
		}
	}

	ListView {
		id: list

		anchors {
			left: parent.left
			right: parent.right
			verticalCenter: parent.verticalCenter
		}

		height: main.imageHeight

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
		property bool mouseEnabled: false

		property bool initialAnimationStarted: false

		property real tileWidth:
			configs.number_of_pictures > 0
			? Math.max(
				1,
				width / configs.number_of_pictures - 10
			)
			: 0

		property real wheelTargetX: contentX

		function selectIndex(index) {
			index = Math.max(
				0,
				Math.min(index, count - 1)
			)

			if (index === selectedIndex)
				return

			previousSelectedIndex = selectedIndex
			selectedIndex = index
		}

		function keyboardSelect(index) {
			keyboardMode = true
			mouseEnabled = false

			mouseMovementHandler.lastPosition =
				mouseMovementHandler.point.position

			selectIndex(index)
			ensureVisibleAnimated(selectedIndex)
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

			if (i === 0) {
				keyboardScrollAnimation.stop()

				if (contentX !== 0) {
					keyboardScrollAnimation.from = contentX
					keyboardScrollAnimation.to = 0
					keyboardScrollAnimation.start()
				}

				return
			}

			const expandedWidth =
				list.tileWidth * 1.50 + 40

			const extraWidth =
				Math.max(
					0,
					expandedWidth - list.tileWidth
				)

			const itemStart =
				item.x - extraWidth / 2

			const itemEnd =
				item.x +
				item.width +
				extraWidth / 2

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

		function startEntranceAnimation() {
			if (initialAnimationStarted)
				return

			initialAnimationStarted = true

			for (let i = 0; i < list.count; i++) {
				const item = list.itemAtIndex(i)

				if (item)
					item.startEntrance()
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

		Timer {
			id: cacheRetryTimer

			interval: 1000
			repeat: true
			running: true

			onTriggered: {
				let failed = false

				for (let i = 0; i < list.count; i++) {
					const item = list.itemAtIndex(i)

					if (!item)
						continue

					if (item.retryImage())
						failed = true
				}

				if (!failed)
					stop()
			}
		}

		delegate: Item {
			id: delegateItem

			required property int index

			property bool active:
				index === list.selectedIndex

			property real entranceOffset: 25

			function retryImage() {
				if (img.status !== Image.Error)
					return false

				const source = img.source

				img.source = ""
				img.source = source

				return true
			}

			function startEntrance() {
				entranceTimer.restart()
			}

			width: list.tileWidth
			height: main.imageHeight

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

				height: active
					? main.imageHeight
					: main.inactiveImageHeight

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

					sourceSize.height: main.imageHeight

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
					if (
						!list.keyboardMode &&
						list.mouseEnabled
					) {
						hoverTimer.start()
					}
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

			Component.onCompleted: {
				if (list.initialAnimationStarted) {
					opacity = 1
					entranceOffset = 0
				}
			}

			Timer {
				id: entranceTimer

				interval: index * 30
				repeat: false

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
				keyboardSelect(selectedIndex + 5)

			} else if (
				event.key === Qt.Key_K ||
				event.key === Qt.Key_Up
			) {
				keyboardSelect(selectedIndex - 5)

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

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
	id: root

	property var cavaBars: []
	property var smoothBars: []

	property real sensitivity: 0.55
	property real visualScale: 1.35

	property real attack: 0.10
	property real decay: 0.085

	// Edge dampening.
	property real edgeDamping: 0.38
	property real edgeDampingCurve: 1.6

	property var cavaColors: [
		"#98b3b3",
		"#8eaebe",
		"#85abbc",
		"#89b1c3",
		"#bea7b0",
		"#d7c9ce",
		"#e5dbdf",
		"#98b3b3"
	]

	property string cavaConfig:
		"[general]\n" +
		"framerate = 60\n" +
		"bars = 80\n" +
		"autosens = 1\n" +
		"lower_cutoff_freq = 25\n" +
		"higher_cutoff_freq = 18000\n" +
		"sleep_timer = 0\n" +
		"[input]\n" +
		"method = pipewire\n" +
		"source = auto\n" +
		"sample_rate = 48000\n" +
		"sample_bits = 16\n" +
		"channels = mono\n" +
		"mono_option = average\n" +
		"[output]\n" +
		"method = raw\n" +
		"raw_target = /dev/stdout\n" +
		"data_format = ascii\n" +
		"ascii_max_range = 1000\n" +
		"bar_delimiter = 32\n" +
		"frame_delimiter = 10\n" +
		"[smoothing]\n" +
		"noise_reduction = 3\n" +
		"monstercat = 0\n" +
		"waves = 0"

	// NOW PLAYING
	property string nowPlaying: ""

	function gradientColor(position) {
		if (root.cavaColors.length === 0)
			return "#ffffff"

		if (root.cavaColors.length === 1)
			return root.cavaColors[0]

		position = Math.max(0, Math.min(1, position))

		var scaled =
			position * (root.cavaColors.length - 1)

		var index = Math.floor(scaled)

		if (index >= root.cavaColors.length - 1)
			return root.cavaColors[
				root.cavaColors.length - 1
			]

		var fraction = scaled - index

		var first =
			Qt.color(root.cavaColors[index])

		var second =
			Qt.color(root.cavaColors[index + 1])

		return Qt.rgba(
			first.r +
				(second.r - first.r) * fraction,
			first.g +
				(second.g - first.g) * fraction,
			first.b +
				(second.b - first.b) * fraction,
			first.a +
				(second.a - first.a) * fraction
		)
	}

	Process {
		id: themeColors

		command: [
			"sh",
			"-c",
			"awk -F\"'\" " +
			"'/^[[:space:]]*gradient_color_[1-8][[:space:]]*=/ " +
			"{print $2}' " +
			"\"$HOME/.config/calos/current/theme/cava/config\""
		]

		running: true

		stdout: SplitParser {
			splitMarker: "\n"

			onRead: data => {
				if (!data)
					return

				var color = data.trim()

				if (
					color.length === 7 &&
					color.charAt(0) === "#"
				) {
					var colors = root.cavaColors.slice()

					if (colors.length >= 8)
						colors.shift()

					colors.push(color)

					if (colors.length === 8)
						root.cavaColors = colors
				}
			}
		}
	}

	Process {
		id: nowPlayingWatcher

		command: [
			"playerctl",
			"--follow",
			"metadata",
			"--format",
			"{{ status }}|{{ artist }}|{{ title }}"
		]

		running: true

		stdout: SplitParser {
			splitMarker: "\n"

			onRead: data => {
				if (!data)
					return

				var line = data.trim()

				if (!line)
					return

				var parts = line.split("|")

				if (parts.length < 3) {
					root.nowPlaying = ""
					return
				}

				var status = parts[0]
				var artist = parts[1].trim()
				var title = parts.slice(2).join("|").trim()

				if (
					status !== "Playing" ||
					(!artist && !title)
				) {
					root.nowPlaying = ""
					return
				}

				if (artist && title) {
					root.nowPlaying =
						"♪  " + artist + " — " + title
				} else if (title) {
					root.nowPlaying =
						"♪  " + title
				} else {
					root.nowPlaying =
						"♪  " + artist
				}
			}
		}
	}

	Timer {
		id: visualizerTimer

		interval: 16
		running: true
		repeat: true

		onTriggered: {
			if (root.cavaBars.length === 0)
				return

			var bars = root.smoothBars.slice()
			var barCount = root.cavaBars.length

			while (bars.length < barCount)
				bars.push(0)

			for (var i = 0; i < barCount; ++i) {
				var target = root.cavaBars[i]
				var current = bars[i]

				// Symmetric edge dampening.
				var center =
					(barCount - 1) / 2

				var distance =
					center > 0
						? Math.abs(i - center) / center
						: 0

				var edgeFactor =
					1 -
					(
						root.edgeDamping *
						Math.pow(
							distance,
							root.edgeDampingCurve
						)
					)

				target *= edgeFactor

				// Uniform smoothing.
				if (target > current) {
					current +=
						(target - current) *
						root.attack
				} else {
					current +=
						(target - current) *
						root.decay
				}

				bars[i] = current
			}

			root.smoothBars = bars
		}
	}

	Process {
		id: cava

		command: [
			"sh",
			"-c",
			"printf '%s\\n' \"$CAVA_CONFIG\" | cava -p /dev/stdin"
		]

		environment: ({
			CAVA_CONFIG: root.cavaConfig
		})

		running: true

		stdout: SplitParser {
			splitMarker: "\n"

			onRead: data => {
				if (!data)
					return

				var parts = data.trim().split(/\s+/)
				var values = []

				for (var i = 0; i < parts.length; ++i) {
					var value = Number(parts[i])

					if (!isNaN(value)) {
						value = Math.max(
							0,
							Math.min(
								1,
								value / 1000
							)
						)

						value =
							Math.pow(
								value,
								root.sensitivity
							)

						value = Math.max(
							0.02,
							value
						)

						values.push(value)
					}
				}

				if (values.length > 0)
					root.cavaBars = values
			}
		}
	}

	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: window

			property var modelData
			property date currentTime: new Date()
			property bool ready: false

			screen: modelData

			anchors {
				top: true
				bottom: true
				left: true
				right: true
			}

			exclusionMode: ExclusionMode.Ignore
			color: "#80000000"

			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.namespace: "clock"
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

			Timer {
				id: startupTimer

				interval: 150
				repeat: false
				running: true

				onTriggered: {
					window.ready = true
				}
			}

			Timer {
				id: clockTimer

				interval: 1000
				running: true
				repeat: true

				onTriggered: {
					window.currentTime = new Date()
				}
			}

			Item {
				id: keyboardHandler

				width: 1
				height: 1

				focus: true

				Keys.onPressed: function(event) {
					Qt.quit()
					event.accepted = true
				}
			}

			// NOW PLAYING
			Text {
				id: nowPlayingText

				anchors {
					top: parent.top
					left: parent.left
					topMargin: 30
					leftMargin: 30
					right: parent.right
					rightMargin: 30
				}

				visible: root.nowPlaying.length > 0

				text: root.nowPlaying

				color: "#60ffffff"

				font.pointSize: 18
				font.family: "Inter"

				elide: Text.ElideRight
				maximumLineCount: 1

				horizontalAlignment: Text.AlignLeft
				verticalAlignment: Text.AlignVCenter
			}

			Column {
				anchors.centerIn: parent
				spacing: 0

				Text {
					anchors.horizontalCenter:
						parent.horizontalCenter

					text: Qt.formatDateTime(
						window.currentTime,
						"dddd, MMMM d, yyyy"
					)

					color: "#60ffffff"
					font.pointSize: 18
					font.family: "Jet Brains Mono"
				}

				Text {
					anchors.horizontalCenter:
						parent.horizontalCenter

					text: Qt.formatDateTime(
						window.currentTime,
						"hh:mm:ss"
					)

					color: "#d9d9d9"
					font.pointSize: 68
					font.bold: true
					font.family: "Inter"
				}
			}

			Item {
				id: cavaVisualizer

				anchors {
					left: parent.left
					right: parent.right
					bottom: parent.bottom
				}

				height: 360

				Row {
					anchors {
						left: parent.left
						right: parent.right
						bottom: parent.bottom
					}

					height: parent.height
					spacing: 4

					Repeater {
						model: root.smoothBars

						Item {
							id: barContainer

							property real barSpacing:
								(root.smoothBars.length - 1) * 4

							property real barWidth:
								(
									cavaVisualizer.width -
									barSpacing
								) /
								root.smoothBars.length

							width: barWidth
							height: cavaVisualizer.height
							anchors.bottom: parent.bottom

							Rectangle {
								id: bar

								width: parent.width

								height: Math.max(
									2,
									parent.height *
									Math.min(
										1,
										modelData *
										root.visualScale
									)
								)

								anchors.bottom: parent.bottom
								radius: 1

								color: root.gradientColor(
									root.smoothBars.length <= 1
										? 0.5
										: index /
											(
												root.smoothBars.length -
												1
											)
								)

								opacity: {
									if (
										root.smoothBars.length <= 1
									)
										return 0.42

									var center =
										(root.smoothBars.length - 1) /
										2

									var distance =
										Math.abs(
											index - center
										) /
										center

									var falloff =
										Math.pow(
											distance,
											1.7
										)

									return 0.42 -
										(falloff * 0.34)
								}
							}
						}
					}
				}
			}

			MouseArea {
				anchors.fill: parent

				enabled: window.ready
				acceptedButtons: Qt.LeftButton

				onClicked: {
					Qt.quit()
				}
			}
		}
	}
}

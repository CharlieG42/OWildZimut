/*
 * MapView.qml - Vue carte avec gestion des calques
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    clip: true

    property var layers: []
    property real zoomLevel: 1.0
    property real panX: 0
    property real panY: 0

    Rectangle {
        id: mapBackground
        anchors.fill: parent
        color: "#f0f0f0"

        Canvas {
            id: gridCanvas
            anchors.fill: parent
            visible: true

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.strokeStyle = "#e0e0e0"
                ctx.lineWidth = 1

                var gridSize = 50
                for (var x = 0; x < width; x += gridSize) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }
                for (var y = 0; y < height; y += gridSize) {
                    ctx.beginPath()
                    ctx.moveTo(0, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }

                ctx.strokeStyle = "#c0c0c0"
                ctx.lineWidth = 2
                for (var x = 0; x < width; x += 250) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }
                for (var y = 0; y < height; y += 250) {
                    ctx.beginPath()
                    ctx.moveTo(0, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }
            }
        }
    }

    Item {
        id: layersContainer
        anchors.fill: parent
        clip: true

        transform: [
            Scale {
                xScale: zoomLevel
                yScale: zoomLevel
                origin.x: width / 2
                origin.y: height / 2
            },
            Translate {
                x: panX
                y: panY
            }
        ]

        Repeater {
            id: layerRepeater
            model: layers
            delegate: LayerRenderer {
                layerData: modelData
                width: layersContainer.width
                height: layersContainer.height
                visible: modelData.visible
                opacity: modelData.opacity
            }
        }

        MouseArea {
            anchors.fill: parent
            drag.target: layersContainer
            drag.axis: Drag.Both
            drag.minimumX: -width * (zoomLevel - 1)
            drag.maximumX: width * (zoomLevel - 1)
            drag.minimumY: -height * (zoomLevel - 1)
            drag.maximumY: height * (zoomLevel - 1)
            onWheel: {
                if (wheel.angleDelta.y > 0) {
                    zoomLevel *= 1.1
                } else {
                    zoomLevel /= 1.1
                }
            }
        }
    }

    Label {
        id: zoomIndicator
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 10
        }
        text: (zoomLevel * 100).toFixed(0) + "%"
        color: "#2c3e50"
        background: Rectangle {
            color: "white"
            radius: 5
            opacity: 0.8
            anchors.margins: 5
        }
    }
}

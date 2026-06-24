/*
 * LayerRenderer.qml - Rendu d'un calque individuel
 */

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    clip: true

    property var layerData: ({})
    property color layerColor: layerData.color || "#3498db"

    Repeater {
        model: layerData.symbols || []
        delegate: Item {
            id: symbolItem
            x: symbolData.coordinates ? symbolData.coordinates[0] : 0
            y: symbolData.coordinates ? symbolData.coordinates[1] : 0

            Loader {
                id: symbolLoader
                anchors.fill: parent
                sourceComponent: {
                    if (symbolData.type === "point") return pointComponent
                    if (symbolData.type === "line") return lineComponent
                    if (symbolData.type === "area") return areaComponent
                    return textComponent
                }
            }

            Component {
                id: pointComponent
                Canvas {
                    id: pointCanvas
                    width: symbolData.size || 12
                    height: symbolData.size || 12
                    anchors.centerIn: parent

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.fillStyle = symbolData.color || layerColor
                        ctx.beginPath()
                        ctx.arc(width/2, height/2, width/2, 0, Math.PI * 2)
                        ctx.fill()
                        if (symbolData.iof_code === 701) {
                            ctx.strokeStyle = "white"
                            ctx.lineWidth = 2
                            ctx.beginPath()
                            ctx.arc(width/2, height/2, width/2 - 1, 0, Math.PI * 2)
                            ctx.stroke()
                        }
                    }
                }
            }

            Component {
                id: lineComponent
                Canvas {
                    id: lineCanvas
                    width: parent.width
                    height: parent.height

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        if (!symbolData.coordinates || symbolData.coordinates.length < 2) return
                        ctx.strokeStyle = symbolData.color || layerColor
                        ctx.lineWidth = symbolData.width || 2
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.beginPath()
                        var coords = symbolData.coordinates
                        ctx.moveTo(coords[0][0], coords[0][1])
                        for (var i = 1; i < coords.length; i++) {
                            ctx.lineTo(coords[i][0], coords[i][1])
                        }
                        ctx.stroke()
                    }
                }
            }

            Component {
                id: areaComponent
                Canvas {
                    id: areaCanvas
                    width: parent.width
                    height: parent.height

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        if (!symbolData.coordinates || symbolData.coordinates.length < 3) return
                        ctx.fillStyle = symbolData.color || layerColor
                        ctx.globalAlpha = 0.7
                        ctx.beginPath()
                        var coords = symbolData.coordinates
                        ctx.moveTo(coords[0][0], coords[0][1])
                        for (var i = 1; i < coords.length; i++) {
                            ctx.lineTo(coords[i][0], coords[i][1])
                        }
                        ctx.closePath()
                        ctx.fill()
                        ctx.globalAlpha = 1.0
                        ctx.strokeStyle = "#2c3e50"
                        ctx.lineWidth = 1
                        ctx.stroke()
                    }
                }
            }

            Component {
                id: textComponent
                Text {
                    text: symbolData.text || ""
                    color: symbolData.color || layerColor
                    font.pixelSize: symbolData.size || 12
                    anchors.centerIn: parent
                }
            }
        }
    }
}
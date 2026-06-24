/*
 * LayerItem.qml - Element de la liste des calques
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: parent.width
    height: 60
    color: selected ? "#3498db" : "#34495e"
    radius: 5
    border.color: selected ? "white" : "transparent"
    border.width: selected ? 2 : 0

    property var layerData: ({})
    property bool selected: false

    signal visibilityToggled()
    signal opacityChanged(var newOpacity)
    signal moveUp()
    signal moveDown()
    signal remove()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 10

        Button {
            id: visibilityButton
            width: 30
            height: 30
            flat: true
            checkable: true
            checked: layerData.visible
            background: Rectangle {
                color: "transparent"
                radius: 15
            }
            contentItem: Canvas {
                id: eyeCanvas
                width: 20
                height: 20
                anchors.centerIn: parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    if (checked) {
                        ctx.fillStyle = "white"
                        ctx.beginPath()
                        ctx.arc(10, 10, 8, 0, Math.PI * 2)
                        ctx.fill()
                        ctx.fillStyle = "#34495e"
                        ctx.beginPath()
                        ctx.arc(10, 10, 4, 0, Math.PI * 2)
                        ctx.fill()
                    } else {
                        ctx.strokeStyle = "white"
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(2, 2)
                        ctx.lineTo(18, 18)
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(18, 2)
                        ctx.lineTo(2, 18)
                        ctx.stroke()
                    }
                }
            }
            onClicked: {
                checked = !checked
                visibilityToggled()
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Label {
                text: layerData.name || "Calque sans nom"
                color: "white"
                font.bold: true
                font.pixelSize: 14
                elide: Text.ElideRight
            }

            RowLayout {
                spacing: 10

                Label {
                    text: "Type: " + (layerData.type || "inconnu")
                    color: "#bdc3c7"
                    font.pixelSize: 11
                }

                Label {
                    text: "Z: " + (layerData.z_index || 0)
                    color: "#bdc3c7"
                    font.pixelSize: 11
                }
            }
        }

        Slider {
            id: opacitySlider
            width: 80
            from: 0
            to: 1
            value: layerData.opacity || 1.0
            onMoved: opacityChanged(value)
            ToolTip.text: "Opacite: " + (value * 100).toFixed(0) + "%"
            ToolTip.visible: hovered
        }

        RowLayout {
            spacing: 5

            Button {
                id: moveUpButton
                width: 24
                height: 24
                flat: true
                enabled: layerData.z_index < (parent.parent.parent.parent.parent.model.count - 1)
                background: Rectangle {
                    color: enabled ? "#27ae60" : "#7f8c8d"
                    radius: 12
                }
                contentItem: Text {
                    text: "Up"
                    color: "white"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: moveUp()
                ToolTip.text: "Monter"
            }

            Button {
                id: moveDownButton
                width: 24
                height: 24
                flat: true
                enabled: layerData.z_index > 1
                background: Rectangle {
                    color: enabled ? "#27ae60" : "#7f8c8d"
                    radius: 12
                }
                contentItem: Text {
                    text: "Down"
                    color: "white"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: moveDown()
                ToolTip.text: "Descendre"
            }

            Button {
                id: removeButton
                width: 24
                height: 24
                flat: true
                background: Rectangle {
                    color: "#e74c3c"
                    radius: 12
                }
                contentItem: Text {
                    text: "X"
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: remove()
                ToolTip.text: "Supprimer"
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (!visibilityButton.contains(mouse)) {
                selected = true
            }
        }
    }
}
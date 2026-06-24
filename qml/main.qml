/*
 * OWildZimut - Interface principale
 * Prototype QML pour la gestion de calques CO
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 1200
    height: 800
    title: "OWildZimut - Outil de creation de cartes CO"
    minimumWidth: 800
    minimumHeight: 600

    property color primaryColor: "#2c3e50"
    property color secondaryColor: "#3498db"
    property color backgroundColor: "#ecf0f1"
    property color textColor: "#2c3e50"
    property color accentColor: "#e74c3c"

    menuBar: MenuBar {
        Menu {
            title: "Fichier"
            MenuItem { text: "Nouveau projet" }
            MenuItem { text: "Ouvrir..." }
            MenuItem { text: "Enregistrer" }
            MenuItem { text: "Enregistrer sous..." }
            MenuItem { text: "Exporter en JSON"; onTriggered: exportJSON() }
            MenuItem { text: "Quitter"; onTriggered: Qt.quit() }
        }
        Menu {
            title: "Calques"
            MenuItem { text: "Nouveau calque"; onTriggered: layerModel.addLayer("Nouveau Calque") }
            MenuItem { text: "Supprimer calque"; onTriggered: removeSelectedLayer() }
        }
        Menu {
            title: "Affichage"
            MenuItem { text: "Zoom avant"; onTriggered: mapController.zoomIn() }
            MenuItem { text: "Zoom arriere"; onTriggered: mapController.zoomOut() }
            MenuItem { text: "Reinitialiser vue"; onTriggered: resetView() }
        }
        Menu {
            title: "Aide"
            MenuItem { text: "A propos" }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: layersPanel
            width: 300
            color: primaryColor
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Label {
                    text: "Calques"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }

                ListView {
                    id: layerListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: layerModel.layers
                    delegate: LayerItem {
                        layerData: modelData
                        selected: index === layerModel.selectedLayerIndex
                        onSelectedChanged: if (selected) layerModel.selectedLayerIndex = index
                        onVisibilityToggled: layerModel.setLayerVisible(layerData.id, !layerData.visible)
                        onOpacityChanged: layerModel.setLayerOpacity(layerData.id, opacity)
                        onMoveUp: layerModel.setLayerZIndex(layerData.id, layerData.z_index + 1)
                        onMoveDown: layerModel.setLayerZIndex(layerData.id, layerData.z_index - 1)
                        onRemove: layerModel.removeLayer(layerData.id)
                    }
                    spacing: 5
                }

                Button {
                    text: "+ Ajouter un calque"
                    Layout.fillWidth: true
                    onClicked: layerModel.addLayer("Nouveau Calque")
                    flat: true
                    background: Rectangle {
                        color: secondaryColor
                        radius: 5
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        MapView {
            id: mapView
            Layout.fillWidth: true
            Layout.fillHeight: true
            layers: layerModel.layers
            zoomLevel: mapController.zoomLevel
            panX: mapController.panX
            panY: mapController.panY
        }

        Rectangle {
            id: toolsPanel
            width: 250
            color: backgroundColor
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Label {
                    text: "Outils"
                    color: primaryColor
                    font.bold: true
                    font.pixelSize: 16
                    Layout.alignment: Qt.AlignHCenter
                }

                ComboBox {
                    id: toolSelector
                    Layout.fillWidth: true
                    model: ["Selection", "Point", "Ligne", "Polygone", "Texte"]
                    currentIndex: 0
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5

                    Label {
                        text: "Zoom"
                        color: textColor
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Button {
                            text: "+"
                            Layout.fillWidth: true
                            onClicked: mapController.zoomIn()
                        }
                        Button {
                            text: "-"
                            Layout.fillWidth: true
                            onClicked: mapController.zoomOut()
                        }
                    }
                    Slider {
                        id: zoomSlider
                        Layout.fillWidth: true
                        from: 0.1
                        to: 10
                        value: mapController.zoomLevel
                        onMoved: mapController.zoomLevel = value
                    }
                }

                Label {
                    text: "Selectionne: " + (layerModel.selectedLayerIndex >= 0 ? 
                        layerModel.layers[layerModel.selectedLayerIndex].name : "Aucun")
                    color: textColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    function exportJSON() {
        var json = layerModel.toJSON()
        console.log("Export JSON:", json)
    }

    function removeSelectedLayer() {
        if (layerModel.selectedLayerIndex >= 0) {
            var layer = layerModel.layers[layerModel.selectedLayerIndex]
            layerModel.removeLayer(layer.id)
        }
    }

    function resetView() {
        mapController.zoomLevel = 1.0
        mapController.panX = 0
        mapController.panY = 0
    }

    Shortcut {
        sequence: "Ctrl++"
        onActivated: mapController.zoomIn()
    }
    Shortcut {
        sequence: "Ctrl+-"
        onActivated: mapController.zoomOut()
    }
    Shortcut {
        sequence: "Ctrl+0"
        onActivated: resetView()
    }
    Shortcut {
        sequence: "Del"
        onActivated: removeSelectedLayer()
    }
}
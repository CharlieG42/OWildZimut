#!/usr/bin/env python3
"""
OWildZimut - Outil de creation de cartes CO
Prototype PySide6/QML avec gestion de calques

Auteur: Charlie Gentil
Date: 2026-06-24
"""

import sys
import os
from pathlib import Path

from PySide6.QtCore import QObject, Signal, Slot, Property, QUrl, QCoreApplication
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickView


class LayerModel(QObject):
    """Modele de donnees pour les calques (expose a QML)"""
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self._layers = []
        self._selected_layer_index = -1
        
    layersChanged = Signal()
    selectedLayerIndexChanged = Signal()
    
    @Property(list, notify=layersChanged)
    def layers(self):
        return self._layers
    
    @layers.setter
    def layers(self, value):
        if self._layers != value:
            self._layers = value
            self.layersChanged.emit()
    
    @Property(int, notify=selectedLayerIndexChanged)
    def selectedLayerIndex(self):
        return self._selected_layer_index
    
    @selectedLayerIndex.setter
    def selectedLayerIndex(self, value):
        if self._selected_layer_index != value:
            self._selected_layer_index = value
            self.selectedLayerIndexChanged.emit()
    
    @Slot(result=str)
    def addLayer(self, name="Nouveau Calque", layer_type="vector"):
        new_layer = {
            "id": f"layer_{len(self._layers) + 1}",
            "name": name,
            "type": layer_type,
            "visible": True,
            "opacity": 1.0,
            "z_index": len(self._layers) + 1,
            "locked": False,
            "symbols": []
        }
        self._layers.append(new_layer)
        self.layersChanged.emit()
        return new_layer["id"]
    
    @Slot(str)
    def removeLayer(self, layer_id):
        self._layers = [l for l in self._layers if l["id"] != layer_id]
        for i, layer in enumerate(self._layers):
            layer["z_index"] = i + 1
        self.layersChanged.emit()
    
    @Slot(str, int)
    def setLayerZIndex(self, layer_id, new_z_index):
        for layer in self._layers:
            if layer["id"] == layer_id:
                layer["z_index"] = new_z_index
                break
        self._layers.sort(key=lambda x: x["z_index"])
        self.layersChanged.emit()
    
    @Slot(str, bool)
    def setLayerVisible(self, layer_id, visible):
        for layer in self._layers:
            if layer["id"] == layer_id:
                layer["visible"] = visible
                break
        self.layersChanged.emit()
    
    @Slot(str, float)
    def setLayerOpacity(self, layer_id, opacity):
        for layer in self._layers:
            if layer["id"] == layer_id:
                layer["opacity"] = max(0.0, min(1.0, opacity))
                break
        self.layersChanged.emit()
    
    @Slot(result=str)
    def toJSON(self):
        import json
        return json.dumps({
            "metadata": {
                "version": "1.0",
                "name": "OWildZimut Project",
                "created_at": "2026-06-24T10:00:00+02:00"
            },
            "layers": self._layers
        }, indent=2, ensure_ascii=False)
    
    @Slot(str)
    def loadFromJSON(self, json_str):
        import json
        try:
            data = json.loads(json_str)
            self._layers = data.get("layers", [])
            self.layersChanged.emit()
        except json.JSONDecodeError as e:
            print(f"Erreur JSON: {e}")


class MapController(QObject):
    def __init__(self, layer_model, parent=None):
        super().__init__(parent)
        self._layer_model = layer_model
        self._zoom_level = 1.0
        self._pan_x = 0
        self._pan_y = 0
        self._app_version = "0.0.001"
    
    zoomLevelChanged = Signal()
    panChanged = Signal()
    
    @Property(str, constant=True)
    def appVersion(self):
        return self._app_version
    
    @Property(float, notify=zoomLevelChanged)
    def zoomLevel(self):
        return self._zoom_level
    
    @zoomLevel.setter
    def zoomLevel(self, value):
        if self._zoom_level != value:
            self._zoom_level = max(0.1, min(10.0, value))
            self.zoomLevelChanged.emit()
    
    @Property(float, notify=panChanged)
    def panX(self):
        return self._pan_x
    
    @panX.setter
    def panX(self, value):
        if self._pan_x != value:
            self._pan_x = value
            self.panChanged.emit()
    
    @Property(float, notify=panChanged)
    def panY(self):
        return self._pan_y
    
    @panY.setter
    def panY(self, value):
        if self._pan_y != value:
            self._pan_y = value
            self.panChanged.emit()
    
    @Slot(float, float)
    def panTo(self, x, y):
        self.panX = x
        self.panY = y
    
    @Slot(float)
    def zoomIn(self, factor=1.2):
        self.zoomLevel *= factor
    
    @Slot(float)
    def zoomOut(self, factor=1.2):
        self.zoomLevel /= factor


def main():
    app = QGuiApplication(sys.argv)
    app.setApplicationName("OWildZimut")
    app.setOrganizationName("WildZimut")
    
    layer_model = LayerModel()
    layer_model.addLayer("Vegetation", "vector")
    layer_model.addLayer("Chemins", "vector")
    layer_model.addLayer("Controles", "vector")
    
    map_controller = MapController(layer_model)
    
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("layerModel", layer_model)
    engine.rootContext().setContextProperty("mapController", map_controller)
    
    qml_path = Path(__file__).parent / "qml" / "main.qml"
    engine.load(QUrl.fromLocalFile(str(qml_path)))
    
    if not engine.rootObjects():
        print("Erreur: Impossible de charger le fichier QML")
        return -1
    
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
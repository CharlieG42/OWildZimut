import 'package:flutter/material.dart';
import 'layer.dart';
import 'symbol.dart' as symbol_model;

/// État global de la carte (géré par un StateNotifier ou Riverpod)
class MapState {
  final List<Layer> layers;
  final int? selectedLayerIndex;
  final double zoomLevel;
  final Offset panOffset;
  final String appVersion;

  const MapState({
    this.layers = const [],
    this.selectedLayerIndex,
    this.zoomLevel = 1.0,
    this.panOffset = Offset.zero,
    this.appVersion = '0.0.001',
  });

  /// Ajoute un nouveau calque
  MapState addLayer(String name, LayerType type) {
    final newLayer = Layer(
      id: 'layer_${DateTime.now().millisecondsSinceEpoch}_${layers.length + 1}',
      name: name,
      type: type,
      zIndex: layers.length + 1,
      color: _getDefaultColorForLayerType(type),
    );
    return copyWith(
      layers: [...layers, newLayer],
      selectedLayerIndex: layers.length,
    );
  }

  /// Couleur par défaut selon le type de calque
  Color _getDefaultColorForLayerType(LayerType type) {
    switch (type) {
      case LayerType.vector:
        return Colors.blue.withValues(alpha: 0.3);
      case LayerType.raster:
        return Colors.grey.withValues(alpha: 0.5);
    }
  }

  /// Supprime un calque par ID
  MapState removeLayer(String layerId) {
    final newLayers = layers.where((layer) => layer.id != layerId).toList();

    // Recalculer les zIndex
    final reorderedLayers = newLayers.asMap().entries.map((entry) {
      return entry.value.copyWith(zIndex: entry.key + 1);
    }).toList();

    // Mettre à jour selectedLayerIndex
    int? newSelectedIndex;
    if (selectedLayerIndex != null && selectedLayerIndex! < newLayers.length) {
      newSelectedIndex = selectedLayerIndex;
    } else if (newLayers.isNotEmpty) {
      newSelectedIndex = newLayers.length - 1;
    }

    return copyWith(
      layers: reorderedLayers,
      selectedLayerIndex: newSelectedIndex,
    );
  }

  /// Modifie la visibilité d'un calque
  MapState setLayerVisibility(String layerId, bool visible) {
    final newLayers = layers.map((layer) {
      if (layer.id == layerId) {
        return layer.copyWith(visible: visible);
      }
      return layer;
    }).toList();
    return copyWith(layers: newLayers);
  }

  /// Modifie l'opacité d'un calque
  MapState setLayerOpacity(String layerId, double opacity) {
    final newLayers = layers.map((layer) {
      if (layer.id == layerId) {
        return layer.copyWith(opacity: opacity.clamp(0.0, 1.0));
      }
      return layer;
    }).toList();
    return copyWith(layers: newLayers);
  }

  /// Modifie le z-index d'un calque
  MapState setLayerZIndex(String layerId, int newZIndex) {
    final newLayers = layers.map((layer) {
      if (layer.id == layerId) {
        return layer.copyWith(zIndex: newZIndex);
      }
      return layer;
    }).toList();

    // Re-trier par zIndex
    newLayers.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return copyWith(layers: newLayers);
  }

  /// Sélectionne un calque
  MapState selectLayer(int? index) {
    return copyWith(selectedLayerIndex: index);
  }

  /// Modifie le niveau de zoom
  MapState setZoomLevel(double zoom) {
    return copyWith(zoomLevel: zoom.clamp(0.1, 10.0));
  }

  /// Modifie le décalage de la vue
  MapState setPanOffset(Offset offset) {
    return copyWith(panOffset: offset);
  }

  /// Réinitialise la vue
  MapState resetView() {
    return copyWith(
      zoomLevel: 1.0,
      panOffset: Offset.zero,
    );
  }

  /// Ajoute un symbole au calque sélectionné
  MapState addSymbolToSelectedLayer(symbol_model.MapSymbol symbol) {
    if (selectedLayerIndex == null || selectedLayerIndex! >= layers.length) {
      return this;
    }

    final newLayers = List<Layer>.from(layers);
    newLayers[selectedLayerIndex!] = newLayers[selectedLayerIndex!].addSymbol(symbol);

    return copyWith(layers: newLayers);
  }

  /// Crée une copie avec des modifications
  MapState copyWith({
    List<Layer>? layers,
    int? selectedLayerIndex,
    double? zoomLevel,
    Offset? panOffset,
    String? appVersion,
  }) {
    return MapState(
      layers: layers ?? this.layers,
      selectedLayerIndex: selectedLayerIndex ?? this.selectedLayerIndex,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      panOffset: panOffset ?? this.panOffset,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  /// Exporte en JSON (pour sauvegarde)
  Map<String, dynamic> toJson() {
    return {
      'metadata': {
        'version': appVersion,
        'name': 'OWildZimut Project',
        'created_at': DateTime.now().toIso8601String(),
      },
      'layers': layers.map((layer) => {
        'id': layer.id,
        'name': layer.name,
        'type': layer.type.name,
        'visible': layer.visible,
        'opacity': layer.opacity,
        'z_index': layer.zIndex,
        'locked': layer.locked,
        'color': layer.color.toARGB32().toRadixString(16),
        'symbols': layer.symbols.map((symbol) => {
          'id': symbol.id,
          'type': symbol.type.name,
          'code': symbol.code,
          'position': {'x': symbol.position.dx, 'y': symbol.position.dy},
          'description': symbol.description,
          'color': symbol.color.toARGB32().toRadixString(16),
          'size': symbol.size,
          'rotation': symbol.rotation,
          'points': symbol.points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
        }).toList(),
      }).toList(),
      'view': {
        'zoom': zoomLevel,
        'pan_x': panOffset.dx,
        'pan_y': panOffset.dy,
      },
    };
  }

  /// Charge depuis JSON
  static MapState fromJson(Map<String, dynamic> json) {
    final layersData = json['layers'] as List? ?? [];
    final layers = layersData.map((data) {
      final symbolsData = data['symbols'] as List? ?? [];
      final symbols = symbolsData.map((symbolData) {
        final pointsData = symbolData['points'] as List? ?? [];
        final points = pointsData.map((p) => 
          Offset((p['x'] as num?)?.toDouble() ?? 0.0, (p['y'] as num?)?.toDouble() ?? 0.0)
        ).toList();

        return symbol_model.MapSymbol(
          id: symbolData['id'] as String? ?? '',
          type: symbol_model.MapSymbolType.values.firstWhere(
            (e) => e.name == symbolData['type'],
            orElse: () => symbol_model.MapSymbolType.point,
          ),
          code: symbolData['code'] as String? ?? '',
          position: Offset(
            (symbolData['position']?['x'] as num?)?.toDouble() ?? 0.0,
            (symbolData['position']?['y'] as num?)?.toDouble() ?? 0.0,
          ),
          description: symbolData['description'] as String? ?? '',
          color: Color(int.parse(symbolData['color'] as String? ?? '0xFF0000FF')),
          size: (symbolData['size'] as num?)?.toDouble() ?? 1.0,
          rotation: (symbolData['rotation'] as num?)?.toDouble() ?? 0.0,
          points: points,
        );
      }).toList();

      return Layer(
        id: data['id'] as String? ?? '',
        name: data['name'] as String? ?? 'Unnamed',
        type: LayerType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => LayerType.vector,
        ),
        visible: data['visible'] as bool? ?? true,
        opacity: (data['opacity'] as num?)?.toDouble() ?? 1.0,
        zIndex: data['z_index'] as int? ?? 1,
        locked: data['locked'] as bool? ?? false,
        color: Color(int.parse(data['color'] as String? ?? '0xFF0000FF')),
        symbols: symbols,
      );
    }).toList();

    return MapState(
      layers: layers,
      zoomLevel: (json['view']?['zoom'] as num?)?.toDouble() ?? 1.0,
      panOffset: Offset(
        (json['view']?['pan_x'] as num?)?.toDouble() ?? 0.0,
        (json['view']?['pan_y'] as num?)?.toDouble() ?? 0.0,
      ),
      appVersion: json['metadata']?['version'] as String? ?? '0.0.001',
    );
  }
}

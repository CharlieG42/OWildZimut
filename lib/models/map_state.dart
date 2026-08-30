import 'package:flutter/material.dart';
import 'layer.dart';
import 'symbol.dart' as symbol_model;
import 'georeferencing.dart' as geo;

/// État global de la carte (géré par un StateNotifier ou Riverpod)
/// 
/// Cette classe contient toutes les informations nécessaires pour gérer l'état
/// de la carte, y compris les calques, la vue, la sélection, et l'historique.
class MapState {
  final List<Layer> layers;
  final int? selectedLayerIndex;
  final double zoomLevel;
  final Offset panOffset;
  final String appVersion;
  final String? currentFile;
  final String? fileName;
  final Set<String> selectedSymbolIds;
  final geo.Georeferencing? georeferencing;

  const MapState({
    this.layers = const [],
    this.selectedLayerIndex,
    this.zoomLevel = 1.0,
    this.panOffset = Offset.zero,
    this.appVersion = '0.0.007',
    this.currentFile,
    this.fileName,
    this.selectedSymbolIds = const {},
    this.georeferencing,
  });

  /// Crée un MapState initial avec des calques par défaut
  factory MapState.initial() {
    return const MapState(
      appVersion: '0.0.007',
    ).addLayer('Carte de base', LayerType.vector)
      .addLayer('Végétation', LayerType.vector)
      .addLayer('Chemins', LayerType.vector);
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

  /// Crée une copie avec des modifications
  MapState copyWith({
    List<Layer>? layers,
    int? selectedLayerIndex,
    double? zoomLevel,
    Offset? panOffset,
    String? appVersion,
    String? currentFile,
    String? fileName,
    Set<String>? selectedSymbolIds,
    geo.Georeferencing? georeferencing,
  }) {
    return MapState(
      layers: layers ?? this.layers,
      selectedLayerIndex: selectedLayerIndex ?? this.selectedLayerIndex,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      panOffset: panOffset ?? this.panOffset,
      appVersion: appVersion ?? this.appVersion,
      currentFile: currentFile ?? this.currentFile,
      fileName: fileName ?? this.fileName,
      selectedSymbolIds: selectedSymbolIds ?? this.selectedSymbolIds,
      georeferencing: georeferencing ?? this.georeferencing,
    );
  }

  // ============================================================================
  // GESTION DES CALQUES
  // ============================================================================

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

  /// Ajoute un calque d'image de fond (fond de carte jpg/jpeg/png).
  /// Le calque est placé au bas de la pile (zIndex le plus bas) pour que
  /// les calques vectoriels dessinés par-dessus restent visibles.
  MapState addImageBackgroundLayer(String name, String imagePath) {
    final lowestZIndex = layers.isEmpty
        ? 1
        : layers.map((l) => l.zIndex).reduce((a, b) => a < b ? a : b) - 1;

    final newLayer = Layer.imageBackground(
      id: 'layer_${DateTime.now().millisecondsSinceEpoch}_${layers.length + 1}',
      name: name,
      imagePath: imagePath,
      zIndex: lowestZIndex,
    );

    return copyWith(
      layers: [...layers, newLayer],
      selectedLayerIndex: layers.length,
    );
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

    // Effacer la sélection si le calque supprimé contenait des symboles sélectionnés
    final newSelectedIds = selectedSymbolIds.where((id) {
      return newLayers.any((layer) => layer.symbols.any((s) => s.id == id));
    }).toSet();

    return copyWith(
      layers: reorderedLayers,
      selectedLayerIndex: newSelectedIndex,
      selectedSymbolIds: newSelectedIds,
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
    // Effacer la sélection des symboles si on change de calque
    return copyWith(
      selectedLayerIndex: index,
      selectedSymbolIds: const {},
    );
  }

  /// Déplace un calque vers le haut
  MapState moveLayerUp(String layerId) {
    final index = layers.indexWhere((layer) => layer.id == layerId);
    if (index <= 0 || index >= layers.length) return this;

    final newLayers = List<Layer>.from(layers);
    final layer = newLayers.removeAt(index);
    newLayers.insert(index + 1, layer.copyWith(zIndex: index + 2));

    // Recalculer les zIndex
    for (var i = 0; i < newLayers.length; i++) {
      newLayers[i] = newLayers[i].copyWith(zIndex: i + 1);
    }

    return copyWith(layers: newLayers);
  }

  /// Déplace un calque vers le bas
  MapState moveLayerDown(String layerId) {
    final index = layers.indexWhere((layer) => layer.id == layerId);
    if (index < 0 || index >= layers.length - 1) return this;

    final newLayers = List<Layer>.from(layers);
    final layer = newLayers.removeAt(index);
    newLayers.insert(index - 1, layer.copyWith(zIndex: index));

    // Recalculer les zIndex
    for (var i = 0; i < newLayers.length; i++) {
      newLayers[i] = newLayers[i].copyWith(zIndex: i + 1);
    }

    return copyWith(layers: newLayers);
  }

  // ============================================================================
  // GESTION DE LA VUE (ZOOM/PAN)
  // ============================================================================

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

  /// Applique un zoom relatif
  MapState zoomBy(double factor, Offset focalPoint) {
    final newZoom = (zoomLevel * factor).clamp(0.1, 10.0);
    
    // Calculer le nouveau décalage pour zoomer vers le point focal
    final oldPan = panOffset;
    final newPan = Offset(
      oldPan.dx - (focalPoint.dx - oldPan.dx) * (newZoom - zoomLevel) / zoomLevel,
      oldPan.dy - (focalPoint.dy - oldPan.dy) * (newZoom - zoomLevel) / zoomLevel,
    );
    
    return copyWith(
      zoomLevel: newZoom,
      panOffset: newPan,
    );
  }

  /// Déplace la vue
  MapState panBy(Offset delta) {
    return copyWith(panOffset: panOffset + delta);
  }

  // ============================================================================
  // GESTION DES SYMBOLES
  // ============================================================================

  /// Ajoute un symbole au calque sélectionné
  MapState addSymbolToSelectedLayer(symbol_model.MapSymbol symbol) {
    if (selectedLayerIndex == null || selectedLayerIndex! >= layers.length) {
      return this;
    }

    final newLayers = List<Layer>.from(layers);
    newLayers[selectedLayerIndex!] = newLayers[selectedLayerIndex!].addSymbol(symbol);

    return copyWith(
      layers: newLayers,
      selectedSymbolIds: {symbol.id}, // Sélectionner le nouveau symbole
    );
  }

  /// Ajoute un symbole à un calque spécifique
  MapState addSymbolToLayer(String layerId, symbol_model.MapSymbol symbol) {
    final newLayers = layers.map((layer) {
      if (layer.id == layerId) {
        return layer.addSymbol(symbol);
      }
      return layer;
    }).toList();

    return copyWith(
      layers: newLayers,
      selectedSymbolIds: {symbol.id},
    );
  }

  /// Supprime un symbole par ID
  MapState removeSymbol(String symbolId) {
    final newLayers = layers.map((layer) {
      return layer.removeSymbol(symbolId);
    }).toList();

    // Retirer le symbole de la sélection
    final newSelectedIds = Set<String>.from(selectedSymbolIds)..remove(symbolId);

    return copyWith(
      layers: newLayers,
      selectedSymbolIds: newSelectedIds,
    );
  }

  /// Supprime tous les symboles sélectionnés
  MapState removeSelectedSymbols() {
    if (selectedSymbolIds.isEmpty) return this;

    final newLayers = layers.map((layer) {
      return layer.removeSymbols(selectedSymbolIds);
    }).toList();

    return copyWith(
      layers: newLayers,
      selectedSymbolIds: const {},
    );
  }

  /// Déplace un symbole
  MapState moveSymbol(String symbolId, Offset delta) {
    final newLayers = layers.map((layer) {
      return layer.moveSymbol(symbolId, delta);
    }).toList();

    return copyWith(layers: newLayers);
  }

  /// Déplace tous les symboles sélectionnés
  MapState moveSelectedSymbols(Offset delta) {
    if (selectedSymbolIds.isEmpty) return this;

    final newLayers = layers.map((layer) {
      return layer.moveSymbols(selectedSymbolIds, delta);
    }).toList();

    return copyWith(layers: newLayers);
  }

  /// Met à jour un symbole
  MapState updateSymbol(String symbolId, symbol_model.MapSymbol newSymbol) {
    final newLayers = layers.map((layer) {
      return layer.updateSymbol(symbolId, newSymbol);
    }).toList();

    return copyWith(layers: newLayers);
  }

  // ============================================================================
  // GESTION DE LA SÉLECTION
  // ============================================================================

  /// Sélectionne un symbole (remplace la sélection actuelle)
  MapState selectSymbol(String symbolId, {bool multiSelect = false}) {
    if (!multiSelect) {
      // Sélection simple
      return copyWith(selectedSymbolIds: {symbolId});
    } else {
      // Sélection multiple
      final newSelection = Set<String>.from(selectedSymbolIds);
      if (newSelection.contains(symbolId)) {
        newSelection.remove(symbolId);
      } else {
        newSelection.add(symbolId);
      }
      return copyWith(selectedSymbolIds: newSelection);
    }
  }

  /// Sélectionne tous les symboles d'un calque
  MapState selectAllSymbolsInLayer(int layerIndex) {
    if (layerIndex < 0 || layerIndex >= layers.length) return this;

    final layer = layers[layerIndex];
    final newSelection = layer.symbols.map((s) => s.id).toSet();

    return copyWith(selectedSymbolIds: newSelection);
  }

  /// Sélectionne tous les symboles de tous les calques
  MapState selectAllSymbols() {
    final newSelection = <String>{};
    for (final layer in layers) {
      for (final symbol in layer.symbols) {
        newSelection.add(symbol.id);
      }
    }
    return copyWith(selectedSymbolIds: newSelection);
  }

  /// Sélectionne les symboles dans un rectangle
  MapState selectSymbolsInRect(Rect rect) {
    final newSelection = <String>{};
    
    for (final layer in layers) {
      for (final symbol in layer.symbols) {
        if (symbol.boundingBox.overlaps(rect)) {
          newSelection.add(symbol.id);
        }
      }
    }
    
    return copyWith(selectedSymbolIds: newSelection);
  }

  /// Efface la sélection
  MapState clearSelection() {
    return copyWith(selectedSymbolIds: const {});
  }

  /// Inverse la sélection
  MapState invertSelection() {
    final allSymbolIds = <String>{};
    for (final layer in layers) {
      for (final symbol in layer.symbols) {
        allSymbolIds.add(symbol.id);
      }
    }
    
    final newSelection = allSymbolIds.difference(selectedSymbolIds);
    return copyWith(selectedSymbolIds: newSelection);
  }

  /// Récupère les symboles sélectionnés
  List<symbol_model.MapSymbol> get selectedSymbols {
    final result = <symbol_model.MapSymbol>[];
    for (final layer in layers) {
      for (final symbol in layer.symbols) {
        if (selectedSymbolIds.contains(symbol.id)) {
          result.add(symbol);
        }
      }
    }
    return result;
  }

  /// Vérifie si un symbole est sélectionné
  bool isSymbolSelected(String symbolId) {
    return selectedSymbolIds.contains(symbolId);
  }

  // ============================================================================
  // GESTION DU CLIPBOARD (COPIER/COLLER)
  // ============================================================================

  /// Copie les symboles sélectionnés dans le clipboard
  List<symbol_model.MapSymbol> copySelectedSymbols() {
    return selectedSymbols;
  }

  /// Colle des symboles depuis le clipboard
  MapState pasteSymbols(List<symbol_model.MapSymbol> symbols, Offset offset) {
    if (selectedLayerIndex == null || symbols.isEmpty) return this;

    final newSymbols = symbols.map((symbol) {
      // Créer une nouvelle copie avec un nouvel ID et une position décalée
      return symbol.copyWith(
        id: 'symbol_${DateTime.now().millisecondsSinceEpoch}_${symbol.id}',
        position: symbol.position + offset,
        points: symbol.points.map((p) => p + offset).toList(),
      );
    }).toList();

    final newLayers = List<Layer>.from(layers);
    for (final newSymbol in newSymbols) {
      newLayers[selectedLayerIndex!] = newLayers[selectedLayerIndex!].addSymbol(newSymbol);
    }

    return copyWith(
      layers: newLayers,
      selectedSymbolIds: newSymbols.map((s) => s.id).toSet(),
    );
  }

  // ============================================================================
  // GESTION DU GÉORÉFÉRENCEMENT
  // ============================================================================

  /// Met à jour le géoréférencement
  MapState setGeoreferencing(geo.Georeferencing? georef) {
    return copyWith(georeferencing: georef);
  }

  // ============================================================================
  // EXPORT/IMPORT JSON
  // ============================================================================

  /// Exporte en JSON (pour sauvegarde)
  Map<String, dynamic> toJson() {
    return {
      'metadata': {
        'version': appVersion,
        'name': fileName ?? 'OWildZimut Project',
        'created_at': DateTime.now().toIso8601String(),
      },
      'georeferencing': georeferencing?.toJson(),
      'layers': layers.map((layer) => layer.toJson()).toList(),
      'view': {
        'zoom': zoomLevel,
        'pan_x': panOffset.dx,
        'pan_y': panOffset.dy,
      },
      'selection': selectedSymbolIds.toList(),
    };
  }

  /// Charge depuis JSON
  static MapState fromJson(Map<String, dynamic> json) {
    final layersData = json['layers'] as List? ?? [];
    final layers = layersData.map((data) => Layer.fromJson(data)).toList();
    
    geo.Georeferencing? georeferencing;
    if (json['georeferencing'] != null) {
      georeferencing = geo.Georeferencing.fromJson(json['georeferencing'] as Map<String, dynamic>);
    }

    return MapState(
      layers: layers,
      zoomLevel: (json['view']?['zoom'] as num?)?.toDouble() ?? 1.0,
      panOffset: Offset(
        (json['view']?['pan_x'] as num?)?.toDouble() ?? 0.0,
        (json['view']?['pan_y'] as num?)?.toDouble() ?? 0.0,
      ),
      appVersion: json['metadata']?['version'] as String? ?? '0.0.007',
      fileName: json['metadata']?['name'] as String?,
      selectedSymbolIds: (json['selection'] as List<dynamic>?)
          ?.map((id) => id.toString())
          .toSet() ?? const {},
      georeferencing: georeferencing,
    );
  }
}

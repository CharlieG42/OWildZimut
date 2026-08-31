import 'package:flutter/material.dart';
import 'layer.dart';
import 'symbol.dart' as symbol_model;
import 'georeferencing.dart' as geo;

/// État global de la carte
///
/// Cette classe contient toutes les informations nécessaires pour afficher et
/// manipuler la carte : calques, symboles, sélection, zoom, etc.
///
/// Elle est conçue pour être immutable : toutes les modifications créent
/// une nouvelle instance.
class MapState {
  /// Liste des calques
  final List<Layer> layers;

  /// Index du calque sélectionné
  int selectedLayerIndex;

  /// Ensemble des IDs des symboles sélectionnés
  final Set<String> selectedSymbolIds;

  /// Position de la caméra (en mm, dans le repère de la carte)
  final Offset cameraPosition;

  /// Niveau de zoom (1.0 = 100%)
  final double zoom;

  /// Rotation de la vue (en radians)
  final double rotation;

  /// Taille de la zone visible (en mm, dans le repère de la carte)
  final Size viewportSize;

  /// Échelle actuelle (en m/m, 1:5000 = 5000)
  final double scale;

  /// Couleur de fond de la carte
  final Color backgroundColor;

  /// Gestion du géoréférencement
  final geo.Georeferencing? georeferencing;

  /// Mode d'édition actuel
  final MapEditingMode editingMode;

  /// Outil de dessin actuel
  final DrawingTool currentTool;

  /// Grille magnétique active
  final bool snapToGrid;

  /// Taille de la grille (en mm)
  final double gridSize;

  /// Mode avancé (affiche plus d'outils)
  final bool advancedMode;

  /// Crée un nouvel état
  MapState({
    this.layers = const [],
    this.selectedLayerIndex = 0,
    this.selectedSymbolIds = const {},
    this.cameraPosition = Offset.zero,
    this.zoom = 1.0,
    this.rotation = 0.0,
    this.viewportSize = const Size(800, 600),
    this.scale = 5000.0,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.georeferencing,
    this.editingMode = MapEditingMode.select,
    this.currentTool = DrawingTool.select,
    this.snapToGrid = false,
    this.gridSize = 5.0,
    this.advancedMode = false,
  });

  /// État initial avec un calque par défaut
  factory MapState.initial() {
    return MapState(
      layers: [
        Layer(
          id: 'default',
          name: 'Calque 1',
          color: const Color(0xFF2196F3),
        ),
      ],
      selectedLayerIndex: 0,
    );
  }

  /// Crée une copie de l'état avec des modifications
  MapState copyWith({
    List<Layer>? layers,
    int? selectedLayerIndex,
    Set<String>? selectedSymbolIds,
    Offset? cameraPosition,
    double? zoom,
    double? rotation,
    Size? viewportSize,
    double? scale,
    Color? backgroundColor,
    geo.Georeferencing? georeferencing,
    MapEditingMode? editingMode,
    DrawingTool? currentTool,
    bool? snapToGrid,
    double? gridSize,
    bool? advancedMode,
  }) {
    return MapState(
      layers: layers ?? this.layers,
      selectedLayerIndex: selectedLayerIndex ?? this.selectedLayerIndex,
      selectedSymbolIds: selectedSymbolIds ?? this.selectedSymbolIds,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      zoom: zoom ?? this.zoom,
      rotation: rotation ?? this.rotation,
      viewportSize: viewportSize ?? this.viewportSize,
      scale: scale ?? this.scale,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      georeferencing: georeferencing ?? this.georeferencing,
      editingMode: editingMode ?? this.editingMode,
      currentTool: currentTool ?? this.currentTool,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      gridSize: gridSize ?? this.gridSize,
      advancedMode: advancedMode ?? this.advancedMode,
    );
  }

  // ============================================================================
  // ACCESSEURS
  // ============================================================================

  /// Calque sélectionné
  Layer? get selectedLayer => 
      selectedLayerIndex >= 0 && selectedLayerIndex < layers.length
          ? layers[selectedLayerIndex]
          : null;

  /// Tous les symboles sélectionnés
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

  /// Nombre total de symboles
  int get totalSymbolCount {
    int count = 0;
    for (final layer in layers) {
      count += layer.symbols.length;
    }
    return count;
  }

  /// Rectangle englobant de tous les éléments de la carte
  Rect? get boundingBox {
    Rect? result;
    for (final layer in layers) {
      final layerBox = layer.boundingBox;
      if (layerBox != null) {
        result = result == null ? layerBox : result.expandToInclude(layerBox);
      }
    }
    return result;
  }

  /// Vrai si au moins un symbole est sélectionné
  bool get hasSelection => selectedSymbolIds.isNotEmpty;

  /// Vrai si plusieurs symboles sont sélectionnés
  bool get hasMultipleSelection => selectedSymbolIds.length > 1;

  // ============================================================================
  // GESTION DES CALQUES
  // ============================================================================

  /// Ajoute un nouveau calque
  MapState addLayer(Layer layer) {
    final newLayers = List<Layer>.from(layers)..add(layer);
    return copyWith(
      layers: newLayers,
      selectedLayerIndex: newLayers.length - 1,
    );
  }

  /// Supprime un calque
  MapState removeLayer(String layerId) {
    final index = layers.indexWhere((l) => l.id == layerId);
    if (index == -1) return this;
    
    final newLayers = List<Layer>.from(layers)..removeAt(index);
    int newSelectedIndex = selectedLayerIndex;
    
    if (selectedLayerIndex >= newLayers.length) {
      newSelectedIndex = newLayers.length - 1;
    }
    if (selectedLayerIndex > index) {
      newSelectedIndex--;
    }
    
    // Supprimer les symboles sélectionnés qui appartenaient à ce calque
    final newSelectedIds = selectedSymbolIds.where((id) {
      return !layers[index].symbols.any((s) => s.id == id);
    }).toSet();
    
    return copyWith(
      layers: newLayers,
      selectedLayerIndex: newSelectedIndex,
      selectedSymbolIds: newSelectedIds,
    );
  }

  /// Déplace un calque vers une nouvelle position
  MapState moveLayer(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return this;
    if (fromIndex < 0 || fromIndex >= layers.length) return this;
    if (toIndex < 0 || toIndex >= layers.length) return this;
    
    final newLayers = List<Layer>.from(layers);
    final layer = newLayers.removeAt(fromIndex);
    newLayers.insert(toIndex, layer);
    
    int newSelectedIndex = selectedLayerIndex;
    if (selectedLayerIndex == fromIndex) {
      newSelectedIndex = toIndex;
    } else if (fromIndex < toIndex && selectedLayerIndex > fromIndex && selectedLayerIndex <= toIndex) {
      newSelectedIndex--;
    } else if (fromIndex > toIndex && selectedLayerIndex >= toIndex && selectedLayerIndex < fromIndex) {
      newSelectedIndex++;
    }
    
    return copyWith(
      layers: newLayers,
      selectedLayerIndex: newSelectedIndex,
    );
  }

  /// Met à jour un calque
  MapState updateLayer(String layerId, Layer newLayer) {
    final newLayers = layers.map((l) => l.id == layerId ? newLayer : l).toList();
    return copyWith(layers: newLayers);
  }

  /// Change le calque sélectionné
  MapState selectLayer(int index) {
    if (index < 0 || index >= layers.length) return this;
    return copyWith(
      selectedLayerIndex: index,
      selectedSymbolIds: const {}, // Effacer la sélection des symboles
    );
  }

  // ============================================================================
  // GESTION DES SYMBOLES
  // ============================================================================

  /// Ajoute un symbole au calque sélectionné
  MapState addSymbol(symbol_model.MapSymbol symbol) {
    final layer = selectedLayer;
    if (layer == null) return this;
    
    return addSymbolToLayer(layer.id, symbol);
  }

  /// Ajoute un symbole à un calque spécifique
  MapState addSymbolToLayer(String layerId, symbol_model.MapSymbol symbol) {
    final newLayers = layers.map((l) {
      if (l.id == layerId) {
        return l.addSymbol(symbol);
      }
      return l;
    }).toList();
    
    return copyWith(
      layers: newLayers,
      selectedSymbolIds: {symbol.id}, // Sélectionner le nouveau symbole
    );
  }

  /// Ajoute plusieurs symboles au calque sélectionné
  MapState addSymbols(List<symbol_model.MapSymbol> symbols) {
    final layer = selectedLayer;
    if (layer == null) return this;
    
    final newLayers = layers.map((l) {
      if (l.id == layer.id) {
        return l.addSymbols(symbols);
      }
      return l;
    }).toList();
    
    final newSelectedIds = {...selectedSymbolIds, ...symbols.map((s) => s.id)};
    return copyWith(
      layers: newLayers,
      selectedSymbolIds: newSelectedIds,
    );
  }

  /// Supprime un symbole
  MapState removeSymbol(String symbolId) {
    final newLayers = layers.map((l) => l.removeSymbol(symbolId)).toList();
    final newSelectedIds = Set<String>.from(selectedSymbolIds)..remove(symbolId);
    
    return copyWith(
      layers: newLayers,
      selectedSymbolIds: newSelectedIds,
    );
  }

  /// Supprime plusieurs symboles
  MapState removeSymbols(Set<String> symbolIds) {
    final newLayers = layers.map((l) => l.removeSymbols(symbolIds)).toList();
    final newSelectedIds = selectedSymbolIds.difference(symbolIds);
    
    return copyWith(
      layers: newLayers,
      selectedSymbolIds: newSelectedIds,
    );
  }

  /// Supprime tous les symboles sélectionnés
  MapState removeSelectedSymbols() {
    return removeSymbols(selectedSymbolIds);
  }

  /// Met à jour un symbole
  MapState updateSymbol(String symbolId, symbol_model.MapSymbol newSymbol) {
    final newLayers = layers.map((l) {
      return l.updateSymbol(symbolId, newSymbol);
    }).toList();
    
    return copyWith(layers: newLayers);
  }

  /// Déplace un symbole
  MapState moveSymbol(String symbolId, Offset delta) {
    final newLayers = layers.map((l) => l.moveSymbol(symbolId, delta)).toList();
    return copyWith(layers: newLayers);
  }

  /// Déplace plusieurs symboles
  MapState moveSymbols(Set<String> symbolIds, Offset delta) {
    final newLayers = layers.map((l) => l.moveSymbols(symbolIds, delta)).toList();
    return copyWith(layers: newLayers);
  }

  /// Trouve le symbole le plus proche d'un point
  symbol_model.MapSymbol? findSymbolNearestTo(Offset point, {double maxDistance = 10.0}) {
    symbol_model.MapSymbol? nearestSymbol;
    double nearestDistance = maxDistance;
    
    for (final layer in layers) {
      final symbol = layer.findSymbolNearestTo(point, maxDistance: nearestDistance);
      if (symbol != null) {
        final distance = (point - symbol.position).distance;
        if (distance <= nearestDistance) {
          nearestDistance = distance;
          nearestSymbol = symbol;
        }
      }
    }
    
    return nearestSymbol;
  }

  // ============================================================================
  // GESTION DE LA SÉLECTION
  // ============================================================================

  /// Sélectionne un symbole
  MapState selectSymbol(String symbolId, {bool toggle = false, bool multiSelect = false}) {
    if (!multiSelect) {
      // Sélection simple : effacer la sélection actuelle
      return copyWith(selectedSymbolIds: {symbolId});
    }
    
    // Sélection multiple : ajouter/supprimer de la sélection
    final newSelectedIds = Set<String>.from(selectedSymbolIds);
    if (toggle && newSelectedIds.contains(symbolId)) {
      newSelectedIds.remove(symbolId);
    } else {
      newSelectedIds.add(symbolId);
    }
    
    return copyWith(selectedSymbolIds: newSelectedIds);
  }

  /// Sélectionne plusieurs symboles
  MapState selectSymbols(Set<String> symbolIds) {
    return copyWith(selectedSymbolIds: symbolIds);
  }

  /// Sélectionne tous les symboles du calque sélectionné
  MapState selectAllSymbols() {
    final layer = selectedLayer;
    if (layer == null) return this;
    
    return copyWith(
      selectedSymbolIds: layer.symbols.map((s) => s.id).toSet(),
    );
  }

  /// Efface la sélection
  MapState clearSelection() {
    return copyWith(selectedSymbolIds: const {});
  }

  /// Inverse la sélection dans le calque sélectionné
  MapState invertSelection() {
    final layer = selectedLayer;
    if (layer == null) return this;
    
    final newSelectedIds = layer.symbols
        .where((s) => !selectedSymbolIds.contains(s.id))
        .map((s) => s.id)
        .toSet();
    
    return copyWith(selectedSymbolIds: newSelectedIds);
  }

  // ============================================================================
  // GESTION DE LA CAMÉRA
  // ============================================================================

  /// Déplace la caméra
  MapState moveCamera(Offset delta) {
    return copyWith(cameraPosition: cameraPosition + delta);
  }

  /// Centre la caméra sur un point
  MapState centerOn(Offset point) {
    return copyWith(cameraPosition: point - viewportSize.center(Offset.zero));
  }

  /// Centre la caméra sur tous les éléments
  MapState centerOnAll() {
    final box = boundingBox;
    if (box == null) return this;
    
    final center = box.center;
    return copyWith(cameraPosition: center - viewportSize.center(Offset.zero));
  }

  /// Zoom avant/arrière
  MapState zoomBy(double factor, {Offset? focusPoint}) {
    final newZoom = (zoom * factor).clamp(0.1, 10.0);
    
    if (focusPoint == null) {
      return copyWith(zoom: newZoom);
    }
    
    // Zoom centré sur un point
    final oldMousePos = (focusPoint - cameraPosition) / zoom;
    final newMousePos = (focusPoint - cameraPosition) / newZoom;
    final cameraDelta = newMousePos - oldMousePos;
    
    return copyWith(
      zoom: newZoom,
      cameraPosition: cameraPosition - cameraDelta,
    );
  }

  /// Réinitialise la vue
  MapState resetView() {
    return copyWith(
      cameraPosition: Offset.zero,
      zoom: 1.0,
      rotation: 0.0,
    );
  }

  // ============================================================================
  // GESTION DU GÉORÉFÉRENCEMENT
  // ============================================================================

  /// Met à jour le géoréférencement
  MapState updateGeoreferencing(geo.Georeferencing newGeoreferencing) {
    return copyWith(georeferencing: newGeoreferencing);
  }

  /// Ajoute un point de contrôle au sol
  MapState addGroundControlPoint(geo.GroundControlPoint point) {
    final current = georeferencing;
    if (current == null) {
      return copyWith(
        georeferencing: geo.Georeferencing(
          scale: scale,
          rotation: 0.0,
          groundControlPoints: [point],
        ),
      );
    }
    
    final newPoints = List<geo.GroundControlPoint>.from(current.groundControlPoints)..add(point);
    return copyWith(
      georeferencing: current.copyWith(groundControlPoints: newPoints),
    );
  }

  /// Supprime un point de contrôle au sol
  MapState removeGroundControlPoint(String pointId) {
    final current = georeferencing;
    if (current == null) return this;
    
    final newPoints = current.groundControlPoints
        .where((p) => p.id != pointId)
        .toList();
    
    return copyWith(
      georeferencing: current.copyWith(groundControlPoints: newPoints),
    );
  }

  // ============================================================================
  // GESTION DU PRESSE-PAPIER
  // ============================================================================

  /// Copie les symboles sélectionnés dans le presse-papier
  List<symbol_model.MapSymbol> copyToClipboard() {
    return selectedSymbols
        .map((s) => s.copyWith(
              id: '${s.id}_copy',
              selected: false,
            ))
        .toList();
  }

  /// Colle les symboles depuis le presse-papier
  MapState pasteFromClipboard(List<symbol_model.MapSymbol> clipboard, Offset position) {
    if (clipboard.isEmpty) return this;
    
    final newSymbols = clipboard.map((s) {
      final offset = position - s.position;
      return s.copyWith(
        id: '${s.id}_${DateTime.now().millisecondsSinceEpoch}',
        position: position,
        points: s.points.map((p) => p + offset).toList(),
        selected: true,
      );
    }).toList();
    
    return addSymbols(newSymbols);
  }

  // ============================================================================
  // OUTILS DE DESSIN
  // ============================================================================

  /// Mode d'édition
  MapState setEditingMode(MapEditingMode mode) {
    return copyWith(editingMode: mode);
  }

  /// Outil de dessin
  MapState setCurrentTool(DrawingTool tool) {
    return copyWith(currentTool: tool);
  }

  /// Active/désactive la grille magnétique
  MapState toggleSnapToGrid() {
    return copyWith(snapToGrid: !snapToGrid);
  }

  /// Met à jour la taille de la grille
  MapState setGridSize(double size) {
    return copyWith(gridSize: size.clamp(0.1, 100.0));
  }

  /// Active/désactive le mode avancé
  MapState toggleAdvancedMode() {
    return copyWith(advancedMode: !advancedMode);
  }

  // ============================================================================
  // CONVERSION DE COORDONNÉES
  // ============================================================================

  /// Convertit une position écran en position carte
  Offset screenToMap(Offset screenPosition) {
    return (screenPosition / zoom) + cameraPosition;
  }

  /// Convertit une position carte en position écran
  Offset mapToScreen(Offset mapPosition) {
    return (mapPosition - cameraPosition) * zoom;
  }

  /// Convertit une taille carte en taille écran
  double mapToScreenSize(double mapSize) {
    return mapSize * zoom;
  }

  /// Convertit une taille écran en taille carte
  double screenToMapSize(double screenSize) {
    return screenSize / zoom;
  }

  // ============================================================================
  // EXPORT/IMPORT JSON
  // ============================================================================

  /// Exporte l'état en JSON
  Map<String, dynamic> toJson() {
    return {
      'layers': layers.map((l) => l.toJson()).toList(),
      'selected_layer_index': selectedLayerIndex,
      'selected_symbol_ids': selectedSymbolIds.toList(),
      'camera_position': {'x': cameraPosition.dx, 'y': cameraPosition.dy},
      'zoom': zoom,
      'rotation': rotation,
      'viewport_size': {'width': viewportSize.width, 'height': viewportSize.height},
      'scale': scale,
      'background_color': backgroundColor.toARGB32().toRadixString(16),
      if (georeferencing != null) 'georeferencing': georeferencing!.toJson(),
      'editing_mode': editingMode.name,
      'current_tool': currentTool.name,
      'snap_to_grid': snapToGrid,
      'grid_size': gridSize,
      'advanced_mode': advancedMode,
    };
  }

  /// Charge l'état depuis JSON
  factory MapState.fromJson(Map<String, dynamic> json) {
    final layersData = json['layers'] as List<dynamic>? ?? [];
    final layers = layersData
        .map((data) => Layer.fromJson(data as Map<String, dynamic>))
        .toList();
    
    final selectedSymbolIds = Set<String>.from(
      (json['selected_symbol_ids'] as List<dynamic>? ?? []).map((id) => id as String),
    );
    
    final cameraPositionData = json['camera_position'] as Map<String, dynamic>? ?? {};
    final viewportSizeData = json['viewport_size'] as Map<String, dynamic>? ?? {};
    
    return MapState(
      layers: layers,
      selectedLayerIndex: json['selected_layer_index'] as int? ?? 0,
      selectedSymbolIds: selectedSymbolIds,
      cameraPosition: Offset(
        (cameraPositionData['x'] as num?)?.toDouble() ?? 0.0,
        (cameraPositionData['y'] as num?)?.toDouble() ?? 0.0,
      ),
      zoom: (json['zoom'] as num?)?.toDouble() ?? 1.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      viewportSize: Size(
        (viewportSizeData['width'] as num?)?.toDouble() ?? 800.0,
        (viewportSizeData['height'] as num?)?.toDouble() ?? 600.0,
      ),
      scale: (json['scale'] as num?)?.toDouble() ?? 5000.0,
      backgroundColor: Color(int.parse(json['background_color'] as String? ?? '0xFFFFFFFF')),
      georeferencing: json['georeferencing'] != null
          ? geo.Georeferencing.fromJson(json['georeferencing'] as Map<String, dynamic>)
          : null,
      editingMode: MapEditingMode.values.firstWhere(
        (e) => e.name == json['editing_mode'],
        orElse: () => MapEditingMode.select,
      ),
      currentTool: DrawingTool.values.firstWhere(
        (e) => e.name == json['current_tool'],
        orElse: () => DrawingTool.select,
      ),
      snapToGrid: json['snap_to_grid'] as bool? ?? false,
      gridSize: (json['grid_size'] as num?)?.toDouble() ?? 5.0,
      advancedMode: json['advanced_mode'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'MapState(layers: ${layers.length}, selectedLayer: $selectedLayerIndex, '
        'selectedSymbols: ${selectedSymbolIds.length}, camera: $cameraPosition, '
        'zoom: $zoom, scale: $scale)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapState &&
        other.layers == layers &&
        other.selectedLayerIndex == selectedLayerIndex &&
        other.selectedSymbolIds == selectedSymbolIds &&
        other.cameraPosition == cameraPosition &&
        other.zoom == zoom &&
        other.rotation == rotation &&
        other.viewportSize == viewportSize &&
        other.scale == scale &&
        other.backgroundColor == backgroundColor &&
        other.georeferencing == georeferencing &&
        other.editingMode == editingMode &&
        other.currentTool == currentTool &&
        other.snapToGrid == snapToGrid &&
        other.gridSize == gridSize &&
        other.advancedMode == advancedMode;
  }

  @override
  int get hashCode {
    return layers.hashCode ^
        selectedLayerIndex.hashCode ^
        selectedSymbolIds.hashCode ^
        cameraPosition.hashCode ^
        zoom.hashCode ^
        rotation.hashCode ^
        viewportSize.hashCode ^
        scale.hashCode ^
        backgroundColor.hashCode ^
        georeferencing.hashCode ^
        editingMode.hashCode ^
        currentTool.hashCode ^
        snapToGrid.hashCode ^
        gridSize.hashCode ^
        advancedMode.hashCode;
  }
}

/// Modes d'édition possibles
enum MapEditingMode {
  /// Mode sélection : permet de sélectionner et déplacer des symboles
  select,

  /// Mode dessin : permet de dessiner de nouveaux symboles
  draw,

  /// Mode édition : permet de modifier les propriétés des symboles
  edit,
}

/// Outils de dessin possibles
enum DrawingTool {
  /// Outil de sélection
  select,

  /// Outil point : dessine des symboles ponctuels
  point,

  /// Outil ligne : dessine des lignes
  line,

  /// Outil surface : dessine des surfaces
  area,

  /// Outil texte : ajoute du texte
  text,

  /// Outil rectangle : dessine des rectangles
  rectangle,

  /// Outil cercle : dessine des cercles
  circle,

  /// Outil de suppression
  erase,

  /// Outil pipette : copie les propriétés d'un symbole
  eyedropper,

  /// Outil mesure : mesure des distances
  measure,
}

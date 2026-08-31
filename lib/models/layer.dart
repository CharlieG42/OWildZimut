import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'symbol.dart' as symbol_model;

/// Types de calques possibles
enum LayerType {
  /// Calque vectoriel : contient des symboles IOF (points, lignes, surfaces, textes)
  vector,

  /// Calque raster : image de fond importee (jpg, jpeg, png) servant de support
  /// pour tracer la carte par-dessus (photo aerienne, scan de carte existante, ...)
  raster,
}

/// Modèle de données pour un calque
///
/// Un calque représente une couche de la carte qui peut contenir :
/// - Des symboles vectoriels (points, lignes, surfaces, textes)
/// - Une image de fond (pour les calques raster)
class Layer {
  /// Identifiant unique du calque
  final String id;
  
  /// Nom du calque
  String name;
  
  /// Type de calque (vectoriel ou raster)
  LayerType type;
  
  /// Visibilité du calque
  bool visible;
  
  /// Opacité du calque (0.0 - 1.0)
  double opacity;
  
  /// Index Z (ordre de dessin, les calques avec un zIndex plus élevé sont dessinés par-dessus)
  int zIndex;
  
  /// Vrai si le calque est verrouillé (ne peut pas être modifié)
  bool locked;
  
  /// Liste des symboles dans ce calque
  List<symbol_model.MapSymbol> symbols;
  
  /// Couleur par défaut pour ce calque
  Color color;

  /// Chemin local de l'image de fond (uniquement pour les calques de type [LayerType.raster]).
  String? imagePath;

  /// Décalage (en mm, dans le repère de la carte) appliqué à l'image de fond.
  /// Permet un calibrage manuel simple tant que le calage sur points de contrôle
  /// n'est pas implémenté.
  Offset imageOffset;

  /// Facteur d'échelle appliqué à l'image de fond.
  double imageScale;

  Layer({
    required this.id,
    required this.name,
    this.type = LayerType.vector,
    this.visible = true,
    this.opacity = 1.0,
    this.zIndex = 1,
    this.locked = false,
    this.symbols = const [],
    this.color = const Color(0xFF2196F3),
    this.imagePath,
    this.imageOffset = Offset.zero,
    this.imageScale = 1.0,
  });

  /// Crée un calque raster (image de fond) à partir d'un fichier local
  factory Layer.imageBackground({
    required String id,
    required String name,
    required String imagePath,
    int zIndex = 0,
  }) {
    return Layer(
      id: id,
      name: name,
      type: LayerType.raster,
      zIndex: zIndex,
      color: const Color(0xFF9E9E9E),
      imagePath: imagePath,
    );
  }

  /// Crée une copie du calque avec des modifications
  Layer copyWith({
    String? id,
    String? name,
    LayerType? type,
    bool? visible,
    double? opacity,
    int? zIndex,
    bool? locked,
    List<symbol_model.MapSymbol>? symbols,
    Color? color,
    String? imagePath,
    Offset? imageOffset,
    double? imageScale,
  }) {
    return Layer(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      visible: visible ?? this.visible,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      locked: locked ?? this.locked,
      symbols: symbols ?? this.symbols,
      color: color ?? this.color,
      imagePath: imagePath ?? this.imagePath,
      imageOffset: imageOffset ?? this.imageOffset,
      imageScale: imageScale ?? this.imageScale,
    );
  }

  // ============================================================================
  // GESTION DES SYMBOLES
  // ============================================================================

  /// Ajoute un symbole au calque
  Layer addSymbol(symbol_model.MapSymbol symbol) {
    return copyWith(
      symbols: [...symbols, symbol],
    );
  }

  /// Ajoute plusieurs symboles au calque
  Layer addSymbols(List<symbol_model.MapSymbol> newSymbols) {
    return copyWith(
      symbols: [...symbols, ...newSymbols],
    );
  }

  /// Supprime un symbole du calque
  Layer removeSymbol(String symbolId) {
    return copyWith(
      symbols: symbols.where((s) => s.id != symbolId).toList(),
    );
  }

  /// Supprime plusieurs symboles du calque
  Layer removeSymbols(Set<String> symbolIds) {
    return copyWith(
      symbols: symbols.where((s) => !symbolIds.contains(s.id)).toList(),
    );
  }

  /// Met à jour un symbole existant
  Layer updateSymbol(String symbolId, symbol_model.MapSymbol updatedSymbol) {
    final newSymbols = symbols.map((s) {
      if (s.id == symbolId) {
        return updatedSymbol;
      }
      return s;
    }).toList();
    return copyWith(symbols: newSymbols);
  }

  /// Met à jour plusieurs symboles
  Layer updateSymbols(Map<String, symbol_model.MapSymbol> updates) {
    final newSymbols = symbols.map((s) {
      return updates[s.id] ?? s;
    }).toList();
    return copyWith(symbols: newSymbols);
  }

  /// Déplace un symbole
  Layer moveSymbol(String symbolId, Offset delta) {
    final newSymbols = symbols.map((s) {
      if (s.id == symbolId) {
        return s.copyWith(
          position: s.position + delta,
          points: s.points.map((p) => p + delta).toList(),
        );
      }
      return s;
    }).toList();
    return copyWith(symbols: newSymbols);
  }

  /// Déplace plusieurs symboles
  Layer moveSymbols(Set<String> symbolIds, Offset delta) {
    final newSymbols = symbols.map((s) {
      if (symbolIds.contains(s.id)) {
        return s.copyWith(
          position: s.position + delta,
          points: s.points.map((p) => p + delta).toList(),
        );
      }
      return s;
    }).toList();
    return copyWith(symbols: newSymbols);
  }

  /// Récupère un symbole par son ID
  symbol_model.MapSymbol? getSymbolById(String symbolId) {
    try {
      return symbols.firstWhere((s) => s.id == symbolId);
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si le calque contient un symbole
  bool containsSymbol(String symbolId) {
    return symbols.any((s) => s.id == symbolId);
  }

  /// Récupère tous les symboles d'un certain type
  List<symbol_model.MapSymbol> getSymbolsByType(symbol_model.MapSymbolType type) {
    return symbols.where((s) => s.type == type).toList();
  }

  /// Nombre de symboles dans le calque
  int get symbolCount => symbols.length;

  /// Vrai si ce calque est une image de fond
  bool get isImageBackground => type == LayerType.raster && imagePath != null;

  /// Rectangle englobant de tous les symboles du calque
  Rect? get boundingBox {
    if (symbols.isEmpty) return null;
    
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = -double.infinity;
    double maxY = -double.infinity;
    
    for (final symbol in symbols) {
      final box = symbol.boundingBox;
      minX = box.left < minX ? box.left : minX;
      minY = box.top < minY ? box.top : minY;
      maxX = box.right > maxX ? box.right : maxX;
      maxY = box.bottom > maxY ? box.bottom : maxY;
    }
    
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  // ============================================================================
  // EXPORT/IMPORT JSON
  // ============================================================================

  /// Exporte en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'visible': visible,
      'opacity': opacity,
      'z_index': zIndex,
      'locked': locked,
      'color': color.value.toRadixString(16),
      if (imagePath != null) 'image_path': imagePath,
      'image_offset': {'x': imageOffset.dx, 'y': imageOffset.dy},
      'image_scale': imageScale,
      'symbols': symbols.map((s) => s.toJson()).toList(),
    };
  }

  /// Charge depuis JSON
  factory Layer.fromJson(Map<String, dynamic> json) {
    final symbolsData = json['symbols'] as List? ?? [];
    final symbols = symbolsData
        .map((data) => symbol_model.MapSymbol.fromJson(data))
        .toList();
    
    return Layer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed',
      type: LayerType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LayerType.vector,
      ),
      visible: json['visible'] as bool? ?? true,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      zIndex: json['z_index'] as int? ?? 1,
      locked: json['locked'] as bool? ?? false,
      color: Color(int.parse(json['color'] as String? ?? '0xFF0000FF')),
      imagePath: json['image_path'] as String?,
      imageOffset: Offset(
        (json['image_offset']?['x'] as num?)?.toDouble() ?? 0.0,
        (json['image_offset']?['y'] as num?)?.toDouble() ?? 0.0,
      ),
      imageScale: (json['image_scale'] as num?)?.toDouble() ?? 1.0,
      symbols: symbols,
    );
  }

  @override
  String toString() {
    return 'Layer(id: $id, name: $name, type: $type, visible: $visible, '
        'opacity: $opacity, zIndex: $zIndex, symbols: $symbolCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Layer &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.visible == visible &&
        other.opacity == opacity &&
        other.zIndex == zIndex &&
        other.locked == locked &&
        other.symbols == symbols &&
        other.color == color &&
        other.imagePath == imagePath &&
        other.imageOffset == imageOffset &&
        other.imageScale == imageScale;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        visible.hashCode ^
        opacity.hashCode ^
        zIndex.hashCode ^
        locked.hashCode ^
        symbols.hashCode ^
        color.hashCode ^
        imagePath.hashCode ^
        imageOffset.hashCode ^
        imageScale.hashCode;
  }
}

/// Extension pour manipuler les calques facilement
extension LayerExtensions on Layer {
  /// Vrai si le calque est visible et non verrouillé
  bool get isEditable => visible && !locked;

  /// Trouve le symbole le plus proche d'un point
  symbol_model.MapSymbol? findSymbolNearestTo(Offset point, {double maxDistance = 10.0}) {
    symbol_model.MapSymbol? nearestSymbol;
    double nearestDistance = maxDistance;
    
    for (final symbol in symbols) {
      final distance = _distanceToSymbol(point, symbol);
      if (distance <= nearestDistance) {
        nearestDistance = distance;
        nearestSymbol = symbol;
      }
    }
    
    return nearestSymbol;
  }

  /// Calcule la distance d'un point à un symbole
  static double _distanceToSymbol(Offset point, symbol_model.MapSymbol symbol) {
    switch (symbol.type) {
      case symbol_model.MapSymbolType.point:
        return (point - symbol.position).distance - symbol.size / 2;
      case symbol_model.MapSymbolType.line:
        return _distanceToLine(point, symbol.points);
      case symbol_model.MapSymbolType.area:
        if (symbol.contains(point)) {
          return 0;
        }
        return _distanceToPolygon(point, symbol.points);
      case symbol_model.MapSymbolType.text:
        return _distanceToRect(point, symbol.boundingBox);
    }
  }

  /// Calcule la distance d'un point à une ligne
  static double _distanceToLine(Offset point, List<Offset> linePoints) {
    if (linePoints.isEmpty) return double.infinity;
    if (linePoints.length == 1) return (point - linePoints.first).distance;
    
    double minDistance = double.infinity;
    
    for (var i = 0; i < linePoints.length - 1; i++) {
      final p1 = linePoints[i];
      final p2 = linePoints[i + 1];
      final distance = _distanceToSegment(point, p1, p2);
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
    
    return minDistance;
  }

  /// Calcule la distance d'un point à un segment de ligne
  static double _distanceToSegment(Offset point, Offset p1, Offset p2) {
    final lineLength = (p2 - p1).distance;
    if (lineLength == 0) return (point - p1).distance;
    
    // Produit scalaire pour projeter le point sur la ligne
    final t = ((point.dx - p1.dx) * (p2.dx - p1.dx) + (point.dy - p1.dy) * (p2.dy - p1.dy)) / 
             (lineLength * lineLength);
    
    if (t < 0) return (point - p1).distance;
    if (t > 1) return (point - p2).distance;
    
    final projection = Offset(
      p1.dx + t * (p2.dx - p1.dx),
      p1.dy + t * (p2.dy - p1.dy),
    );
    return (point - projection).distance;
  }

  /// Calcule la distance d'un point à un polygone
  static double _distanceToPolygon(Offset point, List<Offset> polygonPoints) {
    if (polygonPoints.isEmpty) return double.infinity;
    
    // Vérifier si le point est à l'intérieur du polygone
    if (symbol_model.MapSymbol.pointInPolygon(point, polygonPoints)) {
      return 0;
    }
    
    // Sinon, calculer la distance à chaque segment
    return _distanceToLine(point, polygonPoints);
  }

  /// Calcule la distance d'un point à un rectangle
  static double _distanceToRect(Offset point, Rect rect) {
    // Si le point est dans le rectangle, distance = 0
    if (rect.contains(point)) return 0;
    
    // Sinon, calculer la distance au bord le plus proche
    double dx = 0;
    double dy = 0;
    
    if (point.dx < rect.left) {
      dx = rect.left - point.dx;
    } else if (point.dx > rect.right) {
      dx = point.dx - rect.right;
    }
    
    if (point.dy < rect.top) {
      dy = rect.top - point.dy;
    } else if (point.dy > rect.bottom) {
      dy = point.dy - rect.bottom;
    }
    
    return math.sqrt(dx * dx + dy * dy);
  }
}

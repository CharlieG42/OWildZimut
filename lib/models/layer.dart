import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'symbol.dart' as symbol_model;
import 'symbol.dart' show MapSymbolType;

/// Extension pour ajouter la méthode dot à Offset
extension OffsetExtensions on Offset {
  double dot(Offset other) {
    return dx * other.dx + dy * other.dy;
  }
}

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
      'color': color.toARGB32().toRadixString(16),
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
      type:

import 'package:flutter/material.dart';
import 'symbol.dart' as symbol_model;

/// Types de calques possibles
enum LayerType {
  /// Calque vectoriel : contient des symboles IOF (points, lignes, surfaces, textes)
  vector,

  /// Calque raster : image de fond importee (jpg, jpeg, png) servant de support
  /// pour tracer la carte par-dessus (photo aerienne, scan de carte existante, ...)
  raster,
}

/// Modele de donnees pour un calque
class Layer {
  final String id;
  String name;
  LayerType type;
  bool visible;
  double opacity;
  int zIndex;
  bool locked;
  List<symbol_model.MapSymbol> symbols;
  Color color;

  /// Chemin local de l'image de fond (uniquement pour les calques de type [LayerType.raster]).
  String? imagePath;

  /// Decalage (en pixels, dans le repere de la carte) applique a l'image de fond.
  /// Permet un calibrage manuel simple tant que le calage sur points de controle
  /// n'est pas implemente.
  Offset imageOffset;

  /// Facteur d'echelle applique a l'image de fond.
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
    this.color = Colors.blue,
    this.imagePath,
    this.imageOffset = Offset.zero,
    this.imageScale = 1.0,
  });

  /// Cree un calque raster (image de fond) a partir d'un fichier local
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
      color: Colors.grey,
      imagePath: imagePath,
    );
  }

  /// Cree une copie du calque avec des modifications
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

  /// Ajoute un symbole au calque
  Layer addSymbol(symbol_model.MapSymbol symbol) {
    return copyWith(
      symbols: [...symbols, symbol],
    );
  }

  /// Supprime un symbole du calque
  Layer removeSymbol(String symbolId) {
    return copyWith(
      symbols: symbols.where((s) => s.id != symbolId).toList(),
    );
  }

  /// Met a jour un symbole existant
  Layer updateSymbol(symbol_model.MapSymbol updatedSymbol) {
    final newSymbols = symbols.map((s) {
      if (s.id == updatedSymbol.id) {
        return updatedSymbol;
      }
      return s;
    }).toList();
    return copyWith(symbols: newSymbols);
  }

  /// Recupere un symbole par son ID
  symbol_model.MapSymbol? getSymbolById(String symbolId) {
    try {
      return symbols.firstWhere((s) => s.id == symbolId);
    } catch (e) {
      return null;
    }
  }

  /// Nombre de symboles dans le calque
  int get symbolCount => symbols.length;

  /// Vrai si ce calque est une image de fond
  bool get isImageBackground => type == LayerType.raster && imagePath != null;

  @override
  String toString() {
    return 'Layer(id: $id, name: $name, type: $type, visible: $visible, opacity: $opacity, symbols: $symbolCount)';
  }
}

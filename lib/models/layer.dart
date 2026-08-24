import 'package:flutter/material.dart';
import 'symbol.dart';

/// Types de calques possibles
enum LayerType {
  vector,
  raster,
}

/// Modèle de données pour un calque
class Layer {
  final String id;
  String name;
  LayerType type;
  bool visible;
  double opacity;
  int zIndex;
  bool locked;
  List<Symbol> symbols;
  Color color;

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
  });

  /// Crée une copie du calque avec des modifications
  Layer copyWith({
    String? id,
    String? name,
    LayerType? type,
    bool? visible,
    double? opacity,
    int? zIndex,
    bool? locked,
    List<Symbol>? symbols,
    Color? color,
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
    );
  }

  @override
  String toString() {
    return 'Layer(id: $id, name: $name, type: $type, visible: $visible, opacity: $opacity)';
  }
}

import 'package:flutter/material.dart';

/// Types de symboles IOF (International Orienteering Federation)
enum SymbolType {
  point,   // Code 701 - Postes de contrôle
  line,    // Code 502 - Chemins
  area,    // Code 401 - Forêts
  text,    // Légendes
}

/// Modèle de données pour un symbole sur la carte
class Symbol {
  final String id;
  final SymbolType type;
  String code; // Code IOF (ex: "701", "502")
  Offset position; // Position sur la carte
  String description;
  Color color;
  double size;
  double rotation; // En degrés
  List<Offset> points; // Pour les lignes et polygones

  Symbol({
    required this.id,
    required this.type,
    this.code = '',
    this.position = Offset.zero,
    this.description = '',
    this.color = Colors.black,
    this.size = 1.0,
    this.rotation = 0.0,
    this.points = const [],
  });

  /// Crée une copie du symbole avec des modifications
  Symbol copyWith({
    String? id,
    SymbolType? type,
    String? code,
    Offset? position,
    String? description,
    Color? color,
    double? size,
    double? rotation,
    List<Offset>? points,
  }) {
    return Symbol(
      id: id ?? this.id,
      type: type ?? this.type,
      code: code ?? this.code,
      position: position ?? this.position,
      description: description ?? this.description,
      color: color ?? this.color,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      points: points ?? this.points,
    );
  }

  @override
  String toString() {
    return 'Symbol(id: $id, type: $type, code: $code, position: $position)';
  }
}

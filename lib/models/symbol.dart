import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Types de symboles possibles dans une carte d'orientation
///
/// Ces types correspondent aux types de symboles IOF (International Orienteering Federation)
/// et sont utilisés dans le format OMAP.
enum MapSymbolType {
  /// Point : symbole ponctuel (rocher, arbre isolé, etc.)
  point,
  
  /// Ligne : symbole linéaire (chemin, rivière, ligne électrique, etc.)
  line,
  
  /// Surface : symbole de surface (forêt, champ, zone rocheuse, etc.)
  area,
  
  /// Texte : symbole textuel (nom, numéro, description, etc.)
  text,
}

/// Modèle de données pour un symbole de carte d'orientation
///
/// Un symbole représente un élément graphique sur la carte :
/// - Un point (rocher, arbre isolé, etc.)
/// - Une ligne (chemin, rivière, etc.)
/// - Une surface (forêt, champ, etc.)
/// - Du texte (nom, numéro, etc.)
///
/// Les coordonnées sont en millimètres dans le repère de la carte.
class MapSymbol {
  /// Identifiant unique du symbole
  final String id;
  
  /// Nom ou description du symbole
  String name;
  
  /// Type du symbole (point, ligne, surface, texte)
  MapSymbolType type;
  
  /// Position du symbole (pour les points et les textes)
  Offset position;
  
  /// Liste de points (pour les lignes et les surfaces)
  /// Pour une ligne : liste de points formant la ligne
  /// Pour une surface : liste de points formant le polygone (doit être fermé)
  List<Offset> points;
  
  /// Taille du symbole (pour les points, diamètre du cercle)
  double size;
  
  /// Couleur de la ligne (pour les lignes, surfaces et textes)
  Color strokeColor;
  
  /// Largeur de la ligne (pour les lignes et surfaces)
  double strokeWidth;
  
  /// Style de la ligne (pleine, pointillée, etc.)
  StrokeStyle strokeStyle;
  
  /// Couleur de remplissage (pour les surfaces et les points)
  Color fillColor;
  
  /// Opacité de remplissage (0.0 - 1.0)
  double fillOpacity;
  
  /// Vrai si la surface est fermée (pour les polygones)
  bool isClosed;
  
  /// Texte à afficher (pour les symboles de type texte)
  String text;
  
  /// Style du texte
  TextStyle textStyle;
  
  /// Alignement du texte
  TextAlign textAlign;
  
  /// Rotation du symbole (en radians)
  double rotation;
  
  /// Vrai si le symbole est visible
  bool visible;
  
  /// Vrai si le symbole est sélectionné
  bool selected;
  
  /// Niveau de détail (pour le filtrage par échelle)
  int detailLevel;
  
  /// Couche à laquelle appartient le symbole
  String layerId;
  
  /// Crée un nouveau symbole
  MapSymbol({
    required this.id,
    this.name = '',
    this.type = MapSymbolType.point,
    this.position = Offset.zero,
    this.points = const [],
    this.size = 1.0,
    this.strokeColor = const Color(0xFF000000),
    this.strokeWidth = 0.35,
    this.strokeStyle = StrokeStyle.solid,
    this.fillColor = const Color(0xFFFFFFFF),
    this.fillOpacity = 1.0,
    this.isClosed = false,
    this.text = '',
    this.textStyle = const TextStyle(color: Color(0xFF000000), fontSize: 2.5),
    this.textAlign = TextAlign.center,
    this.rotation = 0.0,
    this.visible = true,
    this.selected = false,
    this.detailLevel = 0,
    this.layerId = '',
  });

  /// Crée un symbole point
  factory MapSymbol.point({
    required String id,
    required Offset position,
    double size = 1.0,
    Color color = const Color(0xFF000000),
    String name = '',
    String layerId = '',
  }) {
    return MapSymbol(
      id: id,
      name: name,
      type: MapSymbolType.point,
      position: position,
      size: size,
      strokeColor: color,
      fillColor: color,
      layerId: layerId,
    );
  }

  /// Crée un symbole ligne
  factory MapSymbol.line({
    required String id,
    required List<Offset> points,
    Color color = const Color(0xFF000000),
    double width = 0.35,
    String name = '',
    String layerId = '',
  }) {
    return MapSymbol(
      id: id,
      name: name,
      type: MapSymbolType.line,
      points: points,
      strokeColor: color,
      strokeWidth: width,
      isClosed: false,
      layerId: layerId,
    );
  }

  /// Crée un symbole surface
  factory MapSymbol.area({
    required String id,
    required List<Offset> points,
    Color fillColor = const Color(0xFFFFEB3B),
    Color strokeColor = const Color(0xFF000000),
    double strokeWidth = 0.35,
    String name = '',
    String layerId = '',
  }) {
    return MapSymbol(
      id: id,
      name: name,
      type: MapSymbolType.area,
      points: points,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      isClosed: true,
      layerId: layerId,
    );
  }

  /// Crée un symbole texte
  factory MapSymbol.text({
    required String id,
    required String text,
    required Offset position,
    TextStyle style = const TextStyle(color: Color(0xFF000000), fontSize: 2.5),
    String name = '',
    String layerId = '',
  }) {
    return MapSymbol(
      id: id,
      name: name,
      type: MapSymbolType.text,
      position: position,
      text: text,
      textStyle: style,
      layerId: layerId,
    );
  }

  /// Crée une copie du symbole avec des modifications
  MapSymbol copyWith({
    String? id,
    String? name,
    MapSymbolType? type,
    Offset? position,
    List<Offset>? points,
    double? size,
    Color? strokeColor,
    double? strokeWidth,
    StrokeStyle? strokeStyle,
    Color? fillColor,
    double? fillOpacity,
    bool? isClosed,
    String? text,
    TextStyle? textStyle,
    TextAlign? textAlign,
    double? rotation,
    bool? visible,
    bool? selected,
    int? detailLevel,
    String? layerId,
  }) {
    return MapSymbol(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      position: position ?? this.position,
      points: points ?? this.points,
      size: size ?? this.size,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      fillColor: fillColor ?? this.fillColor,
      fillOpacity: fillOpacity ?? this.fillOpacity,
      isClosed: isClosed ?? this.isClosed,
      text: text ?? this.text,
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      rotation: rotation ?? this.rotation,
      visible: visible ?? this.visible,
      selected: selected ?? this.selected,
      detailLevel: detailLevel ?? this.detailLevel,
      layerId: layerId ?? this.layerId,
    );
  }

  // ============================================================================
  // PROPRIÉTÉS CALCULÉES
  // ============================================================================

  /// Rectangle englobant du symbole
  Rect get boundingBox {
    switch (type) {
      case MapSymbolType.point:
        final halfSize = size / 2;
        return Rect.fromCircle(
          center: position,
          radius: halfSize,
        );
      case MapSymbolType.line:
        if (points.isEmpty) return Rect.zero;
        if (points.length == 1) {
          return Rect.fromCircle(
            center: points.first,
            radius: strokeWidth / 2,
          );
        }
        return _computeLineBoundingBox();
      case MapSymbolType.area:
        if (points.isEmpty) return Rect.zero;
        return _computePolygonBoundingBox();
      case MapSymbolType.text:
        // Estimation de la taille du texte (simplifiée)
        final textLength = text.length * textStyle.fontSize! * 0.6;
        final textHeight = textStyle.fontSize! * 1.2;
        return Rect.fromLTWH(
          position.dx - textLength / 2,
          position.dy - textHeight / 2,
          textLength,
          textHeight,
        );
    }
  }

  /// Calcule le rectangle englobant pour une ligne
  Rect _computeLineBoundingBox() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = -double.infinity;
    double maxY = -double.infinity;
    
    for (final point in points) {
      minX = math.min(minX, point.dx);
      minY = math.min(minY, point.dy);
      

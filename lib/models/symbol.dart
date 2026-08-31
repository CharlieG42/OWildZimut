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
      maxX = math.max(maxX, point.dx);
      maxY = math.max(maxY, point.dy);
    }
    
    // Ajouter la moitié de la largeur de la ligne
    final padding = strokeWidth / 2;
    return Rect.fromLTRB(
      minX - padding,
      minY - padding,
      maxX + padding,
      maxY + padding,
    );
  }

  /// Calcule le rectangle englobant pour un polygone
  Rect _computePolygonBoundingBox() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = -double.infinity;
    double maxY = -double.infinity;
    
    for (final point in points) {
      minX = math.min(minX, point.dx);
      minY = math.min(minY, point.dy);
      maxX = math.max(maxX, point.dx);
      maxY = math.max(maxY, point.dy);
    }
    
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Vérifie si un point est à l'intérieur du symbole
  bool contains(Offset point) {
    switch (type) {
      case MapSymbolType.point:
        return (point - position).distance <= size / 2;
      case MapSymbolType.line:
        return _containsLine(point);
      case MapSymbolType.area:
        return pointInPolygon(point, points);
      case MapSymbolType.text:
        return boundingBox.contains(point);
    }
  }

  /// Vérifie si un point est sur une ligne
  bool _containsLine(Offset point) {
    if (points.isEmpty) return false;
    if (points.length == 1) {
      return (point - points.first).distance <= strokeWidth / 2;
    }
    
    for (var i = 0; i < points.length - 1; i++) {
      if (_pointOnSegment(point, points[i], points[i + 1])) {
        return true;
      }
    }
    return false;
  }

  /// Vérifie si un point est sur un segment de ligne
  bool _pointOnSegment(Offset point, Offset p1, Offset p2) {
    final lineLength = (p2 - p1).distance;
    if (lineLength == 0) return false;
    
    // Produit scalaire pour projeter le point sur la ligne
    final t = ((point.dx - p1.dx) * (p2.dx - p1.dx) + (point.dy - p1.dy) * (p2.dy - p1.dy)) / 
             (lineLength * lineLength);
    
    if (t < 0 || t > 1) return false;
    
    final projection = Offset(
      p1.dx + t * (p2.dx - p1.dx),
      p1.dy + t * (p2.dy - p1.dy),
    );
    
    return (point - projection).distance <= strokeWidth / 2;
  }

  // ============================================================================
  // ALGORITHMES GÉOMÉTRIQUES
  // ============================================================================

  /// Vérifie si un point est à l'intérieur d'un polygone
  ///
  /// Utilise l'algorithme du rayon (ray casting algorithm)
  /// [point] : Le point à tester
  /// [polygon] : La liste de points du polygone (doit être fermé)
  /// Retourne vrai si le point est à l'intérieur du polygone
  static bool pointInPolygon(Offset point, List<Offset> polygon) {
    if (polygon.isEmpty) return false;
    
    bool inside = false;
    int n = polygon.length;
    
    for (int i = 0, j = n - 1; i < n; j = i++) {
      final xi = polygon[i].dx;
      final yi = polygon[i].dy;
      final xj = polygon[j].dx;
      final yj = polygon[j].dy;
      
      // Vérifie si le rayon horizontal intersecte le segment
      bool intersect = ((yi > point.dy) != (yj > point.dy)) &&
          (point.dx < (xj - xi) * (point.dy - yi) / (yj - yi) + xi);
      
      if (intersect) {
        inside = !inside;
      }
    }
    
    return inside;
  }

  /// Calcule le centre d'un polygone
  static Offset computePolygonCenter(List<Offset> polygon) {
    if (polygon.isEmpty) return Offset.zero;
    
    double sumX = 0;
    double sumY = 0;
    
    for (final point in polygon) {
      sumX += point.dx;
      sumY += point.dy;
    }
    
    return Offset(sumX / polygon.length, sumY / polygon.length);
  }

  /// Calcule l'aire d'un polygone
  static double computePolygonArea(List<Offset> polygon) {
    if (polygon.length < 3) return 0;
    
    double area = 0;
    int n = polygon.length;
    
    for (int i = 0, j = n - 1; i < n; j = i++) {
      final xi = polygon[i].dx;
      final yi = polygon[i].dy;
      final xj = polygon[j].dx;
      final yj = polygon[j].dy;
      
      area += (xi * yj) - (xj * yi);
    }
    
    return area.abs() / 2;
  }

  /// Calcule la longueur d'une ligne
  static double computeLineLength(List<Offset> points) {
    if (points.length < 2) return 0;
    
    double length = 0;
    for (var i = 0; i < points.length - 1; i++) {
      length += (points[i + 1] - points[i]).distance;
    }
    return length;
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
      'position': {'x': position.dx, 'y': position.dy},
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'size': size,
      'stroke_color': strokeColor.value.toRadixString(16),
      'stroke_width': strokeWidth,
      'stroke_style': strokeStyle.name,
      'fill_color': fillColor.value.toRadixString(16),
      'fill_opacity': fillOpacity,
      'is_closed': isClosed,
      'text': text,
      'text_style': {
        'color': textStyle.color?.value.toRadixString(16) ?? '0xFF000000',
        'font_size': textStyle.fontSize,
        'font_weight': textStyle.fontWeight?.name ?? 'normal',
        'font_style': textStyle.fontStyle?.name ?? 'normal',
      },
      'text_align': textAlign.name,
      'rotation': rotation,
      'visible': visible,
      'selected': selected,
      'detail_level': detailLevel,
      'layer_id': layerId,
    };
  }

  /// Charge depuis JSON
  factory MapSymbol.fromJson(Map<String, dynamic> json) {
    final positionData = json['position'] as Map<String, dynamic>? ?? {};
    final pointsData = json['points'] as List<dynamic>? ?? [];
    final textStyleData = json['text_style'] as Map<String, dynamic>? ?? {};
    
    final points = pointsData
        .map((p) => Offset(
              (p['x'] as num?)?.toDouble() ?? 0.0,
              (p['y'] as num?)?.toDouble() ?? 0.0,
            ))
        .toList();
    
    final textStyle = TextStyle(
      color: Color(int.parse(textStyleData['color'] as String? ?? '0xFF000000')),
      fontSize: (textStyleData['font_size'] as num?)?.toDouble() ?? 2.5,
      fontWeight: _parseFontWeight(textStyleData['font_weight'] as String? ?? 'normal'),
      fontStyle: _parseFontStyle(textStyleData['font_style'] as String? ?? 'normal'),
    );
    
    return MapSymbol(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: MapSymbolType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MapSymbolType.point,
      ),
      position: Offset(
        (positionData['x'] as num?)?.toDouble() ?? 0.0,
        (positionData['y'] as num?)?.toDouble() ?? 0.0,
      ),
      points: points,
      size: (json['size'] as num?)?.toDouble() ?? 1.0,
      strokeColor: Color(int.parse(json['stroke_color'] as String? ?? '0xFF000000')),
      strokeWidth: (json['stroke_width'] as num?)?.toDouble() ?? 0.35,
      strokeStyle: StrokeStyle.values.firstWhere(
        (e) => e.name == json['stroke_style'],
        orElse: () => StrokeStyle.solid,
      ),
      fillColor: Color(int.parse(json['fill_color'] as String? ?? '0xFFFFFFFF')),
      fillOpacity: (json['fill_opacity'] as num?)?.toDouble() ?? 1.0,
      isClosed: json['is_closed'] as bool? ?? false,
      text: json['text'] as String? ?? '',
      textStyle: textStyle,
      textAlign: TextAlign.values.firstWhere(
        (e) => e.name == json['text_align'],
        orElse: () => TextAlign.center,
      ),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      visible: json['visible'] as bool? ?? true,
      selected: json['selected'] as bool? ?? false,
      detailLevel: json['detail_level'] as int? ?? 0,
      layerId: json['layer_id'] as String? ?? '',
    );
  }

  static FontWeight _parseFontWeight(String name) {
    switch (name) {
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  static FontStyle _parseFontStyle(String name) {
    switch (name) {
      case 'italic':
        return FontStyle.italic;
      default:
        return FontStyle.normal;
    }
  }

  // ============================================================================
  // SÉRIALISATION POUR OMAP
  // ============================================================================

  /// Convertit en Map pour l'export OMAP
  Map<String, dynamic> toOmapMap() {
    return {
      '@Type': typeToOmapType(type),
      '@Id': id,
      if (name.isNotEmpty) '@Name': name,
      if (type == MapSymbolType.point) ..._pointToOmap(),
      if (type == MapSymbolType.line) ..._lineToOmap(),
      if (type == MapSymbolType.area) ..._areaToOmap(),
      if (type == MapSymbolType.text) ..._textToOmap(),
    };
  }

  /// Convertit le type de symbole en type OMAP
  static String typeToOmapType(MapSymbolType type) {
    switch (type) {
      case MapSymbolType.point:
        return 'Point';
      case MapSymbolType.line:
        return 'Line';
      case MapSymbolType.area:
        return 'Path';
      case MapSymbolType.text:
        return 'Text';
    }
  }

  /// Convertit un point en format OMAP
  Map<String, dynamic> _pointToOmap() {
    return {
      '@X': position.dx.toStringAsFixed(3),
      '@Y': position.dy.toStringAsFixed(3),
      '@Symbol': _getOmapSymbolCode(),
    };
  }

  /// Convertit une ligne en format OMAP
  Map<String, dynamic> _lineToOmap() {
    final map = <String, dynamic>{
      '@Symbol': _getOmapSymbolCode(),
      'Pt': points.map((p) => {
        '@X': p.dx.toStringAsFixed(3),
        '@Y': p.dy.toStringAsFixed(3),
      }).toList(),
    };
    return map;
  }

  /// Convertit une surface en format OMAP
  Map<String, dynamic> _areaToOmap() {
    final map = <String, dynamic>{
      '@Symbol': _getOmapSymbolCode(),
      '@Closed': isClosed ? '1' : '0',
      'Pt': points.map((p) => {
        '@X': p.dx.toStringAsFixed(3),
        '@Y': p.dy.toStringAsFixed(3),
      }).toList(),
    };
    return map;
  }

  /// Convertit du texte en format OMAP
  Map<String, dynamic> _textToOmap() {
    return {
      '@X': position.dx.toStringAsFixed(3),
      '@Y': position.dy.toStringAsFixed(3),
      '@Symbol': _getOmapSymbolCode(),
      '@Text': text,
      '@Font': 'Arial',
      '@Size': textStyle.fontSize?.toStringAsFixed(1) ?? '10',
      '@Bold': textStyle.fontWeight == FontWeight.bold ? '1' : '0',
      '@Italic': textStyle.fontStyle == FontStyle.italic ? '1' : '0',
    };
  }

  /// Récupère le code du symbole OMAP (simplifié)
  String _getOmapSymbolCode() {
    // Codes IOF standard (simplifiés)
    switch (type) {
      case MapSymbolType.point:
        return name.isNotEmpty ? name : '101.0'; // Roche par défaut
      case MapSymbolType.line:
        return name.isNotEmpty ? name : '201.0'; // Chemin par défaut
      case MapSymbolType.area:
        return name.isNotEmpty ? name : '301.0'; // Forêt par défaut
      case MapSymbolType.text:
        return name.isNotEmpty ? name : '0.0';
    }
  }

  @override
  String toString() {
    return 'MapSymbol(id: $id, name: $name, type: $type, position: $position, '
        'points: ${points.length}, size: $size, layer: $layerId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapSymbol &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.position == position &&
        other.points == points &&
        other.size == size &&
        other.strokeColor == strokeColor &&
        other.strokeWidth == strokeWidth &&
        other.strokeStyle == strokeStyle &&
        other.fillColor == fillColor &&
        other.fillOpacity == fillOpacity &&
        other.isClosed == isClosed &&
        other.text == text &&
        other.textStyle == textStyle &&
        other.textAlign == textAlign &&
        other.rotation == rotation &&
        other.visible == visible &&
        other.selected == selected &&
        other.detailLevel == detailLevel &&
        other.layerId == layerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        position.hashCode ^
        points.hashCode ^
        size.hashCode ^
        strokeColor.hashCode ^
        strokeWidth.hashCode ^
        strokeStyle.hashCode ^
        fillColor.hashCode ^
        fillOpacity.hashCode ^
        isClosed.hashCode ^
        text.hashCode ^
        textStyle.hashCode ^
        textAlign.hashCode ^
        rotation.hashCode ^
        visible.hashCode ^
        selected.hashCode ^
        detailLevel.hashCode ^
        layerId.hashCode;
  }
}

/// Style de ligne
enum StrokeStyle {
  solid,
  dashed,
  dotted,
  dashDot,
  dashDotDot,
}

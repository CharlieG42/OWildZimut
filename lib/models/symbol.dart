import 'package:flutter/material.dart';

/// Type de symbole IOF (International Orienteering Federation)
enum MapSymbolType {
  /// Symbole ponctuel (ex: rocher, arbre isolé)
  point,
  
  /// Symbole linéaire (ex: chemin, rivière)
  line,
  
  /// Symbole de surface (ex: forêt, lac)
  area,
  
  /// Symbole de texte
  text,
}

/// Symbole de carte d'orientation
///
/// Un symbole représente un élément géométrique sur la carte avec des
/// propriétés comme la position, la couleur, la taille, etc.
class MapSymbol {
  /// Identifiant unique du symbole
  final String id;
  
  /// Type de symbole (point, ligne, surface, texte)
  final MapSymbolType type;
  
  /// Code IOF (ex: "701.1" pour forêt blanche)
  final String? iofCode;
  
  /// Code personnalisé (si différent du code IOF)
  final String? code;
  
  /// Nom du symbole
  final String name;
  
  /// Description du symbole
  final String description;
  
  /// Position principale (pour les points, ou premier point pour les lignes/surfaces)
  final Offset position;
  
  /// Liste de tous les points (pour les lignes et surfaces)
  final List<Offset> points;
  
  /// Couleur principale
  final Color color;
  
  /// Couleur de contour (pour les surfaces)
  final Color? strokeColor;
  
  /// Couleur de remplissage (pour les surfaces)
  final Color? fillColor;
  
  /// Épaisseur de la ligne (pour les lignes et contours)
  final double strokeWidth;
  
  /// Taille (pour les points, diamètre en pixels)
  final double size;
  
  /// Rotation en radians
  final double rotation;
  
  /// Vrai si la surface est fermée (dernier point = premier point)
  final bool isClosed;
  
  /// Opacité (0.0 - 1.0)
  final double opacity;
  
  /// Icône encodée en base64 (pour les symboles ponctuels)
  final String? iconBase64;
  
  /// Texte (pour les symboles de texte)
  final String? text;
  
  /// Style de police (pour les symboles de texte)
  final String? fontFamily;
  
  /// Taille de la police (pour les symboles de texte)
  final double? fontSize;
  
  /// Alignement horizontal du texte
  final TextAlign? textAlign;

  const MapSymbol({
    required this.id,
    required this.type,
    this.iofCode,
    this.code,
    this.name = '',
    this.description = '',
    this.position = Offset.zero,
    this.points = const [],
    this.color = Colors.black,
    this.strokeColor,
    this.fillColor,
    this.strokeWidth = 1.0,
    this.size = 5.0,
    this.rotation = 0.0,
    this.isClosed = false,
    this.opacity = 1.0,
    this.iconBase64,
    this.text,
    this.fontFamily,
    this.fontSize,
    this.textAlign,
  });

  /// Crée un symbole ponctuel
  factory MapSymbol.point({
    required String id,
    Offset? position,
    Color? color,
    double? size,
    String? iofCode,
    String? name,
    String? description,
    double? rotation,
    String? iconBase64,
  }) {
    return MapSymbol(
      id: id,
      type: MapSymbolType.point,
      iofCode: iofCode,
      name: name ?? 'Point',
      description: description ?? '',
      position: position ?? Offset.zero,
      points: position != null ? [position] : [],
      color: color ?? Colors.black,
      size: size ?? 5.0,
      rotation: rotation ?? 0.0,
      iconBase64: iconBase64,
    );
  }

  /// Crée un symbole linéaire
  factory MapSymbol.line({
    required String id,
    required List<Offset> points,
    Color? color,
    double? strokeWidth,
    String? iofCode,
    String? name,
    String? description,
  }) {
    return MapSymbol(
      id: id,
      type: MapSymbolType.line,
      iofCode: iofCode,
      name: name ?? 'Ligne',
      description: description ?? '',
      position: points.isNotEmpty ? points.first : Offset.zero,
      points: points,
      color: color ?? Colors.black,
      strokeColor: color,
      strokeWidth: strokeWidth ?? 2.0,
      isClosed: false,
    );
  }

  /// Crée un symbole de surface (polygone)
  factory MapSymbol.area({
    required String id,
    required List<Offset> points,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    String? iofCode,
    String? name,
    String? description,
    bool? isClosed,
  }) {
    return MapSymbol(
      id: id,
      type: MapSymbolType.area,
      iofCode: iofCode,
      name: name ?? 'Surface',
      description: description ?? '',
      position: points.isNotEmpty ? points.first : Offset.zero,
      points: points,
      color: fillColor ?? Colors.blue.withOpacity(0.3),
      fillColor: fillColor,
      strokeColor: strokeColor ?? Colors.blue,
      strokeWidth: strokeWidth ?? 1.0,
      isClosed: isClosed ?? (points.length > 1 && points.first == points.last),
    );
  }

  /// Crée un symbole de texte
  factory MapSymbol.text({
    required String id,
    required String text,
    Offset? position,
    Color? color,
    double? fontSize,
    String? fontFamily,
    TextAlign? textAlign,
    String? iofCode,
    String? name,
    String? description,
  }) {
    return MapSymbol(
      id: id,
      type: MapSymbolType.text,
      iofCode: iofCode,
      name: name ?? 'Texte',
      description: description ?? '',
      position: position ?? Offset.zero,
      points: position != null ? [position] : [],
      color: color ?? Colors.black,
      text: text,
      fontSize: fontSize ?? 12.0,
      fontFamily: fontFamily,
      textAlign: textAlign,
    );
  }

  /// Crée une copie avec des modifications
  MapSymbol copyWith({
    String? id,
    MapSymbolType? type,
    String? iofCode,
    String? code,
    String? name,
    String? description,
    Offset? position,
    List<Offset>? points,
    Color? color,
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    double? size,
    double? rotation,
    bool? isClosed,
    double? opacity,
    String? iconBase64,
    String? text,
    String? fontFamily,
    double? fontSize,
    TextAlign? textAlign,
  }) {
    return MapSymbol(
      id: id ?? this.id,
      type: type ?? this.type,
      iofCode: iofCode ?? this.iofCode,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      position: position ?? this.position,
      points: points ?? this.points,
      color: color ?? this.color,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      isClosed: isClosed ?? this.isClosed,
      opacity: opacity ?? this.opacity,
      iconBase64: iconBase64 ?? this.iconBase64,
      text: text ?? this.text,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  /// Rectangle englobant (bounding box) du symbole
  Rect get boundingBox {
    if (points.isEmpty) {
      return Rect.fromCircle(center: position, radius: size / 2);
    }
    
    if (points.length == 1) {
      return Rect.fromCircle(center: points.first, radius: size / 2);
    }
    
    // Calculer le rectangle englobant de tous les points
    double minX = points.first.dx;
    double minY = points.first.dy;
    double maxX = points.first.dx;
    double maxY = points.first.dy;
    
    for (final point in points) {
      minX = point.dx < minX ? point.dx : minX;
      minY = point.dy < minY ? point.dy : minY;
      maxX = point.dx > maxX ? point.dx : maxX;
      maxY = point.dy > maxY ? point.dy : maxY;
    }
    
    // Ajouter une marge pour les symboles avec taille
    final margin = size / 2;
    return Rect.fromLTRB(
      minX - margin,
      minY - margin,
      maxX + margin,
      maxY + margin,
    );
  }

  /// Centre géométrique du symbole
  Offset get center {
    if (points.isEmpty) return position;
    
    double sumX = 0;
    double sumY = 0;
    for (final point in points) {
      sumX += point.dx;
      sumY += point.dy;
    }
    return Offset(sumX / points.length, sumY / points.length);
  }

  /// Vérifie si le symbole contient un point
  bool contains(Offset point) {
    switch (type) {
      case MapSymbolType.point:
        return (point - position).distance <= size / 2;
      case MapSymbolType.line:
        return _pointOnLine(point, points, strokeWidth + 2);
      case MapSymbolType.area:
        return _pointInPolygon(point, points);
      case MapSymbolType.text:
        return boundingBox.contains(point);
    }
  }

  /// Vérifie si un point est sur une ligne (avec tolérance)
  static bool _pointOnLine(Offset point, List<Offset> linePoints, double tolerance) {
    if (linePoints.length < 2) return false;
    
    for (var i = 0; i < linePoints.length - 1; i++) {
      final p1 = linePoints[i];
      final p2 = linePoints[i + 1];
      
      if (_pointOnSegment(point, p1, p2, tolerance)) {
        return true;
      }
    }
    return false;
  }

  /// Vérifie si un point est sur un segment de ligne
  static bool _pointOnSegment(Offset point, Offset p1, Offset p2, double tolerance) {
    // Calculer la distance du point à la ligne
    final lineLength = (p2 - p1).distance;
    if (lineLength == 0) return false;
    
    final t = ((point - p1).dot(p2 - p1)) / (lineLength * lineLength);
    
    // Projeter le point sur la ligne
    final projection = p1 + (p2 - p1) * t.clamp(0, 1);
    
    return (point - projection).distance <= tolerance;
  }

  /// Vérifie si un point est à l'intérieur d'un polygone
  /// (algorithme du rayon)
  static bool _pointInPolygon(Offset point, List<Offset> polygonPoints) {
    if (polygonPoints.length < 3) return false;
    
    bool inside = false;
    for (var i = 0, j = polygonPoints.length - 1; i < polygonPoints.length; j = i++) {
      final xi = polygonPoints[i].dx;
      final yi = polygonPoints[i].dy;
      final xj = polygonPoints[j].dx;
      final yj = polygonPoints[j].dy;
      
      final intersect = ((yi > point.dy) != (yj > point.dy)) &&
          (point.dx < (xj - xi) * (point.dy - yi) / (yj - yi) + xi);
      
      if (intersect) inside = !inside;
    }
    return inside;
  }

  /// Exporte en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      if (iofCode != null) 'iof_code': iofCode,
      if (code != null) 'code': code,
      'name': name,
      'description': description,
      'position': {'x': position.dx, 'y': position.dy},
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'color': color.toARGB32().toRadixString(16),
      if (strokeColor != null) 'stroke_color': strokeColor!.toARGB32().toRadixString(16),
      if (fillColor != null) 'fill_color': fillColor!.toARGB32().toRadixString(16),
      'stroke_width': strokeWidth,
      'size': size,
      'rotation': rotation,
      'is_closed': isClosed,
      'opacity': opacity,
      if (iconBase64 != null) 'icon_base64': iconBase64,
      if (text != null) 'text': text,
      if (fontFamily != null) 'font_family': fontFamily,
      if (fontSize != null) 'font_size': fontSize,
      if (textAlign != null) 'text_align': textAlign!.index,
    };
  }

  /// Charge depuis JSON
  factory MapSymbol.fromJson(Map<String, dynamic> json) {
    final pointsData = json['points'] as List? ?? [];
    final points = pointsData.map((p) => 
      Offset(
        (p['x'] as num?)?.toDouble() ?? 0.0,
        (p['y'] as num?)?.toDouble() ?? 0.0,
      )
    ).toList();
    
    return MapSymbol(
      id: json['id'] as String? ?? '',
      type: MapSymbolType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MapSymbolType.point,
      ),
      iofCode: json['iof_code'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      position: Offset(
        (json['position']?['x'] as num?)?.toDouble() ?? 0.0,
        (json['position']?['y'] as num?)?.toDouble() ?? 0.0,
      ),
      points: points,
      color: Color(int.parse(json['color'] as String? ?? '0xFF000000')),
      strokeColor: json['stroke_color'] != null
          ? Color(int.parse(json['stroke_color'] as String))
          : null,
      fillColor: json['fill_color'] != null
          ? Color(int.parse(json['fill_color'] as String))
          : null,
      strokeWidth: (json['stroke_width'] as num?)?.toDouble() ?? 1.0,
      size: (json['size'] as num?)?.toDouble() ?? 5.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      isClosed: json['is_closed'] as bool? ?? false,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      iconBase64: json['icon_base64'] as String?,
      text: json['text'] as String?,
      fontFamily: json['font_family'] as String?,
      fontSize: (json['font_size'] as num?)?.toDouble(),
      textAlign: json['text_align'] != null
          ? TextAlign.values[json['text_align'] as int]
          : null,
    );
  }

  @override
  String toString() {
    return 'MapSymbol(id: $id, type: $type, iofCode: $iofCode, name: $name, '
        'position: $position, points: ${points.length}, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapSymbol &&
        other.id == id &&
        other.type == type &&
        other.iofCode == iofCode &&
        other.code == code &&
        other.name == name &&
        other.description == description &&
        other.position == position &&
        other.points == points &&
        other.color == color &&
        other.strokeColor == strokeColor &&
        other.fillColor == fillColor &&
        other.strokeWidth == strokeWidth &&
        other.size == size &&
        other.rotation == rotation &&
        other.isClosed == isClosed &&
        other.opacity == opacity &&
        other.iconBase64 == iconBase64 &&
        other.text == text &&
        other.fontFamily == fontFamily &&
        other.fontSize == fontSize &&
        other.textAlign == textAlign;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        iofCode.hashCode ^
        code.hashCode ^
        name.hashCode ^
        description.hashCode ^
        position.hashCode ^
        points.hashCode ^
        color.hashCode ^
        strokeColor.hashCode ^
        fillColor.hashCode ^
        strokeWidth.hashCode ^
        size.hashCode ^
        rotation.hashCode ^
        isClosed.hashCode ^
        opacity.hashCode ^
        iconBase64.hashCode ^
        text.hashCode ^
        fontFamily.hashCode ^
        fontSize.hashCode ^
        textAlign.hashCode;
  }
}

/// Extension pour créer des symboles facilement
extension MapSymbolExtensions on MapSymbol {
  /// Crée un symbole avec une position mise à jour
  MapSymbol withPosition(Offset newPosition) {
    return copyWith(
      position: newPosition,
      points: type == MapSymbolType.point ? [newPosition] : points,
    );
  }

  /// Crée un symbole avec une couleur mise à jour
  MapSymbol withColor(Color newColor) {
    return copyWith(color: newColor);
  }

  /// Crée un symbole avec une taille mise à jour
  MapSymbol withSize(double newSize) {
    return copyWith(size: newSize);
  }

  /// Crée un symbole avec une rotation mise à jour
  MapSymbol withRotation(double newRotation) {
    return copyWith(rotation: newRotation);
  }
}

// ============================================
// IOF Symbols - genere automatiquement, NE PAS EDITER A LA MAIN.
// Source : ISOM 2017-2
// Regenerer avec generate_iof_symbols.py si le fichier .omap modele change.
// Contient 191 symboles et 35 couleurs IOF.
// ============================================

import 'package:flutter/material.dart';
import 'symbol.dart' as symbol_model;

/// Une couleur du jeu de symboles IOF (valeurs CMJN + RVB precalcule).
class IOFColorV3 {
  final int priority;
  final String name;
  final Color color;
  final double c;
  final double m;
  final double y;
  final double k;
  final double opacity;

  const IOFColorV3(this.priority, this.name, this.color, this.c, this.m, this.y, this.k, this.opacity);

  @override
  String toString() => 'IOFColorV3(priority: ${priority}, name: ${name})';
}

/// Palette des couleurs du jeu de symboles IOF (index = priorite 0..N-1).
class IOFColorsV3 {
  static const List<IOFColorV3> colors = [
    IOFColorV3(0, r'Purple for course overprint', Color(0xFFA626FF), 0.35, 0.85, 0.0, 0.0, 1.0),
    IOFColorV3(1, r'White for course overprint', Color(0xFFFFFFFF), 0.0, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(2, r'Black 100%', Color(0xFF000000), 0.0, 0.0, 0.0, 1.0, 1.0),
    IOFColorV3(3, r'Green 100%', Color(0xFF3DFF17), 0.76, 0.0, 0.91, 0.0, 1.0),
    IOFColorV3(4, r'White for railway', Color(0xFFFFFFFF), 0.0, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(5, r'Blue 100%', Color(0xFF00FFFF), 1.0, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(6, r'Brown 100%', Color(0xFFD15C00), 0.0, 0.56, 1.0, 0.18, 1.0),
    IOFColorV3(7, r'Purple for track symbols', Color(0xFFA626FF), 0.35, 0.85, 0.0, 0.0, 1.0),
    IOFColorV3(8, r'Black below purple for track symbols', Color(0xFF000000), 0.0, 0.0, 0.0, 1.0, 1.0),
    IOFColorV3(9, r'Black 65%', Color(0xFF595959), 0.0, 0.0, 0.0, 0.65, 1.0),
    IOFColorV3(10, r'Black 20%', Color(0xFFCCCCCC), 0.0, 0.0, 0.0, 0.2, 1.0),
    IOFColorV3(11, r'Upper brown 50%', Color(0xFFE8AD80), 0.0, 0.28, 0.5, 0.09, 1.0),
    IOFColorV3(12, r'Black below upper brown 50%', Color(0xFF000000), 0.0, 0.0, 0.0, 1.0, 1.0),
    IOFColorV3(13, r'Lower brown 50%', Color(0xFFE8AD80), 0.0, 0.28, 0.5, 0.09, 1.0),
    IOFColorV3(14, r'Black below lower brown 50%', Color(0xFF000000), 0.0, 0.0, 0.0, 1.0, 1.0),
    IOFColorV3(15, r'Blue 100% for area features', Color(0xFF00FFFF), 1.0, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(16, r'Blue 70%', Color(0xFF4CFFFF), 0.7, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(17, r'Blue 50%', Color(0xFF80FFFF), 0.5, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(18, r'OpenOrienteering Orange', Color(0xFFE87F1B), 0.0, 0.474, 0.895, 0.09, 1.0),
    IOFColorV3(19, r'Yellow 100% for narrow ride', Color(0xFFFFBA36), 0.0, 0.27, 0.79, 0.0, 1.0),
    IOFColorV3(20, r'Green 60% for narrow ride', Color(0xFF8BFF74), 0.456, 0.0, 0.546, 0.0, 1.0),
    IOFColorV3(21, r'Green 30% for narrow ride', Color(0xFFC5FFB9), 0.228, 0.0, 0.273, 0.0, 1.0),
    IOFColorV3(22, r'White over green', Color(0xFFFFFFFF), 0.0, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(23, r'Yellow 100%/Green 50%', Color(0xFF9EBA1D), 0.38, 0.27, 0.886, 0.0, 1.0),
    IOFColorV3(24, r'Black 25% (Grey)', Color(0xFFBFBFBF), 0.0, 0.0, 0.0, 0.25, 1.0),
    IOFColorV3(25, r'Green 100%/Black 50%', Color(0xFF1F800B), 0.76, 0.0, 0.91, 0.5, 1.0),
    IOFColorV3(26, r'Green 100% for area features', Color(0xFF3DFF17), 0.76, 0.0, 0.91, 0.0, 1.0),
    IOFColorV3(27, r'Green 60%', Color(0xFF8BFF74), 0.456, 0.0, 0.546, 0.0, 1.0),
    IOFColorV3(28, r'Green 30%', Color(0xFFC5FFB9), 0.228, 0.0, 0.273, 0.0, 1.0),
    IOFColorV3(29, r'Green 100% for undergrowth', Color(0xFF3DFF17), 0.76, 0.0, 0.91, 0.0, 1.0),
    IOFColorV3(30, r'White over yellow', Color(0xFFFFFFFF), 0.0, 0.0, 0.0, 0.0, 1.0),
    IOFColorV3(31, r'Black for open land', Color(0xFF000000), 0.0, 0.0, 0.0, 1.0, 1.0),
    IOFColorV3(32, r'Yellow', Color(0xFFFFBA36), 0.0, 0.27, 0.79, 0.0, 1.0),
    IOFColorV3(33, r'Yellow 100% for area features', Color(0xFFFFBA36), 0.0, 0.27, 0.79, 0.0, 1.0),
    IOFColorV3(34, r'Yellow 50%', Color(0xFFFFDD9A), 0.0, 0.135, 0.395, 0.0, 1.0),
  ];

  static IOFColorV3? getByPriority(int priority) {
    if (priority >= 0 && priority < colors.length) return colors[priority];
    return null;
  }

  static Color getColorByPriority(int priority) => getByPriority(priority)?.color ?? Colors.black;
}

/// Geometrie (style graphique) d'un symbole IOF ou d'un sous-element.
class IOFSymbolGeometryV3 {
  final String symbolType; // 'point' | 'line' | 'area' | 'text'
  final Map<String, dynamic> properties;

  const IOFSymbolGeometryV3(this.symbolType, this.properties);

  factory IOFSymbolGeometryV3.point({
    required int? innerRadius,
    required String? innerColor,
    required String? outerColor,
    bool rotatable = false,
    List<IOFSymbolElementV3>? elements,
  }) {
    return IOFSymbolGeometryV3('point', {
      'inner_radius': innerRadius,
      'inner_color': innerColor,
      'outer_color': outerColor,
      'rotatable': rotatable,
      'elements': elements ?? const <IOFSymbolElementV3>[],
    });
  }

  factory IOFSymbolGeometryV3.line({
    required String? color,
    required int? lineWidth,
    bool dashed = false,
    int? dashLength,
    int? breakLength,
    String? joinStyle,
    String? capStyle,
  }) {
    return IOFSymbolGeometryV3('line', {
      'color': color,
      'line_width': lineWidth,
      'dashed': dashed,
      'dash_length': dashLength,
      'break_length': breakLength,
      'join_style': joinStyle,
      'cap_style': capStyle,
    });
  }

  factory IOFSymbolGeometryV3.area({required String? innerColor, bool rotatable = false}) {
    return IOFSymbolGeometryV3('area', {'inner_color': innerColor, 'rotatable': rotatable});
  }

  factory IOFSymbolGeometryV3.text({required String? color, required int? fontSize, bool rotatable = false}) {
    return IOFSymbolGeometryV3('text', {'color': color, 'font_size': fontSize, 'rotatable': rotatable});
  }

  String? get colorReference {
    if (symbolType == 'line' || symbolType == 'text') return properties['color']?.toString();
    if (symbolType == 'point' || symbolType == 'area') return properties['inner_color']?.toString();
    return null;
  }

  /// Couleur resolue (transparente si non definie, ex. "-1").
  Color getColor() {
    final colorRef = colorReference;
    if (colorRef == null || colorRef == '-1') return Colors.transparent;
    return IOFColorsV3.getColorByPriority(int.tryParse(colorRef) ?? 0);
  }

  /// Epaisseur de ligne en mm (les unites OMAP sont en 0.001 mm).
  double? get lineWidthMm {
    if (symbolType != 'line') return null;
    final w = properties['line_width'];
    return w == null ? null : (w as int) / 1000.0;
  }

  /// Rayon du point central en mm.
  double? get pointRadiusMm {
    if (symbolType != 'point') return null;
    final r = properties['inner_radius'];
    return r == null ? null : (r as int) / 1000.0;
  }

  bool get isDashed => properties['dashed'] == true;
  double? get dashLengthMm {
    final v = properties['dash_length'];
    return v == null ? null : (v as int) / 1000.0;
  }
  double? get breakLengthMm {
    final v = properties['break_length'];
    return v == null ? null : (v as int) / 1000.0;
  }

  /// Sous-elements graphiques (uniquement pour un point_symbol composite).
  List<IOFSymbolElementV3> get elements =>
      (properties['elements'] as List<IOFSymbolElementV3>?) ?? const [];

  @override
  String toString() => 'IOFSymbolGeometryV3(type: ${symbolType})';
}

/// Un sous-element d'un symbole ponctuel composite (ex. les deux tirets
/// du symbole "marais", ou les cercles concentriques d'un point de
/// controle). [coords] est le trace local (en mm, relatif au centre du
/// symbole) dessine avec le style [symbol] ; [pattern] est la liste des
/// positions ou ce trace est repete (le plus souvent une seule, (0,0)).
class IOFSymbolElementV3 {
  final IOFSymbolGeometryV3 symbol;
  final List<Offset> coords;
  final List<Offset> pattern;

  const IOFSymbolElementV3({required this.symbol, this.coords = const [], this.pattern = const [Offset.zero]});
}

/// Un symbole IOF complet (issu de la specification ISOM/ISSprOM).
class IOFSymbolV3 {
  final String code;
  final String name;
  final String description;
  final int type; // 1=point, 2=ligne, 4=surface, 8=texte
  final String? id;
  final bool isHidden;
  final IOFSymbolGeometryV3? geometry;

  const IOFSymbolV3({
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    this.id,
    this.isHidden = false,
    this.geometry,
  });

  bool get isPoint => type == 1;
  bool get isLine => type == 2;
  bool get isArea => type == 4;
  bool get isText => type == 8;

  /// Groupe ISOM (base sur la plage numerique du code), en anglais.
  String get category {
    if (_baseCode >= 100 && _baseCode <= 199) return 'Landforms';
    if (_baseCode >= 200 && _baseCode <= 299) return 'Rock and boulders';
    if (_baseCode >= 300 && _baseCode <= 399) return 'Water and marsh';
    if (_baseCode >= 400 && _baseCode <= 499) return 'Vegetation';
    if (_baseCode >= 500 && _baseCode <= 599) return 'Man-made features';
    if (_baseCode >= 600 && _baseCode <= 699) return 'Technical symbols';
    if (_baseCode >= 700 && _baseCode <= 799) return 'Course symbols';
    if (_baseCode >= 800 && _baseCode <= 899) return 'Course symbols';
    if (_baseCode >= 900 && _baseCode <= 999) return 'Other';
    return 'Other';
  }

  /// Groupe ISOM, libelle en francais (pour l'UI).
  String get categoryFr {
    if (_baseCode >= 100 && _baseCode <= 199) return 'Formes de terrain';
    if (_baseCode >= 200 && _baseCode <= 299) return 'Rochers et blocs';
    if (_baseCode >= 300 && _baseCode <= 399) return 'Eau et marais';
    if (_baseCode >= 400 && _baseCode <= 499) return 'Végétation';
    if (_baseCode >= 500 && _baseCode <= 599) return 'Aménagements';
    if (_baseCode >= 600 && _baseCode <= 699) return 'Symboles techniques';
    if (_baseCode >= 700 && _baseCode <= 799) return 'Symboles de parcours';
    if (_baseCode >= 800 && _baseCode <= 899) return 'Symboles de parcours';
    if (_baseCode >= 900 && _baseCode <= 999) return 'Autres';
    return 'Autres';
  }

  int get _baseCode => int.tryParse(code.split('.').first) ?? -1;

  /// Couleur declaree par le symbole (peut etre transparente : de
  /// nombreux symboles ponctuels composites n'ont pas de couleur au
  /// niveau racine, leur rendu vient uniquement de [geometry.elements]).
  Color get color => geometry?.getColor() ?? Colors.black;

  /// Couleur utilisable pour un apercu/UI : ne renvoie jamais transparent
  /// (retombe sur une teinte par categorie), pour eviter un symbole
  /// invisible dans le selecteur ou sur la carte.
  Color get displayColor {
    final c = color;
    if (c != Colors.transparent) return c;
    switch (category) {
      case 'Landforms': return const Color(0xFFD15C00);
      case 'Rock and boulders': return Colors.black;
      case 'Water and marsh': return const Color(0xFF00B0FF);
      case 'Vegetation': return const Color(0xFF3DAA17);
      case 'Man-made features': return Colors.black;
      default: return Colors.black87;
    }
  }

  /// Construit un [symbol_model.MapSymbol] pret a etre place sur la
  /// carte a partir de cette definition IOF.
  symbol_model.MapSymbol createMapSymbol({
    required String id,
    Offset position = Offset.zero,
    List<Offset>? points,
    double rotation = 0.0,
  }) {
    switch (type) {
      case 1:
        final diameter = (geometry?.pointRadiusMm ?? 0.5) * 2;
        return symbol_model.MapSymbol(
          id: id,
          type: symbol_model.MapSymbolType.point,
          iofCode: code,
          code: code,
          name: name,
          description: description,
          position: position,
          points: [position],
          color: displayColor,
          size: diameter > 0 ? diameter : 1.0,
          rotation: rotation,
        );
      case 2:
        final pts = points ?? [position, position + const Offset(10, 0)];
        return symbol_model.MapSymbol(
          id: id,
          type: symbol_model.MapSymbolType.line,
          iofCode: code,
          code: code,
          name: name,
          description: description,
          position: pts.first,
          points: pts,
          color: displayColor,
          strokeColor: displayColor,
          strokeWidth: geometry?.lineWidthMm ?? 0.15,
          isDashed: geometry?.isDashed ?? false,
          dashLength: geometry?.dashLengthMm,
          gapLength: geometry?.breakLengthMm,
        );
      case 4:
        final pts = points ??
            [
              position,
              position + const Offset(10, 0),
              position + const Offset(10, 10),
              position + const Offset(0, 10),
              position,
            ];
        return symbol_model.MapSymbol(
          id: id,
          type: symbol_model.MapSymbolType.area,
          iofCode: code,
          code: code,
          name: name,
          description: description,
          position: pts.first,
          points: pts,
          color: displayColor,
          fillColor: displayColor,
          strokeColor: displayColor,
          strokeWidth: 0.0,
          isClosed: true,
        );
      default:
        return symbol_model.MapSymbol(
          id: id,
          type: symbol_model.MapSymbolType.text,
          iofCode: code,
          code: code,
          name: name,
          description: description,
          position: position,
          points: [position],
          color: displayColor,
          text: name,
          fontSize: 3.0,
        );
    }
  }

  @override
  String toString() => 'IOFSymbolV3(code: ${code}, name: ${name})';

  @override
  bool operator ==(Object other) => identical(this, other) || (other is IOFSymbolV3 && other.code == code);

  @override
  int get hashCode => code.hashCode;
}

/// Bibliotheque complete des symboles ISOM 2017-2 (191 symboles).
class IOFSymbolsV3 {
  static final List<IOFSymbolV3> symbols = [
    IOFSymbolV3(
      code: r'101',
      name: r'Contour',
      description: r'A line joining points of equal height. The standard vertical interval between contours is 5 m. A contour interval of 2.5 m may be used for flat terrains. Slope lines may be drawn on the lower side of a contour line to clarify the direction of slope. When used, they should be placed in re-entrants. A closed contour represents a knoll or a depression. A depression has to have at least one slope line. Minimum height/depth should be 1 m. Relationships between adjacent contour lines are important. Adjacent contour lines show form and structure. Small details on contours should be avoided because they tend to hide the main features of the terrain. Prominent features such as depressions, re-entrants, spurs, earth banks and terraces may have to be exaggerated. Absolute height accuracy is of little importance, but the relative height difference between neighbouring features should be represented on the map as accurately as possible. It is permissible to alter the height of a contour slightly if this improves the representation of a feature. This deviation should not exceed 25% of the contour interval, and attention must be paid to neighbouring features. The smallest bend in a contour line is 0.25 mm from centre to centre of the line (footprint 4 m). The mouth of a re-entrant or a spur must be wider than 0.5 mm from centre to centre of the line (footprint 8 m). The minimum length of a contour knoll is 0.9 mm (footprint 13.5 m) and the minimum width is 0.6 mm (footprint 9 m) outside measure. Smaller prominent knolls can be represented using symbol Small knoll (109) or Small elongated knoll (110) or they can be exaggerated on the map to satisfy the minimum dimension. A depression must accommodate a slope line, so the minimum length is 1.1 mm (footprint 16.5 m) and the minimum width is 0.7 mm (footprint 10.5 m) outside measure. Smaller, prominent depressions can be represented using symbol Small depression (111) or they can be exaggerated to satisfy the minimum dimension. Contours should be adapted (not broken) in order not to touch symbol Small knoll (109) or Small elongated knoll (110).',
      type: 2,
      id: r'0',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'2',
        capStyle: r'1',
      ),
    ),
    IOFSymbolV3(
      code: r'101.1',
      name: r'Slope line, contour',
      description: r'Slope lines may be drawn on the lower side of a contour line to clarify the direction of slope. When used, they should be placed in re-entrants. A depression has to have at least one slope line.',
      type: 1,
      id: r'1',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 140,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, 0.0000), Offset(0.0000, -0.4700)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'102',
      name: r'Index contour',
      description: r'Every fifth contour shall be drawn with a thicker line. This is an aid to the quick assessment of height difference and the overall shape of the terrain surface. An index contour may be represented as an ordinary contour line in an area with much detail. Small contour knolls and depressions are normally not represented using index contours. The index contour level must be carefully selected in flat terrain. The ideal level for the index contour is the central contour in the most prominent slopes.',
      type: 2,
      id: r'2',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'2',
        capStyle: r'1',
      ),
    ),
    IOFSymbolV3(
      code: r'102.1',
      name: r'Contour value',
      description: r'An index contour may have a height value assigned. A height value should only be inserted in an index contour in places where other detail is not obscured. It shall be orientated so that the top of the label is on the higher side of the contour. The index value (label) shall be 1.5 mm high and represented in a sans-serif font.',
      type: 8,
      id: r'3',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.text(
        color: r'6',
        fontSize: 2095,
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'103',
      name: r'Form line',
      description: r'Form lines are used where more information must be given about the shape of the ground. Form lines are added only where representation would be incomplete with ordinary contours. They shall not be used as intermediate contours. Only one form line should be used between neighbouring contours. It is very important that a form line fits logically into the contour system, so the start and end of a form line should be parallel to the neighbouring contours. The gaps between the form line dashes must be placed on reasonably straight sections of the form line. Form lines can be used to differentiate flat knolls and depressions from more distinct ones (minimum height / depth should be 1 m). Excessive use of form lines must be avoided as this disturbs the three-dimensional picture of the ground shape and will complicate map reading. Minimum length (non-closed): two dashes. Minimum length of a form line, knoll or depression: 1.1 mm (footprint 16.5 m)',
      type: 2,
      id: r'4',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 100,
        dashed: true,
        dashLength: 2000,
        breakLength: 200,
        joinStyle: r'2',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'103.1',
      name: r'Slope line, formline',
      description: r'Slope lines may be drawn on the lower side of a contour line to clarify the direction of slope. When used, they should be placed in re-entrants.',
      type: 1,
      id: r'5',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, 0.0000), Offset(0.0000, -0.4700)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'104',
      name: r'Earth bank',
      description: r'An earth bank is an abrupt change in ground level which can be clearly distinguished from its surroundings, e.g. gravel or sand pits, road and railway cuttings or embankments. Minimum height: 1 m. An earth bank may impact runnability. The tags represent the full extent of the earth bank. For long earth banks it is allowed to use tags shorter than the minimum length at the ends. If two earth banks are close together, tags may be omitted. Impassable earth banks shall be represented using symbol impassable cliff (201). Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: r'6',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'104.1',
      name: r'Earth bank, minimum size',
      description: r'An earth bank is an abrupt change in ground level which can be clearly distinguished from its surroundings, e.g. gravel or sand pits, road and railway cuttings or embankments. Minimum height: 1 m. An earth bank may impact runnability. The tags represent the full extent of the earth bank. For long earth banks it is allowed to use tags shorter than the minimum length at the ends. If two earth banks are close together, tags may be omitted. Impassable earth banks shall be represented using symbol impassable cliff (201). Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: r'7',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, 0.0000), Offset(0.3000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 140,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.2300, 0.0000), Offset(0.2300, -0.4900)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 140,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2300, 0.0000), Offset(-0.2300, -0.4900)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'104.2',
      name: r'Earth bank, top line',
      description: r'An earth bank is an abrupt change in ground level which can be clearly distinguished from its surroundings, e.g. gravel or sand pits, road and railway cuttings or embankments. Minimum height: 1 m. An earth bank may impact runnability. The tags represent the full extent of the earth bank. For long earth banks it is allowed to use tags shorter than the minimum length at the ends. If two earth banks are close together, tags may be omitted. Impassable earth banks shall be represented using symbol impassable cliff (201). Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: r'8',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'104.3',
      name: r'Earth bank, tag line',
      description: r'Use this symbol to display the full extent of wide earth banks.',
      type: 2,
      id: r'9',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'104.9',
      name: r'Earth bank, minimum size (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: r'10',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, 0.0000), Offset(0.3000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 140,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.2300, 0.0000), Offset(0.2300, 0.4900)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 140,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2300, 0.0000), Offset(-0.2300, 0.4900)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'105',
      name: r'Earth wall',
      description: r'Distinct earth wall. Minimum height: 1 m. Minimum length: 1.4 mm (footprint 21 m).',
      type: 2,
      id: r'11',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'2',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'106',
      name: r'Ruined earth wall',
      description: r'A ruined or less distinct earth wall. Minimum height: 0.5 m. Minimum length: two dashes (3.65 mm - footprint 55 m). If shorter, the object must be exaggerated to the minimum length or changed to symbol Earth wall (105).',
      type: 2,
      id: r'12',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 180,
        dashed: true,
        dashLength: 2000,
        breakLength: 350,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'107',
      name: r'Erosion gully',
      description: r'An erosion gully which is too small to be shown using symbol Earth bank (104) is shown by a single line. Minimum depth: 1 m. Minimum length: 1.15 mm (footprint 17 m). Contour lines should not be broken around this symbol.',
      type: 2,
      id: r'13',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'6',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'2',
        capStyle: r'3',
      ),
    ),
    IOFSymbolV3(
      code: r'108',
      name: r'Small erosion gully',
      description: r'A small erosion gully, dry ditch or trench. Minimum depth: 0.5 m. Minimum length (isolated): three dots (1.15 mm - footprint 17 m). Contour lines should be broken around this symbol.',
      type: 2,
      id: r'14',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 0,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'109',
      name: r'Small knoll',
      description: r'An obvious mound or knoll which cannot be drawn to scale with a contour. Minimum height: 1 m. The symbol shall not touch or overlap contours. Footprint: 7.5 m x 7.5 m.',
      type: 1,
      id: r'15',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 250,
        innerColor: r'6',
        outerColor: r'-1',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'110',
      name: r'Small elongated knoll',
      description: r'An obvious elongated knoll which cannot be drawn to scale with a contour. Minimum height: 1 m. The symbol shall not touch or overlap contours. Footprint: 12 m x 6 m.',
      type: 1,
      id: r'16',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'6',
            rotatable: false,
          ),
          coords: [Offset(0.0000, -0.4000), Offset(0.1100, -0.4000), Offset(0.2000, -0.2210), Offset(0.2000, 0.0000), Offset(0.2000, 0.2210), Offset(0.1100, 0.4000), Offset(0.0000, 0.4000), Offset(-0.1100, 0.4000), Offset(-0.2000, 0.2210), Offset(-0.2000, 0.0000), Offset(-0.2000, -0.2210), Offset(-0.1100, -0.4000), Offset(0.0000, -0.4000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'111',
      name: r'Small depression',
      description: r'A small depression or hollow without steep sides that is too small to be shown by contours. Minimum depth: 1 m, minimum width: 2 m. Small depressions with steep sides are represented with symbol Pit (112). The symbol shall not touch or overlap other brown symbols. Location is the centre of gravity of the symbol, and the symbol is orientated to north. Footprint: 12 m x 6 m.',
      type: 1,
      id: r'17',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 180,
            dashed: false,
            dashLength: 3444,
            breakLength: 861,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.3100, -0.2030), Offset(0.3100, -0.0320), Offset(0.1710, 0.1070), Offset(0.0000, 0.1070), Offset(-0.1710, 0.1070), Offset(-0.3100, -0.0320), Offset(-0.3100, -0.2030)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'112',
      name: r'Pit',
      description: r'Pits and holes with distinct steep sides which cannot be shown to scale using symbol Earth bank (104). Minimum depth: 1 m, minimum width: 1 m. A pit larger than 5 m x 5 m should normally be exaggerated and drawn using Earth bank (104). Pits without steep sides are represented with symbol Small depression (111). The symbol shall not touch or overlap other brown symbols. Location is the centre of gravity of the symbol, and the symbol is orientated to north. Footprint: 10.5 m x 12 m.',
      type: 1,
      id: r'18',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 900,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'6',
            rotatable: false,
          ),
          coords: [Offset(0.1540, -0.3020), Offset(0.3500, -0.3020), Offset(0.0000, 0.4890), Offset(-0.3500, -0.3020), Offset(-0.1540, -0.3020), Offset(0.0000, 0.0500), Offset(0.1540, -0.3020)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'113',
      name: r'Broken ground',
      description: r'An area of pits and / or knolls which is too intricate to be shown in detail, or other types of rough and uneven ground that is clearly distinguishable but has little impact on runnability. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.5 mm. Contours should not be cut in broken ground areas. The dots shall not be arranged to form a single point wide line.',
      type: 4,
      id: r'19',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'113.1',
      name: r'Broken ground, individual dot',
      description: r'An area of pits and / or knolls which is too intricate to be shown in detail, or other types of rough and uneven ground that is clearly distinguishable but has little impact on runnability. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.5 mm. Contours should not be cut in broken ground areas. The dots shall not be arranged to form a single point wide line. Density: 3-4 dots / mm².',
      type: 1,
      id: r'20',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 100,
        innerColor: r'6',
        outerColor: r'-1',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'114',
      name: r'Very broken ground',
      description: r'An area of pits and/or knolls, which is too intricate to be shown in detail, or other types of rough and uneven ground that is clearly distinguishable and affects runnability. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. The minimum number of dots is three (footprint 7 m x 7 m). The maximum centre to centre distance between neighbouring dots is 0.38 mm. The minimum centre to centre distance between neighbouring dots is 0.25 mm. Contours should not be cut in broken ground areas. The dots shall not be arranged to form a single point wide line.',
      type: 4,
      id: r'21',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'115',
      name: r'Prominent landform feature',
      description: r'The feature must be very clearly distinguishable from its surroundings. Location is the centre of gravity of the symbol, which is orientated to north. The symbol shall not touch or overlap other brown symbols. The definition of the symbol must be given on the map. Footprint: 13.5 m x 11.5 m.',
      type: 1,
      id: r'22',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'6',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2940, 0.1700), Offset(0.2940, 0.1700), Offset(0.0000, -0.3400), Offset(-0.2940, 0.1700)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'201',
      name: r'Impassable cliff',
      description: r'A cliff, quarry or earth bank that is so high and steep that it is impossible to pass/climb or is dangerous. For vertical rock faces the tags may be omitted if space is short. Ends of the top line may be rounded or square. Shorter tags may be used at the ends. The gap between two impassable cliffs or between impassable cliffs and other impassable feature symbols must exceed 0.25 mm on the map. When an impassable cliff drops straight into water, making it impossible to pass under the cliff along the water’s edge, the bank line is omitted or the tags shall clearly extend over the bank line. An impassable cliff should interplay with the contour lines. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: r'23',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 350,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'201.1',
      name: r'Impassable cliff, minimum size',
      description: r'A cliff, quarry or earth bank that is so high and steep that it is impossible to pass/climb or is dangerous. For vertical rock faces the tags may be omitted if space is short. Ends of the top line may be rounded or square. Shorter tags may be used at the ends. The gap between two impassable cliffs or between impassable cliffs and other impassable feature symbols must exceed 0.25 mm on the map. When an impassable cliff drops straight into water, making it impossible to pass under the cliff along the water’s edge, the bank line is omitted or the tags shall clearly extend over the bank line. An impassable cliff should interplay with the contour lines. Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: r'24',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 350,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, 0.0000), Offset(0.3000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.2400, 0.0000), Offset(0.2400, -0.5750)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2400, 0.0000), Offset(-0.2400, -0.5750)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'201.2',
      name: r'Impassable cliff, plan shape representation (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 4,
      id: r'25',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'2',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'201.3',
      name: r'Impassable cliff, top line',
      description: r'A cliff, quarry or earth bank that is so high and steep that it is impossible to pass/climb or is dangerous. For vertical rock faces the tags may be omitted if space is short. Ends of the top line may be rounded or square. Shorter tags may be used at the ends. The gap between two impassable cliffs or between impassable cliffs and other impassable feature symbols must exceed 0.25 mm on the map. When an impassable cliff drops straight into water, making it impossible to pass under the cliff along the water’s edge, the bank line is omitted or the tags shall clearly extend over the bank line. An impassable cliff should interplay with the contour lines. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: r'26',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 350,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'201.4',
      name: r'Impassable cliff, tag line',
      description: r'Use this symbol to display the full extent of a wide cliff.',
      type: 2,
      id: r'27',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 120,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'201.9',
      name: r'Impassable cliff, minimum size (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: r'28',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 350,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, 0.0000), Offset(0.3000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.2400, 0.0000), Offset(0.2400, 0.5750)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2400, 0.0000), Offset(-0.2400, 0.5750)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'202',
      name: r'Cliff',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: r'29',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'202.1',
      name: r'Cliff, minimum size',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: r'30',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 250,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, 0.0000), Offset(0.3000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'202.2',
      name: r'Cliff, with tags',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: r'31',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'202.3',
      name: r'Cliff, with tags, minimum size',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: r'32',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 250,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, 0.0000), Offset(0.3000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.2400, 0.0000), Offset(0.2400, -0.5250)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2400, 0.0000), Offset(-0.2400, -0.5250)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'202.9',
      name: r'Cliff, with tags, minimum size (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: r'33',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 250,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, 0.0000), Offset(0.3000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.2400, 0.0000), Offset(0.2400, 0.5250)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 120,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2400, 0.0000), Offset(-0.2400, 0.5250)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'203.1',
      name: r'Rocky pit or cave (without a distinct entrance)',
      description: r'Rocky pits, holes, caves or mineshafts without a distinct entrance which may constitute a danger to the competitor. Location is the centre of gravity of the symbol, and the symbol shall be orientated to north. Rocky pits larger than 5 m in diameter should be exaggerated and represented using cliff symbols (201, 202). Minimum depth: 1 m. Footprint: 10.5 m x 12 m.',
      type: 1,
      id: r'34',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 900,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(0.1750, -0.3100), Offset(0.3500, -0.3100), Offset(0.0000, 0.4900), Offset(-0.3500, -0.3100), Offset(-0.1750, -0.3100), Offset(0.0000, 0.0900), Offset(0.1750, -0.3100)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'203.2',
      name: r'Cave or rocky pit (with a distinct entrance)',
      description: r'Rocky pits, holes, caves or mineshafts with a distinct entrance which may constitute a danger to the competitor. Minimum depth: 1 m. Location is the centre of gravity of the symbol, and the symbol should point into the cave. Rocky pits larger than 5 m in diameter should be exaggerated and represented using cliff symbols (201, 202).',
      type: 1,
      id: r'35',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 900,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(0.1750, 0.3100), Offset(0.3500, 0.3100), Offset(0.0000, -0.4900), Offset(-0.3500, 0.3100), Offset(-0.1750, 0.3100), Offset(0.0000, -0.0900), Offset(0.1750, 0.3100)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'203.9',
      name: r'Rocky pit or cave with distinct entrance (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: r'36',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 900,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(0.1750, -0.3100), Offset(0.3500, -0.3100), Offset(0.0000, 0.4900), Offset(-0.3500, -0.3100), Offset(-0.1750, -0.3100), Offset(0.0000, 0.0900), Offset(0.1750, -0.3100)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'204',
      name: r'Boulder',
      description: r'A distinct boulder (should be higher than 1 m), which is immediately identifiable on the ground. Groups of boulders are represented using symbol Boulder cluster (207) or a boulder field symbol (208, 209). To be able to show the distinction between neighbouring (closer than 30 m apart) boulders with significant difference in size, it is permitted to enlarge the symbol to 0.5 mm for some of the boulders. Footprint: 6 m diameter (7.5 m diameter).',
      type: 1,
      id: r'37',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 200,
        innerColor: r'2',
        outerColor: r'-1',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'204.5',
      name: r'Boulder or large boulder, different size',
      description: r'A boulder which is larger than neighboring boulders (204), or a large boulder which is smaller than neighboring large boulders (205). To be able to show the distinction between neighbouring (closer than 30 metres apart) boulders (204) with significant difference in size, it is permitted to use this symbol (0.5 mm) as an enlargement of symbol 204 for some of the boulders. To be able to show the distinction between neighbouring (closer than 30 metres apart) large boulders (205) with significant difference in size, it is permitted to use this symbol (0.5 mm) as an as a reduction of symbol 205 for some of the boulders.',
      type: 1,
      id: r'38',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 250,
        innerColor: r'2',
        outerColor: r'-1',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'205',
      name: r'Large boulder',
      description: r'A particularly large and distinct boulder. A large boulder should be more than 2 m high. To be able to show the distinction between neighbouring (closer than 30 m apart) large boulders with significant difference in size, it is permitted to reduce the size of the symbol to 0.5 mm for some of the boulders. Footprint: 9 m diameter (7.5 m diameter).',
      type: 1,
      id: r'39',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 300,
        innerColor: r'2',
        outerColor: r'-1',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'206',
      name: r'Gigantic boulder',
      description: r'A gigantic boulder, rock pillar or massive cliff shall be represented in plan shape. The objects can vary in shape and width. The gap between gigantic boulders or between gigantic boulders and other impassable feature symbols must exceed 0.15 mm on the map. Minimum width: 0.25 mm (footprint 3.75 m). Minimum area: 0.3 mm² (footprint 67 m²).',
      type: 4,
      id: r'40',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'2',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'207',
      name: r'Boulder cluster',
      description: r'A distinct group of boulders so closely clustered together that they cannot be marked individually. The boulders in the cluster should be higher than 1 m. A boulder cluster must be easily identifiable as a group of boulders. To be able to show the distinction between neighbouring (maximum 30 m apart) boulder clusters with significant difference in boulder size, it is permitted to enlarge this symbol to 120% (edge length 0.96 mm) for some of the boulder clusters. The symbol is orientated to north. Footprint: 12 m x 10 m.',
      type: 1,
      id: r'41',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-0.4000, 0.2310), Offset(0.4000, 0.2310), Offset(0.0000, -0.4620), Offset(-0.4000, 0.2310)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'207.1',
      name: r'Boulder cluster, large',
      description: r'To be able to show the distinction between neighbouring (maximum 30 m apart) boulder clusters with significant difference in boulder size, it is permitted to use this symbol instead of regular Boulder cluster (207) for some of the boulder clusters.',
      type: 1,
      id: r'42',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1250,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-0.4800, 0.2770), Offset(0.4800, 0.2770), Offset(0.0000, -0.5540), Offset(-0.4800, 0.2770)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'208',
      name: r'Boulder field',
      description: r'An area which is covered with so many scattered blocks of stone that they cannot be marked individually, is shown with randomly placed and orientated solid triangles. A boulder field will generally not impact runnability. If the runnability of the boulder field is reduced, symbol 209 (dense boulder field) should be used or the symbol should be combined with a stony ground symbol. A minimum of two triangles should be used. One triangle may be used if it is combined with other rock symbols (for instance directly below cliff symbols (201, 202), adjacent to boulder symbols (204-206) or combined with stony ground symbols (210-212)). The maximum centre to centre distance between neighbouring triangles is 1.2 mm. The minimum centre to centre distance between neighbouring triangles is 0.75 mm. Density: 0.8-1 symbol / mm². To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%. Footprint of individual triangle: 12 m x 6 m.',
      type: 4,
      id: r'43',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'208.1',
      name: r'Boulder field, single triangle',
      description: r'An area which is covered with so many scattered blocks of stone that they cannot be marked individually, is shown with randomly placed and orientated solid triangles. A boulder field will generally not impact runnability. If the runnability of the boulder field is reduced, symbol 209 (dense boulder field) should be used or the symbol should be combined with a stony ground symbol. A minimum of two triangles should be used. One triangle may be used if it is combined with other rock symbols (for instance directly below cliff symbols (201, 202), adjacent to boulder symbols (204-206) or combined with stony ground symbols (210-212)). The maximum centre to centre distance between neighbouring triangles is 1.2 mm. The minimum centre to centre distance between neighbouring triangles is 0.75 mm. Density: 0.8-1 symbol / mm². To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%. Footprint of individual triangle: 12 m x 6 m.',
      type: 1,
      id: r'44',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 640,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(0.1250, 0.3770), Offset(0.1250, -0.4230), Offset(-0.2490, 0.0460), Offset(0.1250, 0.3770)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'208.2',
      name: r'Boulder field, single triangle, enlarged',
      description: r'To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%.',
      type: 1,
      id: r'45',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 768,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(0.1500, 0.4520), Offset(0.1500, -0.5080), Offset(-0.2990, 0.0550), Offset(0.1500, 0.4520)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'209',
      name: r'Dense boulder field',
      description: r'An area which is covered with so many blocks of stone that they cannot be marked individually and the runnability is affected, is shown with randomly placed and orientated solid triangles. A minimum of two triangles must be used. The maximum centre to centre distance between neighbouring triangles is 0.6 mm. Density: 2-3 symbols / mm². To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%. Footprint of individual triangle: 12 m x 6 m.',
      type: 4,
      id: r'46',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'210',
      name: r'Stony ground, slow running',
      description: r'Stony or rocky ground which reduces runnability to about 60-80% of normal speed. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.45 mm. Density: 3-4 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 4,
      id: r'47',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'210.1',
      name: r'Stony ground, individual dot',
      description: r'Stony or rocky ground which reduces runnability to about 60-80% of normal speed. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.45 mm. Density: 3-4 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 1,
      id: r'48',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 100,
        innerColor: r'2',
        outerColor: r'-1',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'211',
      name: r'Stony ground, walk',
      description: r'Stony or rocky ground which reduces the runnability significantly (to about 20-60% of normal speed). The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 8 m x 8 m). The maximum centre to centre distance between neighbouring dots is 0.4 mm. The minimum centre to centre distance between neighbouring dots is 0.32 mm. Density: 6-8 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 4,
      id: r'49',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'212',
      name: r'Stony ground, fight',
      description: r'Stony or rocky ground which is hardly passable (less than 20% of normal speed). The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 7 m x 7 m). The maximum centre to centre distance between neighbouring dots is 0.32 mm. The minimum centre to centre distance between neighbouring dots is 0.25 mm. Density: 10-12 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 4,
      id: r'50',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'213',
      name: r'Sandy ground',
      description: r'An area of soft sandy ground where runnability is reduced to less than 80% of normal speed. The symbol is orientated to north. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: r'51',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'34',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'214',
      name: r'Bare rock',
      description: r'A runnable area of rock without earth or vegetation should be shown as bare rock. An area of rock covered with grass, moss or other low vegetation, shall not be shown using the bare rock symbol. An area of less runnable bare rock should be shown using a stony ground symbol (210-212). Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: r'52',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'24',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'215',
      name: r'Trench',
      description: r'Rocky or artificial trench. Minimum depth should be 1 m. Minimum length: 1 mm (footprint 15 m). Shorter trenches may be exaggerated to the minimum graphical dimension. Impassable trenches shall be represented using symbol Impassable cliff (201). Collapsed and easily crossable trenches should be mapped as erosion gullies.',
      type: 2,
      id: r'53',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 100,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'301',
      name: r'Uncrossable body of water (full colour), with bank line',
      description: r'The black bank line emphasises that the feature is uncrossable. Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'54',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'15',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'301.1',
      name: r'Uncrossable body of water (full colour)',
      description: r'Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'55',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'15',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'301.2',
      name: r'Uncrossable body of water (dominant), with bank line',
      description: r'The black bank line emphasises that the feature is uncrossable. Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'56',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'16',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'301.3',
      name: r'Uncrossable body of water (dominant)',
      description: r'Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'57',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'16',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'301.4',
      name: r'Uncrossable body of water, bank line',
      description: r'A black bank line indicates that the feature cannot be crossed.',
      type: 2,
      id: r'58',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'0',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'302',
      name: r'Shallow body of water, with solid outline',
      description: r'A shallow seasonal or periodic body of water may be represented using a dashed outline. Small shallow water bodies may be represented as 100% blue (without an outline). Minimum width (inside): 0.3 mm. Minimum area (inside): 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width (full colour): 0.3 mm. Minimum area (full colour): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'59',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'17',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'302.1',
      name: r'Shallow body of water',
      description: r'A shallow seasonal or periodic body of water may be represented using a dashed outline. Small shallow water bodies may be represented as 100% blue (without an outline). Minimum width (inside): 0.3 mm. Minimum area (inside): 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width (full colour): 0.3 mm. Minimum area (full colour): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'60',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'17',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'302.2',
      name: r'Shallow body of water, solid outline',
      description: r'Use this symbol to represent the outline of a shallow body of water which is not seasonal or periodic.',
      type: 2,
      id: r'61',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'5',
        lineWidth: 100,
        dashed: false,
        dashLength: 1250,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'302.3',
      name: r'Shallow body of water, dashed outline',
      description: r'Use this symbol to represent the outline of a shallow seasonal or periodic body of water.',
      type: 2,
      id: r'62',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'5',
        lineWidth: 100,
        dashed: true,
        dashLength: 1250,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'302.5',
      name: r'Small shallow body of water (full colour)',
      description: r'Small shallow water bodies may be represented using this symbol (without an outline). Minimum width: 0.3 mm. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'63',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'15',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'303',
      name: r'Waterhole',
      description: r'A water-filled pit or an area of water which is too small to be shown to scale. Location is the centre of gravity of the symbol, and the symbol is orientated to north. Footprint: 10.5 m x 12 m.',
      type: 1,
      id: r'64',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 900,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'5',
            rotatable: false,
          ),
          coords: [Offset(0.1540, -0.3020), Offset(0.3500, -0.3020), Offset(0.0000, 0.4890), Offset(-0.3500, -0.3020), Offset(-0.1540, -0.3020), Offset(0.0000, 0.0500), Offset(0.1540, -0.3020)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'304',
      name: r'Crossable watercourse',
      description: r'Should be at least 2 m wide. Minimum length (isolated): 1 mm (footprint 15 m).',
      type: 2,
      id: r'65',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'5',
        lineWidth: 300,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'305',
      name: r'Small crossable watercourse',
      description: r'Minimum length (isolated): 1 mm (footprint 15 m).',
      type: 2,
      id: r'66',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'5',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'306',
      name: r'Minor/seasonal water channel',
      description: r'A natural or man-made minor water channel which may contain water only intermittently. Minimum length (isolated): two dashes (2.75 mm - footprint 41 m).',
      type: 2,
      id: r'67',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'5',
        lineWidth: 180,
        dashed: true,
        dashLength: 1250,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'307',
      name: r'Uncrossable marsh, with outline',
      description: r'A marsh which is uncrossable or dangerous for the competitor. The black outline emphasises that the feature is uncrossable. The black outline is omitted for boundaries between uncrossable marsh and symbol Uncrossable body of water (301). The symbol may be combined with a rough open land symbol (403, 404) to show openness. The symbol is orientated to north. Minimum width: 0.3 mm (inside). Minimum area: 0.5 mm² (inside).',
      type: 4,
      id: r'68',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'307.1',
      name: r'Uncrossable marsh',
      description: r'A marsh which is uncrossable or dangerous for the competitor. The black outline emphasises that the feature is uncrossable. The black outline is omitted for boundaries between uncrossable marsh and symbol Uncrossable body of water (301). The symbol may be combined with a rough open land symbol (403, 404) to show openness. The symbol is orientated to north. Minimum width: 0.3 mm (inside). Minimum area: 0.5 mm² (inside).',
      type: 4,
      id: r'69',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'307.2',
      name: r'Uncrossable marsh, outline',
      description: r'The black outline emphasises that the feature is uncrossable.',
      type: 2,
      id: r'70',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'308',
      name: r'Marsh',
      description: r'A crossable marsh, usually with a distinct edge. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 0.5 mm x 0.4 mm (footprint 7.5 m x 6 m).',
      type: 4,
      id: r'71',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'308.1',
      name: r'Marsh, minimum size',
      description: r'A crossable marsh, usually with a distinct edge. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 0.5 mm x 0.4 mm (footprint 7.5 m x 6 m).',
      type: 1,
      id: r'72',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2500, -0.1500), Offset(0.2500, -0.1500)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2500, 0.1500), Offset(0.2500, 0.1500)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'309',
      name: r'Narrow marsh',
      description: r'A marsh or trickle of water which is too narrow (less than about 5 m wide) to be shown with the marsh symbol. Minimum length (isolated): two dots (0.7 mm - footprint 10.5 m).',
      type: 2,
      id: r'73',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 0,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'310',
      name: r'Indistinct marsh',
      description: r'An indistinct marsh, seasonal marsh or an area of gradual transition from marsh to firm ground, which is crossable. The edge is generally indistinct and the vegetation similar to that of the surrounding ground. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 2.0 mm x 0.7 mm (footprint 30 m x 10.5 m).',
      type: 4,
      id: r'74',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'310.1',
      name: r'Indistinct marsh, minimum size',
      description: r'An indistinct marsh, seasonal marsh or an area of gradual transition from marsh to firm ground, which is crossable. The edge is generally indistinct and the vegetation similar to that of the surrounding ground. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 2.0 mm x 0.7 mm (footprint 30 m x 10.5 m).',
      type: 1,
      id: r'75',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.4500, -0.3000), Offset(0.4500, -0.3000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.4500, 0.3000), Offset(0.4500, 0.3000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-1.0250, 0.0000), Offset(-0.1250, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.1250, 0.0000), Offset(1.0250, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'311',
      name: r'Well, fountain or water tank',
      description: r'A prominent well, fountain, water tank or captive spring. Footprint: 12 m x 12 m.',
      type: 1,
      id: r'76',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3100, -0.3100), Offset(0.3100, -0.3100), Offset(0.3100, 0.3100), Offset(-0.3100, 0.3100), Offset(-0.3100, -0.3100)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'312',
      name: r'Spring',
      description: r'A source of water. Location is the centre of gravity of the symbol. The symbol is orientated to open downstream. Footprint: 13.5 m x 7 m.',
      type: 1,
      id: r'77',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.3600, -0.2340), Offset(0.3600, -0.0360), Offset(0.1990, 0.1260), Offset(0.0000, 0.1260), Offset(-0.1990, 0.1260), Offset(-0.3600, -0.0360), Offset(-0.3600, -0.2340)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'313',
      name: r'Prominent water feature',
      description: r'The symbol is orientated to north. The definition of the symbol must be given on the map. Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: r'78',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1048,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 160,
            dashed: false,
            dashLength: 4189,
            breakLength: 1048,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -0.4500), Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 160,
            dashed: false,
            dashLength: 4189,
            breakLength: 1048,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.4280, -0.1390), Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 160,
            dashed: false,
            dashLength: 4189,
            breakLength: 1048,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.2650, 0.3640), Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 160,
            dashed: false,
            dashLength: 4189,
            breakLength: 1048,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.2650, 0.3640), Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'5',
            lineWidth: 160,
            dashed: false,
            dashLength: 4189,
            breakLength: 1048,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.4280, -0.1390), Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'401',
      name: r'Open land',
      description: r'Open land that has a ground cover (grass, moss or similar) which offers better runnability than typical open forest. If yellow coloured areas become dominant, a screen (75% instead of full yellow) may be used. Shall not be combined with area symbols other than Broken ground (113), Boulder field (208), Marsh (308) and Indistinct marsh (310). Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'79',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'33',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'402',
      name: r'Open land with scattered trees',
      description: r'Areas with scattered trees or bushes in open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Prominent individual trees may be added using symbol Prominent large tree (417). If yellow coloured areas become dominant, a screen (75% instead of full yellow) may be used. Shall not be combined with area symbols other than symbol Broken ground (113), symbol Boulder field (208) or marsh symbols (308, 310). Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m). Smaller areas must either be left out, exaggerated or shown using symbol Open land (401). The symbol is orientated to north.',
      type: 4,
      id: r'80',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'33',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'402.1',
      name: r'Open land with scattered bushes (green dots)',
      description: r'Areas with scattered trees or bushes in open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Prominent individual trees may be added using symbol Prominent large tree (417). If yellow coloured areas become dominant, a screen (75% instead of full yellow) may be used. Shall not be combined with area symbols other than symbol Broken ground (113), symbol Boulder field (208) or marsh symbols (308, 310). Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m). Smaller areas must either be left out, exaggerated or shown using symbol Open land (401). The symbol is orientated to north.',
      type: 4,
      id: r'81',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'33',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'403',
      name: r'Rough open land',
      description: r'Heath, moorland, felled areas, newly planted areas (trees lower than ca. 1 m) or other generally open land with rough ground vegetation, heather or tall grass offering the same runnability as typical open forest. May be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m). Smaller areas must either be left out, exaggerated or shown using symbol Open land (401).',
      type: 4,
      id: r'82',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'34',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'404',
      name: r'Rough open land with scattered trees',
      description: r'Areas with scattered trees or bushes in rough open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Only the white dot variant can be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. The symbol is orientated to north. Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2.5 mm x 2.5 mm (footprint 37.5 m x 37.5 m). Smaller areas must either be left out, exaggerated or shown using symbol Rough open land (403).',
      type: 4,
      id: r'83',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'34',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'404.1',
      name: r'Rough open land with scattered bushes (green dots)',
      description: r'Areas with scattered trees or bushes in rough open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Only the white dot variant can be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. The symbol is orientated to north. Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2.5 mm x 2.5 mm (footprint 37.5 m x 37.5 m). Smaller areas must either be left out, exaggerated or shown using symbol Rough open land (403).',
      type: 4,
      id: r'84',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'34',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'405',
      name: r'Forest',
      description: r'Typical open forest for the particular type of terrain. If no part of the forest is easily runnable then no white should appear on the map. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m) for openings in screens of other colours, except for the following: For openings in symbol Open land (401), the minimum area is 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). For openings in symbol Vegetation: walk (408), the minimum area is 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). For openings in symbol Vegetation: fight (410) the minimum area is 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: r'85',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'22',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'406',
      name: r'Vegetation: slow running',
      description: r'An area with dense vegetation (low visibility) which reduces running to about 60-80% of normal speed. Where runnability is better in one direction, a regular pattern of white stripes is left in the screen to show the direction of better running. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m). Minimum width: 0.4 mm (footprint 6 m).',
      type: 4,
      id: r'86',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'28',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'406.1',
      name: r'Vegetation: slow running, normal running in one direction',
      description: r'An area with dense vegetation (low visibility) which reduces running to about 60-80% of normal speed. Where runnability is better in one direction, a regular pattern of white stripes is left in the screen to show the direction of better running. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m). Minimum width: 0.4 mm (footprint 6 m).',
      type: 4,
      id: r'87',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'28',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'407',
      name: r'Vegetation: slow running, good visibility',
      description: r'An area of good visibility and reduced runnability, due to, for instance, undergrowth (brambles, heather, low bushes, cut branches). Running speed is reduced to about 60-80% of normal speed. The symbol is orientated to north. Minimum area: 1.5 mm x 1 mm (footprint 22.5 m x 15 m).',
      type: 4,
      id: r'88',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'408',
      name: r'Vegetation: walk',
      description: r'An area with dense trees or thickets (low visibility) which reduce running to about 20-60% of normal speed. Where runnability is better in one direction, a regular pattern of white or green 20% stripes is left in the screen to show the direction of better running. Minimum area: 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: r'89',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'27',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'408.1',
      name: r'Vegetation: walk, normal running in one direction',
      description: r'An area with dense trees or thickets (low visibility) which reduce running to about 20-60% of normal speed. Where runnability is better in one direction, a regular pattern of white or green 20% stripes is left in the screen to show the direction of better running. Minimum area: 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: r'90',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'27',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'408.2',
      name: r'Vegetation: walk, slow running in one direction',
      description: r'An area with dense trees or thickets (low visibility) which reduce running to about 20-60% of normal speed. Where runnability is better in one direction, a regular pattern of white or green 20% stripes is left in the screen to show the direction of better running. Minimum area: 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: r'91',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'28',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'409',
      name: r'Vegetation: walk, good visibility',
      description: r'An area of good visibility that is difficult to run through, due to, for instance, undergrowth (brambles, heather, low bushes, cut branches). Running speed is reduced to about 20-60% of normal speed. Areas of good visibility that are very difficult to run or impassable are represented using symbol Vegetation: fight (410). The symbol is orientated to north. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: r'92',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'410',
      name: r'Vegetation: fight',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: r'93',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'26',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'410.1',
      name: r'Vegetation: fight, normal running in one direction',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: r'94',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'26',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'410.2',
      name: r'Vegetation: fight, slow running in one direction',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: r'95',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'28',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'410.3',
      name: r'Vegetation: fight, walk in one direction',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: r'96',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'27',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'410.4',
      name: r'Vegetation: fight, minimum width',
      description: r'An area of dense vegetation (trees or undergrowth) which is effectively impassable. Minimum width: 0.35 mm',
      type: 2,
      id: r'97',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'26',
        lineWidth: 350,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'411',
      name: r'Vegetation, impassable (from ISOM 2017, first edition)',
      description: r'Provided for migration from ISOM 2000. Use either Vegetation: fight (410) or Area that shall not be entered (520) instead.',
      type: 4,
      id: r'98',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'26',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'412',
      name: r'Cultivated land',
      description: r'Cultivated land, normally used for growing crops. Runnability may vary according to the type of crops grown and the time of year. For agroforestry, symbol Forest (405) or Open land with scattered trees (402) may be used instead of yellow. Since the runnability may vary, such areas should be avoided when setting courses. The symbol is combined with symbol Out-of-bounds area (709) to show cultivated land that shall not be entered. The symbol is orientated to north. Minimum area: 3 mm x 3 mm (footprint 45 m x 45 m).',
      type: 4,
      id: r'99',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'33',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'412.1',
      name: r'Cultivated land (black pattern)',
      description: r'Cultivated land. This symbol must be used together with another symbol: - For land used for growing crops, combine with symbol Open land (401). - For agroforrestry, use with symbol Forest (405) or Open land with scattered trees (402). Runnability may vary according to the type of crops or trees, and the time of year. Since the runnability may vary, such areas should be avoided when setting courses. The symbol is orientated to north. Minimum area: 3 mm x 3 mm (footprint 45 m x 45 m).',
      type: 4,
      id: r'100',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'413',
      name: r'Orchard',
      description: r'Land planted with trees or bushes, normally in a regular pattern. The dot lines may be orientated to show the direction of planting. Must be combined with either symbol Open land (401) or Rough open land (403). May be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: r'101',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'33',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'413.1',
      name: r'Orchard, rough open land',
      description: r'Land planted with trees or bushes, normally in a regular pattern. The dot lines may be orientated to show the direction of planting. Must be combined with either symbol Open land (401) or Rough open land (403). May be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: r'102',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'34',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'414',
      name: r'Vineyard or similar',
      description: r'A vineyard or similar cultivated land containing dense rows of plants offering good or normal runnability in the direction of planting. The lines shall be orientated to show the direction of planting. At least three lines shall be clearly visible. Must be combined with either symbol Open land (401) or Rough open land (403). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: r'103',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'33',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'414.1',
      name: r'Vineyard or similar, rough open land',
      description: r'A vineyard or similar cultivated land containing dense rows of plants offering good or normal runnability in the direction of planting. The lines shall be orientated to show the direction of planting. At least three lines shall be clearly visible. Must be combined with either symbol Open land (401) or Rough open land (403). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: r'104',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'34',
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'415',
      name: r'Distinct cultivation boundary',
      description: r'A boundary of cultivated land vegetation (symbols 401, 412, 413, 414) or a boundary between areas of cultivated land when not shown with other symbols (fence, wall, path, etc.). Minimum length: 2 mm (footprint 30 m).',
      type: 2,
      id: r'105',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'416',
      name: r'Distinct vegetation boundary',
      description: r'A distinct forest edge or vegetation boundary within the forest. Very distinct forest edges and vegetation boundaries may be represented using the cultivation boundary symbol. Only one of the vegetation boundary symbols (black dotted line or dashed green line) can be used on a map. For areas with a lot of rock features, it is recommended to use the green dashed line for vegetation boundaries. A disadvantage with a green line is that it cannot be used to show distinct vegetation boundaries around and within symbol Vegetation: fight (410). An alternative for these situations is to use symbol Distinct cultivation boundary (415). Minimum length, black dot implementation: 5 dots (2.5 mm - footprint 37 m). Minimum length, green line implementation: 4 dashes (1.8 mm - footprint 27 m).',
      type: 2,
      id: r'106',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 0,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'416.1',
      name: r'Distinct vegetation boundary, green dashed line',
      description: r'A distinct forest edge or vegetation boundary within the forest. Very distinct forest edges and vegetation boundaries may be represented using the cultivation boundary symbol. Only one of the vegetation boundary symbols (black dotted line or dashed green line) can be used on a map. For areas with a lot of rock features, it is recommended to use the green dashed line for vegetation boundaries. A disadvantage with a green line is that it cannot be used to show distinct vegetation boundaries around and within symbol Vegetation: fight (410). An alternative for these situations is to use symbol Distinct cultivation boundary (415). Minimum length, black dot implementation: 5 dots (2.5 mm - footprint 37 m). Minimum length, green line implementation: 4 dashes (1.8 mm - footprint 27 m).',
      type: 2,
      id: r'107',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'25',
        lineWidth: 140,
        dashed: true,
        dashLength: 300,
        breakLength: 200,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'417',
      name: r'Prominent large tree',
      description: r'Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: r'108',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 270,
        innerColor: r'-1',
        outerColor: r'3',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.point(
            innerRadius: 550,
            innerColor: r'22',
            outerColor: r'-1',
            rotatable: false,
            elements: null,
          ),
          coords: [Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'418',
      name: r'Prominent bush or tree',
      description: r'Use sparingly, as it is easily mistaken for symbol Small knoll (109). Footprint: 9.0 m x 9.0 m.',
      type: 1,
      id: r'109',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 50,
        innerColor: r'22',
        outerColor: r'3',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'419',
      name: r'Prominent vegetation feature',
      description: r'The symbol is orientated to north. The definition of the symbol must be given on the map. Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: r'110',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'3',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3900, -0.3900), Offset(0.3900, 0.3900)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'3',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.3900, -0.3900), Offset(-0.3900, 0.3900)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'22',
            lineWidth: 360,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.4500, -0.4500), Offset(0.4500, 0.4500)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'22',
            lineWidth: 360,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.4500, -0.4500), Offset(-0.4500, 0.4500)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'501',
      name: r'Paved area, with bounding line',
      description: r'An area with a firm surface such as asphalt, hard gravel, tiles, concrete or the like. Paved areas should be bordered (or framed) by a thin black line where they have a distinct boundary. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 1,
      id: r'111',
      isHidden: false,
      geometry: null,
    ),
    IOFSymbolV3(
      code: r'501.1',
      name: r'Paved area',
      description: r'An area with a firm surface such as asphalt, hard gravel, tiles, concrete or the like. Paved areas should be bordered (or framed) by a thin black line where they have a distinct boundary. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: r'112',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'11',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'501.2',
      name: r'Paved area, bounding line',
      description: r'Paved areas should be bordered (or framed) by a thin black line where they have a distinct boundary.',
      type: 2,
      id: r'113',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'8',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'502',
      name: r'Wide road, minimum width',
      description: r'The width should be drawn to scale, but not smaller than the minimum width (0.3 + 2*0.14 mm - footprint 8.7 m). The outer boundary lines may be replaced with other black line symbols, such as symbol Fence (516), Impassable fence (518), Wall (513) or Impassable wall (515) if the feature is so close to the road edge that it cannot practically be shown as a separate symbol. The space between the black lines is filled with brown (50%). A road with two carriageways can be represented using two wide road symbols side by side, keeping only one of the road edges in the middle.',
      type: 2,
      id: r'114',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'11',
        lineWidth: 300,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'502.1',
      name: r'Wide road, 0.5 mm (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 2,
      id: r'115',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.line(
        color: r'11',
        lineWidth: 500,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'502.2',
      name: r'Road with two carriageways',
      description: r'The width should be drawn to scale, but not smaller than the minimum width (0.3 + 2*0.14 mm - footprint 8.7 m). The outer boundary lines may be replaced with other black line symbols, such as symbol Fence (516), Impassable fence (518), Wall (513) or Impassable wall (515) if the feature is so close to the road edge that it cannot practically be shown as a separate symbol. The space between the black lines is filled with brown (50%). A road with two carriageways can be represented using two wide road symbols side by side, keeping only one of the road edges in the middle.',
      type: 1,
      id: r'116',
      isHidden: false,
      geometry: null,
    ),
    IOFSymbolV3(
      code: r'503',
      name: r'Road',
      description: r'A maintained road suitable for motor vehicles in all weather. Width less than 5 m.',
      type: 2,
      id: r'117',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 350,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'504',
      name: r'Vehicle track',
      description: r'A track or poorly maintained road suitable for vehicles only when travelling slowly. For distinct junctions the dashes of the symbols are joined at the junction. For indistinct junctions the dashes of the symbols are not joined. Minimum length (isolated): two dashes (6.25 mm - footprint 94 m).',
      type: 2,
      id: r'118',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 350,
        dashed: true,
        dashLength: 3000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'505',
      name: r'Footpath',
      description: r'An easily runnable path, bicycle track or old vehicle track. For distinct junctions the dashes of the symbols are joined at the junction. For indistinct junctions the dashes of the symbols are not joined. Minimum length (isolated): two dashes (4.25 mm - footprint 64 m)',
      type: 2,
      id: r'119',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 250,
        dashed: true,
        dashLength: 2000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'506',
      name: r'Small footpath',
      description: r'A runnable small path or (temporary) forest extraction track which can be followed at competition speed. For distinct junctions the dashes of the symbols are joined at the junction. For indistinct junctions the dashes of the symbols are not joined. Minimum length (isolated): two dashes (2.25 mm - footprint 34 m).',
      type: 2,
      id: r'120',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 180,
        dashed: true,
        dashLength: 1000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'507',
      name: r'Less distinct small footpath',
      description: r'A runnable less distinct / visible small path or forestry extraction track. Minimum length: two sections of double dashes (5.3 mm - footprint 79.5 m).',
      type: 2,
      id: r'121',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 180,
        dashed: true,
        dashLength: 1000,
        breakLength: 800,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'508',
      name: r'Narrow ride',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Without background: the same runnability as the surroundings. Yellow 100%: easy running. White in green: normal runnability. Green 30%: slow running. Green 60%: walk. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 2,
      id: r'122',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: true,
        dashLength: 2000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'508.1',
      name: r'Narrow ride, easy running',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 2,
      id: r'123',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: true,
        dashLength: 2000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'508.2',
      name: r'Narrow ride, normal runnability',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 2,
      id: r'124',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: true,
        dashLength: 2000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'508.3',
      name: r'Narrow ride, slow running',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 2,
      id: r'125',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: true,
        dashLength: 2000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'508.4',
      name: r'Narrow ride, walk',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 2,
      id: r'126',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: true,
        dashLength: 2000,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'509',
      name: r'Railway',
      description: r'A railway or other kind of railed track. If it is forbidden to run along the railway, it shall be combined with symbol Out-of-bounds route (711). If it is forbidden to cross the railway, it must be combined with symbol Area that shall not be entered (520) or Out-of-bounds area (709). Minimum length (isolated): two dashes (4 mm - footprint 60 m).',
      type: 1,
      id: r'127',
      isHidden: false,
      geometry: null,
    ),
    IOFSymbolV3(
      code: r'510',
      name: r'Power line, cableway or skilift',
      description: r'Power line, cableway or skilift. The bars show the exact location of the pylons. The line may be broken to improve legibility. If a section of a power line, cableway or skilift goes along a road or path (and does not offer significant additional navigational value) it should be omitted. Minimum length (isolated): 5 mm (footprint: 75 m).',
      type: 2,
      id: r'128',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'511',
      name: r'Major power line, minimum width',
      description: r'Major power lines should be drawn with a double line. The gap between the lines may indicate the extent of the power line. The lines may be broken to improve legibility. Very large carrying masts shall be represented in plan shape using outline of symbol Building (521) or with symbol High tower (524).',
      type: 2,
      id: r'129',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 400,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'511.1',
      name: r'Major power line',
      description: r'Major power lines should be drawn with a double line. The gap between the lines may indicate the extent of the power line. The lines may be broken to improve legibility. The bars show the exact location of the pylons. Very large carrying masts shall be represented in plan shape using outline of symbol Building (521) or with symbol High tower (524).',
      type: 2,
      id: r'130',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 1340,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'511.2',
      name: r'Major power line, large carrying masts',
      description: r'Major power lines should be drawn with a double line. The gap between the lines may indicate the extent of the powerline. The bars show the exact location of the pylons. The lines may be broken to improve legibility. Very large carrying masts shall be represented in plan shape using symbol 521 (building) or with symbol 524 (high tower).',
      type: 2,
      id: r'131',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 1340,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'512',
      name: r'Bridge / tunnel',
      description: r'Bridges and tunnels are represented using the same basic symbols. If it is not possible to get through a tunnel (or under a bridge), it shall be omitted. Minimum length (of baseline): 0.4 mm (footprint 6 m). Small bridges connected to a track/path are shown by centring a track dash on the crossing. Tracks/paths are broken for water course crossings without bridges. A small footbridge with no path leading to it is represented with a single dash.',
      type: 2,
      id: r'132',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'512.1',
      name: r'Bridge / tunnel, minimum size',
      description: r'Bridges and tunnels are represented using the same basic symbols. If it is not possible to get through a tunnel (or under a bridge), it shall be omitted. Minimum length (of baseline): 0.4 mm (footprint 6 m). Small bridges connected to a track/path are shown by centring a track dash on the crossing. Tracks/paths are broken for water course crossings without bridges. A small footbridge with no path leading to it is represented with a single dash.',
      type: 1,
      id: r'133',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.5000, -0.4360), Offset(0.2000, 0.0000), Offset(-0.2000, 0.0000), Offset(-0.5000, -0.4360)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'512.2',
      name: r'Footbridge',
      description: r'A small footbridge with no path leading to it is represented with a single dash. Note: if the stream is wider than 0.25 mm, adjust this symbol so it extends 0.5 mm over both sides of the stream!',
      type: 1,
      id: r'134',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 250,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -0.6250), Offset(0.0000, 0.6250)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'513',
      name: r'Wall',
      description: r'A significant wall of stone, concrete, wood or other materials. Minimum height: 1 m. Minimum length (isolated): 1.4 mm (footprint 21 m).',
      type: 2,
      id: r'135',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'514',
      name: r'Ruined wall',
      description: r'A ruined or less distinct wall. Minimum height 0.5 m. Minimum length: two dashes (3.65 mm - footprint 55 m). If shorter, the object must be exaggerated to the minimum length or changed to symbol Wall (513).',
      type: 2,
      id: r'136',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: true,
        dashLength: 2000,
        breakLength: 350,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'515',
      name: r'Impassable wall',
      description: r'An impassable or uncrossable wall, normally more than 1.5 m high. Minimum length (isolated): 3 mm (footprint 45 m).',
      type: 2,
      id: r'137',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'516',
      name: r'Fence',
      description: r'If the fence forms an enclosed area, tags should be placed inside. Minimum length (isolated): 1.5 mm (footprint 22.5 m).',
      type: 2,
      id: r'138',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'517',
      name: r'Ruined fence',
      description: r'A ruined or less distinct fence. If the fence forms an enclosed area, tags should be placed inside. Minimum length: two dashes (3.65 mm - footprint 55 m). If shorter, the symbol must be exaggerated to the minimum length or changed to symbol Fence (516).',
      type: 2,
      id: r'139',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: true,
        dashLength: 2000,
        breakLength: 350,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'518',
      name: r'Impassable fence',
      description: r'An impassable or uncrossable fence, normally more than 1.5 m high. If the fence forms an enclosed area, tags should be placed inside. Minimum length (isolated): 2 mm (footprint 30 m).',
      type: 2,
      id: r'140',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'519',
      name: r'Crossing point',
      description: r'A way through or over a wall, fence or other linear feature, including a gate or stile. For impassable features, the line shall be broken at the crossing point. For passable features, the line shall not be broken if passing involves a degree of climb.',
      type: 1,
      id: r'141',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.3000, -0.5000), Offset(0.3000, 0.5000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 180,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3000, -0.5000), Offset(-0.3000, 0.5000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'520',
      name: r'Area that shall not be entered',
      description: r'An out-of-bounds area is a feature such as a private house, a garden, a factory or another industrial area. Only contours and prominent features such as railways and large buildings shall be shown inside an out-of-bounds area. Vertical black stripes may be used for areas where it is important to show a complete representation of the terrain (e.g. when a part of the forest is out-of-bounds). The area shall be discontinued where a path or track goes through. Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur. Course planning symbol 709 can be used for temporary out-of bounds areas. The vertical black stripes version of the symbol is orientated to north. An out-of-bounds area shall not be entered. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: r'142',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'23',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'520.1',
      name: r'Area that shall not be entered, solid colour, bounding line',
      description: r'Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur.',
      type: 2,
      id: r'143',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'520.2',
      name: r'Area that shall not be entered, stripes',
      description: r'An out-of-bounds area is a feature such as a private house, a garden, a factory or another industrial area. Only contours and prominent features such as railways and large buildings shall be shown inside an out-of-bounds area. Vertical black stripes may be used for areas where it is important to show a complete representation of the terrain (e.g. when a part of the forest is out-of-bounds). The area shall be discontinued where a path or track goes through. Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur. Course planning symbol 709 can be used for temporary out-of bounds areas. The vertical black stripes version of the symbol is orientated to north. An out-of-bounds area shall not be entered. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: r'144',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'520.3',
      name: r'Area that shall not be entered, stripes, bounding line',
      description: r'Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur.',
      type: 2,
      id: r'145',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 350,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'521',
      name: r'Building',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 4,
      id: r'146',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'8',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'521.1',
      name: r'Building, minimum size',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 1,
      id: r'147',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-0.2500, -0.2500), Offset(0.2500, -0.2500), Offset(0.2500, 0.2500), Offset(-0.2500, 0.2500), Offset(-0.2500, -0.2500)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'521.2',
      name: r'Large building with outline',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 4,
      id: r'148',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'9',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'521.3',
      name: r'Large building',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 4,
      id: r'149',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'9',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'521.4',
      name: r'Large building, outline',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 2,
      id: r'150',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 200,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'522',
      name: r'Canopy with outline',
      description: r'An accessible and runnable area with roof. Minimum area (isolated): 0.6 mm x 0.6 mm (footprint 9 m x 9 m). Minimum (inside) width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: r'151',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'10',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'522.1',
      name: r'Canopy',
      description: r'An accessible and runnable area with roof. Minimum area (isolated): 0.6 mm x 0.6 mm (footprint 9 m x 9 m). Minimum (inside) width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: r'152',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'10',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'522.2',
      name: r'Canopy, outline',
      description: r'An accessible and runnable area with roof. Minimum area (isolated): 0.6 mm x 0.6 mm (footprint 9 m x 9 m). Minimum (inside) width: 0.3 mm (footprint 4.5 m).',
      type: 2,
      id: r'153',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 100,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'523',
      name: r'Ruin',
      description: r'A ruined building. The ground plan of a ruin is shown to scale, down to the minimum size. Ruins that are so small that they cannot be drawn to scale may be represented using a solid line. Minimum area (outside measures): 0.8 mm x 0.8 mm (footprint 12 m x 12 m).',
      type: 2,
      id: r'154',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 160,
        dashed: true,
        dashLength: 500,
        breakLength: 250,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'523.1',
      name: r'Ruin, minimum size',
      description: r'A ruined building. The ground plan of a ruin is shown to scale, down to the minimum size. Ruins that are so small that they cannot be drawn to scale may be represented using a solid line. Minimum area (outside measures): 0.8 mm x 0.8 mm (footprint 12 m x 12 m).',
      type: 1,
      id: r'155',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.3200, 0.3200), Offset(0.3200, -0.3200), Offset(-0.3200, -0.3200), Offset(-0.3200, 0.3200), Offset(0.3200, 0.3200)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'524',
      name: r'High tower',
      description: r'A high tower or large pylon. If it is in a forest, it must be visible above the level of the surrounding forest.Towers with a larger footprint must be represented using symbol Building (521). The symbol is orientated to north. Footprint: 21 m in diameter.',
      type: 1,
      id: r'156',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 400,
        innerColor: r'2',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.7000, 0.0000), Offset(0.7000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -0.7000), Offset(0.0000, 0.7000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'525',
      name: r'Small tower',
      description: r'An obvious small tower, platform or seat. Location is at the centre of gravity of the symbol. The symbol is orientated to north. Footprint: 15 m x 15 m.',
      type: 1,
      id: r'157',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -0.3080), Offset(0.0000, 0.6020)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.5000, -0.3080), Offset(0.5000, -0.3080)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'526',
      name: r'Cairn',
      description: r'A prominent cairn, memorial stone, boundary stone or trigonometric point. Minimum height: 0.5 m. Footprint: 12 m in diameter.',
      type: 1,
      id: r'158',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 70,
        innerColor: r'2',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.point(
            innerRadius: 240,
            innerColor: r'-1',
            outerColor: r'2',
            rotatable: false,
            elements: null,
          ),
          coords: [Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'527',
      name: r'Fodder rack',
      description: r'A fodder rack, which is free standing or attached to a tree. Location is at the centre of gravity of the symbol. The symbol is orientated to north. Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: r'159',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -0.2740), Offset(0.0000, 0.5460)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.4100, -0.0370), Offset(0.0000, -0.2740), Offset(0.4100, -0.0370)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'528',
      name: r'Prominent line feature',
      description: r'A prominent man-made line feature. For example, a low pipeline (gas, water, oil, heat, etc.) or a bobsleigh / skeleton track that is clearly visible. The definition of the symbol must be given on the map. Minimum length: 1.5 mm (footprint 22.5 m).',
      type: 2,
      id: r'160',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 140,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'529',
      name: r'Prominent impassable line feature',
      description: r'An impassable man-made line feature. For example, a high pipeline (gas, water, oil, heat, etc.) or a bobsleigh / skeleton track. The definition of the symbol must be given on the map. Minimum length: 2 mm (footprint 30 m).',
      type: 2,
      id: r'161',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'530',
      name: r'Prominent man-made feature – ring',
      description: r'Location is at the centre of gravity of the symbol. The definition of the symbol must be given on the map. Footprint: 12 m in diameter.',
      type: 1,
      id: r'162',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 240,
        innerColor: r'-1',
        outerColor: r'2',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'531',
      name: r'Prominent man-made feature – x',
      description: r'Location is at the centre of gravity of the symbol. The symbol is orientated to north. The definition of the symbol must be given on the map. Footprint: 12 m x 12 m.',
      type: 1,
      id: r'163',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-0.3440, -0.3440), Offset(0.3440, 0.3440)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'2',
            lineWidth: 160,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.3440, -0.3440), Offset(-0.3440, 0.3440)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'532',
      name: r'Stairway',
      description: r'A distinct stairway through the terrain which helps to climb very steep slopes or to cross over impassable objects. A stairway going through rock passages or between impassable objects may be drawn without border lines. An easily runnable stairway or indistinct stairway should be drawn as a footpath. Steps of a stairway shall be represented in a generalized manner. Minimum length: 3 (graphical) steps. Minimum width: 0.4 mm (IM).',
      type: 2,
      id: r'164',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'22',
        lineWidth: 400,
        dashed: false,
        dashLength: 1067,
        breakLength: 267,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'532.1',
      name: r'Stairway, without border lines',
      description: r'A distinct stairway through the terrain which helps to climb very steep slopes or to cross over impassable objects. A stairway going through rock passages or between impassable objects may be drawn without border lines. An easily runnable stairway or indistinct stairway should be drawn as a footpath. Steps of a stairway shall be represented in a generalized manner.',
      type: 2,
      id: r'165',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'22',
        lineWidth: 400,
        dashed: false,
        dashLength: 1067,
        breakLength: 267,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'601.1',
      name: r'Magnetic north line',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 2,
      id: r'166',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'2',
        lineWidth: 100,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'601.2',
      name: r'North lines pattern',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 4,
      id: r'167',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'601.3',
      name: r'Magnetic north line, blue',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 2,
      id: r'168',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'5',
        lineWidth: 180,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'601.4',
      name: r'North lines pattern, blue',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 4,
      id: r'169',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'602',
      name: r'Registration mark',
      description: r'At least three registration marks may be placed in the corners of the map. These can be used for printing courses on already printed maps. In addition, it allows a check of colour registration when printing colours separately.',
      type: 1,
      id: r'170',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'-900',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -2.0000), Offset(0.0000, 2.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'-900',
            lineWidth: 100,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-2.0000, 0.0000), Offset(2.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'603.0',
      name: r'Spot height, dot',
      description: r'Spot heights are used for the rough assessment of height differences. The height is given to the nearest metre. Water levels are given without the dot. Spot heights must only be used where they do not conflict with other symbols.',
      type: 1,
      id: r'171',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 150,
        innerColor: r'2',
        outerColor: r'-1',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'603.1',
      name: r'Spot height, text',
      description: r'Spot heights are used for the rough assessment of height differences. The height is given to the nearest metre. Water levels are given without the dot. Spot heights must only be used where they do not conflict with other symbols.',
      type: 8,
      id: r'172',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.text(
        color: r'2',
        fontSize: 2095,
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'701',
      name: r'Start',
      description: r'The place where the orienteering starts. The centre of the triangle shows the precise position where the orienteering course starts. The start must be on a clearly identifiable point on the map. The triangle points in the direction of the first control.',
      type: 1,
      id: r'173',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 857,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'7',
            lineWidth: 350,
            dashed: false,
            dashLength: 3429,
            breakLength: 857,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-2.6970, 1.5570), Offset(0.0000, -3.1140), Offset(2.6970, 1.5570), Offset(-2.6970, 1.5570)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'702',
      name: r'Map issue point',
      description: r'If there is a marked route to the start point, the map issue point is marked using this symbol.',
      type: 1,
      id: r'174',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 600,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-1.2500, 0.0000), Offset(1.2500, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'703',
      name: r'Control point',
      description: r'For point features, the centre of the circle shall be the centre of the symbol. For line and area features, the centre of the circle shows the precise position of the control marker. Controls shall only be placed on points that are clearly identifiable on the map. Sections of the circle should be omitted to leave important detail showing. Footprint 75 m',
      type: 1,
      id: r'175',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 2325,
        innerColor: r'-1',
        outerColor: r'7',
        rotatable: false,
        elements: null,
      ),
    ),
    IOFSymbolV3(
      code: r'704',
      name: r'Control number',
      description: r'The number of the control is placed close to the control point circle in such a way that it does not obscure important detail. The numbers are orientated to north.',
      type: 8,
      id: r'176',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.text(
        color: r'0',
        fontSize: 5588,
        rotatable: true,
      ),
    ),
    IOFSymbolV3(
      code: r'705',
      name: r'Course line',
      description: r'Where controls are to be visited in order, the sequence is shown using straight lines from the start to the first control and then from each control to the next one. Sections of lines should be omitted to leave important detail showing. The line should be drawn via mandatory crossing points. There should be gaps between the line and the control circle in order to increase the readability of the underlying detail close to the control.',
      type: 2,
      id: r'177',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.line(
        color: r'7',
        lineWidth: 350,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'706',
      name: r'Finish',
      description: r'The end of the course.',
      type: 1,
      id: r'178',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1825,
        innerColor: r'-1',
        outerColor: r'7',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.point(
            innerRadius: 2825,
            innerColor: r'-1',
            outerColor: r'7',
            rotatable: false,
            elements: null,
          ),
          coords: [Offset(0.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'707',
      name: r'Marked route',
      description: r'A marked route that is a part of the course. It is mandatory to follow the marked route. Minimum length: 2 dashes (4.5 mm – footprint: 67.5 m).',
      type: 2,
      id: r'179',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.line(
        color: r'0',
        lineWidth: 350,
        dashed: true,
        dashLength: 2000,
        breakLength: 500,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'708',
      name: r'Out-of-bounds boundary',
      description: r'A boundary which it is not permitted to cross. An out-of-bounds boundary shall not be crossed. Minimum length: 1 mm (footprint: 15 m).',
      type: 2,
      id: r'180',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.line(
        color: r'7',
        lineWidth: 700,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'709',
      name: r'Out-of-bounds area',
      description: r'An out-of-bounds area. A bounding line may be drawn if there is no natural boundary, as follows: – a solid line indicates that the boundary is marked continuously (tapes, etc.) in the terrain, – a dashed line indicates intermittent marking in the terrain, – no line indicates no marking in the terrain. An out-of-bounds area shall not be entered. Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: r'181',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.area(
        innerColor: r'-1',
        rotatable: false,
      ),
    ),
    IOFSymbolV3(
      code: r'709.1',
      name: r'Out-of-bounds area, solid boundary',
      description: r'A solid line indicates that the boundary is marked continuously (tapes, etc.) on the ground.',
      type: 2,
      id: r'182',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.line(
        color: r'0',
        lineWidth: 250,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'709.2',
      name: r'Out-of-bounds area, dashed boundary',
      description: r'A dashed line indicates intermittent marking on the ground.',
      type: 2,
      id: r'183',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.line(
        color: r'0',
        lineWidth: 250,
        dashed: true,
        dashLength: 3000,
        breakLength: 500,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'710',
      name: r'Crossing point',
      description: r'A crossing point, for instance through or over a wall or fence, across a road or railway, through a tunnel or out-of-bounds area, or over an uncrossable boundary is drawn on the map with two lines curving outwards. The lines shall reflect the length of the crossing.',
      type: 1,
      id: r'184',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'7',
            lineWidth: 350,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-1.5000, 0.7500), Offset(-0.5000, 0.4750), Offset(0.5000, 0.4750), Offset(1.5000, 0.7500)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'7',
            lineWidth: 350,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-1.5000, -0.7500), Offset(-0.5000, -0.4750), Offset(0.5000, -0.4750), Offset(1.5000, -0.7500)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'711',
      name: r'Out-of-bounds route',
      description: r'A route which is out-of-bounds. Competitors are allowed to cross directly over a forbidden route, but it is forbidden to go along it. An out-of-bounds route shall not be used. Minimum length: 2 symbols (6 mm – footprint 90 m).',
      type: 2,
      id: r'185',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 0,
        dashed: false,
        dashLength: 4000,
        breakLength: 1000,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'711.1',
      name: r'Out-of-bounds route, single cross',
      description: r'A route which is out-of-bounds. Competitors are allowed to cross directly over a forbidden route, but it is forbidden to go along it. An out-of-bounds route shall not be used. Minimum length: 2 symbols (6 mm – footprint 90 m).',
      type: 1,
      id: r'186',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: true,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 350,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(1.0610, -1.0610), Offset(-1.0610, 1.0610)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 350,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(1.0610, 1.0610), Offset(-1.0610, -1.0610)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'712',
      name: r'First aid post',
      description: r'The location of a first aid post.',
      type: 1,
      id: r'187',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 1330,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(-2.0000, 0.0000), Offset(2.0000, 0.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 1330,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -2.0000), Offset(0.0000, 2.0000)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'713',
      name: r'Refreshment point',
      description: r'The location of a refreshment point which is not at a control.',
      type: 1,
      id: r'188',
      isHidden: true,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 1000,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 400,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'1',
          ),
          coords: [Offset(-1.3400, -1.3950), Offset(-0.8200, 1.3800)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 400,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'1',
            capStyle: r'1',
          ),
          coords: [Offset(1.3400, -1.3950), Offset(0.8200, 1.3800)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 400,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'2',
            capStyle: r'0',
          ),
          coords: [Offset(0.0000, -1.7700), Offset(0.6000, -1.7700), Offset(1.2000, -1.6200), Offset(1.3400, -1.3950), Offset(1.2000, -1.1700), Offset(0.6000, -1.0200), Offset(0.0000, -1.0200), Offset(-0.6000, -1.0200), Offset(-1.2000, -1.1700), Offset(-1.3400, -1.3950), Offset(-1.2000, -1.6200), Offset(-0.6000, -1.7700), Offset(0.0000, -1.7700)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.line(
            color: r'0',
            lineWidth: 400,
            dashed: false,
            dashLength: 4000,
            breakLength: 1000,
            joinStyle: r'2',
            capStyle: r'1',
          ),
          coords: [Offset(-0.8200, 1.3800), Offset(-0.6800, 1.6800), Offset(0.6800, 1.6800), Offset(0.8200, 1.3800)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
    IOFSymbolV3(
      code: r'799',
      name: r'Simple Orienteering Course',
      description: r'This symbol provides a simple and quick way to make training courses. The purple line will extend a bit into the finish symbol. This is a shortcoming of this simple approach.',
      type: 2,
      id: r'189',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.line(
        color: r'-1',
        lineWidth: 0,
        dashed: false,
        dashLength: 1000,
        breakLength: 1450,
        joinStyle: r'1',
        capStyle: r'0',
      ),
    ),
    IOFSymbolV3(
      code: r'999',
      name: r'OpenOrienteering Logo',
      description: r'The OpenOrienteering Logo.',
      type: 1,
      id: r'190',
      isHidden: false,
      geometry: IOFSymbolGeometryV3.point(
        innerRadius: 250,
        innerColor: r'-1',
        outerColor: r'-1',
        rotatable: false,
        elements: [
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'24',
            rotatable: false,
          ),
          coords: [Offset(-12.7970, -0.5570), Offset(-12.7550, -0.4470), Offset(-12.7700, -0.4200), Offset(-12.8730, -0.4200), Offset(-12.9530, -0.4200), Offset(-12.9730, -0.4400), Offset(-12.9730, -0.5200), Offset(-12.9730, -0.6350), Offset(-12.8380, -0.6630), Offset(-12.7970, -0.5570)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'24',
            rotatable: false,
          ),
          coords: [Offset(-0.9330, 2.0630), Offset(-0.9330, 1.9250), Offset(-0.9200, 1.9000), Offset(-0.8510, 1.9000), Offset(-0.7800, 1.9000), Offset(-0.7700, 1.9210), Offset(-0.7810, 2.0500), Offset(-0.7890, 2.1540), Offset(-0.8140, 2.2030), Offset(-0.8630, 2.2130), Offset(-0.9200, 2.2240), Offset(-0.9330, 2.1970), Offset(-0.9330, 2.0630), Offset(-0.9330, 2.0630)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-8.8750, -3.8600), Offset(-8.9220, -3.9200), Offset(-8.9840, -3.9680), Offset(-9.0610, -4.0060), Offset(-9.1340, -4.0450), Offset(-9.2250, -4.0650), Offset(-9.3370, -4.0650), Offset(-9.4440, -4.0650), Offset(-9.5350, -4.0450), Offset(-9.6120, -4.0060), Offset(-9.6880, -3.9740), Offset(-9.7520, -3.9270), Offset(-9.8030, -3.8670), Offset(-9.8550, -3.8070), Offset(-9.8950, -3.7370), Offset(-9.9250, -3.6550), Offset(-9.9500, -3.5780), Offset(-9.9700, -3.5000), Offset(-9.9820, -3.4180), Offset(-8.7230, -3.4180), Offset(-8.7250, -3.5000), Offset(-8.7400, -3.5780), Offset(-8.7680, -3.6550), Offset(-8.7890, -3.7320), Offset(-8.8240, -3.8000), Offset(-8.8750, -3.8600)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'17',
            rotatable: false,
          ),
          coords: [Offset(-4.2300, -3.9230), Offset(-4.1830, -3.7370), Offset(-4.1600, -3.5270), Offset(-4.1600, -3.2960), Offset(-4.1600, -1.3950), Offset(-5.1130, -1.3950), Offset(-5.1130, -3.1820), Offset(-5.1130, -3.4880), Offset(-5.1550, -3.7070), Offset(-5.2350, -3.8330), Offset(-5.3170, -3.9610), Offset(-5.4680, -4.0270), Offset(-5.6900, -4.0270), Offset(-5.7590, -4.0270), Offset(-5.8300, -4.0210), Offset(-5.9070, -4.0130), Offset(-5.9830, -4.0080), Offset(-6.0520, -4.0040), Offset(-6.1120, -3.9930), Offset(-6.1120, -1.3950), Offset(-7.0640, -1.3950), Offset(-7.0640, -4.6460), Offset(-6.9030, -4.6930), Offset(-6.6940, -4.7360), Offset(-6.4380, -4.7740), Offset(-6.1810, -4.8180), Offset(-5.9130, -4.8380), Offset(-5.6310, -4.8380), Offset(-5.3470, -4.8380), Offset(-5.1100, -4.8000), Offset(-4.9210, -4.7230), Offset(-4.7300, -4.6520), Offset(-4.5790, -4.5470), Offset(-4.4670, -4.4100), Offset(-4.3570, -4.2730), Offset(-4.2770, -4.1110), Offset(-4.2300, -3.9230)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(-13.5240, 1.1180), Offset(-13.6050, 1.1260), Offset(-13.6670, 1.1370), Offset(-13.7080, 1.1500), Offset(-13.7080, 3.7220), Offset(-14.6620, 3.7220), Offset(-14.6620, 0.5360), Offset(-14.4920, 0.4760), Offset(-14.2920, 0.4200), Offset(-14.0600, 0.3690), Offset(-13.8270, 0.3140), Offset(-13.5650, 0.2860), Offset(-13.2800, 0.2860), Offset(-13.2290, 0.2860), Offset(-13.1670, 0.2900), Offset(-13.0960, 0.2990), Offset(-13.0220, 0.3030), Offset(-12.9510, 0.3120), Offset(-12.8780, 0.3250), Offset(-12.8060, 0.3330), Offset(-12.7330, 0.3450), Offset(-12.6600, 0.3630), Offset(-12.5870, 0.3750), Offset(-12.5260, 0.3920), Offset(-12.4740, 0.4140), Offset(-12.6340, 1.2010), Offset(-12.7190, 1.1800), Offset(-12.8190, 1.1580), Offset(-12.9360, 1.1370), Offset(-13.0510, 1.1120), Offset(-13.1740, 1.0980), Offset(-13.3060, 1.0980), Offset(-13.3660, 1.0980), Offset(-13.4390, 1.1050), Offset(-13.5240, 1.1180)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(-11.0930, -0.2000), Offset(-11.2040, -0.1010), Offset(-11.3360, -0.0520), Offset(-11.4900, -0.0520), Offset(-11.6420, -0.0520), Offset(-11.7770, -0.1010), Offset(-11.8930, -0.2000), Offset(-12.0040, -0.3030), Offset(-12.0590, -0.4410), Offset(-12.0590, -0.6160), Offset(-12.0590, -0.7910), Offset(-12.0040, -0.9270), Offset(-11.8930, -1.0260), Offset(-11.7770, -1.1280), Offset(-11.6420, -1.1790), Offset(-11.4900, -1.1790), Offset(-11.3360, -1.1790), Offset(-11.2040, -1.1280), Offset(-11.0930, -1.0260), Offset(-10.9780, -0.9270), Offset(-10.9200, -0.7910), Offset(-10.9200, -0.6160), Offset(-10.9200, -0.4410), Offset(-10.9780, -0.3030), Offset(-11.0930, -0.2000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(-11.0090, 3.7220), Offset(-11.9630, 3.7220), Offset(-11.9630, 0.3570), Offset(-11.0090, 0.3570), Offset(-11.0090, 3.7220)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-8.6490, 1.0530), Offset(-8.7550, 1.0530), Offset(-8.8470, 1.0730), Offset(-8.9240, 1.1120), Offset(-9.0010, 1.1450), Offset(-9.0650, 1.1920), Offset(-9.1150, 1.2520), Offset(-9.1670, 1.3120), Offset(-9.2070, 1.3810), Offset(-9.2370, 1.4640), Offset(-9.2640, 1.5390), Offset(-9.2820, 1.6180), Offset(-9.2960, 1.7000), Offset(-8.0340, 1.7000), Offset(-8.0390, 1.6180), Offset(-8.0540, 1.5390), Offset(-8.0790, 1.4640), Offset(-8.1010, 1.3870), Offset(-8.1370, 1.3180), Offset(-8.1890, 1.2590), Offset(-8.2360, 1.1990), Offset(-8.2970, 1.1500), Offset(-8.3740, 1.1120), Offset(-8.4450, 1.0730), Offset(-8.5370, 1.0530), Offset(-8.6490, 1.0530)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(-5.2200, 1.1050), Offset(-5.2970, 1.1100), Offset(-5.3650, 1.1150), Offset(-5.4250, 1.1250), Offset(-5.4250, 3.7220), Offset(-6.3780, 3.7220), Offset(-6.3780, 0.4720), Offset(-6.2170, 0.4250), Offset(-6.0070, 0.3820), Offset(-5.7510, 0.3440), Offset(-5.4950, 0.3010), Offset(-5.2270, 0.2800), Offset(-4.9450, 0.2800), Offset(-4.6580, 0.2800), Offset(-4.4220, 0.3180), Offset(-4.2350, 0.3950), Offset(-4.0420, 0.4670), Offset(-3.8900, 0.5720), Offset(-3.7810, 0.7090), Offset(-3.6690, 0.8450), Offset(-3.5910, 1.0070), Offset(-3.5440, 1.1950), Offset(-3.4970, 1.3810), Offset(-3.4740, 1.5920), Offset(-3.4740, 1.8210), Offset(-3.4740, 3.7220), Offset(-4.4270, 3.7220), Offset(-4.4270, 1.9370), Offset(-4.4270, 1.6300), Offset(-4.4670, 1.4110), Offset(-4.5490, 1.2850), Offset(-4.6280, 1.1560), Offset(-4.7800, 1.0920), Offset(-5.0020, 1.0920), Offset(-5.0700, 1.0920), Offset(-5.1430, 1.0970), Offset(-5.2200, 1.1050)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(-2.6360, 2.3460), Offset(-2.6360, -0.4810), Offset(-1.6830, -0.6340), Offset(-1.6830, 0.3570), Offset(-0.5390, 0.3570), Offset(-0.5390, 1.1500), Offset(-1.6830, 1.1500), Offset(-1.6830, 2.3330), Offset(-1.6830, 2.5350), Offset(-1.6480, 2.6940), Offset(-1.5810, 2.8130), Offset(-1.5080, 2.9330), Offset(-1.3650, 2.9930), Offset(-1.1510, 2.9930), Offset(-1.0500, 2.9930), Offset(-0.9450, 2.9840), Offset(-0.8380, 2.9660), Offset(-0.7280, 2.9460), Offset(-0.6270, 2.9180), Offset(-0.5390, 2.8840), Offset(-0.4040, 3.6260), Offset(-0.5180, 3.6730), Offset(-0.6460, 3.7120), Offset(-0.7870, 3.7480), Offset(-0.9280, 3.7800), Offset(-1.1020, 3.7990), Offset(-1.3050, 3.7990), Offset(-1.5660, 3.7990), Offset(-1.7810, 3.7640), Offset(-1.9510, 3.6960), Offset(-2.1230, 3.6240), Offset(-2.2590, 3.5260), Offset(-2.3610, 3.4020), Offset(-2.4630, 3.2740), Offset(-2.5360, 3.1210), Offset(-2.5790, 2.9410), Offset(-2.6180, 2.7630), Offset(-2.6360, 2.5650), Offset(-2.6360, 2.3460)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(2.1420, 1.4640), Offset(2.1210, 1.3870), Offset(2.0840, 1.3180), Offset(2.0320, 1.2590), Offset(1.9860, 1.1990), Offset(1.9240, 1.1500), Offset(1.8470, 1.1120), Offset(1.7760, 1.0730), Offset(1.6850, 1.0530), Offset(1.5720, 1.0530), Offset(1.4660, 1.0530), Offset(1.3750, 1.0730), Offset(1.2980, 1.1120), Offset(1.2210, 1.1450), Offset(1.1560, 1.1920), Offset(1.1060, 1.2520), Offset(1.0540, 1.3120), Offset(1.0140, 1.3810), Offset(0.9840, 1.4640), Offset(0.9580, 1.5390), Offset(0.9390, 1.6180), Offset(0.9260, 1.7000), Offset(2.1870, 1.7000), Offset(2.1830, 1.6180), Offset(2.1680, 1.5390), Offset(2.1420, 1.4640)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(5.9230, 1.7000), Offset(5.9190, 1.6180), Offset(5.9040, 1.5390), Offset(5.8780, 1.4640), Offset(5.8560, 1.3870), Offset(5.8210, 1.3180), Offset(5.7690, 1.2590), Offset(5.7230, 1.1990), Offset(5.6610, 1.1500), Offset(5.5850, 1.1120), Offset(5.5110, 1.0730), Offset(5.4190, 1.0530), Offset(5.3080, 1.0530), Offset(5.2010, 1.0530), Offset(5.1100, 1.0730), Offset(5.0330, 1.1120), Offset(4.9570, 1.1450), Offset(4.8930, 1.1920), Offset(4.8410, 1.2520), Offset(4.7900, 1.3120), Offset(4.7500, 1.3810), Offset(4.7200, 1.4640), Offset(4.6950, 1.5390), Offset(4.6750, 1.6180), Offset(4.6630, 1.7000), Offset(5.9230, 1.7000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(8.7180, 1.1180), Offset(8.6370, 1.1260), Offset(8.5750, 1.1370), Offset(8.5340, 1.1500), Offset(8.5340, 3.7220), Offset(7.5810, 3.7220), Offset(7.5810, 0.5360), Offset(7.7500, 0.4760), Offset(7.9500, 0.4200), Offset(8.1820, 0.3690), Offset(8.4150, 0.3140), Offset(8.6770, 0.2860), Offset(8.9620, 0.2860), Offset(9.0130, 0.2860), Offset(9.0750, 0.2900), Offset(9.1460, 0.2990), Offset(9.2200, 0.3030), Offset(9.2920, 0.3120), Offset(9.3650, 0.3250), Offset(9.4370, 0.3330), Offset(9.5100, 0.3450), Offset(9.5830, 0.3630), Offset(9.6550, 0.3750), Offset(9.7170, 0.3920), Offset(9.7680, 0.4140), Offset(9.6080, 1.2010), Offset(9.5230, 1.1800), Offset(9.4240, 1.1580), Offset(9.3060, 1.1370), Offset(9.1910, 1.1120), Offset(9.0690, 1.0980), Offset(8.9370, 1.0980), Offset(8.8770, 1.0980), Offset(8.8040, 1.1050), Offset(8.7180, 1.1180)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(10.3500, -0.2000), Offset(10.2380, -0.3030), Offset(10.1830, -0.4410), Offset(10.1830, -0.6160), Offset(10.1830, -0.7910), Offset(10.2380, -0.9270), Offset(10.3500, -1.0260), Offset(10.4650, -1.1280), Offset(10.6000, -1.1790), Offset(10.7520, -1.1790), Offset(10.9060, -1.1790), Offset(11.0380, -1.1280), Offset(11.1490, -1.0260), Offset(11.2640, -0.9270), Offset(11.3230, -0.7910), Offset(11.3230, -0.6160), Offset(11.3230, -0.4410), Offset(11.2640, -0.3030), Offset(11.1490, -0.2000), Offset(11.0380, -0.1010), Offset(10.9060, -0.0520), Offset(10.7520, -0.0520), Offset(10.6000, -0.0520), Offset(10.4650, -0.1010), Offset(10.3500, -0.2000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(11.2330, 3.7220), Offset(10.2790, 3.7220), Offset(10.2790, 0.3570), Offset(11.2330, 0.3570), Offset(11.2330, 3.7220)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(14.7260, 0.7090), Offset(14.8360, 0.8450), Offset(14.9160, 1.0070), Offset(14.9630, 1.1950), Offset(15.0100, 1.3810), Offset(15.0330, 1.5920), Offset(15.0330, 1.8210), Offset(15.0330, 3.7220), Offset(14.0800, 3.7220), Offset(14.0800, 1.9370), Offset(14.0800, 1.6300), Offset(14.0390, 1.4110), Offset(13.9580, 1.2850), Offset(13.8760, 1.1560), Offset(13.7250, 1.0920), Offset(13.5040, 1.0920), Offset(13.4350, 1.0920), Offset(13.3630, 1.0970), Offset(13.2870, 1.1050), Offset(13.2100, 1.1100), Offset(13.1420, 1.1150), Offset(13.0820, 1.1250), Offset(13.0820, 3.7220), Offset(12.1290, 3.7220), Offset(12.1290, 0.4720), Offset(12.2900, 0.4250), Offset(12.4990, 0.3820), Offset(12.7560, 0.3440), Offset(13.0120, 0.3010), Offset(13.2800, 0.2800), Offset(13.5620, 0.2800), Offset(13.8470, 0.2800), Offset(14.0830, 0.3180), Offset(14.2720, 0.3950), Offset(14.4630, 0.4670), Offset(14.6140, 0.5720), Offset(14.7260, 0.7090)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'17',
            rotatable: false,
          ),
          coords: [Offset(-17.0510, -1.3070), Offset(-17.2990, -1.3070), Offset(-17.5250, -1.3490), Offset(-17.7290, -1.4340), Offset(-17.9310, -1.5210), Offset(-18.1020, -1.6390), Offset(-18.2470, -1.7940), Offset(-18.3920, -1.9510), Offset(-18.5050, -2.1390), Offset(-18.5870, -2.3550), Offset(-18.6690, -2.5790), Offset(-18.7080, -2.8200), Offset(-18.7080, -3.0850), Offset(-18.7080, -3.3500), Offset(-18.6690, -3.5910), Offset(-18.5870, -3.8080), Offset(-18.5020, -4.0270), Offset(-18.3870, -4.2110), Offset(-18.2420, -4.3650), Offset(-18.0920, -4.5180), Offset(-17.9170, -4.6380), Offset(-17.7170, -4.7230), Offset(-17.5120, -4.8080), Offset(-17.2910, -4.8510), Offset(-17.0510, -4.8510), Offset(-16.8080, -4.8510), Offset(-16.5860, -4.8080), Offset(-16.3860, -4.7230), Offset(-16.1820, -4.6380), Offset(-16.0060, -4.5180), Offset(-15.8610, -4.3650), Offset(-15.7160, -4.2110), Offset(-15.6030, -4.0270), Offset(-15.5230, -3.8080), Offset(-15.4420, -3.5910), Offset(-15.4010, -3.3500), Offset(-15.4010, -3.0850), Offset(-15.4010, -2.8200), Offset(-15.4400, -2.5790), Offset(-15.5170, -2.3550), Offset(-15.5930, -2.1390), Offset(-15.7030, -1.9510), Offset(-15.8480, -1.7940), Offset(-15.9930, -1.6390), Offset(-16.1680, -1.5210), Offset(-16.3730, -1.4340), Offset(-16.5740, -1.3490), Offset(-16.8000, -1.3070), Offset(-17.0510, -1.3070), Offset(-17.0510, -2.1260), Offset(-16.8340, -2.1260), Offset(-16.6680, -2.2100), Offset(-16.5520, -2.3830), Offset(-16.4330, -2.5570), Offset(-16.3730, -2.7920), Offset(-16.3730, -3.0850), Offset(-16.3730, -3.3800), Offset(-16.4330, -3.6100), Offset(-16.5520, -3.7770), Offset(-16.6680, -3.9460), Offset(-16.8340, -4.0340), Offset(-17.0510, -4.0340), Offset(-17.2690, -4.0340), Offset(-17.4370, -3.9460), Offset(-17.5570, -3.7770), Offset(-17.6750, -3.6100), Offset(-17.7360, -3.3800), Offset(-17.7360, -3.0850), Offset(-17.7360, -2.7920), Offset(-17.6750, -2.5570), Offset(-17.5570, -2.3830), Offset(-17.4370, -2.2100), Offset(-17.2690, -2.1260), Offset(-17.0510, -2.1260)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'17',
            rotatable: false,
          ),
          coords: [Offset(-14.6620, -0.2130), Offset(-14.6620, -4.6460), Offset(-14.5760, -4.6730), Offset(-14.4780, -4.6970), Offset(-14.3690, -4.7160), Offset(-14.2570, -4.7430), Offset(-14.1420, -4.7650), Offset(-14.0220, -4.7810), Offset(-13.8980, -4.7980), Offset(-13.7760, -4.8110), Offset(-13.6520, -4.8190), Offset(-13.5240, -4.8330), Offset(-13.4020, -4.8380), Offset(-13.2870, -4.8380), Offset(-13.0090, -4.8380), Offset(-12.7630, -4.7960), Offset(-12.5440, -4.7110), Offset(-12.3280, -4.6300), Offset(-12.1440, -4.5130), Offset(-11.9950, -4.3580), Offset(-11.8460, -4.2100), Offset(-11.7320, -4.0270), Offset(-11.6570, -3.8080), Offset(-11.5740, -3.5910), Offset(-11.5350, -3.3480), Offset(-11.5350, -3.0780), Offset(-11.5350, -2.8190), Offset(-11.5660, -2.5820), Offset(-11.6290, -2.3680), Offset(-11.6940, -2.1560), Offset(-11.7880, -1.9720), Offset(-11.9110, -1.8190), Offset(-12.0340, -1.6660), Offset(-12.1890, -1.5460), Offset(-12.3730, -1.4610), Offset(-12.5560, -1.3760), Offset(-12.7650, -1.3330), Offset(-13.0060, -1.3330), Offset(-13.1370, -1.3330), Offset(-13.2610, -1.3460), Offset(-13.3770, -1.3710), Offset(-13.4920, -1.3950), Offset(-13.6020, -1.4320), Offset(-13.7080, -1.4790), Offset(-13.7080, -0.2130), Offset(-14.6620, -0.2130), Offset(-13.1840, -2.1390), Offset(-12.7330, -2.1390), Offset(-12.5060, -2.4430), Offset(-12.5060, -3.0540), Offset(-12.5060, -3.3480), Offset(-12.5720, -3.5820), Offset(-12.7040, -3.7560), Offset(-12.8370, -3.9360), Offset(-13.0320, -4.0270), Offset(-13.2930, -4.0270), Offset(-13.3790, -4.0270), Offset(-13.4570, -4.0210), Offset(-13.5300, -4.0130), Offset(-13.6020, -4.0080), Offset(-13.6620, -4.0040), Offset(-13.7080, -3.9930), Offset(-13.7080, -2.2740), Offset(-13.6480, -2.2340), Offset(-13.5720, -2.2020), Offset(-13.4790, -2.1770), Offset(-13.3810, -2.1520), Offset(-13.2820, -2.1390), Offset(-13.1840, -2.1390)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'17',
            rotatable: false,
          ),
          coords: [Offset(-9.1820, -1.3070), Offset(-9.4850, -1.3070), Offset(-9.7500, -1.3520), Offset(-9.9760, -1.4400), Offset(-10.1980, -1.5300), Offset(-10.3830, -1.6520), Offset(-10.5330, -1.8060), Offset(-10.6780, -1.9640), Offset(-10.7870, -2.1490), Offset(-10.8580, -2.3620), Offset(-10.9260, -2.5750), Offset(-10.9620, -2.8070), Offset(-10.9620, -3.0540), Offset(-10.9620, -3.3520), Offset(-10.9170, -3.6120), Offset(-10.8270, -3.8330), Offset(-10.7330, -4.0600), Offset(-10.6110, -4.2480), Offset(-10.4620, -4.3960), Offset(-10.3140, -4.5470), Offset(-10.1410, -4.6600), Offset(-9.9500, -4.7360), Offset(-9.7540, -4.8130), Offset(-9.5530, -4.8510), Offset(-9.3490, -4.8510), Offset(-8.8720, -4.8510), Offset(-8.4940, -4.7050), Offset(-8.2170, -4.4100), Offset(-7.9390, -4.1200), Offset(-7.8010, -3.6920), Offset(-7.8010, -3.1230), Offset(-7.8010, -3.0690), Offset(-7.8030, -3.0070), Offset(-7.8080, -2.9390), Offset(-7.8100, -2.8730), Offset(-7.8160, -2.8170), Offset(-7.8190, -2.7660), Offset(-9.9820, -2.7660), Offset(-9.9610, -2.5690), Offset(-9.8700, -2.4130), Offset(-9.7070, -2.2990), Offset(-9.5450, -2.1840), Offset(-9.3270, -2.1260), Offset(-9.0550, -2.1260), Offset(-8.8810, -2.1260), Offset(-8.7080, -2.1410), Offset(-8.5420, -2.1710), Offset(-8.3720, -2.2050), Offset(-8.2340, -2.2460), Offset(-8.1270, -2.2920), Offset(-7.9990, -1.5170), Offset(-8.0510, -1.4930), Offset(-8.1190, -1.4680), Offset(-8.2040, -1.4400), Offset(-8.2890, -1.4160), Offset(-8.3850, -1.3950), Offset(-8.4920, -1.3780), Offset(-8.5940, -1.3560), Offset(-8.7060, -1.3390), Offset(-8.8240, -1.3260), Offset(-8.9440, -1.3140), Offset(-9.0630, -1.3070), Offset(-9.1820, -1.3070), Offset(-9.9820, -3.4180), Offset(-8.7230, -3.4180), Offset(-8.7250, -3.5000), Offset(-8.7400, -3.5780), Offset(-8.7680, -3.6550), Offset(-8.7890, -3.7320), Offset(-8.8240, -3.8000), Offset(-8.8750, -3.8600), Offset(-8.9220, -3.9200), Offset(-8.9840, -3.9680), Offset(-9.0610, -4.0060), Offset(-9.1340, -4.0450), Offset(-9.2250, -4.0650), Offset(-9.3370, -4.0650), Offset(-9.4440, -4.0650), Offset(-9.5350, -4.0450), Offset(-9.6120, -4.0060), Offset(-9.6880, -3.9740), Offset(-9.7520, -3.9270), Offset(-9.8030, -3.8670), Offset(-9.8550, -3.8070), Offset(-9.8950, -3.7370), Offset(-9.9250, -3.6550), Offset(-9.9500, -3.5780), Offset(-9.9700, -3.5000), Offset(-9.9820, -3.4180)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-17.0510, -2.1260), Offset(-17.2690, -2.1260), Offset(-17.4370, -2.2100), Offset(-17.5570, -2.3830), Offset(-17.6750, -2.5570), Offset(-17.7360, -2.7920), Offset(-17.7360, -3.0850), Offset(-17.7360, -3.3800), Offset(-17.6750, -3.6100), Offset(-17.5570, -3.7770), Offset(-17.4370, -3.9460), Offset(-17.2690, -4.0340), Offset(-17.0510, -4.0340), Offset(-16.8340, -4.0340), Offset(-16.6680, -3.9460), Offset(-16.5520, -3.7770), Offset(-16.4330, -3.6100), Offset(-16.3730, -3.3800), Offset(-16.3730, -3.0850), Offset(-16.3730, -2.7920), Offset(-16.4330, -2.5570), Offset(-16.5520, -2.3830), Offset(-16.6680, -2.2100), Offset(-16.8340, -2.1260), Offset(-17.0510, -2.1260), Offset(-17.0640, -2.5930), Offset(-16.9440, -2.5910), Offset(-16.8420, -2.8080), Offset(-16.8380, -3.0770), Offset(-16.8340, -3.3470), Offset(-16.9280, -3.5670), Offset(-17.0490, -3.5690), Offset(-17.1700, -3.5710), Offset(-17.2710, -3.3540), Offset(-17.2750, -3.0840), Offset(-17.2800, -2.8150), Offset(-17.1850, -2.5950), Offset(-17.0640, -2.5930)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(-8.4960, 3.8100), Offset(-8.7980, 3.8100), Offset(-9.0620, 3.7650), Offset(-9.2880, 3.6770), Offset(-9.5100, 3.5880), Offset(-9.6960, 3.4660), Offset(-9.8450, 3.3120), Offset(-9.9900, 3.1540), Offset(-10.0980, 2.9690), Offset(-10.1710, 2.7560), Offset(-10.2400, 2.5420), Offset(-10.2730, 2.3110), Offset(-10.2730, 2.0650), Offset(-10.2730, 1.7660), Offset(-10.2300, 1.5070), Offset(-10.1400, 1.2850), Offset(-10.0450, 1.0580), Offset(-9.9230, 0.8700), Offset(-9.7750, 0.7220), Offset(-9.6250, 0.5720), Offset(-9.4550, 0.4590), Offset(-9.2640, 0.3820), Offset(-9.0670, 0.3050), Offset(-8.8670, 0.2670), Offset(-8.6620, 0.2670), Offset(-8.1840, 0.2670), Offset(-7.8060, 0.4140), Offset(-7.5290, 0.7090), Offset(-7.2520, 0.9980), Offset(-7.1130, 1.4260), Offset(-7.1130, 1.9950), Offset(-7.1130, 2.0500), Offset(-7.1160, 2.1120), Offset(-7.1190, 2.1800), Offset(-7.1240, 2.2450), Offset(-7.1280, 2.3010), Offset(-7.1320, 2.3530), Offset(-9.2960, 2.3530), Offset(-9.2730, 2.5500), Offset(-9.1820, 2.7040), Offset(-9.0200, 2.8200), Offset(-8.8570, 2.9340), Offset(-8.6400, 2.9930), Offset(-8.3680, 2.9930), Offset(-8.1930, 2.9930), Offset(-8.0220, 2.9780), Offset(-7.8550, 2.9480), Offset(-7.6840, 2.9120), Offset(-7.5460, 2.8730), Offset(-7.4400, 2.8260), Offset(-7.3110, 3.6010), Offset(-7.3630, 3.6260), Offset(-7.4310, 3.6510), Offset(-7.5160, 3.6770), Offset(-7.6030, 3.7030), Offset(-7.6970, 3.7240), Offset(-7.8040, 3.7410), Offset(-7.9080, 3.7630), Offset(-8.0170, 3.7790), Offset(-8.1370, 3.7930), Offset(-8.2570, 3.8040), Offset(-8.3760, 3.8100), Offset(-8.4960, 3.8100), Offset(-9.2960, 1.7000), Offset(-8.0340, 1.7000), Offset(-8.0390, 1.6180), Offset(-8.0540, 1.5390), Offset(-8.0790, 1.4640), Offset(-8.1010, 1.3870), Offset(-8.1370, 1.3180), Offset(-8.1890, 1.2590), Offset(-8.2360, 1.1990), Offset(-8.2970, 1.1500), Offset(-8.3740, 1.1120), Offset(-8.4450, 1.0730), Offset(-8.5370, 1.0530), Offset(-8.6490, 1.0530), Offset(-8.7550, 1.0530), Offset(-8.8470, 1.0730), Offset(-8.9240, 1.1120), Offset(-9.0010, 1.1450), Offset(-9.0650, 1.1920), Offset(-9.1150, 1.2520), Offset(-9.1670, 1.3120), Offset(-9.2070, 1.3810), Offset(-9.2370, 1.4640), Offset(-9.2640, 1.5390), Offset(-9.2820, 1.6180), Offset(-9.2960, 1.7000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(1.7260, 3.8100), Offset(1.4220, 3.8100), Offset(1.1590, 3.7650), Offset(0.9330, 3.6770), Offset(0.7120, 3.5880), Offset(0.5240, 3.4660), Offset(0.3760, 3.3120), Offset(0.2310, 3.1540), Offset(0.1230, 2.9690), Offset(0.0490, 2.7560), Offset(-0.0190, 2.5420), Offset(-0.0520, 2.3110), Offset(-0.0520, 2.0650), Offset(-0.0520, 1.7660), Offset(-0.0090, 1.5070), Offset(0.0810, 1.2850), Offset(0.1770, 1.0580), Offset(0.2980, 0.8700), Offset(0.4460, 0.7220), Offset(0.5960, 0.5720), Offset(0.7660, 0.4590), Offset(0.9580, 0.3820), Offset(1.1540, 0.3050), Offset(1.3540, 0.2670), Offset(1.5590, 0.2670), Offset(2.0380, 0.2670), Offset(2.4160, 0.4140), Offset(2.6920, 0.7090), Offset(2.9680, 0.9980), Offset(3.1090, 1.4260), Offset(3.1090, 1.9950), Offset(3.1090, 2.0500), Offset(3.1050, 2.1120), Offset(3.1020, 2.1800), Offset(3.0970, 2.2450), Offset(3.0940, 2.3010), Offset(3.0880, 2.3530), Offset(0.9260, 2.3530), Offset(0.9470, 2.5500), Offset(1.0390, 2.7040), Offset(1.2010, 2.8200), Offset(1.3640, 2.9340), Offset(1.5810, 2.9930), Offset(1.8540, 2.9930), Offset(2.0290, 2.9930), Offset(2.1990, 2.9780), Offset(2.3650, 2.9480), Offset(2.5380, 2.9120), Offset(2.6750, 2.8730), Offset(2.7820, 2.8260), Offset(2.9100, 3.6010), Offset(2.8590, 3.6260), Offset(2.7900, 3.6510), Offset(2.7050, 3.6770), Offset(2.6190, 3.7030), Offset(2.5240, 3.7240), Offset(2.4170, 3.7410), Offset(2.3140, 3.7630), Offset(2.2040, 3.7790), Offset(2.0840, 3.7930), Offset(1.9650, 3.8040), Offset(1.8460, 3.8100), Offset(1.7260, 3.8100), Offset(0.9260, 1.7000), Offset(2.1870, 1.7000), Offset(2.1830, 1.6180), Offset(2.1680, 1.5390), Offset(2.1420, 1.4640), Offset(2.1210, 1.3870), Offset(2.0840, 1.3180), Offset(2.0320, 1.2590), Offset(1.9860, 1.1990), Offset(1.9240, 1.1500), Offset(1.8470, 1.1120), Offset(1.7760, 1.0730), Offset(1.6850, 1.0530), Offset(1.5720, 1.0530), Offset(1.4660, 1.0530), Offset(1.3750, 1.0730), Offset(1.2980, 1.1120), Offset(1.2210, 1.1450), Offset(1.1560, 1.1920), Offset(1.1060, 1.2520), Offset(1.0540, 1.3120), Offset(1.0140, 1.3810), Offset(0.9840, 1.4640), Offset(0.9580, 1.5390), Offset(0.9390, 1.6180), Offset(0.9260, 1.7000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(5.4630, 3.8100), Offset(5.1600, 3.8100), Offset(4.8950, 3.7650), Offset(4.6680, 3.6770), Offset(4.4460, 3.5880), Offset(4.2620, 3.4660), Offset(4.1120, 3.3120), Offset(3.9670, 3.1540), Offset(3.8580, 2.9690), Offset(3.7870, 2.7560), Offset(3.7190, 2.5420), Offset(3.6840, 2.3110), Offset(3.6840, 2.0650), Offset(3.6840, 1.7660), Offset(3.7290, 1.5070), Offset(3.8190, 1.2850), Offset(3.9110, 1.0580), Offset(4.0330, 0.8700), Offset(4.1830, 0.7220), Offset(4.3320, 0.5720), Offset(4.5030, 0.4590), Offset(4.6950, 0.3820), Offset(4.8910, 0.3050), Offset(5.0910, 0.2670), Offset(5.2970, 0.2670), Offset(5.7730, 0.2670), Offset(6.1510, 0.4140), Offset(6.4280, 0.7090), Offset(6.7060, 0.9980), Offset(6.8440, 1.4260), Offset(6.8440, 1.9950), Offset(6.8440, 2.0500), Offset(6.8430, 2.1120), Offset(6.8370, 2.1800), Offset(6.8340, 2.2450), Offset(6.8290, 2.3010), Offset(6.8260, 2.3530), Offset(4.6630, 2.3530), Offset(4.6830, 2.5500), Offset(4.7750, 2.7040), Offset(4.9380, 2.8200), Offset(5.1000, 2.9340), Offset(5.3180, 2.9930), Offset(5.5900, 2.9930), Offset(5.7650, 2.9930), Offset(5.9360, 2.9780), Offset(6.1030, 2.9480), Offset(6.2720, 2.9120), Offset(6.4110, 2.8730), Offset(6.5180, 2.8260), Offset(6.6460, 3.6010), Offset(6.5940, 3.6260), Offset(6.5260, 3.6510), Offset(6.4410, 3.6770), Offset(6.3560, 3.7030), Offset(6.2590, 3.7240), Offset(6.1520, 3.7410), Offset(6.0510, 3.7630), Offset(5.9390, 3.7790), Offset(5.8210, 3.7930), Offset(5.7010, 3.8040), Offset(5.5810, 3.8100), Offset(5.4630, 3.8100), Offset(4.6630, 1.7000), Offset(5.9230, 1.7000), Offset(5.9190, 1.6180), Offset(5.9040, 1.5390), Offset(5.8780, 1.4640), Offset(5.8560, 1.3870), Offset(5.8210, 1.3180), Offset(5.7690, 1.2590), Offset(5.7230, 1.1990), Offset(5.6610, 1.1500), Offset(5.5850, 1.1120), Offset(5.5110, 1.0730), Offset(5.4190, 1.0530), Offset(5.3080, 1.0530), Offset(5.2010, 1.0530), Offset(5.1100, 1.0730), Offset(5.0330, 1.1120), Offset(4.9570, 1.1450), Offset(4.8930, 1.1920), Offset(4.8410, 1.2520), Offset(4.7900, 1.3120), Offset(4.7500, 1.3810), Offset(4.7200, 1.4640), Offset(4.6950, 1.5390), Offset(4.6750, 1.6180), Offset(4.6630, 1.7000)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(17.0920, 4.9240), Offset(16.8870, 4.9240), Offset(16.6820, 4.9050), Offset(16.4770, 4.8670), Offset(16.2720, 4.8320), Offset(16.0830, 4.7850), Offset(15.9080, 4.7250), Offset(16.0740, 3.9260), Offset(16.2240, 3.9860), Offset(16.3790, 4.0320), Offset(16.5430, 4.0670), Offset(16.7070, 4.1010), Offset(16.8960, 4.1190), Offset(17.1050, 4.1190), Offset(17.3770, 4.1190), Offset(17.5700, 4.0590), Offset(17.6800, 3.9390), Offset(17.7960, 3.8190), Offset(17.8540, 3.6660), Offset(17.8540, 3.4790), Offset(17.8540, 3.3570), Offset(17.7500, 3.4040), Offset(17.6440, 3.4410), Offset(17.5330, 3.4660), Offset(17.4270, 3.4870), Offset(17.3090, 3.4980), Offset(17.1820, 3.4980), Offset(16.7170, 3.4980), Offset(16.3610, 3.3610), Offset(16.1130, 3.0870), Offset(15.8660, 2.8110), Offset(15.7430, 2.4240), Offset(15.7430, 1.9300), Offset(15.7430, 1.6830), Offset(15.7810, 1.4580), Offset(15.8570, 1.2590), Offset(15.9340, 1.0530), Offset(16.0440, 0.8780), Offset(16.1890, 0.7330), Offset(16.3390, 0.5890), Offset(16.5210, 0.4780), Offset(16.7340, 0.4020), Offset(16.9470, 0.3200), Offset(17.1870, 0.2800), Offset(17.4570, 0.2800), Offset(17.5720, 0.2800), Offset(17.6890, 0.2860), Offset(17.8090, 0.2990), Offset(17.9310, 0.3070), Offset(18.0530, 0.3200), Offset(18.1730, 0.3370), Offset(18.2920, 0.3540), Offset(18.4050, 0.3750), Offset(18.5120, 0.4020), Offset(18.6240, 0.4220), Offset(18.7220, 0.4460), Offset(18.8060, 0.4720), Offset(18.8060, 3.2990), Offset(18.8060, 3.8490), Offset(18.6650, 4.2570), Offset(18.3850, 4.5220), Offset(18.1070, 4.7900), Offset(17.6770, 4.9240), Offset(17.0920, 4.9240), Offset(17.3600, 2.7300), Offset(17.4590, 2.7300), Offset(17.5500, 2.7180), Offset(17.6360, 2.6910), Offset(17.7200, 2.6660), Offset(17.7940, 2.6360), Offset(17.8540, 2.6030), Offset(17.8540, 1.0800), Offset(17.8070, 1.0720), Offset(17.7500, 1.0650), Offset(17.6870, 1.0600), Offset(17.6230, 1.0520), Offset(17.5480, 1.0470), Offset(17.4640, 1.0470), Offset(17.2120, 1.0470), Offset(17.0240, 1.1300), Offset(16.9000, 1.2970), Offset(16.7760, 1.4640), Offset(16.7140, 1.6750), Offset(16.7140, 1.9300), Offset(16.7140, 2.4630), Offset(16.9300, 2.7300), Offset(17.3600, 2.7300)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-17.0510, 2.9930), Offset(-17.2690, 2.9930), Offset(-17.4370, 2.9080), Offset(-17.5570, 2.7360), Offset(-17.6750, 2.5610), Offset(-17.7360, 2.3260), Offset(-17.7360, 2.0330), Offset(-17.7360, 1.7380), Offset(-17.6750, 1.5090), Offset(-17.5570, 1.3420), Offset(-17.4370, 1.1710), Offset(-17.2690, 1.0850), Offset(-17.0510, 1.0850), Offset(-16.8340, 1.0850), Offset(-16.6680, 1.1710), Offset(-16.5520, 1.3420), Offset(-16.4330, 1.5090), Offset(-16.3730, 1.7380), Offset(-16.3730, 2.0330), Offset(-16.3730, 2.3260), Offset(-16.4330, 2.5610), Offset(-16.5520, 2.7360), Offset(-16.6680, 2.9080), Offset(-16.8340, 2.9930), Offset(-17.0510, 2.9930), Offset(-17.0640, 2.5260), Offset(-16.9440, 2.5280), Offset(-16.8420, 2.3110), Offset(-16.8380, 2.0420), Offset(-16.8340, 1.7720), Offset(-16.9280, 1.5520), Offset(-17.0490, 1.5500), Offset(-17.1700, 1.5480), Offset(-17.2710, 1.7650), Offset(-17.2750, 2.0350), Offset(-17.2800, 2.3040), Offset(-17.1850, 2.5240), Offset(-17.0640, 2.5260)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'18',
            rotatable: false,
          ),
          coords: [Offset(-17.0510, 3.8100), Offset(-17.2990, 3.8100), Offset(-17.5250, 3.7690), Offset(-17.7290, 3.6840), Offset(-17.9310, 3.5980), Offset(-18.1020, 3.4790), Offset(-18.2470, 3.3240), Offset(-18.3920, 3.1680), Offset(-18.5050, 2.9800), Offset(-18.5870, 2.7630), Offset(-18.6690, 2.5400), Offset(-18.7080, 2.2980), Offset(-18.7080, 2.0330), Offset(-18.7080, 1.7680), Offset(-18.6690, 1.5260), Offset(-18.5870, 1.3100), Offset(-18.5020, 1.0920), Offset(-18.3870, 0.9060), Offset(-18.2420, 0.7540), Offset(-18.0920, 0.6000), Offset(-17.9170, 0.4800), Offset(-17.7170, 0.3950), Offset(-17.5120, 0.3100), Offset(-17.2910, 0.2670), Offset(-17.0510, 0.2670), Offset(-16.8080, 0.2670), Offset(-16.5860, 0.3100), Offset(-16.3860, 0.3950), Offset(-16.1820, 0.4800), Offset(-16.0060, 0.6000), Offset(-15.8610, 0.7540), Offset(-15.7160, 0.9060), Offset(-15.6030, 1.0920), Offset(-15.5230, 1.3100), Offset(-15.4420, 1.5260), Offset(-15.4010, 1.7680), Offset(-15.4010, 2.0330), Offset(-15.4010, 2.2980), Offset(-15.4400, 2.5400), Offset(-15.5170, 2.7630), Offset(-15.5930, 2.9800), Offset(-15.7030, 3.1680), Offset(-15.8480, 3.3240), Offset(-15.9930, 3.4790), Offset(-16.1680, 3.5980), Offset(-16.3730, 3.6840), Offset(-16.5740, 3.7690), Offset(-16.8000, 3.8100), Offset(-17.0510, 3.8100), Offset(-17.0510, 2.9930), Offset(-16.8340, 2.9930), Offset(-16.6680, 2.9080), Offset(-16.5520, 2.7360), Offset(-16.4330, 2.5610), Offset(-16.3730, 2.3260), Offset(-16.3730, 2.0330), Offset(-16.3730, 1.7380), Offset(-16.4330, 1.5090), Offset(-16.5520, 1.3420), Offset(-16.6680, 1.1710), Offset(-16.8340, 1.0850), Offset(-17.0510, 1.0850), Offset(-17.2690, 1.0850), Offset(-17.4370, 1.1710), Offset(-17.5570, 1.3420), Offset(-17.6750, 1.5090), Offset(-17.7360, 1.7380), Offset(-17.7360, 2.0330), Offset(-17.7360, 2.3260), Offset(-17.6750, 2.5610), Offset(-17.5570, 2.7360), Offset(-17.4370, 2.9080), Offset(-17.2690, 2.9930), Offset(-17.0510, 2.9930)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(17.0900, 5.3900), Offset(16.8640, 5.3900), Offset(16.6230, 5.3620), Offset(16.3910, 5.3210), Offset(16.3890, 5.3200), Offset(16.3890, 5.3200), Offset(16.3870, 5.3200), Offset(16.1690, 5.2840), Offset(15.9630, 5.2400), Offset(15.7580, 5.1700), Offset(15.5550, 5.1020), Offset(15.4090, 4.8470), Offset(15.4500, 4.6370), Offset(15.4500, 4.6350), Offset(15.4500, 4.6340), Offset(15.4500, 4.6320), Offset(15.5380, 4.2210), Offset(15.5490, 4.1650), Offset(15.5260, 4.1090), Offset(15.4780, 4.0790), Offset(15.4310, 4.0490), Offset(15.3690, 4.0520), Offset(15.3240, 4.0880), Offset(15.2450, 4.1520), Offset(15.1380, 4.1910), Offset(15.0330, 4.1910), Offset(14.0800, 4.1910), Offset(13.9300, 4.1930), Offset(13.7750, 4.1070), Offset(13.6920, 3.9830), Offset(13.6690, 3.9440), Offset(13.6250, 3.9210), Offset(13.5800, 3.9210), Offset(13.5340, 3.9210), Offset(13.4920, 3.9440), Offset(13.4660, 3.9830), Offset(13.3850, 4.1070), Offset(13.2330, 4.1910), Offset(13.0830, 4.1910), Offset(12.1310, 4.1910), Offset(12.0010, 4.1910), Offset(11.8660, 4.1310), Offset(11.7810, 4.0320), Offset(11.7550, 4.0040), Offset(11.7190, 3.9870), Offset(11.6800, 3.9870), Offset(11.6420, 3.9870), Offset(11.6060, 4.0040), Offset(11.5810, 4.0320), Offset(11.4960, 4.1310), Offset(11.3640, 4.1910), Offset(11.2340, 4.1910), Offset(10.2810, 4.1910), Offset(10.0480, 4.1930), Offset(9.8150, 3.9570), Offset(9.8150, 3.7240), Offset(9.8150, 1.7960), Offset(9.8150, 1.7580), Offset(9.7980, 1.7210), Offset(9.7700, 1.6970), Offset(9.7410, 1.6700), Offset(9.7030, 1.6580), Offset(9.6650, 1.6630), Offset(9.6080, 1.6700), Offset(9.5530, 1.6680), Offset(9.4980, 1.6550), Offset(9.4330, 1.6380), Offset(9.3410, 1.6180), Offset(9.2270, 1.5970), Offset(9.2210, 1.5950), Offset(9.2170, 1.5930), Offset(9.2100, 1.5920), Offset(9.1610, 1.5820), Offset(9.1420, 1.5820), Offset(9.1570, 1.5840), Offset(9.1180, 1.5780), Offset(9.0780, 1.5900), Offset(9.0480, 1.6150), Offset(9.0180, 1.6400), Offset(9.0010, 1.6780), Offset(9.0010, 1.7160), Offset(9.0010, 1.7160), Offset(9.0010, 3.7240), Offset(9.0010, 3.7240), Offset(9.0010, 3.9570), Offset(8.7680, 4.1930), Offset(8.5350, 4.1910), Offset(7.5820, 4.1910), Offset(7.4240, 4.1910), Offset(7.2620, 4.0990), Offset(7.1830, 3.9620), Offset(7.1620, 3.9260), Offset(7.1250, 3.9000), Offset(7.0820, 3.8940), Offset(7.0400, 3.8890), Offset(6.9990, 3.9020), Offset(6.9690, 3.9320), Offset(6.9350, 3.9660), Offset(6.8990, 3.9960), Offset(6.8550, 4.0160), Offset(6.7680, 4.0590), Offset(6.6790, 4.0920), Offset(6.5740, 4.1240), Offset(6.4670, 4.1570), Offset(6.3640, 4.1780), Offset(6.2530, 4.1950), Offset(6.2440, 4.1970), Offset(6.2360, 4.1990), Offset(6.2260, 4.2020), Offset(6.1070, 4.2270), Offset(5.9910, 4.2400), Offset(5.8700, 4.2540), Offset(5.7380, 4.2670), Offset(5.6010, 4.2790), Offset(5.4610, 4.2790), Offset(5.1210, 4.2790), Offset(4.8080, 4.2310), Offset(4.5200, 4.1200), Offset(4.5140, 4.1180), Offset(4.5060, 4.1140), Offset(4.4980, 4.1100), Offset(4.2200, 3.9980), Offset(3.9770, 3.8400), Offset(3.7780, 3.6360), Offset(3.7170, 3.5660), Offset(3.6630, 3.4940), Offset(3.6090, 3.4120), Offset(3.5710, 3.3610), Offset(3.5030, 3.3440), Offset(3.4450, 3.3710), Offset(3.3890, 3.3960), Offset(3.3570, 3.4590), Offset(3.3700, 3.5210), Offset(3.4040, 3.7110), Offset(3.2930, 3.9300), Offset(3.1200, 4.0160), Offset(3.0340, 4.0600), Offset(2.9450, 4.0920), Offset(2.8370, 4.1240), Offset(2.7320, 4.1570), Offset(2.6280, 4.1780), Offset(2.5170, 4.1950), Offset(2.5080, 4.1970), Offset(2.4990, 4.1990), Offset(2.4900, 4.2020), Offset(2.3720, 4.2270), Offset(2.2560, 4.2400), Offset(2.1340, 4.2540), Offset(2.0010, 4.2670), Offset(1.8660, 4.2790), Offset(1.7260, 4.2790), Offset(1.3860, 4.2790), Offset(1.0710, 4.2310), Offset(0.7850, 4.1200), Offset(0.7780, 4.1180), Offset(0.7710, 4.1140), Offset(0.7610, 4.1100), Offset(0.5620, 4.0290), Offset(0.3830, 3.9170), Offset(0.2180, 3.7820), Offset(0.1860, 3.7570), Offset(0.1450, 3.7480), Offset(0.1050, 3.7570), Offset(0.0640, 3.7650), Offset(0.0320, 3.7930), Offset(0.0130, 3.8290), Offset(-0.0350, 3.9290), Offset(-0.1240, 4.0130), Offset(-0.2290, 4.0540), Offset(-0.3620, 4.1090), Offset(-0.5120, 4.1640), Offset(-0.6780, 4.2040), Offset(-0.8710, 4.2510), Offset(-1.0730, 4.2660), Offset(-1.3030, 4.2660), Offset(-1.6060, 4.2660), Offset(-1.8760, 4.2270), Offset(-2.1270, 4.1260), Offset(-2.3550, 4.0310), Offset(-2.5610, 3.8920), Offset(-2.7170, 3.7060), Offset(-2.7190, 3.7010), Offset(-2.7210, 3.6990), Offset(-2.7190, 3.7020), Offset(-2.7160, 3.7070), Offset(-2.7180, 3.7060), Offset(-2.7210, 3.7000), Offset(-2.7240, 3.6940), Offset(-2.7340, 3.6670), Offset(-2.7640, 3.6240), Offset(-2.7990, 3.5770), Offset(-2.8590, 3.5580), Offset(-2.9150, 3.5760), Offset(-2.9690, 3.5940), Offset(-3.0070, 3.6460), Offset(-3.0060, 3.7040), Offset(-3.0060, 3.7240), Offset(-3.0060, 3.9570), Offset(-3.2390, 4.1930), Offset(-3.4730, 4.1910), Offset(-4.4270, 4.1910), Offset(-4.5770, 4.1930), Offset(-4.7300, 4.1070), Offset(-4.8140, 3.9830), Offset(-4.8380, 3.9440), Offset(-4.8800, 3.9210), Offset(-4.9270, 3.9210), Offset(-4.9720, 3.9210), Offset(-5.0130, 3.9440), Offset(-5.0380, 3.9830), Offset(-5.1220, 4.1070), Offset(-5.2740, 4.1910), Offset(-5.4210, 4.1910), Offset(-6.3770, 4.1910), Offset(-6.5330, 4.1910), Offset(-6.6960, 4.0990), Offset(-6.7770, 3.9620), Offset(-6.7960, 3.9260), Offset(-6.8330, 3.9000), Offset(-6.8750, 3.8940), Offset(-6.9160, 3.8890), Offset(-6.9580, 3.9020), Offset(-6.9880, 3.9320), Offset(-7.0210, 3.9660), Offset(-7.0590, 3.9960), Offset(-7.1010, 4.0160), Offset(-7.1010, 4.0170), Offset(-7.1040, 4.0160), Offset(-7.1040, 4.0160), Offset(-7.1910, 4.0590), Offset(-7.2780, 4.0920), Offset(-7.3840, 4.1240), Offset(-7.4890, 4.1570), Offset(-7.5920, 4.1780), Offset(-7.7040, 4.1950), Offset(-7.7140, 4.1970), Offset(-7.7220, 4.1990), Offset(-7.7290, 4.1990), Offset(-7.7310, 4.2010), Offset(-7.7330, 4.2020), Offset(-7.7350, 4.2040), Offset(-7.8490, 4.2270), Offset(-7.9660, 4.2400), Offset(-8.0880, 4.2540), Offset(-8.2210, 4.2670), Offset(-8.3550, 4.2790), Offset(-8.4960, 4.2790), Offset(-8.8360, 4.2790), Offset(-9.1510, 4.2310), Offset(-9.4370, 4.1200), Offset(-9.4440, 4.1180), Offset(-9.4500, 4.1140), Offset(-9.4610, 4.1100), Offset(-9.7370, 3.9980), Offset(-9.9800, 3.8400), Offset(-10.1810, 3.6350), Offset(-10.1850, 3.6310), Offset(-10.1850, 3.6280), Offset(-10.1860, 3.6240), Offset(-10.2180, 3.5910), Offset(-10.2500, 3.5360), Offset(-10.3000, 3.4700), Offset(-10.3330, 3.4250), Offset(-10.3930, 3.4040), Offset(-10.4500, 3.4230), Offset(-10.5050, 3.4400), Offset(-10.5410, 3.4930), Offset(-10.5410, 3.5490), Offset(-10.5410, 3.5490), Offset(-10.5410, 3.7240), Offset(-10.5410, 3.7240), Offset(-10.5410, 3.9570), Offset(-10.7740, 4.1930), Offset(-11.0080, 4.1910), Offset(-11.9610, 4.1910), Offset(-12.1940, 4.1930), Offset(-12.4270, 3.9570), Offset(-12.4270, 3.7240), Offset(-12.4270, 1.7960), Offset(-12.4270, 1.7580), Offset(-12.4440, 1.7210), Offset(-12.4720, 1.6970), Offset(-12.5010, 1.6700), Offset(-12.5390, 1.6580), Offset(-12.5770, 1.6630), Offset(-12.6340, 1.6700), Offset(-12.6890, 1.6680), Offset(-12.7440, 1.6550), Offset(-12.8090, 1.6380), Offset(-12.9010, 1.6180), Offset(-13.0150, 1.5970), Offset(-13.0210, 1.5950), Offset(-13.0260, 1.5930), Offset(-13.0320, 1.5920), Offset(-13.0810, 1.5820), Offset(-13.1010, 1.5820), Offset(-13.0860, 1.5840), Offset(-13.1240, 1.5780), Offset(-13.1640, 1.5900), Offset(-13.1940, 1.6150), Offset(-13.2240, 1.6400), Offset(-13.2400, 1.6780), Offset(-13.2400, 1.7160), Offset(-13.2400, 3.7240), Offset(-13.2400, 3.9570), Offset(-13.4740, 4.1930), Offset(-13.7070, 4.1910), Offset(-14.6600, 4.1910), Offset(-14.8930, 4.1930), Offset(-15.1260, 3.9570), Offset(-15.1260, 3.7240), Offset(-15.1260, 3.5320), Offset(-15.1260, 3.4760), Offset(-15.1640, 3.4230), Offset(-15.2180, 3.4060), Offset(-15.2730, 3.3870), Offset(-15.3350, 3.4080), Offset(-15.3680, 3.4550), Offset(-15.4200, 3.5260), Offset(-15.4630, 3.5910), Offset(-15.5110, 3.6430), Offset(-15.5170, 3.6510), Offset(-15.5170, 3.6520), Offset(-15.5180, 3.6560), Offset(-15.7030, 3.8510), Offset(-15.9330, 4.0020), Offset(-16.1890, 4.1100), Offset(-16.4580, 4.2240), Offset(-16.7480, 4.2790), Offset(-17.0510, 4.2790), Offset(-17.3460, 4.2790), Offset(-17.6290, 4.2250), Offset(-17.8890, 4.1200), Offset(-17.8950, 4.1180), Offset(-17.9020, 4.1140), Offset(-17.9090, 4.1120), Offset(-18.1600, 4.0050), Offset(-18.3920, 3.8490), Offset(-18.5800, 3.6510), Offset(-18.5860, 3.6430), Offset(-18.5870, 3.6410), Offset(-18.5880, 3.6370), Offset(-18.7760, 3.4340), Offset(-18.9190, 3.1960), Offset(-19.0170, 2.9310), Offset(-19.0170, 2.9310), Offset(-19.0170, 2.9330), Offset(-19.0190, 2.9270), Offset(-19.1220, 2.6480), Offset(-19.1760, 2.3500), Offset(-19.1760, 2.0330), Offset(-19.1760, 1.7180), Offset(-19.1230, 1.4190), Offset(-19.0190, 1.1420), Offset(-19.0190, 1.1390), Offset(-18.9130, 0.8750), Offset(-18.7700, 0.6420), Offset(-18.5870, 0.4460), Offset(-18.4070, 0.2410), Offset(-18.0540, 0.0350), Offset(-17.8970, -0.0330), Offset(-17.8940, -0.0330), Offset(-17.8910, -0.0350), Offset(-17.8890, -0.0370), Offset(-17.6280, -0.1430), Offset(-17.3440, -0.2000), Offset(-17.0510, -0.2000), Offset(-16.7550, -0.2000), Offset(-16.4680, -0.1430), Offset(-16.2060, -0.0330), Offset(-15.9460, 0.0760), Offset(-15.7070, 0.2350), Offset(-15.5180, 0.4330), Offset(-15.4700, 0.4870), Offset(-15.4250, 0.5600), Offset(-15.3680, 0.6390), Offset(-15.3350, 0.6850), Offset(-15.2730, 0.7050), Offset(-15.2180, 0.6870), Offset(-15.1640, 0.6690), Offset(-15.1260, 0.6170), Offset(-15.1260, 0.5590), Offset(-15.1260, 0.5380), Offset(-15.1260, 0.4350), Offset(-15.0880, 0.3290), Offset(-15.0230, 0.2470), Offset(-14.9830, 0.1980), Offset(-14.9830, 0.1290), Offset(-15.0230, 0.0800), Offset(-15.0880, -0.0010), Offset(-15.1260, -0.1080), Offset(-15.1260, -0.2110), Offset(-15.1260, -1.5860), Offset(-15.1260, -1.6440), Offset(-15.1640, -1.6960), Offset(-15.2180, -1.7140), Offset(-15.2730, -1.7330), Offset(-15.3350, -1.7120), Offset(-15.3680, -1.6660), Offset(-15.4200, -1.5940), Offset(-15.4630, -1.5290), Offset(-15.5060, -1.4830), Offset(-15.5080, -1.4780), Offset(-15.5110, -1.4740), Offset(-15.5170, -1.4650), Offset(-15.7010, -1.2710), Offset(-15.9280, -1.1150), Offset(-16.1890, -1.0050), Offset(-16.4630, -0.8890), Offset(-16.7530, -0.8410), Offset(-17.0510, -0.8410), Offset(-17.3410, -0.8410), Offset(-17.6240, -0.8880), Offset(-17.8890, -0.9950), Offset(-17.8950, -0.9970), Offset(-17.9020, -1.0010), Offset(-17.9090, -1.0030), Offset(-18.1650, -1.1130), Offset(-18.3940, -1.2730), Offset(-18.5780, -1.4630), Offset(-18.5820, -1.4680), Offset(-18.5820, -1.4700), Offset(-18.5840, -1.4740), Offset(-18.5860, -1.4760), Offset(-18.5870, -1.4790), Offset(-18.5880, -1.4830), Offset(-18.7760, -1.6840), Offset(-18.9190, -1.9240), Offset(-19.0190, -2.1920), Offset(-19.1220, -2.4720), Offset(-19.1760, -2.7700), Offset(-19.1760, -3.0850), Offset(-19.1760, -3.4010), Offset(-19.1220, -3.6980), Offset(-19.0190, -3.9730), Offset(-18.9150, -4.2380), Offset(-18.7740, -4.4730), Offset(-18.5860, -4.6750), Offset(-18.5820, -4.6800), Offset(-18.5800, -4.6820), Offset(-18.5800, -4.6840), Offset(-18.5770, -4.6860), Offset(-18.5730, -4.6880), Offset(-18.5720, -4.6900), Offset(-18.3840, -4.8830), Offset(-18.1520, -5.0430), Offset(-17.8970, -5.1510), Offset(-17.8940, -5.1530), Offset(-17.8910, -5.1540), Offset(-17.8890, -5.1560), Offset(-17.6280, -5.2630), Offset(-17.3440, -5.3170), Offset(-17.0510, -5.3170), Offset(-16.7550, -5.3170), Offset(-16.4680, -5.2630), Offset(-16.2040, -5.1500), Offset(-15.9430, -5.0380), Offset(-15.7070, -4.8850), Offset(-15.5180, -4.6840), Offset(-15.4680, -4.6310), Offset(-15.4250, -4.5600), Offset(-15.3680, -4.4810), Offset(-15.3350, -4.4330), Offset(-15.2730, -4.4130), Offset(-15.2180, -4.4310), Offset(-15.1640, -4.4490), Offset(-15.1260, -4.5020), Offset(-15.1260, -4.5600), Offset(-15.1260, -4.5600), Offset(-15.1260, -4.6480), Offset(-15.1260, -4.6480), Offset(-15.1260, -4.8400), Offset(-14.9780, -5.0380), Offset(-14.7940, -5.0930), Offset(-14.6940, -5.1230), Offset(-14.5980, -5.1440), Offset(-14.4990, -5.1650), Offset(-14.4990, -5.1650), Offset(-14.4770, -5.1680), Offset(-14.4520, -5.1730), Offset(-14.3400, -5.1980), Offset(-14.2170, -5.2190), Offset(-14.0850, -5.2400), Offset(-13.9220, -5.2660), Offset(-13.8420, -5.2660), Offset(-13.6820, -5.2810), Offset(-13.5470, -5.2940), Offset(-13.4150, -5.3060), Offset(-13.2860, -5.3060), Offset(-12.9640, -5.3060), Offset(-12.6600, -5.2530), Offset(-12.3800, -5.1450), Offset(-12.3730, -5.1430), Offset(-12.3710, -5.1430), Offset(-12.3690, -5.1430), Offset(-12.1010, -5.0410), Offset(-11.8640, -4.8830), Offset(-11.6650, -4.6810), Offset(-11.6570, -4.6710), Offset(-11.6530, -4.6680), Offset(-11.6490, -4.6650), Offset(-11.5360, -4.5480), Offset(-11.4410, -4.4120), Offset(-11.3580, -4.2600), Offset(-11.3340, -4.2180), Offset(-11.2890, -4.1920), Offset(-11.2420, -4.1920), Offset(-11.1930, -4.1920), Offset(-11.1480, -4.2180), Offset(-11.1250, -4.2600), Offset(-11.0280, -4.4340), Offset(-10.9230, -4.5930), Offset(-10.7910, -4.7260), Offset(-10.6000, -4.9170), Offset(-10.3720, -5.0650), Offset(-10.1280, -5.1650), Offset(-10.1250, -5.1650), Offset(-10.1240, -5.1660), Offset(-10.1180, -5.1680), Offset(-9.8720, -5.2630), Offset(-9.6130, -5.3170), Offset(-9.3500, -5.3170), Offset(-8.7830, -5.3170), Offset(-8.2510, -5.1200), Offset(-7.8820, -4.7300), Offset(-7.8460, -4.6910), Offset(-7.8120, -4.6410), Offset(-7.7670, -4.5810), Offset(-7.7330, -4.5380), Offset(-7.6760, -4.5190), Offset(-7.6220, -4.5360), Offset(-7.5690, -4.5530), Offset(-7.5320, -4.6000), Offset(-7.5290, -4.6560), Offset(-7.5260, -4.8460), Offset(-7.3760, -5.0390), Offset(-7.1920, -5.0930), Offset(-6.9990, -5.1480), Offset(-6.7770, -5.1860), Offset(-6.5180, -5.2260), Offset(-6.5130, -5.2270), Offset(-6.5100, -5.2290), Offset(-6.5050, -5.2310), Offset(-6.2260, -5.2760), Offset(-5.9330, -5.3060), Offset(-5.6300, -5.3060), Offset(-5.3050, -5.3060), Offset(-5.0200, -5.2590), Offset(-4.7540, -5.1530), Offset(-4.4990, -5.0540), Offset(-4.2710, -4.9080), Offset(-4.1060, -4.7060), Offset(-3.9480, -4.5130), Offset(-3.8390, -4.2820), Offset(-3.7770, -4.0340), Offset(-3.7190, -3.8030), Offset(-3.6940, -3.5570), Offset(-3.6940, -3.2940), Offset(-3.6940, -1.3950), Offset(-3.6940, -1.1610), Offset(-3.9270, -0.9270), Offset(-4.1600, -0.9270), Offset(-5.1130, -0.9270), Offset(-5.2630, -0.9270), Offset(-5.4190, -1.0110), Offset(-5.5020, -1.1360), Offset(-5.5250, -1.1740), Offset(-5.5690, -1.1980), Offset(-5.6130, -1.1980), Offset(-5.6600, -1.1980), Offset(-5.7010, -1.1740), Offset(-5.7270, -1.1360), Offset(-5.8080, -1.0120), Offset(-5.9600, -0.9270), Offset(-6.1100, -0.9270), Offset(-7.0630, -0.9270), Offset(-7.2200, -0.9290), Offset(-7.3800, -1.0210), Offset(-7.4590, -1.1580), Offset(-7.4790, -1.1940), Offset(-7.5160, -1.2190), Offset(-7.5580, -1.2240), Offset(-7.5990, -1.2310), Offset(-7.6410, -1.2160), Offset(-7.6710, -1.1860), Offset(-7.7060, -1.1510), Offset(-7.7440, -1.1210), Offset(-7.7900, -1.1000), Offset(-7.8980, -1.0460), Offset(-7.9760, -1.0230), Offset(-8.0710, -0.9950), Offset(-8.1780, -0.9630), Offset(-8.2810, -0.9420), Offset(-8.3920, -0.9240), Offset(-8.4000, -0.9230), Offset(-8.4090, -0.9210), Offset(-8.4170, -0.9200), Offset(-8.4190, -0.9180), Offset(-8.4190, -0.9160), Offset(-8.4210, -0.9160), Offset(-8.5270, -0.8940), Offset(-8.6440, -0.8740), Offset(-8.7750, -0.8610), Offset(-8.9170, -0.8460), Offset(-9.0540, -0.8410), Offset(-9.1830, -0.8410), Offset(-9.5230, -0.8410), Offset(-9.8370, -0.8880), Offset(-10.1250, -0.9990), Offset(-10.1320, -1.0030), Offset(-10.1380, -1.0040), Offset(-10.1480, -1.0100), Offset(-10.2050, -1.0330), Offset(-10.2610, -1.0660), Offset(-10.3330, -1.1020), Offset(-10.3800, -1.1260), Offset(-10.4380, -1.1190), Offset(-10.4780, -1.0850), Offset(-10.5200, -1.0510), Offset(-10.5370, -0.9960), Offset(-10.5200, -0.9440), Offset(-10.4810, -0.8260), Offset(-10.4530, -0.7090), Offset(-10.4530, -0.6160), Offset(-10.4530, -0.4410), Offset(-10.5250, -0.2460), Offset(-10.6370, -0.0670), Offset(-10.6670, -0.0200), Offset(-10.6650, 0.0400), Offset(-10.6330, 0.0840), Offset(-10.5750, 0.1640), Offset(-10.5410, 0.2620), Offset(-10.5410, 0.3590), Offset(-10.5410, 0.5590), Offset(-10.5410, 0.6170), Offset(-10.5050, 0.6690), Offset(-10.4500, 0.6870), Offset(-10.3930, 0.7050), Offset(-10.3330, 0.6850), Offset(-10.3000, 0.6390), Offset(-10.2330, 0.5470), Offset(-10.1710, 0.4610), Offset(-10.1030, 0.3920), Offset(-9.9140, 0.2020), Offset(-9.6850, 0.0530), Offset(-9.4420, -0.0450), Offset(-9.4390, -0.0460), Offset(-9.4350, -0.0480), Offset(-9.4330, -0.0500), Offset(-9.4320, -0.0500), Offset(-9.4310, -0.0500), Offset(-9.4290, -0.0500), Offset(-9.1830, -0.1440), Offset(-8.9270, -0.2000), Offset(-8.6620, -0.2000), Offset(-8.0960, -0.2000), Offset(-7.5620, -0.0010), Offset(-7.1940, 0.3860), Offset(-7.1940, 0.3860), Offset(-7.1920, 0.3870), Offset(-7.1940, 0.3850), Offset(-7.1940, 0.3880), Offset(-7.1920, 0.3920), Offset(-7.1920, 0.3890), Offset(-7.1920, 0.3900), Offset(-7.1430, 0.4530), Offset(-7.0790, 0.5380), Offset(-7.0460, 0.5810), Offset(-6.9880, 0.5980), Offset(-6.9350, 0.5810), Offset(-6.8820, 0.5660), Offset(-6.8460, 0.5190), Offset(-6.8430, 0.4630), Offset(-6.8370, 0.2730), Offset(-6.6880, 0.0790), Offset(-6.5050, 0.0250), Offset(-6.3130, -0.0300), Offset(-6.0910, -0.0670), Offset(-5.8240, -0.1100), Offset(-5.5400, -0.1560), Offset(-5.2460, -0.1860), Offset(-4.9440, -0.1860), Offset(-4.6190, -0.1860), Offset(-4.3320, -0.1420), Offset(-4.0660, -0.0350), Offset(-3.8130, 0.0640), Offset(-3.5840, 0.2110), Offset(-3.4190, 0.4140), Offset(-3.4040, 0.4320), Offset(-3.3870, 0.4770), Offset(-3.3470, 0.5340), Offset(-3.3150, 0.5850), Offset(-3.2540, 0.6090), Offset(-3.1950, 0.5900), Offset(-3.1390, 0.5740), Offset(-3.1010, 0.5190), Offset(-3.1030, 0.4590), Offset(-3.1030, 0.4590), Offset(-3.1030, -0.4820), Offset(-3.1030, -0.4820), Offset(-3.1030, -0.6930), Offset(-2.9150, -0.9080), Offset(-2.7060, -0.9410), Offset(-1.7530, -1.0910), Offset(-1.5010, -1.1290), Offset(-1.2150, -0.8860), Offset(-1.2150, -0.6330), Offset(-1.2150, -0.2410), Offset(-1.2150, -0.1660), Offset(-1.1550, -0.1080), Offset(-1.0820, -0.1080), Offset(-0.5370, -0.1080), Offset(-0.3230, -0.1060), Offset(-0.1090, 0.0820), Offset(-0.0790, 0.2920), Offset(-0.0700, 0.3420), Offset(-0.0350, 0.3840), Offset(0.0110, 0.3990), Offset(0.0600, 0.4150), Offset(0.1110, 0.4020), Offset(0.1470, 0.3670), Offset(0.3330, 0.1900), Offset(0.5490, 0.0490), Offset(0.7860, -0.0470), Offset(1.0370, -0.1440), Offset(1.2940, -0.2000), Offset(1.5590, -0.2000), Offset(2.1260, -0.2000), Offset(2.6580, -0.0010), Offset(3.0270, 0.3880), Offset(3.1440, 0.5130), Offset(3.2390, 0.6540), Offset(3.3170, 0.8050), Offset(3.3380, 0.8480), Offset(3.3830, 0.8750), Offset(3.4320, 0.8750), Offset(3.4810, 0.8760), Offset(3.5260, 0.8520), Offset(3.5500, 0.8080), Offset(3.6420, 0.6540), Offset(3.7370, 0.5100), Offset(3.8530, 0.3920), Offset(4.0450, 0.2020), Offset(4.2730, 0.0530), Offset(4.5210, -0.0470), Offset(4.5210, -0.0470), Offset(4.5210, -0.0480), Offset(4.5200, -0.0460), Offset(4.5220, -0.0470), Offset(4.5290, -0.0500), Offset(4.5270, -0.0500), Offset(4.5270, -0.0500), Offset(4.7730, -0.1440), Offset(5.0310, -0.2000), Offset(5.2950, -0.2000), Offset(5.8610, -0.2000), Offset(6.3940, -0.0010), Offset(6.7630, 0.3880), Offset(6.8020, 0.4320), Offset(6.8390, 0.4800), Offset(6.8820, 0.5380), Offset(6.9140, 0.5810), Offset(6.9690, 0.6000), Offset(7.0220, 0.5850), Offset(7.0740, 0.5720), Offset(7.1120, 0.5290), Offset(7.1190, 0.4760), Offset(7.1400, 0.3100), Offset(7.2710, 0.1520), Offset(7.4270, 0.0970), Offset(7.6150, 0.0320), Offset(7.8310, -0.0230), Offset(8.0800, -0.0810), Offset(8.0850, -0.0820), Offset(8.0830, -0.0820), Offset(8.0830, -0.0820), Offset(8.3600, -0.1460), Offset(8.6540, -0.1780), Offset(8.9650, -0.1780), Offset(9.0280, -0.1780), Offset(9.0990, -0.1730), Offset(9.1680, -0.1660), Offset(9.1820, -0.1650), Offset(9.1900, -0.1630), Offset(9.2050, -0.1610), Offset(9.2780, -0.1560), Offset(9.3470, -0.1480), Offset(9.4150, -0.1360), Offset(9.4370, -0.1330), Offset(9.4450, -0.1330), Offset(9.4470, -0.1330), Offset(9.5070, -0.1250), Offset(9.5700, -0.1160), Offset(9.6350, -0.1030), Offset(9.6810, -0.0950), Offset(9.7280, -0.1120), Offset(9.7580, -0.1460), Offset(9.7880, -0.1810), Offset(9.8000, -0.2300), Offset(9.7850, -0.2740), Offset(9.7450, -0.3940), Offset(9.7180, -0.5120), Offset(9.7180, -0.6160), Offset(9.7180, -0.8780), Offset(9.8380, -1.1860), Offset(10.0430, -1.3690), Offset(10.0480, -1.3720), Offset(10.0510, -1.3740), Offset(10.0580, -1.3800), Offset(10.2430, -1.5380), Offset(10.5080, -1.6440), Offset(10.7510, -1.6440), Offset(10.9940, -1.6440), Offset(11.2570, -1.5420), Offset(11.4520, -1.3730), Offset(11.4580, -1.3670), Offset(11.4600, -1.3650), Offset(11.4660, -1.3640), Offset(11.6710, -1.1770), Offset(11.7890, -0.8690), Offset(11.7890, -0.6160), Offset(11.7890, -0.4410), Offset(11.7170, -0.2460), Offset(11.6060, -0.0670), Offset(11.5760, -0.0180), Offset(11.5790, 0.0440), Offset(11.6190, 0.0940), Offset(11.6440, 0.1320), Offset(11.6780, 0.1510), Offset(11.7160, 0.1550), Offset(11.7530, 0.1590), Offset(11.7910, 0.1470), Offset(11.8170, 0.1220), Offset(11.8710, 0.0770), Offset(11.9350, 0.0440), Offset(12.0010, 0.0250), Offset(12.1940, -0.0300), Offset(12.4160, -0.0670), Offset(12.6820, -0.1100), Offset(12.9670, -0.1560), Offset(13.2600, -0.1860), Offset(13.5640, -0.1860), Offset(13.8890, -0.1860), Offset(14.1730, -0.1420), Offset(14.4390, -0.0350), Offset(14.6950, 0.0640), Offset(14.9230, 0.2110), Offset(15.0880, 0.4140), Offset(15.1810, 0.5290), Offset(15.2530, 0.6690), Offset(15.3160, 0.8170), Offset(15.3370, 0.8630), Offset(15.3810, 0.8930), Offset(15.4310, 0.8970), Offset(15.4810, 0.9000), Offset(15.5290, 0.8740), Offset(15.5550, 0.8300), Offset(15.6410, 0.6730), Offset(15.7390, 0.5300), Offset(15.8620, 0.4040), Offset(16.0610, 0.2120), Offset(16.2990, 0.0650), Offset(16.5700, -0.0350), Offset(16.8490, -0.1400), Offset(17.1470, -0.1860), Offset(17.4570, -0.1860), Offset(17.5850, -0.1860), Offset(17.7130, -0.1740), Offset(17.8470, -0.1610), Offset(17.8540, -0.1610), Offset(17.8420, -0.1630), Offset(17.8650, -0.1610), Offset(17.9900, -0.1530), Offset(18.1100, -0.1380), Offset(18.2370, -0.1200), Offset(18.3550, -0.1030), Offset(18.4750, -0.0820), Offset(18.5930, -0.0580), Offset(18.6050, -0.0520), Offset(18.6170, -0.0500), Offset(18.6280, -0.0500), Offset(18.7430, -0.0260), Offset(18.8480, -0.0010), Offset(18.9400, 0.0250), Offset(19.1240, 0.0800), Offset(19.2730, 0.2790), Offset(19.2730, 0.4720), Offset(19.2730, 3.2990), Offset(19.2730, 3.9150), Offset(19.1110, 4.4660), Offset(18.7240, 4.8440), Offset(18.7180, 4.8500), Offset(18.7160, 4.8520), Offset(18.7090, 4.8580), Offset(18.3050, 5.2430), Offset(17.7420, 5.3900), Offset(17.0900, 5.3900), Offset(-1.3050, 3.7990), Offset(-1.1020, 3.7990), Offset(-0.9280, 3.7800), Offset(-0.7870, 3.7480), Offset(-0.6460, 3.7120), Offset(-0.5180, 3.6730), Offset(-0.4040, 3.6260), Offset(-0.5390, 2.8840), Offset(-0.6270, 2.9180), Offset(-0.7280, 2.9460), Offset(-0.8380, 2.9660), Offset(-0.9450, 2.9840), Offset(-1.0500, 2.9930), Offset(-1.1510, 2.9930), Offset(-1.3650, 2.9930), Offset(-1.5080, 2.9330), Offset(-1.5810, 2.8130), Offset(-1.6480, 2.6940), Offset(-1.6830, 2.5350), Offset(-1.6830, 2.3330), Offset(-1.6830, 1.1500), Offset(-0.5390, 1.1500), Offset(-0.5390, 0.3570), Offset(-1.6830, 0.3570), Offset(-1.6830, -0.6340), Offset(-2.6360, -0.4810), Offset(-2.6360, 2.3460), Offset(-2.6360, 2.5650), Offset(-2.6180, 2.7630), Offset(-2.5790, 2.9410), Offset(-2.5360, 3.1210), Offset(-2.4630, 3.2740), Offset(-2.3610, 3.4020), Offset(-2.2590, 3.5260), Offset(-2.1230, 3.6240), Offset(-1.9510, 3.6960), Offset(-1.7810, 3.7640), Offset(-1.5660, 3.7990), Offset(-1.3050, 3.7990), Offset(10.7520, -0.0520), Offset(10.9060, -0.0520), Offset(11.0380, -0.1010), Offset(11.1490, -0.2000), Offset(11.2640, -0.3030), Offset(11.3230, -0.4410), Offset(11.3230, -0.6160), Offset(11.3230, -0.7910), Offset(11.2640, -0.9270), Offset(11.1490, -1.0260), Offset(11.0380, -1.1280), Offset(10.9060, -1.1790), Offset(10.7520, -1.1790), Offset(10.6000, -1.1790), Offset(10.4650, -1.1280), Offset(10.3500, -1.0260), Offset(10.2380, -0.9270), Offset(10.1830, -0.7910), Offset(10.1830, -0.6160), Offset(10.1830, -0.4410), Offset(10.2380, -0.3030), Offset(10.3500, -0.2000), Offset(10.4650, -0.1010), Offset(10.6000, -0.0520), Offset(10.7520, -0.0520), Offset(10.2790, 3.7220), Offset(11.2330, 3.7220), Offset(11.2330, 0.3570), Offset(10.2790, 0.3570), Offset(10.2790, 3.7220), Offset(-11.9630, 3.7220), Offset(-11.0090, 3.7220), Offset(-11.0090, 0.3570), Offset(-11.9630, 0.3570), Offset(-11.9630, 3.7220), Offset(7.5810, 3.7220), Offset(8.5340, 3.7220), Offset(8.5340, 1.1500), Offset(8.5750, 1.1370), Offset(8.6370, 1.1260), Offset(8.7180, 1.1180), Offset(8.8040, 1.1050), Offset(8.8770, 1.0980), Offset(8.9370, 1.0980), Offset(9.0690, 1.0980), Offset(9.1910, 1.1120), Offset(9.3060, 1.1370), Offset(9.4240, 1.1580), Offset(9.5230, 1.1800), Offset(9.6080, 1.2010), Offset(9.7680, 0.4140), Offset(9.7170, 0.3920), Offset(9.6550, 0.3750), Offset(9.5830, 0.3630), Offset(9.5100, 0.3450), Offset(9.4370, 0.3330), Offset(9.3650, 0.3250), Offset(9.2920, 0.3120), Offset(9.2200, 0.3030), Offset(9.1460, 0.2990), Offset(9.0750, 0.2900), Offset(9.0130, 0.2860), Offset(8.9620, 0.2860), Offset(8.6770, 0.2860), Offset(8.4150, 0.3140), Offset(8.1820, 0.3690), Offset(7.9500, 0.4200), Offset(7.7500, 0.4760), Offset(7.5810, 0.5360), Offset(7.5810, 3.7220), Offset(12.1290, 3.7220), Offset(13.0820, 3.7220), Offset(13.0820, 1.1250), Offset(13.1420, 1.1150), Offset(13.2100, 1.1100), Offset(13.2870, 1.1050), Offset(13.3630, 1.0970), Offset(13.4350, 1.0920), Offset(13.5040, 1.0920), Offset(13.7250, 1.0920), Offset(13.8760, 1.1560), Offset(13.9580, 1.2850), Offset(14.0390, 1.4110), Offset(14.0800, 1.6300), Offset(14.0800, 1.9370), Offset(14.0800, 3.7220), Offset(15.0330, 3.7220), Offset(15.0330, 1.8210), Offset(15.0330, 1.5920), Offset(15.0100, 1.3810), Offset(14.9630, 1.1950), Offset(14.9160, 1.0070), Offset(14.8360, 0.8450), Offset(14.7260, 0.7090), Offset(14.6140, 0.5720), Offset(14.4630, 0.4670), Offset(14.2720, 0.3950), Offset(14.0830, 0.3180), Offset(13.8470, 0.2800), Offset(13.5620, 0.2800), Offset(13.2800, 0.2800), Offset(13.0120, 0.3010), Offset(12.7560, 0.3440), Offset(12.4990, 0.3820), Offset(12.2900, 0.4250), Offset(12.1290, 0.4720), Offset(12.1290, 3.7220), Offset(15.7290, 3.6160), Offset(15.7370, 3.6070), Offset(15.7490, 3.5960), Offset(15.7580, 3.5880), Offset(15.7840, 3.5620), Offset(15.7990, 3.5280), Offset(15.7990, 3.4910), Offset(15.7990, 3.4910), Offset(15.7990, 3.4890), Offset(15.7990, 3.4870), Offset(15.7940, 3.4400), Offset(15.7670, 3.4000), Offset(15.7690, 3.4040), Offset(15.7630, 3.3840), Offset(15.7370, 3.3540), Offset(15.7110, 3.3210), Offset(15.6710, 3.3030), Offset(15.6230, 3.3060), Offset(15.5490, 3.3180), Offset(15.4990, 3.3740), Offset(15.4990, 3.4410), Offset(15.4990, 3.4410), Offset(15.4990, 3.5240), Offset(15.4990, 3.5240), Offset(15.5010, 3.5790), Offset(15.5330, 3.6280), Offset(15.5850, 3.6480), Offset(15.6340, 3.6670), Offset(15.6910, 3.6560), Offset(15.7290, 3.6160), Offset(-14.6620, 3.7220), Offset(-13.7080, 3.7220), Offset(-13.7080, 1.1500), Offset(-13.6670, 1.1370), Offset(-13.6050, 1.1260), Offset(-13.5240, 1.1180), Offset(-13.4390, 1.1050), Offset(-13.3660, 1.0980), Offset(-13.3060, 1.0980), Offset(-13.1740, 1.0980), Offset(-13.0510, 1.1120), Offset(-12.9360, 1.1370), Offset(-12.8190, 1.1580), Offset(-12.7190, 1.1800), Offset(-12.6340, 1.2010), Offset(-12.4740, 0.4140), Offset(-12.5260, 0.3920), Offset(-12.5870, 0.3750), Offset(-12.6600, 0.3630), Offset(-12.7330, 0.3450), Offset(-12.8060, 0.3330), Offset(-12.8780, 0.3250), Offset(-12.9510, 0.3120), Offset(-13.0220, 0.3030), Offset(-13.0960, 0.2990), Offset(-13.1670, 0.2900), Offset(-13.2290, 0.2860), Offset(-13.2800, 0.2860), Offset(-13.5650, 0.2860), Offset(-13.8270, 0.3140), Offset(-14.0600, 0.3690), Offset(-14.2920, 0.4200), Offset(-14.4920, 0.4760), Offset(-14.6620, 0.5360), Offset(-14.6620, 3.7220), Offset(-6.3780, 3.7220), Offset(-5.4250, 3.7220), Offset(-5.4250, 1.1250), Offset(-5.3650, 1.1150), Offset(-5.2970, 1.1100), Offset(-5.2200, 1.1050), Offset(-5.1430, 1.0970), Offset(-5.0700, 1.0920), Offset(-5.0020, 1.0920), Offset(-4.7800, 1.0920), Offset(-4.6280, 1.1560), Offset(-4.5490, 1.2850), Offset(-4.4670, 1.4110), Offset(-4.4270, 1.6300), Offset(-4.4270, 1.9370), Offset(-4.4270, 3.7220), Offset(-3.4740, 3.7220), Offset(-3.4740, 1.8210), Offset(-3.4740, 1.5920), Offset(-3.4970, 1.3810), Offset(-3.5440, 1.1950), Offset(-3.5910, 1.0070), Offset(-3.6690, 0.8450), Offset(-3.7810, 0.7090), Offset(-3.8900, 0.5720), Offset(-4.0420, 0.4670), Offset(-4.2350, 0.3950), Offset(-4.4220, 0.3180), Offset(-4.6580, 0.2800), Offset(-4.9450, 0.2800), Offset(-5.2270, 0.2800), Offset(-5.4950, 0.3010), Offset(-5.7510, 0.3440), Offset(-6.0070, 0.3820), Offset(-6.2170, 0.4250), Offset(-6.3780, 0.4720), Offset(-6.3780, 3.7220), Offset(17.0920, 4.9240), Offset(17.6770, 4.9240), Offset(18.1070, 4.7900), Offset(18.3850, 4.5220), Offset(18.6650, 4.2570), Offset(18.8060, 3.8490), Offset(18.8060, 3.2990), Offset(18.8060, 0.4720), Offset(18.7220, 0.4460), Offset(18.6240, 0.4220), Offset(18.5120, 0.4020), Offset(18.4050, 0.3750), Offset(18.2920, 0.3540), Offset(18.1730, 0.3370), Offset(18.0530, 0.3200), Offset(17.9310, 0.3070), Offset(17.8090, 0.2990), Offset(17.6890, 0.2860), Offset(17.5720, 0.2800), Offset(17.4570, 0.2800), Offset(17.1870, 0.2800), Offset(16.9470, 0.3200), Offset(16.7340, 0.4020), Offset(16.5210, 0.4780), Offset(16.3390, 0.5890), Offset(16.1890, 0.7330), Offset(16.0440, 0.8780), Offset(15.9340, 1.0530), Offset(15.8570, 1.2590), Offset(15.7810, 1.4580), Offset(15.7430, 1.6830), Offset(15.7430, 1.9300), Offset(15.7430, 2.4240), Offset(15.8660, 2.8110), Offset(16.1130, 3.0870), Offset(16.3610, 3.3610), Offset(16.7170, 3.4980), Offset(17.1820, 3.4980), Offset(17.3090, 3.4980), Offset(17.4270, 3.4870), Offset(17.5330, 3.4660), Offset(17.6440, 3.4410), Offset(17.7500, 3.4040), Offset(17.8540, 3.3570), Offset(17.8540, 3.4790), Offset(17.8540, 3.6660), Offset(17.7960, 3.8190), Offset(17.6800, 3.9390), Offset(17.5700, 4.0590), Offset(17.3770, 4.1190), Offset(17.1050, 4.1190), Offset(16.8960, 4.1190), Offset(16.7070, 4.1010), Offset(16.5430, 4.0670), Offset(16.3790, 4.0320), Offset(16.2240, 3.9860), Offset(16.0740, 3.9260), Offset(15.9080, 4.7250), Offset(16.0830, 4.7850), Offset(16.2720, 4.8320), Offset(16.4770, 4.8670), Offset(16.6820, 4.9050), Offset(16.8870, 4.9240), Offset(17.0920, 4.9240), Offset(1.7260, 3.8100), Offset(1.8460, 3.8100), Offset(1.9650, 3.8040), Offset(2.0840, 3.7930), Offset(2.2040, 3.7790), Offset(2.3140, 3.7630), Offset(2.4170, 3.7410), Offset(2.5240, 3.7240), Offset(2.6190, 3.7030), Offset(2.7050, 3.6770), Offset(2.7900, 3.6510), Offset(2.8590, 3.6260), Offset(2.9100, 3.6010), Offset(2.7820, 2.8260), Offset(2.6750, 2.8730), Offset(2.5380, 2.9120), Offset(2.3650, 2.9480), Offset(2.1990, 2.9780), Offset(2.0290, 2.9930), Offset(1.8540, 2.9930), Offset(1.5810, 2.9930), Offset(1.3640, 2.9340), Offset(1.2010, 2.8200), Offset(1.0390, 2.7040), Offset(0.9470, 2.5500), Offset(0.9260, 2.3530), Offset(3.0880, 2.3530), Offset(3.0940, 2.3010), Offset(3.0970, 2.2450), Offset(3.1020, 2.1800), Offset(3.1050, 2.1120), Offset(3.1090, 2.0500), Offset(3.1090, 1.9950), Offset(3.1090, 1.4260), Offset(2.9680, 0.9980), Offset(2.6920, 0.7090), Offset(2.4160, 0.4140), Offset(2.0380, 0.2670), Offset(1.5590, 0.2670), Offset(1.3540, 0.2670), Offset(1.1540, 0.3050), Offset(0.9580, 0.3820), Offset(0.7660, 0.4590), Offset(0.5960, 0.5720), Offset(0.4460, 0.7220), Offset(0.2980, 0.8700), Offset(0.1770, 1.0580), Offset(0.0810, 1.2850), Offset(-0.0090, 1.5070), Offset(-0.0520, 1.7660), Offset(-0.0520, 2.0650), Offset(-0.0520, 2.3110), Offset(-0.0190, 2.5420), Offset(0.0490, 2.7560), Offset(0.1230, 2.9690), Offset(0.2310, 3.1540), Offset(0.3760, 3.3120), Offset(0.5240, 3.4660), Offset(0.7120, 3.5880), Offset(0.9330, 3.6770), Offset(1.1590, 3.7650), Offset(1.4220, 3.8100), Offset(1.7260, 3.8100), Offset(-8.4960, 3.8100), Offset(-8.3760, 3.8100), Offset(-8.2570, 3.8040), Offset(-8.1370, 3.7930), Offset(-8.0170, 3.7790), Offset(-7.9080, 3.7630), Offset(-7.8040, 3.7410), Offset(-7.6970, 3.7240), Offset(-7.6030, 3.7030), Offset(-7.5160, 3.6770), Offset(-7.4310, 3.6510), Offset(-7.3630, 3.6260), Offset(-7.3110, 3.6010), Offset(-7.4400, 2.8260), Offset(-7.5460, 2.8730), Offset(-7.6840, 2.9120), Offset(-7.8550, 2.9480), Offset(-8.0220, 2.9780), Offset(-8.1930, 2.9930), Offset(-8.3680, 2.9930), Offset(-8.6400, 2.9930), Offset(-8.8570, 2.9340), Offset(-9.0200, 2.8200), Offset(-9.1820, 2.7040), Offset(-9.2730, 2.5500), Offset(-9.2960, 2.3530), Offset(-7.1320, 2.3530), Offset(-7.1280, 2.3010), Offset(-7.1240, 2.2450), Offset(-7.1190, 2.1800), Offset(-7.1160, 2.1120), Offset(-7.1130, 2.0500), Offset(-7.1130, 1.9950), Offset(-7.1130, 1.4260), Offset(-7.2520, 0.9980), Offset(-7.5290, 0.7090), Offset(-7.8060, 0.4140), Offset(-8.1840, 0.2670), Offset(-8.6620, 0.2670), Offset(-8.8670, 0.2670), Offset(-9.0670, 0.3050), Offset(-9.2640, 0.3820), Offset(-9.4550, 0.4590), Offset(-9.6250, 0.5720), Offset(-9.7750, 0.7220), Offset(-9.9230, 0.8700), Offset(-10.0450, 1.0580), Offset(-10.1400, 1.2850), Offset(-10.2300, 1.5070), Offset(-10.2730, 1.7660), Offset(-10.2730, 2.0650), Offset(-10.2730, 2.3110), Offset(-10.2400, 2.5420), Offset(-10.1710, 2.7560), Offset(-10.0980, 2.9690), Offset(-9.9900, 3.1540), Offset(-9.8450, 3.3120), Offset(-9.6960, 3.4660), Offset(-9.5100, 3.5880), Offset(-9.2880, 3.6770), Offset(-9.0620, 3.7650), Offset(-8.7980, 3.8100), Offset(-8.4960, 3.8100), Offset(-12.4840, -0.1460), Offset(-12.4540, -0.1810), Offset(-12.4420, -0.2300), Offset(-12.4570, -0.2740), Offset(-12.4970, -0.3940), Offset(-12.5240, -0.5120), Offset(-12.5240, -0.6160), Offset(-12.5240, -0.6190), Offset(-12.5020, -0.6700), Offset(-12.4910, -0.7530), Offset(-12.4840, -0.7940), Offset(-12.4960, -0.8360), Offset(-12.5240, -0.8660), Offset(-12.5540, -0.8960), Offset(-12.5940, -0.9110), Offset(-12.6400, -0.9050), Offset(-12.7650, -0.8820), Offset(-12.8860, -0.8660), Offset(-13.0020, -0.8660), Offset(-13.0090, -0.8660), Offset(-13.0430, -0.8760), Offset(-13.1020, -0.8780), Offset(-13.1390, -0.8790), Offset(-13.1740, -0.8660), Offset(-13.1990, -0.8410), Offset(-13.2250, -0.8140), Offset(-13.2400, -0.7810), Offset(-13.2400, -0.7450), Offset(-13.2400, -0.7450), Offset(-13.2400, -0.3000), Offset(-13.2400, -0.3000), Offset(-13.2400, -0.2300), Offset(-13.1880, -0.1710), Offset(-13.1190, -0.1660), Offset(-13.0790, -0.1610), Offset(-13.0640, -0.1650), Offset(-13.0740, -0.1660), Offset(-13.0560, -0.1640), Offset(-13.0370, -0.1610), Offset(-12.9640, -0.1560), Offset(-12.8950, -0.1480), Offset(-12.8270, -0.1360), Offset(-12.8060, -0.1330), Offset(-12.7970, -0.1330), Offset(-12.7950, -0.1330), Offset(-12.7950, -0.1320), Offset(-12.7930, -0.1320), Offset(-12.7950, -0.1330), Offset(-12.7350, -0.1250), Offset(-12.6730, -0.1160), Offset(-12.6070, -0.1030), Offset(-12.5610, -0.0950), Offset(-12.5140, -0.1120), Offset(-12.4840, -0.1460), Offset(-14.6620, -0.2130), Offset(-13.7080, -0.2130), Offset(-13.7080, -1.4790), Offset(-13.6020, -1.4320), Offset(-13.4920, -1.3950), Offset(-13.3770, -1.3710), Offset(-13.2610, -1.3460), Offset(-13.1370, -1.3330), Offset(-13.0060, -1.3330), Offset(-12.7650, -1.3330), Offset(-12.5560, -1.3760), Offset(-12.3730, -1.4610), Offset(-12.1890, -1.5460), Offset(-12.0340, -1.6660), Offset(-11.9110, -1.8190), Offset(-11.7880, -1.9720), Offset(-11.6940, -2.1560), Offset(-11.6290, -2.3680), Offset(-11.5660, -2.5820), Offset(-11.5350, -2.8190), Offset(-11.5350, -3.0780), Offset(-11.5350, -3.3480), Offset(-11.5740, -3.5910), Offset(-11.6570, -3.8080), Offset(-11.7320, -4.0270), Offset(-11.8460, -4.2100), Offset(-11.9950, -4.3580), Offset(-12.1440, -4.5130), Offset(-12.3280, -4.6300), Offset(-12.5440, -4.7110), Offset(-12.7630, -4.7960), Offset(-13.0090, -4.8380), Offset(-13.2870, -4.8380), Offset(-13.4020, -4.8380), Offset(-13.5240, -4.8330), Offset(-13.6520, -4.8190), Offset(-13.7760, -4.8110), Offset(-13.8980, -4.7980), Offset(-14.0220, -4.7810), Offset(-14.1420, -4.7650), Offset(-14.2570, -4.7430), Offset(-14.3690, -4.7160), Offset(-14.4780, -4.6970), Offset(-14.5760, -4.6730), Offset(-14.6620, -4.6460), Offset(-14.6620, -0.2130), Offset(-17.0510, 3.8100), Offset(-16.8000, 3.8100), Offset(-16.5740, 3.7690), Offset(-16.3730, 3.6840), Offset(-16.1680, 3.5980), Offset(-15.9930, 3.4790), Offset(-15.8480, 3.3240), Offset(-15.7030, 3.1680), Offset(-15.5930, 2.9800), Offset(-15.5170, 2.7630), Offset(-15.4400, 2.5400), Offset(-15.4010, 2.2980), Offset(-15.4010, 2.0330), Offset(-15.4010, 1.7680), Offset(-15.4420, 1.5260), Offset(-15.5230, 1.3100), Offset(-15.6030, 1.0920), Offset(-15.7160, 0.9060), Offset(-15.8610, 0.7540), Offset(-16.0060, 0.6000), Offset(-16.1820, 0.4800), Offset(-16.3860, 0.3950), Offset(-16.5860, 0.3100), Offset(-16.8080, 0.2670), Offset(-17.0510, 0.2670), Offset(-17.2910, 0.2670), Offset(-17.5120, 0.3100), Offset(-17.7170, 0.3950), Offset(-17.9170, 0.4800), Offset(-18.0920, 0.6000), Offset(-18.2420, 0.7540), Offset(-18.3870, 0.9060), Offset(-18.5020, 1.0920), Offset(-18.5870, 1.3100), Offset(-18.6690, 1.5260), Offset(-18.7080, 1.7680), Offset(-18.7080, 2.0330), Offset(-18.7080, 2.2980), Offset(-18.6690, 2.5400), Offset(-18.5870, 2.7630), Offset(-18.5050, 2.9800), Offset(-18.3920, 3.1680), Offset(-18.2470, 3.3240), Offset(-18.1020, 3.4790), Offset(-17.9310, 3.5980), Offset(-17.7290, 3.6840), Offset(-17.5250, 3.7690), Offset(-17.2990, 3.8100), Offset(-17.0510, 3.8100), Offset(5.4630, 3.8100), Offset(5.5810, 3.8100), Offset(5.7010, 3.8040), Offset(5.8210, 3.7930), Offset(5.9390, 3.7790), Offset(6.0510, 3.7630), Offset(6.1520, 3.7410), Offset(6.2590, 3.7240), Offset(6.3560, 3.7030), Offset(6.4410, 3.6770), Offset(6.5260, 3.6510), Offset(6.5940, 3.6260), Offset(6.6460, 3.6010), Offset(6.5180, 2.8260), Offset(6.4110, 2.8730), Offset(6.2720, 2.9120), Offset(6.1030, 2.9480), Offset(5.9360, 2.9780), Offset(5.7650, 2.9930), Offset(5.5900, 2.9930), Offset(5.3180, 2.9930), Offset(5.1000, 2.9340), Offset(4.9380, 2.8200), Offset(4.7750, 2.7040), Offset(4.6830, 2.5500), Offset(4.6630, 2.3530), Offset(6.8260, 2.3530), Offset(6.8290, 2.3010), Offset(6.8340, 2.2450), Offset(6.8370, 2.1800), Offset(6.8430, 2.1120), Offset(6.8440, 2.0500), Offset(6.8440, 1.9950), Offset(6.8440, 1.4260), Offset(6.7060, 0.9980), Offset(6.4280, 0.7090), Offset(6.1510, 0.4140), Offset(5.7730, 0.2670), Offset(5.2970, 0.2670), Offset(5.0910, 0.2670), Offset(4.8910, 0.3050), Offset(4.6950, 0.3820), Offset(4.5030, 0.4590), Offset(4.3320, 0.5720), Offset(4.1830, 0.7220), Offset(4.0330, 0.8700), Offset(3.9110, 1.0580), Offset(3.8190, 1.2850), Offset(3.7290, 1.5070), Offset(3.6840, 1.7660), Offset(3.6840, 2.0650), Offset(3.6840, 2.3110), Offset(3.7190, 2.5420), Offset(3.7870, 2.7560), Offset(3.8580, 2.9690), Offset(3.9670, 3.1540), Offset(4.1120, 3.3120), Offset(4.2620, 3.4660), Offset(4.4460, 3.5880), Offset(4.6680, 3.6770), Offset(4.8950, 3.7650), Offset(5.1600, 3.8100), Offset(5.4630, 3.8100), Offset(-1.0650, 2.5210), Offset(-1.0180, 2.5180), Offset(-0.9690, 2.5180), Offset(-0.9110, 2.5080), Offset(-0.9100, 2.5080), Offset(-0.9090, 2.5060), Offset(-0.9070, 2.5050), Offset(-0.8300, 2.4890), Offset(-0.7620, 2.4730), Offset(-0.7040, 2.4500), Offset(-0.7020, 2.4500), Offset(-0.7000, 2.4500), Offset(-0.6980, 2.4500), Offset(-0.6700, 2.4390), Offset(-0.6420, 2.4260), Offset(-0.6120, 2.4220), Offset(-0.5450, 2.4090), Offset(-0.5000, 2.3500), Offset(-0.5030, 2.2830), Offset(-0.5090, 2.2030), Offset(-0.5200, 2.1310), Offset(-0.5200, 2.0670), Offset(-0.5200, 1.9730), Offset(-0.5020, 1.8750), Offset(-0.4900, 1.7630), Offset(-0.4870, 1.7250), Offset(-0.5000, 1.6880), Offset(-0.5250, 1.6600), Offset(-0.5500, 1.6330), Offset(-0.5860, 1.6160), Offset(-0.6230, 1.6160), Offset(-1.1060, 1.6160), Offset(-1.1700, 1.6300), Offset(-1.2170, 1.6870), Offset(-1.2150, 1.7500), Offset(-1.2150, 2.3330), Offset(-1.2150, 2.3600), Offset(-1.2110, 2.3860), Offset(-1.2060, 2.4050), Offset(-1.1980, 2.4740), Offset(-1.1360, 2.5270), Offset(-1.0650, 2.5210), Offset(-11.4900, -0.0520), Offset(-11.3360, -0.0520), Offset(-11.2040, -0.1010), Offset(-11.0930, -0.2000), Offset(-10.9780, -0.3030), Offset(-10.9200, -0.4410), Offset(-10.9200, -0.6160), Offset(-10.9200, -0.7910), Offset(-10.9780, -0.9270), Offset(-11.0930, -1.0260), Offset(-11.2040, -1.1280), Offset(-11.3360, -1.1790), Offset(-11.4900, -1.1790), Offset(-11.6420, -1.1790), Offset(-11.7770, -1.1280), Offset(-11.8930, -1.0260), Offset(-12.0040, -0.9270), Offset(-12.0590, -0.7910), Offset(-12.0590, -0.6160), Offset(-12.0590, -0.4410), Offset(-12.0040, -0.3030), Offset(-11.8930, -0.2000), Offset(-11.7770, -0.1010), Offset(-11.6420, -0.0520), Offset(-11.4900, -0.0520), Offset(-17.0510, -1.3070), Offset(-16.8000, -1.3070), Offset(-16.5740, -1.3490), Offset(-16.3730, -1.4340), Offset(-16.1680, -1.5210), Offset(-15.9930, -1.6390), Offset(-15.8480, -1.7940), Offset(-15.7030, -1.9510), Offset(-15.5930, -2.1390), Offset(-15.5170, -2.3550), Offset(-15.4400, -2.5790), Offset(-15.4010, -2.8200), Offset(-15.4010, -3.0850), Offset(-15.4010, -3.3500), Offset(-15.4420, -3.5910), Offset(-15.5230, -3.8080), Offset(-15.6030, -4.0270), Offset(-15.7160, -4.2110), Offset(-15.8610, -4.3650), Offset(-16.0060, -4.5180), Offset(-16.1820, -4.6380), Offset(-16.3860, -4.7230), Offset(-16.5860, -4.8080), Offset(-16.8080, -4.8510), Offset(-17.0510, -4.8510), Offset(-17.2910, -4.8510), Offset(-17.5120, -4.8080), Offset(-17.7170, -4.7230), Offset(-17.9170, -4.6380), Offset(-18.0920, -4.5180), Offset(-18.2420, -4.3650), Offset(-18.3870, -4.2110), Offset(-18.5020, -4.0270), Offset(-18.5870, -3.8080), Offset(-18.6690, -3.5910), Offset(-18.7080, -3.3500), Offset(-18.7080, -3.0850), Offset(-18.7080, -2.8200), Offset(-18.6690, -2.5790), Offset(-18.5870, -2.3550), Offset(-18.5050, -2.1390), Offset(-18.3920, -1.9510), Offset(-18.2470, -1.7940), Offset(-18.1020, -1.6390), Offset(-17.9310, -1.5210), Offset(-17.7290, -1.4340), Offset(-17.5250, -1.3490), Offset(-17.2990, -1.3070), Offset(-17.0510, -1.3070), Offset(-7.0640, -1.3950), Offset(-6.1120, -1.3950), Offset(-6.1120, -3.9930), Offset(-6.0520, -4.0040), Offset(-5.9830, -4.0080), Offset(-5.9070, -4.0130), Offset(-5.8300, -4.0210), Offset(-5.7590, -4.0270), Offset(-5.6900, -4.0270), Offset(-5.4680, -4.0270), Offset(-5.3170, -3.9610), Offset(-5.2350, -3.8330), Offset(-5.1550, -3.7070), Offset(-5.1130, -3.4880), Offset(-5.1130, -3.1820), Offset(-5.1130, -1.3950), Offset(-4.1600, -1.3950), Offset(-4.1600, -3.2960), Offset(-4.1600, -3.5270), Offset(-4.1830, -3.7370), Offset(-4.2300, -3.9230), Offset(-4.2770, -4.1110), Offset(-4.3570, -4.2730), Offset(-4.4670, -4.4100), Offset(-4.5790, -4.5470), Offset(-4.7300, -4.6520), Offset(-4.9210, -4.7230), Offset(-5.1100, -4.8000), Offset(-5.3470, -4.8380), Offset(-5.6310, -4.8380), Offset(-5.9130, -4.8380), Offset(-6.1810, -4.8180), Offset(-6.4380, -4.7740), Offset(-6.6940, -4.7360), Offset(-6.9030, -4.6930), Offset(-7.0640, -4.6460), Offset(-7.0640, -1.3950), Offset(-11.0990, -1.6440), Offset(-11.0680, -1.6890), Offset(-11.0670, -1.7480), Offset(-11.0950, -1.7940), Offset(-11.1200, -1.8340), Offset(-11.1280, -1.8420), Offset(-11.1200, -1.8270), Offset(-11.1430, -1.8720), Offset(-11.1890, -1.8990), Offset(-11.2420, -1.8990), Offset(-11.2460, -1.8970), Offset(-11.2510, -1.8950), Offset(-11.2580, -1.8940), Offset(-11.2980, -1.8870), Offset(-11.3320, -1.8620), Offset(-11.3530, -1.8270), Offset(-11.3580, -1.8220), Offset(-11.3640, -1.8140), Offset(-11.3750, -1.7990), Offset(-11.3940, -1.7610), Offset(-11.3960, -1.7180), Offset(-11.3790, -1.6790), Offset(-11.3620, -1.6390), Offset(-11.3280, -1.6110), Offset(-11.2870, -1.6020), Offset(-11.2570, -1.5960), Offset(-11.2400, -1.5940), Offset(-11.2420, -1.5940), Offset(-11.1880, -1.5810), Offset(-11.1330, -1.6010), Offset(-11.0990, -1.6440), Offset(-9.1820, -1.3070), Offset(-9.0630, -1.3070), Offset(-8.9440, -1.3140), Offset(-8.8240, -1.3260), Offset(-8.7060, -1.3390), Offset(-8.5940, -1.3560), Offset(-8.4920, -1.3780), Offset(-8.3850, -1.3950), Offset(-8.2890, -1.4160), Offset(-8.2040, -1.4400), Offset(-8.1190, -1.4680), Offset(-8.0510, -1.4930), Offset(-7.9990, -1.5170), Offset(-8.1270, -2.2920), Offset(-8.2340, -2.2460), Offset(-8.3720, -2.2050), Offset(-8.5420, -2.1710), Offset(-8.7080, -2.1410), Offset(-8.8810, -2.1260), Offset(-9.0550, -2.1260), Offset(-9.3270, -2.1260), Offset(-9.5450, -2.1840), Offset(-9.7070, -2.2990), Offset(-9.8700, -2.4130), Offset(-9.9610, -2.5690), Offset(-9.9820, -2.7660), Offset(-7.8190, -2.7660), Offset(-7.8160, -2.8170), Offset(-7.8100, -2.8730), Offset(-7.8080, -2.9390), Offset(-7.8030, -3.0070), Offset(-7.8010, -3.0690), Offset(-7.8010, -3.1230), Offset(-7.8010, -3.6920), Offset(-7.9390, -4.1200), Offset(-8.2170, -4.4100), Offset(-8.4940, -4.7050), Offset(-8.8720, -4.8510), Offset(-9.3490, -4.8510), Offset(-9.5530, -4.8510), Offset(-9.7540, -4.8130), Offset(-9.9500, -4.7360), Offset(-10.1410, -4.6600), Offset(-10.3140, -4.5470), Offset(-10.4620, -4.3960), Offset(-10.6110, -4.2480), Offset(-10.7330, -4.0600), Offset(-10.8270, -3.8330), Offset(-10.9170, -3.6120), Offset(-10.9620, -3.3520), Offset(-10.9620, -3.0540), Offset(-10.9620, -2.8070), Offset(-10.9260, -2.5750), Offset(-10.8580, -2.3620), Offset(-10.7870, -2.1490), Offset(-10.6780, -1.9640), Offset(-10.5330, -1.8060), Offset(-10.3830, -1.6520), Offset(-10.1980, -1.5300), Offset(-9.9760, -1.4400), Offset(-9.7500, -1.3520), Offset(-9.4850, -1.3070), Offset(-9.1820, -1.3070)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'24',
            rotatable: false,
          ),
          coords: [Offset(16.4280, 5.9640), Offset(15.4930, 5.8160), Offset(15.1560, 5.6330), Offset(14.9050, 5.1360), Offset(14.8420, 5.0100), Offset(14.7670, 4.8930), Offset(14.7390, 4.8750), Offset(14.6860, 4.8430), Offset(13.8290, 4.7690), Offset(13.5880, 4.7770), Offset(13.5110, 4.7790), Offset(12.6730, 4.7860), Offset(11.7260, 4.7910), Offset(10.0030, 4.8010), Offset(9.4120, 4.4910), Offset(8.8100, 4.8010), Offset(8.1890, 4.8150), Offset(7.7030, 4.8260), Offset(7.5010, 4.8140), Offset(7.2610, 4.7590), Offset(6.9570, 4.6900), Offset(6.9500, 4.6900), Offset(6.5210, 4.7850), Offset(6.1700, 4.8630), Offset(5.9740, 4.8810), Offset(5.4880, 4.8800), Offset(5.4570, 4.8800), Offset(4.8110, 4.8800), Offset(4.5630, 4.8310), Offset(4.0740, 4.6000), Offset(3.9120, 4.5240), Offset(3.7450, 4.4610), Offset(3.7030, 4.4610), Offset(3.6600, 4.4610), Offset(3.5400, 4.5040), Offset(3.4370, 4.5560), Offset(2.8810, 4.8380), Offset(1.8580, 4.9730), Offset(1.1480, 4.8590), Offset(1.0050, 4.8350), Offset(0.7410, 4.7650), Offset(0.5600, 4.7030), Offset(0.2060, 4.5790), Offset(0.2010, 4.5790), Offset(-0.2800, 4.7370), Offset(-0.6400, 4.8540), Offset(-1.1730, 4.9150), Offset(-1.5640, 4.8830), Offset(-1.8760, 4.8580), Offset(-2.0850, 4.8060), Offset(-2.5220, 4.6440), Offset(-2.6870, 4.5830), Offset(-2.7000, 4.5850), Offset(-2.9620, 4.6910), Offset(-3.2210, 4.7960), Offset(-3.2600, 4.8010), Offset(-3.9120, 4.7990), Offset(-4.2860, 4.7970), Offset(-4.7000, 4.7910), Offset(-4.8320, 4.7850), Offset(-4.9640, 4.7790), Offset(-5.3680, 4.7860), Offset(-5.7290, 4.8020), Offset(-6.2860, 4.8270), Offset(-6.4330, 4.8200), Offset(-6.6970, 4.7600), Offset(-7.0030, 4.6900), Offset(-7.0120, 4.6900), Offset(-7.4200, 4.7790), Offset(-8.2630, 4.9640), Offset(-9.1170, 4.9260), Offset(-9.6990, 4.6790), Offset(-10.0910, 4.5130), Offset(-10.1770, 4.5110), Offset(-10.4820, 4.6660), Offset(-10.7480, 4.8010), Offset(-12.2380, 4.8010), Offset(-12.5410, 4.6450), Offset(-12.8440, 4.4890), Offset(-13.1380, 4.6450), Offset(-13.4320, 4.8010), Offset(-14.9220, 4.8010), Offset(-15.2080, 4.6630), Offset(-15.5290, 4.5070), Offset(-15.4670, 4.5020), Offset(-16.1520, 4.7440), Offset(-16.8310, 4.9840), Offset(-17.6210, 4.9450), Offset(-18.2380, 4.6420), Offset(-19.0100, 4.2610), Offset(-19.4820, 3.6850), Offset(-19.6910, 2.8650), Offset(-19.9080, 2.0130), Offset(-19.8010, 1.1560), Offset(-19.3910, 0.4680), Offset(-19.2270, 0.1940), Offset(-19.0670, 0.0140), Offset(-18.7620, -0.2380), Offset(-18.4600, -0.4880), Offset(-18.4620, -0.5520), Offset(-18.7720, -0.7930), Offset(-19.0300, -0.9930), Offset(-19.3470, -1.3930), Offset(-19.5070, -1.7200), Offset(-19.7000, -2.1130), Offset(-19.7890, -2.5520), Offset(-19.7890, -3.0990), Offset(-19.7880, -3.6880), Offset(-19.7270, -3.9660), Offset(-19.4890, -4.4500), Offset(-19.1920, -5.0570), Offset(-18.5720, -5.5900), Offset(-17.9120, -5.8060), Offset(-17.3740, -5.9840), Offset(-16.5460, -5.9880), Offset(-15.7700, -5.6330), Offset(-15.4470, -5.4850), Offset(-15.2390, -5.5760), Offset(-14.7400, -5.7940), Offset(-14.0920, -5.9080), Offset(-13.3520, -5.9090), Offset(-12.5690, -5.9090), Offset(-12.1180, -5.7790), Offset(-11.5320, -5.3810), Offset(-11.4330, -5.3140), Offset(-11.3150, -5.2590), Offset(-11.2700, -5.2590), Offset(-11.2250, -5.2590), Offset(-11.0470, -5.3520), Offset(-10.8750, -5.4650), Offset(-10.0150, -6.0290), Offset(-9.0780, -6.0790), Offset(-8.0230, -5.6160), Offset(-7.8130, -5.5240), Offset(-7.4430, -5.6480), Offset(-6.6380, -5.9170), Offset(-5.4820, -5.9960), Offset(-4.8400, -5.8240), Offset(-4.2360, -5.6630), Offset(-3.7680, -5.3390), Offset(-3.4670, -4.8730), Offset(-3.1480, -4.3780), Offset(-3.0900, -4.0730), Offset(-3.0640, -2.7790), Offset(-3.0520, -2.1960), Offset(-3.0260, -1.6870), Offset(-3.0060, -1.6490), Offset(-2.9590, -1.5600), Offset(-2.7870, -1.5590), Offset(-2.3120, -1.6440), Offset(-2.1140, -1.6790), Offset(-1.8350, -1.7090), Offset(-1.6910, -1.7090), Offset(-1.2290, -1.7120), Offset(-0.8880, -1.4860), Offset(-0.6540, -1.0240), Offset(-0.5410, -0.7990), Offset(-0.5280, -0.7880), Offset(-0.2450, -0.6810), Offset(0.1870, -0.5190), Offset(0.2430, -0.5180), Offset(0.6680, -0.6620), Offset(0.9650, -0.7630), Offset(1.1350, -0.7950), Offset(1.4480, -0.8090), Offset(2.0910, -0.8370), Offset(2.5660, -0.7040), Offset(3.1310, -0.3370), Offset(3.2640, -0.2500), Offset(3.4000, -0.1790), Offset(3.4320, -0.1790), Offset(3.4640, -0.1790), Offset(3.6190, -0.2590), Offset(3.7770, -0.3580), Offset(4.1370, -0.5810), Offset(4.2870, -0.6440), Offset(4.6880, -0.7410), Offset(5.2980, -0.8880), Offset(5.8960, -0.8210), Offset(6.5190, -0.5340), Offset(6.8700, -0.3720), Offset(7.1770, -0.4780), Offset(7.6250, -0.6330), Offset(8.0760, -0.7330), Offset(8.5500, -0.7810), Offset(9.0200, -0.8290), Offset(9.1050, -0.8760), Offset(9.1820, -1.1330), Offset(9.3080, -1.5540), Offset(9.6940, -1.9430), Offset(10.0950, -2.1290), Offset(10.4560, -2.2990), Offset(11.0450, -2.2790), Offset(11.4280, -2.0950), Offset(11.8800, -1.8780), Offset(12.1700, -1.5930), Offset(12.3290, -1.1080), Offset(12.4410, -0.7660), Offset(12.4550, -0.7560), Offset(12.8150, -0.7790), Offset(14.0100, -0.8550), Offset(14.6390, -0.7300), Offset(15.2380, -0.2970), Offset(15.3270, -0.2320), Offset(15.4350, -0.1790), Offset(15.4790, -0.1790), Offset(15.5220, -0.1790), Offset(15.6860, -0.2580), Offset(15.8430, -0.3550), Offset(16.6030, -0.8240), Offset(17.4540, -0.9220), Offset(18.6510, -0.6790), Offset(19.2040, -0.5670), Offset(19.4170, -0.4690), Offset(19.6280, -0.2300), Offset(19.9000, 0.0790), Offset(19.9080, 0.1450), Offset(19.9080, 1.9510), Offset(19.9080, 2.0680), Offset(19.9080, 3.6510), Offset(19.8860, 3.9340), Offset(19.7180, 4.4010), Offset(19.5030, 5.0000), Offset(19.1400, 5.4020), Offset(18.5440, 5.7030), Offset(18.0070, 5.9740), Offset(17.1550, 6.0790), Offset(16.4280, 5.9640), Offset(17.9280, 5.5610), Offset(18.7000, 5.3630), Offset(19.2320, 4.8450), Offset(19.4560, 4.0710), Offset(19.5120, 3.8770), Offset(19.5250, 3.5760), Offset(19.5380, 2.1410), Offset(19.5500, 0.9420), Offset(19.5410, 0.3960), Offset(19.5090, 0.2890), Offset(19.4380, 0.0500), Offset(19.2140, -0.1700), Offset(18.9730, -0.2380), Offset(18.2650, -0.4380), Offset(17.2330, -0.4980), Offset(16.7510, -0.3670), Offset(16.3480, -0.2570), Offset(15.9930, -0.0620), Offset(15.7060, 0.2080), Offset(15.4440, 0.4560), Offset(15.3060, 0.2710), Offset(15.1160, 0.0170), Offset(14.7910, -0.1940), Offset(14.3880, -0.3270), Offset(14.0800, -0.4280), Offset(13.9970, -0.4390), Offset(13.5080, -0.4360), Offset(13.0480, -0.4330), Offset(12.4420, -0.3640), Offset(12.0830, -0.2740), Offset(12.0000, -0.2530), Offset(11.9980, -0.2590), Offset(12.0350, -0.4360), Offset(12.0800, -0.6470), Offset(12.0300, -0.9450), Offset(11.9080, -1.1990), Offset(11.6360, -1.7620), Offset(10.8970, -2.0450), Offset(10.2920, -1.8170), Offset(9.8060, -1.6350), Offset(9.4680, -1.1480), Offset(9.4680, -0.6320), Offset(9.4680, -0.4070), Offset(9.2160, -0.4310), Offset(8.8660, -0.4640), Offset(8.2560, -0.3990), Offset(7.7830, -0.2800), Offset(7.3230, -0.1630), Offset(7.2010, -0.1080), Offset(7.0460, 0.0570), Offset(6.9340, 0.1750), Offset(6.7720, 0.0370), Offset(5.9070, -0.7040), Offset(4.3820, -0.5910), Offset(3.6070, 0.2710), Offset(3.4240, 0.4740), Offset(3.3600, 0.3770), Offset(3.1190, 0.0210), Offset(2.5220, -0.3360), Offset(2.0230, -0.4200), Offset(1.4400, -0.5180), Offset(0.7560, -0.3940), Offset(0.3410, -0.1140), Offset(0.1290, 0.0290), Offset(0.0280, -0.0910), Offset(-0.1390, -0.2890), Offset(-0.3540, -0.3790), Offset(-0.6610, -0.3790), Offset(-0.9320, -0.3790), Offset(-0.9320, -0.5090), Offset(-0.9330, -0.7500), Offset(-1.0170, -0.9550), Offset(-1.1870, -1.1240), Offset(-1.4370, -1.3740), Offset(-1.5500, -1.3910), Offset(-2.2460, -1.2830), Offset(-2.5690, -1.2320), Offset(-2.8870, -1.1630), Offset(-2.9530, -1.1290), Offset(-3.2480, -0.9750), Offset(-3.3720, -0.7180), Offset(-3.3720, -0.2580), Offset(-3.3720, 0.0650), Offset(-3.5500, -0.0580), Offset(-3.8010, -0.2300), Offset(-4.0650, -0.3370), Offset(-4.4050, -0.4020), Offset(-4.7810, -0.4750), Offset(-5.0940, -0.4740), Offset(-5.6710, -0.3980), Offset(-6.5020, -0.2890), Offset(-6.7660, -0.2020), Offset(-6.9430, 0.0240), Offset(-7.0400, 0.1490), Offset(-7.2320, 0.0030), Offset(-7.4990, -0.2010), Offset(-7.6900, -0.2920), Offset(-8.0420, -0.3810), Offset(-8.7550, -0.5640), Offset(-9.5760, -0.3950), Offset(-10.1200, 0.0470), Offset(-10.2780, 0.1750), Offset(-10.2910, 0.1780), Offset(-10.3280, 0.1080), Offset(-10.3580, 0.0530), Offset(-10.3480, -0.0230), Offset(-10.2890, -0.1760), Offset(-10.2460, -0.2910), Offset(-10.2060, -0.4650), Offset(-10.2020, -0.5630), Offset(-10.1960, -0.7050), Offset(-10.1820, -0.7360), Offset(-10.1330, -0.7160), Offset(-9.6100, -0.5090), Offset(-8.4520, -0.5500), Offset(-7.8360, -0.7990), Offset(-7.6260, -0.8840), Offset(-7.5870, -0.8890), Offset(-7.5320, -0.8390), Offset(-7.3720, -0.6940), Offset(-7.1840, -0.6590), Offset(-6.5750, -0.6590), Offset(-6.5480, -0.6590), Offset(-5.9840, -0.6590), Offset(-5.8370, -0.6840), Offset(-5.6850, -0.8100), Offset(-5.6270, -0.8590), Offset(-5.6020, -0.8540), Offset(-5.4920, -0.7720), Offset(-5.3740, -0.6860), Offset(-5.3220, -0.6780), Offset(-4.7390, -0.6660), Offset(-4.0550, -0.6520), Offset(-3.8880, -0.6800), Offset(-3.6920, -0.8450), Offset(-3.4320, -1.0640), Offset(-3.4320, -1.0660), Offset(-3.4340, -2.4790), Offset(-3.4360, -3.5400), Offset(-3.4480, -3.8050), Offset(-3.5030, -4.0290), Offset(-3.6930, -4.7910), Offset(-4.1680, -5.2770), Offset(-4.9220, -5.4830), Offset(-5.2610, -5.5750), Offset(-6.1120, -5.5660), Offset(-6.6980, -5.4630), Offset(-7.2720, -5.3630), Offset(-7.4610, -5.2890), Offset(-7.6100, -5.1090), Offset(-7.7260, -4.9680), Offset(-7.8790, -5.0880), Offset(-8.8140, -5.8250), Offset(-10.3550, -5.6850), Offset(-11.0730, -4.7980), Offset(-11.2350, -4.5960), Offset(-11.4940, -4.8600), Offset(-11.7830, -5.1550), Offset(-12.1560, -5.3700), Offset(-12.5720, -5.4820), Offset(-13.1080, -5.6260), Offset(-14.4500, -5.5230), Offset(-14.9600, -5.2990), Offset(-15.0580, -5.2560), Offset(-15.1750, -5.1600), Offset(-15.2390, -5.0690), Offset(-15.3500, -4.9130), Offset(-15.6110, -5.1030), Offset(-16.4400, -5.7040), Offset(-17.5560, -5.7330), Offset(-18.3890, -5.1760), Offset(-18.7630, -4.9260), Offset(-18.9700, -4.6890), Offset(-19.1740, -4.2790), Offset(-19.5440, -3.5360), Offset(-19.5410, -2.6230), Offset(-19.1670, -1.8590), Offset(-18.6980, -0.9030), Offset(-17.6690, -0.4170), Offset(-16.5490, -0.6230), Offset(-16.2670, -0.6750), Offset(-15.7880, -0.8880), Offset(-15.5740, -1.0570), Offset(-15.4210, -1.1790), Offset(-15.4050, -0.5890), Offset(-15.3940, -0.1690), Offset(-15.3730, 0.0260), Offset(-15.3320, 0.0890), Offset(-15.2350, 0.2390), Offset(-15.3190, 0.2370), Offset(-15.5040, 0.0860), Offset(-16.2740, -0.5460), Offset(-17.4020, -0.6340), Offset(-18.2850, -0.1320), Offset(-19.6170, 0.6240), Offset(-19.8530, 2.7340), Offset(-18.7320, 3.8630), Offset(-17.9120, 4.6890), Offset(-16.5050, 4.7720), Offset(-15.5660, 4.0500), Offset(-15.3790, 3.9070), Offset(-15.3330, 4.0190), Offset(-15.2700, 4.1700), Offset(-15.1050, 4.3230), Offset(-14.9230, 4.3990), Offset(-14.7120, 4.4870), Offset(-13.6720, 4.4870), Offset(-13.4610, 4.3990), Offset(-13.2640, 4.3170), Offset(-13.1370, 4.1950), Offset(-13.0480, 4.0010), Offset(-12.9820, 3.8600), Offset(-12.9740, 3.7280), Offset(-12.9730, 2.8710), Offset(-12.9730, 2.8230), Offset(-12.9720, 1.8430), Offset(-12.9780, 1.8740), Offset(-12.7820, 1.9260), Offset(-12.6920, 1.9500), Offset(-12.6920, 3.9730), Offset(-12.6800, 4.0380), Offset(-12.4390, 4.2500), Offset(-12.2220, 4.4400), Offset(-12.0670, 4.4710), Offset(-11.3870, 4.4550), Offset(-10.8040, 4.4410), Offset(-10.7800, 4.4380), Offset(-10.6240, 4.3290), Offset(-10.4920, 4.2380), Offset(-10.4130, 4.1340), Offset(-10.3060, 3.9080), Offset(-10.3030, 3.9010), Offset(-10.2130, 3.9630), Offset(-10.1060, 4.0440), Offset(-9.6320, 4.4080), Offset(-9.0470, 4.5660), Offset(-8.3120, 4.5280), Offset(-7.8250, 4.5030), Offset(-7.3650, 4.4160), Offset(-7.0960, 4.2970), Offset(-6.9330, 4.2260), Offset(-6.9140, 4.2250), Offset(-6.8480, 4.2840), Offset(-6.7020, 4.4170), Offset(-6.4830, 4.4570), Offset(-5.9080, 4.4590), Offset(-5.3550, 4.4610), Offset(-5.1380, 4.4260), Offset(-5.0100, 4.3170), Offset(-4.9580, 4.2720), Offset(-4.9180, 4.2790), Offset(-4.7530, 4.3620), Offset(-4.5710, 4.4540), Offset(-4.5180, 4.4610), Offset(-3.9550, 4.4600), Offset(-3.2670, 4.4590), Offset(-3.1060, 4.4140), Offset(-2.9100, 4.1680), Offset(-2.7970, 4.0270), Offset(-2.6230, 4.1470), Offset(-2.3110, 4.3620), Offset(-2.0520, 4.4560), Offset(-1.6350, 4.5050), Offset(-1.0210, 4.5770), Offset(-0.3480, 4.4540), Offset(0.0370, 4.2000), Offset(0.1860, 4.1010), Offset(0.4370, 4.2380), Offset(0.8000, 4.4350), Offset(1.0690, 4.5030), Offset(1.5880, 4.5290), Offset(1.9620, 4.5470), Offset(2.1340, 4.5350), Offset(2.5080, 4.4640), Offset(3.0720, 4.3580), Offset(3.3550, 4.2300), Offset(3.4950, 4.0170), Offset(3.5520, 3.9310), Offset(3.6070, 3.8610), Offset(3.6170, 3.8610), Offset(3.6270, 3.8610), Offset(3.7100, 3.9250), Offset(3.8020, 4.0040), Offset(4.0530, 4.2190), Offset(4.4840, 4.4140), Offset(4.8680, 4.4870), Offset(5.4400, 4.5940), Offset(6.3910, 4.5050), Offset(6.8610, 4.2990), Offset(7.0330, 4.2230), Offset(7.1980, 4.3320), Offset(7.3570, 4.4380), Offset(7.3820, 4.4410), Offset(8.0050, 4.4530), Offset(8.6110, 4.4650), Offset(8.6580, 4.4600), Offset(8.8260, 4.3730), Offset(8.9230, 4.3230), Offset(9.0580, 4.2120), Offset(9.1260, 4.1270), Offset(9.2480, 3.9740), Offset(9.2600, 2.9370), Offset(9.2720, 1.9010), Offset(9.3600, 1.9020), Offset(9.5410, 1.9030), Offset(9.5430, 1.9140), Offset(9.5560, 2.9690), Offset(9.5680, 3.9740), Offset(9.6900, 4.1270), Offset(9.7580, 4.2120), Offset(9.8920, 4.3220), Offset(9.9890, 4.3710), Offset(10.1490, 4.4530), Offset(10.2210, 4.4610), Offset(10.7670, 4.4600), Offset(11.2600, 4.4590), Offset(11.3970, 4.4460), Offset(11.5280, 4.3870), Offset(11.6820, 4.3170), Offset(11.6940, 4.3170), Offset(11.8480, 4.3870), Offset(11.9790, 4.4460), Offset(12.1170, 4.4590), Offset(12.6110, 4.4600), Offset(13.1620, 4.4610), Offset(13.2300, 4.4530), Offset(13.3960, 4.3690), Offset(13.5770, 4.2780), Offset(13.7320, 4.3590), Offset(13.8710, 4.4320), Offset(13.9610, 4.4410), Offset(14.5510, 4.4410), Offset(15.2140, 4.4410), Offset(15.1970, 4.6260), Offset(15.1730, 4.8690), Offset(15.2400, 5.0590), Offset(15.4080, 5.2330), Offset(15.5680, 5.3970), Offset(15.7990, 5.4830), Offset(16.3660, 5.5860), Offset(16.8350, 5.6720), Offset(17.5380, 5.6610), Offset(17.9280, 5.5610), Offset(17.9280, 5.5610)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(-13.1840, -2.1390), Offset(-13.2820, -2.1390), Offset(-13.3810, -2.1520), Offset(-13.4790, -2.1770), Offset(-13.5720, -2.2020), Offset(-13.6480, -2.2340), Offset(-13.7080, -2.2740), Offset(-13.7080, -3.9930), Offset(-13.6620, -4.0040), Offset(-13.6020, -4.0080), Offset(-13.5300, -4.0130), Offset(-13.4570, -4.0210), Offset(-13.3790, -4.0270), Offset(-13.2930, -4.0270), Offset(-13.0320, -4.0270), Offset(-12.8370, -3.9360), Offset(-12.7040, -3.7560), Offset(-12.5720, -3.5820), Offset(-12.5060, -3.3480), Offset(-12.5060, -3.0540), Offset(-12.5060, -2.4430), Offset(-12.7330, -2.1390), Offset(-13.1840, -2.1390), Offset(-13.2480, -2.6310), Offset(-13.0340, -2.6310), Offset(-12.9760, -2.8760), Offset(-12.9760, -3.0900), Offset(-12.9760, -3.2840), Offset(-13.0540, -3.5050), Offset(-13.2480, -3.5060), Offset(-13.2480, -2.6310)],
          pattern: [Offset(0.0000, 0.0000)],
        ),
        IOFSymbolElementV3(
          symbol: IOFSymbolGeometryV3.area(
            innerColor: r'2',
            rotatable: false,
          ),
          coords: [Offset(17.3600, 2.7300), Offset(16.9300, 2.7300), Offset(16.7140, 2.4630), Offset(16.7140, 1.9300), Offset(16.7140, 1.6750), Offset(16.7760, 1.4640), Offset(16.9000, 1.2970), Offset(17.0240, 1.1300), Offset(17.2120, 1.0470), Offset(17.4640, 1.0470), Offset(17.5480, 1.0470), Offset(17.6230, 1.0520), Offset(17.6870, 1.0600), Offset(17.7500, 1.0650), Offset(17.8070, 1.0720), Offset(17.8540, 1.0800), Offset(17.8540, 2.6030), Offset(17.7940, 2.6360), Offset(17.7200, 2.6660), Offset(17.6360, 2.6910), Offset(17.5500, 2.7180), Offset(17.4590, 2.7300), Offset(17.3600, 2.7300), Offset(17.4090, 2.2320), Offset(17.4090, 1.5710), Offset(17.2010, 1.4920), Offset(17.1800, 1.7130), Offset(17.1800, 1.9260), Offset(17.1780, 2.1200), Offset(17.1920, 2.3380), Offset(17.4090, 2.2320)],
          pattern: [Offset(0.0000, 0.0000)],
        )
      ],
      ),
    ),
  ];

  static final Map<String, IOFSymbolV3> _byCode = {
    for (final s in symbols) s.code: s,
  };

  /// Symboles visibles dans un selecteur (masque les variantes de
  /// migration ISOM2000 et les parties internes des symboles combines).
  static final List<IOFSymbolV3> visibleSymbols =
      symbols.where((s) => !s.isHidden).toList(growable: false);

  /// Recherche par code exact, puis par code de base (ex. "104.9" absent
  /// -> repli sur "104") : utile pour les fichiers .omap externes qui
  /// referencent une variante non listee ici.
  static IOFSymbolV3? getByCode(String code) {
    final exact = _byCode[code];
    if (exact != null) return exact;
    final base = code.split('.').first;
    return _byCode[base];
  }

  static List<IOFSymbolV3> getByCategory(String category, {bool visibleOnly = true}) {
    final source = visibleOnly ? visibleSymbols : symbols;
    return source.where((s) => s.category == category).toList();
  }

  static List<String> getCategories() =>
      visibleSymbols.map((s) => s.category).toSet().toList()..sort();

  static List<IOFSymbolV3> search(String query, {bool visibleOnly = true}) {
    final source = visibleOnly ? visibleSymbols : symbols;
    final q = query.toLowerCase();
    return source
        .where((s) => s.code.toLowerCase().contains(q) || s.name.toLowerCase().contains(q))
        .toList();
  }
}

// ============================================
// IOF Symbols v2 - ISOM 2017-2
// Generated from OMAP file (assets/mapper0.9.6/symbol sets/15000/ISOM 2017-2_15000.omap)
// Contains 202 symbols and 35 colors from the official IOF specification
// ============================================

import 'package:flutter/material.dart';

/// Represents a single IOF (International Orienteering Federation) symbol
/// from the ISOM 2017-2 specification
class IOFSymbol {
  final String code;
  final String name;
  final String description;
  final int type; // 1=point, 2=line, 4=area, 8=text
  final String? id;

  const IOFSymbol({
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    this.id,
  });

  // Type getters for convenience
  bool get isPoint => type == 1;
  bool get isLine => type == 2;
  bool get isArea => type == 4;
  bool get isText => type == 8;

  // Get the symbol category based on code prefix
  String get category {
    if (code.startsWith('10')) return 'Rock and Landforms';
    if (code.startsWith('20')) return 'Rock and Boulders';
    if (code.startsWith('30')) return 'Water and Marsh';
    if (code.startsWith('40')) return 'Vegetation';
    if (code.startsWith('50')) return 'Man-made Features';
    if (code.startsWith('60')) return 'Overhead Features';
    if (code.startsWith('70')) return 'Special';
    if (code.startsWith('80')) return 'Course';
    if (code.startsWith('90')) return 'Technical';
    return 'Other';
  }

  @override
  String toString() => 'IOFSymbol(code: $code, name: $name, type: $type)';

  @override
  bool operator ==(Object other) => 
      identical(this, other) || 
      other is IOFSymbol && 
      other.code == code;

  @override
  int get hashCode => code.hashCode;
}

/// IOF Color palette from ISOM 2017-2 specification
/// Contains 35 colors with CMYK definitions converted to Flutter Color (ARGB)
class IOFColors {
  // Map of color names to Flutter Color
  static const Map<String, Color> colors = {
    'Purple for course overprint': Color(0xFFA626FF),
    'White for course overprint': Color(0xFFFFFFFF),
    'Black 100%': Color(0xFF000000),
    'Green 100%': Color(0xFF3DFF17),
    'White for railway': Color(0xFFFFFFFF),
    'Blue 100%': Color(0xFF00FFFF),
    'Brown 100%': Color(0xFFD15C00),
    'Purple for track symbols': Color(0xFFA626FF),
    'Black below purple for track symbols': Color(0xFF000000),
    'Black 65%': Color(0xFF595959),
    'Black 20%': Color(0xFFCCCCCC),
    'Upper brown 50%': Color(0xFFE8A774),
    'Black below upper brown 50%': Color(0xFF000000),
    'Lower brown 50%': Color(0xFFE8A774),
    'Black below lower brown 50%': Color(0xFF000000),
    'Blue 100% for area features': Color(0xFF00FFFF),
    'Blue 70%': Color(0xFF4DFFFF),
    'Blue 50%': Color(0xFF80FFFF),
    'OpenOrienteering Orange': Color(0xFFE87A18),
    'Yellow 100% for narrow ride': Color(0xFFFFBA36),
    'Green 60% for narrow ride': Color(0xFF8BFF74),
    'Green 30% for narrow ride': Color(0xFFC5FFB9),
    'White over green': Color(0xFFFFFFFF),
    'Yellow 100%/Green 50%': Color(0xFF9EBA1D),
    'Black 25% (Grey)': Color(0xFFBFBFBF),
    'Green 100%/Black 50%': Color(0xFF1F800B),
    'Green 100% for area features': Color(0xFF3DFF17),
    'Green 60%': Color(0xFF8BFF74),
    'Green 30%': Color(0xFFC5FFB9),
    'Green 100% for undergrowth': Color(0xFF3DFF17),
    'White over yellow': Color(0xFFFFFFFF),
    'Black for open land': Color(0xFF000000),
    'Yellow': Color(0xFFFFBA36),
    'Yellow 100% for area features': Color(0xFFFFBA36),
    'Yellow 50%': Color(0xFFFFDD9A),
  };

  // Get color by name
  static Color? get(String name) => colors[name];

  // Get color by priority index (0-34)
  static Color getByPriority(int priority) {
    final color = _priorityToColor[priority];
    return color ?? Colors.black;
  }

  // Internal map for priority lookup
  static const Map<int, Color> _priorityToColor = {
    0: Color(0xFFA626FF),
    1: Color(0xFFFFFFFF),
    2: Color(0xFF000000),
    3: Color(0xFF3DFF17),
    4: Color(0xFFFFFFFF),
    5: Color(0xFF00FFFF),
    6: Color(0xFFD15C00),
    7: Color(0xFFA626FF),
    8: Color(0xFF000000),
    9: Color(0xFF595959),
    10: Color(0xFFCCCCCC),
    11: Color(0xFFE8A774),
    12: Color(0xFF000000),
    13: Color(0xFFE8A774),
    14: Color(0xFF000000),
    15: Color(0xFF00FFFF),
    16: Color(0xFF4DFFFF),
    17: Color(0xFF80FFFF),
    18: Color(0xFFE87A18),
    19: Color(0xFFFFBA36),
    20: Color(0xFF8BFF74),
    21: Color(0xFFC5FFB9),
    22: Color(0xFFFFFFFF),
    23: Color(0xFF9EBA1D),
    24: Color(0xFFBFBFBF),
    25: Color(0xFF1F800B),
    26: Color(0xFF3DFF17),
    27: Color(0xFF8BFF74),
    28: Color(0xFFC5FFB9),
    29: Color(0xFF3DFF17),
    30: Color(0xFFFFFFFF),
    31: Color(0xFF000000),
    32: Color(0xFFFFBA36),
    33: Color(0xFFFFBA36),
    34: Color(0xFFFFDD9A),
  };
}

/// Main library class for IOF Symbols v2
/// Contains all 202 symbols from ISOM 2017-2 specification
class IOFSymbolsV2 {
  // All IOF symbols from ISOM 2017-2
  static const List<IOFSymbol> symbols = [
    IOFSymbol(
      code: '101',
      name: 'Contour',
      description: r'A line joining points of equal height. The standard vertical interval between contours is 5 m. A contour interval of 2.5 m may be used for flat terrains. Slope lines may be drawn on the lower side of a contour line to clarify the direction of slope. When used, they should be placed in re-entrants. A closed contour represents a knoll or a depression. A depression has to have at least one slope line. Minimum height/depth should be 1 m. Relationships between adjacent contour lines are important. Adjacent contour lines show form and structure. Small details on contours should be avoided because they tend to hide the main features of the terrain. Prominent features such as depressions, re-entrants, spurs, earth banks and terraces may have to be exaggerated. Absolute height accuracy is of little importance, but the relative height difference between neighbouring features should be represented on the map as accurately as possible. It is permissible to alter the height of a contour slightly if this improves the representation of a feature. This deviation should not exceed 25% of the contour interval, and attention must be paid to neighbouring features. The smallest bend in a contour line is 0.25 mm from centre to centre of the line (footprint 4 m). The mouth of a re-entrant or a spur must be wider than 0.5 mm from centre to centre of the line (footprint 8 m). The minimum length of a contour knoll is 0.9 mm (footprint 13.5 m) and the minimum width is 0.6 mm (footprint 9 m) outside measure. Smaller prominent knolls can be represented using symbol Small knoll (109) or Small elongated knoll (110) or they can be exaggerated on the map to satisfy the minimum dimension. A depression must accommodate a slope line, so the minimum length is 1.1 mm (footprint 16.5 m) and the minimum width is 0.7 mm (footprint 10.5 m) outside measure. Smaller, prominent depressions can be represented using symbol Small depression (111) or they can be exaggerated to satisfy the minimum dimension. Contours should be adapted (not broken) in order not to touch symbol Small knoll (109) or Small elongated knoll (110).',
      type: 2,
      id: '0',
    ),
    IOFSymbol(
      code: '101.1',
      name: 'Slope line, contour',
      description: r'Slope lines may be drawn on the lower side of a contour line to clarify the direction of slope. When used, they should be placed in re-entrants. A depression has to have at least one slope line.',
      type: 1,
      id: '1',
    ),
    IOFSymbol(
      code: '102',
      name: 'Index contour',
      description: r'Every fifth contour shall be drawn with a thicker line. This is an aid to the quick assessment of height difference and the overall shape of the terrain surface. An index contour may be represented as an ordinary contour line in an area with much detail. Small contour knolls and depressions are normally not represented using index contours. The index contour level must be carefully selected in flat terrain. The ideal level for the index contour is the central contour in the most prominent slopes.',
      type: 2,
      id: '2',
    ),
    IOFSymbol(
      code: '102.1',
      name: 'Contour value',
      description: r'An index contour may have a height value assigned. A height value should only be inserted in an index contour in places where other detail is not obscured. It shall be orientated so that the top of the label is on the higher side of the contour. The index value (label) shall be 1.5 mm high and represented in a sans-serif font.',
      type: 8,
      id: '3',
    ),
    IOFSymbol(
      code: '103',
      name: 'Form line',
      description: r'Form lines are used where more information must be given about the shape of the ground. Form lines are added only where representation would be incomplete with ordinary contours. They shall not be used as intermediate contours. Only one form line should be used between neighbouring contours. It is very important that a form line fits logically into the contour system, so the start and end of a form line should be parallel to the neighbouring contours. The gaps between the form line dashes must be placed on reasonably straight sections of the form line. Form lines can be used to differentiate flat knolls and depressions from more distinct ones (minimum height / depth should be 1 m). Excessive use of form lines must be avoided as this disturbs the three-dimensional picture of the ground shape and will complicate map reading. Minimum length (non-closed): two dashes. Minimum length of a form line, knoll or depression: 1.1 mm (footprint 16.5 m)',
      type: 2,
      id: '4',
    ),
    IOFSymbol(
      code: '103.1',
      name: 'Slope line, formline',
      description: r'Slope lines may be drawn on the lower side of a contour line to clarify the direction of slope. When used, they should be placed in re-entrants.',
      type: 1,
      id: '5',
    ),
    IOFSymbol(
      code: '104',
      name: 'Earth bank',
      description: r'An earth bank is an abrupt change in ground level which can be clearly distinguished from its surroundings, e.g. gravel or sand pits, road and railway cuttings or embankments. Minimum height: 1 m. An earth bank may impact runnability. The tags represent the full extent of the earth bank. For long earth banks it is allowed to use tags shorter than the minimum length at the ends. If two earth banks are close together, tags may be omitted. Impassable earth banks shall be represented using symbol impassable cliff (201). Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: '6',
    ),
    IOFSymbol(
      code: '104.1',
      name: 'Earth bank, minimum size',
      description: r'An earth bank is an abrupt change in ground level which can be clearly distinguished from its surroundings, e.g. gravel or sand pits, road and railway cuttings or embankments. Minimum height: 1 m. An earth bank may impact runnability. The tags represent the full extent of the earth bank. For long earth banks it is allowed to use tags shorter than the minimum length at the ends. If two earth banks are close together, tags may be omitted. Impassable earth banks shall be represented using symbol impassable cliff (201). Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: '7',
    ),
    IOFSymbol(
      code: '104.2',
      name: 'Earth bank, top line',
      description: r'An earth bank is an abrupt change in ground level which can be clearly distinguished from its surroundings, e.g. gravel or sand pits, road and railway cuttings or embankments. Minimum height: 1 m. An earth bank may impact runnability. The tags represent the full extent of the earth bank. For long earth banks it is allowed to use tags shorter than the minimum length at the ends. If two earth banks are close together, tags may be omitted. Impassable earth banks shall be represented using symbol impassable cliff (201). Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: '8',
    ),
    IOFSymbol(
      code: '104.3',
      name: 'Earth bank, tag line',
      description: r'Use this symbol to display the full extent of wide earth banks.',
      type: 2,
      id: '9',
    ),
    IOFSymbol(
      code: '104.9',
      name: 'Earth bank, minimum size (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: '10',
    ),
    IOFSymbol(
      code: '105',
      name: 'Earth wall',
      description: r'Distinct earth wall. Minimum height: 1 m. Minimum length: 1.4 mm (footprint 21 m).',
      type: 2,
      id: '11',
    ),
    IOFSymbol(
      code: '106',
      name: 'Ruined earth wall',
      description: r'A ruined or less distinct earth wall. Minimum height: 0.5 m. Minimum length: two dashes (3.65 mm - footprint 55 m). If shorter, the object must be exaggerated to the minimum length or changed to symbol Earth wall (105).',
      type: 2,
      id: '12',
    ),
    IOFSymbol(
      code: '107',
      name: 'Erosion gully',
      description: r'An erosion gully which is too small to be shown using symbol Earth bank (104) is shown by a single line. Minimum depth: 1 m. Minimum length: 1.15 mm (footprint 17 m). Contour lines should not be broken around this symbol.',
      type: 2,
      id: '13',
    ),
    IOFSymbol(
      code: '108',
      name: 'Small erosion gully',
      description: r'A small erosion gully, dry ditch or trench. Minimum depth: 0.5 m. Minimum length (isolated): three dots (1.15 mm - footprint 17 m). Contour lines should be broken around this symbol.',
      type: 2,
      id: '14',
    ),
    IOFSymbol(
      code: '109',
      name: 'Small knoll',
      description: r'An obvious mound or knoll which cannot be drawn to scale with a contour. Minimum height: 1 m. The symbol shall not touch or overlap contours. Footprint: 7.5 m x 7.5 m.',
      type: 1,
      id: '15',
    ),
    IOFSymbol(
      code: '110',
      name: 'Small elongated knoll',
      description: r'An obvious elongated knoll which cannot be drawn to scale with a contour. Minimum height: 1 m. The symbol shall not touch or overlap contours. Footprint: 12 m x 6 m.',
      type: 1,
      id: '16',
    ),
    IOFSymbol(
      code: '111',
      name: 'Small depression',
      description: r'A small depression or hollow without steep sides that is too small to be shown by contours. Minimum depth: 1 m, minimum width: 2 m. Small depressions with steep sides are represented with symbol Pit (112). The symbol shall not touch or overlap other brown symbols. Location is the centre of gravity of the symbol, and the symbol is orientated to north. Footprint: 12 m x 6 m.',
      type: 1,
      id: '17',
    ),
    IOFSymbol(
      code: '112',
      name: 'Pit',
      description: r'Pits and holes with distinct steep sides which cannot be shown to scale using symbol Earth bank (104). Minimum depth: 1 m, minimum width: 1 m. A pit larger than 5 m x 5 m should normally be exaggerated and drawn using Earth bank (104). Pits without steep sides are represented with symbol Small depression (111). The symbol shall not touch or overlap other brown symbols. Location is the centre of gravity of the symbol, and the symbol is orientated to north. Footprint: 10.5 m x 12 m.',
      type: 1,
      id: '18',
    ),
    IOFSymbol(
      code: '113',
      name: 'Broken ground',
      description: r'An area of pits and / or knolls which is too intricate to be shown in detail, or other types of rough and uneven ground that is clearly distinguishable but has little impact on runnability. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.5 mm. Contours should not be cut in broken ground areas. The dots shall not be arranged to form a single point wide line.',
      type: 4,
      id: '19',
    ),
    IOFSymbol(
      code: '113.1',
      name: 'Broken ground, individual dot',
      description: r'An area of pits and / or knolls which is too intricate to be shown in detail, or other types of rough and uneven ground that is clearly distinguishable but has little impact on runnability. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.5 mm. Contours should not be cut in broken ground areas. The dots shall not be arranged to form a single point wide line. Density: 3-4 dots / mm².',
      type: 1,
      id: '20',
    ),
    IOFSymbol(
      code: '114',
      name: 'Very broken ground',
      description: r'An area of pits and/or knolls, which is too intricate to be shown in detail, or other types of rough and uneven ground that is clearly distinguishable and affects runnability. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. The minimum number of dots is three (footprint 7 m x 7 m). The maximum centre to centre distance between neighbouring dots is 0.38 mm. The minimum centre to centre distance between neighbouring dots is 0.25 mm. Contours should not be cut in broken ground areas. The dots shall not be arranged to form a single point wide line.',
      type: 4,
      id: '21',
    ),
    IOFSymbol(
      code: '115',
      name: 'Prominent landform feature',
      description: r'The feature must be very clearly distinguishable from its surroundings. Location is the centre of gravity of the symbol, which is orientated to north. The symbol shall not touch or overlap other brown symbols. The definition of the symbol must be given on the map. Footprint: 13.5 m x 11.5 m.',
      type: 1,
      id: '22',
    ),
    IOFSymbol(
      code: '201',
      name: 'Impassable cliff',
      description: r'A cliff, quarry or earth bank that is so high and steep that it is impossible to pass/climb or is dangerous. For vertical rock faces the tags may be omitted if space is short. Ends of the top line may be rounded or square. Shorter tags may be used at the ends. The gap between two impassable cliffs or between impassable cliffs and other impassable feature symbols must exceed 0.25 mm on the map. When an impassable cliff drops straight into water, making it impossible to pass under the cliff along the water’s edge, the bank line is omitted or the tags shall clearly extend over the bank line. An impassable cliff should interplay with the contour lines. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: '23',
    ),
    IOFSymbol(
      code: '201.1',
      name: 'Impassable cliff, minimum size',
      description: r'A cliff, quarry or earth bank that is so high and steep that it is impossible to pass/climb or is dangerous. For vertical rock faces the tags may be omitted if space is short. Ends of the top line may be rounded or square. Shorter tags may be used at the ends. The gap between two impassable cliffs or between impassable cliffs and other impassable feature symbols must exceed 0.25 mm on the map. When an impassable cliff drops straight into water, making it impossible to pass under the cliff along the water’s edge, the bank line is omitted or the tags shall clearly extend over the bank line. An impassable cliff should interplay with the contour lines. Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: '24',
    ),
    IOFSymbol(
      code: '201.2',
      name: 'Impassable cliff, plan shape representation (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 4,
      id: '25',
    ),
    IOFSymbol(
      code: '201.3',
      name: 'Impassable cliff, top line',
      description: r'A cliff, quarry or earth bank that is so high and steep that it is impossible to pass/climb or is dangerous. For vertical rock faces the tags may be omitted if space is short. Ends of the top line may be rounded or square. Shorter tags may be used at the ends. The gap between two impassable cliffs or between impassable cliffs and other impassable feature symbols must exceed 0.25 mm on the map. When an impassable cliff drops straight into water, making it impossible to pass under the cliff along the water’s edge, the bank line is omitted or the tags shall clearly extend over the bank line. An impassable cliff should interplay with the contour lines. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: '26',
    ),
    IOFSymbol(
      code: '201.4',
      name: 'Impassable cliff, tag line',
      description: r'Use this symbol to display the full extent of a wide cliff.',
      type: 2,
      id: '27',
    ),
    IOFSymbol(
      code: '201.9',
      name: 'Impassable cliff, minimum size (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: '28',
    ),
    IOFSymbol(
      code: '202',
      name: 'Cliff',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: '29',
    ),
    IOFSymbol(
      code: '202.1',
      name: 'Cliff, minimum size',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: '30',
    ),
    IOFSymbol(
      code: '202.2',
      name: 'Cliff, with tags',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 2,
      id: '31',
    ),
    IOFSymbol(
      code: '202.3',
      name: 'Cliff, with tags, minimum size',
      description: r'A passable cliff or quarry. If the direction of fall of the cliff is not apparent from the contours, or to improve legibility, short tags may be drawn in the direction of the downslope. For non-vertical cliffs, the tags should be drawn to show the full horizontal extent. Ends of the base line must be rounded if no tags appear. A passage between two cliffs must be at least 0.2 mm. A cliff should interplay with the contour lines. Crossing a cliff will normally slow progress. Minimum height: 1 m. Minimum length: 0.6 mm (footprint 9 m).',
      type: 1,
      id: '32',
    ),
    IOFSymbol(
      code: '202.9',
      name: 'Cliff, with tags, minimum size (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: '33',
    ),
    IOFSymbol(
      code: '203.1',
      name: 'Rocky pit or cave (without a distinct entrance)',
      description: r'Rocky pits, holes, caves or mineshafts without a distinct entrance which may constitute a danger to the competitor. Location is the centre of gravity of the symbol, and the symbol shall be orientated to north. Rocky pits larger than 5 m in diameter should be exaggerated and represented using cliff symbols (201, 202). Minimum depth: 1 m. Footprint: 10.5 m x 12 m.',
      type: 1,
      id: '34',
    ),
    IOFSymbol(
      code: '203.2',
      name: 'Cave or rocky pit (with a distinct entrance)',
      description: r'Rocky pits, holes, caves or mineshafts with a distinct entrance which may constitute a danger to the competitor. Minimum depth: 1 m. Location is the centre of gravity of the symbol, and the symbol should point into the cave. Rocky pits larger than 5 m in diameter should be exaggerated and represented using cliff symbols (201, 202).',
      type: 1,
      id: '35',
    ),
    IOFSymbol(
      code: '203.9',
      name: 'Rocky pit or cave with distinct entrance (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 1,
      id: '36',
    ),
    IOFSymbol(
      code: '204',
      name: 'Boulder',
      description: r'A distinct boulder (should be higher than 1 m), which is immediately identifiable on the ground. Groups of boulders are represented using symbol Boulder cluster (207) or a boulder field symbol (208, 209). To be able to show the distinction between neighbouring (closer than 30 m apart) boulders with significant difference in size, it is permitted to enlarge the symbol to 0.5 mm for some of the boulders. Footprint: 6 m diameter (7.5 m diameter).',
      type: 1,
      id: '37',
    ),
    IOFSymbol(
      code: '204.5',
      name: 'Boulder or large boulder, different size',
      description: r'A boulder which is larger than neighboring boulders (204), or a large boulder which is smaller than neighboring large boulders (205). To be able to show the distinction between neighbouring (closer than 30 metres apart) boulders (204) with significant difference in size, it is permitted to use this symbol (0.5 mm) as an enlargement of symbol 204 for some of the boulders. To be able to show the distinction between neighbouring (closer than 30 metres apart) large boulders (205) with significant difference in size, it is permitted to use this symbol (0.5 mm) as an as a reduction of symbol 205 for some of the boulders.',
      type: 1,
      id: '38',
    ),
    IOFSymbol(
      code: '205',
      name: 'Large boulder',
      description: r'A particularly large and distinct boulder. A large boulder should be more than 2 m high. To be able to show the distinction between neighbouring (closer than 30 m apart) large boulders with significant difference in size, it is permitted to reduce the size of the symbol to 0.5 mm for some of the boulders. Footprint: 9 m diameter (7.5 m diameter).',
      type: 1,
      id: '39',
    ),
    IOFSymbol(
      code: '206',
      name: 'Gigantic boulder',
      description: r'A gigantic boulder, rock pillar or massive cliff shall be represented in plan shape. The objects can vary in shape and width. The gap between gigantic boulders or between gigantic boulders and other impassable feature symbols must exceed 0.15 mm on the map. Minimum width: 0.25 mm (footprint 3.75 m). Minimum area: 0.3 mm² (footprint 67 m²).',
      type: 4,
      id: '40',
    ),
    IOFSymbol(
      code: '207',
      name: 'Boulder cluster',
      description: r'A distinct group of boulders so closely clustered together that they cannot be marked individually. The boulders in the cluster should be higher than 1 m. A boulder cluster must be easily identifiable as a group of boulders. To be able to show the distinction between neighbouring (maximum 30 m apart) boulder clusters with significant difference in boulder size, it is permitted to enlarge this symbol to 120% (edge length 0.96 mm) for some of the boulder clusters. The symbol is orientated to north. Footprint: 12 m x 10 m.',
      type: 1,
      id: '41',
    ),
    IOFSymbol(
      code: '207.1',
      name: 'Boulder cluster, large',
      description: r'To be able to show the distinction between neighbouring (maximum 30 m apart) boulder clusters with significant difference in boulder size, it is permitted to use this symbol instead of regular Boulder cluster (207) for some of the boulder clusters.',
      type: 1,
      id: '42',
    ),
    IOFSymbol(
      code: '208',
      name: 'Boulder field',
      description: r'An area which is covered with so many scattered blocks of stone that they cannot be marked individually, is shown with randomly placed and orientated solid triangles. A boulder field will generally not impact runnability. If the runnability of the boulder field is reduced, symbol 209 (dense boulder field) should be used or the symbol should be combined with a stony ground symbol. A minimum of two triangles should be used. One triangle may be used if it is combined with other rock symbols (for instance directly below cliff symbols (201, 202), adjacent to boulder symbols (204-206) or combined with stony ground symbols (210-212)). The maximum centre to centre distance between neighbouring triangles is 1.2 mm. The minimum centre to centre distance between neighbouring triangles is 0.75 mm. Density: 0.8-1 symbol / mm². To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%. Footprint of individual triangle: 12 m x 6 m.',
      type: 4,
      id: '43',
    ),
    IOFSymbol(
      code: '208.1',
      name: 'Boulder field, single triangle',
      description: r'An area which is covered with so many scattered blocks of stone that they cannot be marked individually, is shown with randomly placed and orientated solid triangles. A boulder field will generally not impact runnability. If the runnability of the boulder field is reduced, symbol 209 (dense boulder field) should be used or the symbol should be combined with a stony ground symbol. A minimum of two triangles should be used. One triangle may be used if it is combined with other rock symbols (for instance directly below cliff symbols (201, 202), adjacent to boulder symbols (204-206) or combined with stony ground symbols (210-212)). The maximum centre to centre distance between neighbouring triangles is 1.2 mm. The minimum centre to centre distance between neighbouring triangles is 0.75 mm. Density: 0.8-1 symbol / mm². To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%. Footprint of individual triangle: 12 m x 6 m.',
      type: 1,
      id: '44',
    ),
    IOFSymbol(
      code: '208.2',
      name: 'Boulder field, single triangle, enlarged',
      description: r'To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%.',
      type: 1,
      id: '45',
    ),
    IOFSymbol(
      code: '209',
      name: 'Dense boulder field',
      description: r'An area which is covered with so many blocks of stone that they cannot be marked individually and the runnability is affected, is shown with randomly placed and orientated solid triangles. A minimum of two triangles must be used. The maximum centre to centre distance between neighbouring triangles is 0.6 mm. Density: 2-3 symbols / mm². To be able to show obvious height differences within a boulder field, it is permitted to enlarge some of the triangles to 120%. Footprint of individual triangle: 12 m x 6 m.',
      type: 4,
      id: '46',
    ),
    IOFSymbol(
      code: '210',
      name: 'Stony ground, slow running',
      description: r'Stony or rocky ground which reduces runnability to about 60-80% of normal speed. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.45 mm. Density: 3-4 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 4,
      id: '47',
    ),
    IOFSymbol(
      code: '210.1',
      name: 'Stony ground, individual dot',
      description: r'Stony or rocky ground which reduces runnability to about 60-80% of normal speed. The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 10 m x 10 m). The maximum centre to centre distance between neighbouring dots is 0.6 mm. The minimum centre to centre distance between neighbouring dots is 0.45 mm. Density: 3-4 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 1,
      id: '48',
    ),
    IOFSymbol(
      code: '211',
      name: 'Stony ground, walk',
      description: r'Stony or rocky ground which reduces the runnability significantly (to about 20-60% of normal speed). The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 8 m x 8 m). The maximum centre to centre distance between neighbouring dots is 0.4 mm. The minimum centre to centre distance between neighbouring dots is 0.32 mm. Density: 6-8 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 4,
      id: '49',
    ),
    IOFSymbol(
      code: '212',
      name: 'Stony ground, fight',
      description: r'Stony or rocky ground which is hardly passable (less than 20% of normal speed). The dots should be randomly distributed but not interfere with the representation of important terrain features and objects. Illustration serves as an example of density and also point symbol (single dots) can be used to draw stony ground. The minimum number of dots is three (footprint 7 m x 7 m). The maximum centre to centre distance between neighbouring dots is 0.32 mm. The minimum centre to centre distance between neighbouring dots is 0.25 mm. Density: 10-12 dots / mm². To avoid confusion with symbol Distinct vegetation boundary (416), the dots should not be arranged to form a line.',
      type: 4,
      id: '50',
    ),
    IOFSymbol(
      code: '213',
      name: 'Sandy ground',
      description: r'An area of soft sandy ground where runnability is reduced to less than 80% of normal speed. The symbol is orientated to north. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: '51',
    ),
    IOFSymbol(
      code: '214',
      name: 'Bare rock',
      description: r'A runnable area of rock without earth or vegetation should be shown as bare rock. An area of rock covered with grass, moss or other low vegetation, shall not be shown using the bare rock symbol. An area of less runnable bare rock should be shown using a stony ground symbol (210-212). Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: '52',
    ),
    IOFSymbol(
      code: '215',
      name: 'Trench',
      description: r'Rocky or artificial trench. Minimum depth should be 1 m. Minimum length: 1 mm (footprint 15 m). Shorter trenches may be exaggerated to the minimum graphical dimension. Impassable trenches shall be represented using symbol Impassable cliff (201). Collapsed and easily crossable trenches should be mapped as erosion gullies.',
      type: 2,
      id: '53',
    ),
    IOFSymbol(
      code: '301',
      name: 'Uncrossable body of water (full colour), with bank line',
      description: r'The black bank line emphasises that the feature is uncrossable. Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 16,
      id: '54',
    ),
    IOFSymbol(
      code: '301.1',
      name: 'Uncrossable body of water (full colour)',
      description: r'Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: '55',
    ),
    IOFSymbol(
      code: '301.2',
      name: 'Uncrossable body of water (dominant), with bank line',
      description: r'The black bank line emphasises that the feature is uncrossable. Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 16,
      id: '56',
    ),
    IOFSymbol(
      code: '301.3',
      name: 'Uncrossable body of water (dominant)',
      description: r'Dominant areas of water may be shown with 70% colour. Small areas of water and bodies of water that have narrow parts shall always be shown with full colour. Minimum width (inside): 0.3 mm. Minimum area (inside): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: '57',
    ),
    IOFSymbol(
      code: '301.4',
      name: 'Uncrossable body of water, bank line',
      description: r'A black bank line indicates that the feature cannot be crossed.',
      type: 2,
      id: '58',
    ),
    IOFSymbol(
      code: '302',
      name: 'Shallow body of water, with solid outline',
      description: r'A shallow seasonal or periodic body of water may be represented using a dashed outline. Small shallow water bodies may be represented as 100% blue (without an outline). Minimum width (inside): 0.3 mm. Minimum area (inside): 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width (full colour): 0.3 mm. Minimum area (full colour): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 16,
      id: '59',
    ),
    IOFSymbol(
      code: '302.1',
      name: 'Shallow body of water',
      description: r'A shallow seasonal or periodic body of water may be represented using a dashed outline. Small shallow water bodies may be represented as 100% blue (without an outline). Minimum width (inside): 0.3 mm. Minimum area (inside): 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width (full colour): 0.3 mm. Minimum area (full colour): 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: '60',
    ),
    IOFSymbol(
      code: '302.2',
      name: 'Shallow body of water, solid outline',
      description: r'Use this symbol to represent the outline of a shallow body of water which is not seasonal or periodic.',
      type: 2,
      id: '61',
    ),
    IOFSymbol(
      code: '302.3',
      name: 'Shallow body of water, dashed outline',
      description: r'Use this symbol to represent the outline of a shallow seasonal or periodic body of water.',
      type: 2,
      id: '62',
    ),
    IOFSymbol(
      code: '302.5',
      name: 'Small shallow body of water (full colour)',
      description: r'Small shallow water bodies may be represented using this symbol (without an outline). Minimum width: 0.3 mm. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: '63',
    ),
    IOFSymbol(
      code: '303',
      name: 'Waterhole',
      description: r'A water-filled pit or an area of water which is too small to be shown to scale. Location is the centre of gravity of the symbol, and the symbol is orientated to north. Footprint: 10.5 m x 12 m.',
      type: 1,
      id: '64',
    ),
    IOFSymbol(
      code: '304',
      name: 'Crossable watercourse',
      description: r'Should be at least 2 m wide. Minimum length (isolated): 1 mm (footprint 15 m).',
      type: 2,
      id: '65',
    ),
    IOFSymbol(
      code: '305',
      name: 'Small crossable watercourse',
      description: r'Minimum length (isolated): 1 mm (footprint 15 m).',
      type: 2,
      id: '66',
    ),
    IOFSymbol(
      code: '306',
      name: 'Minor/seasonal water channel',
      description: r'A natural or man-made minor water channel which may contain water only intermittently. Minimum length (isolated): two dashes (2.75 mm - footprint 41 m).',
      type: 2,
      id: '67',
    ),
    IOFSymbol(
      code: '307',
      name: 'Uncrossable marsh, with outline',
      description: r'A marsh which is uncrossable or dangerous for the competitor. The black outline emphasises that the feature is uncrossable. The black outline is omitted for boundaries between uncrossable marsh and symbol Uncrossable body of water (301). The symbol may be combined with a rough open land symbol (403, 404) to show openness. The symbol is orientated to north. Minimum width: 0.3 mm (inside). Minimum area: 0.5 mm² (inside).',
      type: 16,
      id: '68',
    ),
    IOFSymbol(
      code: '307.1',
      name: 'Uncrossable marsh',
      description: r'A marsh which is uncrossable or dangerous for the competitor. The black outline emphasises that the feature is uncrossable. The black outline is omitted for boundaries between uncrossable marsh and symbol Uncrossable body of water (301). The symbol may be combined with a rough open land symbol (403, 404) to show openness. The symbol is orientated to north. Minimum width: 0.3 mm (inside). Minimum area: 0.5 mm² (inside).',
      type: 4,
      id: '69',
    ),
    IOFSymbol(
      code: '307.2',
      name: 'Uncrossable marsh, outline',
      description: r'The black outline emphasises that the feature is uncrossable.',
      type: 2,
      id: '70',
    ),
    IOFSymbol(
      code: '308',
      name: 'Marsh',
      description: r'A crossable marsh, usually with a distinct edge. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 0.5 mm x 0.4 mm (footprint 7.5 m x 6 m).',
      type: 4,
      id: '71',
    ),
    IOFSymbol(
      code: '308.1',
      name: 'Marsh, minimum size',
      description: r'A crossable marsh, usually with a distinct edge. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 0.5 mm x 0.4 mm (footprint 7.5 m x 6 m).',
      type: 1,
      id: '72',
    ),
    IOFSymbol(
      code: '309',
      name: 'Narrow marsh',
      description: r'A marsh or trickle of water which is too narrow (less than about 5 m wide) to be shown with the marsh symbol. Minimum length (isolated): two dots (0.7 mm - footprint 10.5 m).',
      type: 2,
      id: '73',
    ),
    IOFSymbol(
      code: '310',
      name: 'Indistinct marsh',
      description: r'An indistinct marsh, seasonal marsh or an area of gradual transition from marsh to firm ground, which is crossable. The edge is generally indistinct and the vegetation similar to that of the surrounding ground. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 2.0 mm x 0.7 mm (footprint 30 m x 10.5 m).',
      type: 4,
      id: '74',
    ),
    IOFSymbol(
      code: '310.1',
      name: 'Indistinct marsh, minimum size',
      description: r'An indistinct marsh, seasonal marsh or an area of gradual transition from marsh to firm ground, which is crossable. The edge is generally indistinct and the vegetation similar to that of the surrounding ground. The symbol shall be combined with other symbols to show runnability and openness. The symbol is orientated to north. Minimum area: 2.0 mm x 0.7 mm (footprint 30 m x 10.5 m).',
      type: 1,
      id: '75',
    ),
    IOFSymbol(
      code: '311',
      name: 'Well, fountain or water tank',
      description: r'A prominent well, fountain, water tank or captive spring. Footprint: 12 m x 12 m.',
      type: 1,
      id: '76',
    ),
    IOFSymbol(
      code: '312',
      name: 'Spring',
      description: r'A source of water. Location is the centre of gravity of the symbol. The symbol is orientated to open downstream. Footprint: 13.5 m x 7 m.',
      type: 1,
      id: '77',
    ),
    IOFSymbol(
      code: '313',
      name: 'Prominent water feature',
      description: r'The symbol is orientated to north. The definition of the symbol must be given on the map. Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: '78',
    ),
    IOFSymbol(
      code: '401',
      name: 'Open land',
      description: r'Open land that has a ground cover (grass, moss or similar) which offers better runnability than typical open forest. If yellow coloured areas become dominant, a screen (75% instead of full yellow) may be used. Shall not be combined with area symbols other than Broken ground (113), Boulder field (208), Marsh (308) and Indistinct marsh (310). Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: '79',
    ),
    IOFSymbol(
      code: '402',
      name: 'Open land with scattered trees',
      description: r'Areas with scattered trees or bushes in open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Prominent individual trees may be added using symbol Prominent large tree (417). If yellow coloured areas become dominant, a screen (75% instead of full yellow) may be used. Shall not be combined with area symbols other than symbol Broken ground (113), symbol Boulder field (208) or marsh symbols (308, 310). Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m). Smaller areas must either be left out, exaggerated or shown using symbol Open land (401). The symbol is orientated to north.',
      type: 4,
      id: '80',
    ),
    IOFSymbol(
      code: '402.1',
      name: 'Open land with scattered bushes (green dots)',
      description: r'Areas with scattered trees or bushes in open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Prominent individual trees may be added using symbol Prominent large tree (417). If yellow coloured areas become dominant, a screen (75% instead of full yellow) may be used. Shall not be combined with area symbols other than symbol Broken ground (113), symbol Boulder field (208) or marsh symbols (308, 310). Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m). Smaller areas must either be left out, exaggerated or shown using symbol Open land (401). The symbol is orientated to north.',
      type: 4,
      id: '81',
    ),
    IOFSymbol(
      code: '403',
      name: 'Rough open land',
      description: r'Heath, moorland, felled areas, newly planted areas (trees lower than ca. 1 m) or other generally open land with rough ground vegetation, heather or tall grass offering the same runnability as typical open forest. May be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m). Smaller areas must either be left out, exaggerated or shown using symbol Open land (401).',
      type: 4,
      id: '82',
    ),
    IOFSymbol(
      code: '404',
      name: 'Rough open land with scattered trees',
      description: r'Areas with scattered trees or bushes in rough open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Only the white dot variant can be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. The symbol is orientated to north. Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2.5 mm x 2.5 mm (footprint 37.5 m x 37.5 m). Smaller areas must either be left out, exaggerated or shown using symbol Rough open land (403).',
      type: 4,
      id: '83',
    ),
    IOFSymbol(
      code: '404.1',
      name: 'Rough open land with scattered bushes (green dots)',
      description: r'Areas with scattered trees or bushes in rough open land may be generalised by using a regular pattern of large dots in the yellow screen. The dots may be white (scattered trees) or green (scattered bushes / thickets). Only the white dot variant can be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. The symbol is orientated to north. Minimum width: 1.5 mm (footprint 22.5 m). Minimum area: 2.5 mm x 2.5 mm (footprint 37.5 m x 37.5 m). Smaller areas must either be left out, exaggerated or shown using symbol Rough open land (403).',
      type: 4,
      id: '84',
    ),
    IOFSymbol(
      code: '405',
      name: 'Forest',
      description: r'Typical open forest for the particular type of terrain. If no part of the forest is easily runnable then no white should appear on the map. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m) for openings in screens of other colours, except for the following: For openings in symbol Open land (401), the minimum area is 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). For openings in symbol Vegetation: walk (408), the minimum area is 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). For openings in symbol Vegetation: fight (410) the minimum area is 0.55 mm x 0.55 mm (footprint 8 m x 8 m).',
      type: 4,
      id: '85',
    ),
    IOFSymbol(
      code: '406',
      name: 'Vegetation: slow running',
      description: r'An area with dense vegetation (low visibility) which reduces running to about 60-80% of normal speed. Where runnability is better in one direction, a regular pattern of white stripes is left in the screen to show the direction of better running. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m). Minimum width: 0.4 mm (footprint 6 m).',
      type: 4,
      id: '86',
    ),
    IOFSymbol(
      code: '406.1',
      name: 'Vegetation: slow running, normal running in one direction',
      description: r'An area with dense vegetation (low visibility) which reduces running to about 60-80% of normal speed. Where runnability is better in one direction, a regular pattern of white stripes is left in the screen to show the direction of better running. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m). Minimum width: 0.4 mm (footprint 6 m).',
      type: 4,
      id: '87',
    ),
    IOFSymbol(
      code: '407',
      name: 'Vegetation: slow running, good visibility',
      description: r'An area of good visibility and reduced runnability, due to, for instance, undergrowth (brambles, heather, low bushes, cut branches). Running speed is reduced to about 60-80% of normal speed. The symbol is orientated to north. Minimum area: 1.5 mm x 1 mm (footprint 22.5 m x 15 m).',
      type: 4,
      id: '88',
    ),
    IOFSymbol(
      code: '408',
      name: 'Vegetation: walk',
      description: r'An area with dense trees or thickets (low visibility) which reduce running to about 20-60% of normal speed. Where runnability is better in one direction, a regular pattern of white or green 20% stripes is left in the screen to show the direction of better running. Minimum area: 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: '89',
    ),
    IOFSymbol(
      code: '408.1',
      name: 'Vegetation: walk, normal running in one direction',
      description: r'An area with dense trees or thickets (low visibility) which reduce running to about 20-60% of normal speed. Where runnability is better in one direction, a regular pattern of white or green 20% stripes is left in the screen to show the direction of better running. Minimum area: 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: '90',
    ),
    IOFSymbol(
      code: '408.2',
      name: 'Vegetation: walk, slow running in one direction',
      description: r'An area with dense trees or thickets (low visibility) which reduce running to about 20-60% of normal speed. Where runnability is better in one direction, a regular pattern of white or green 20% stripes is left in the screen to show the direction of better running. Minimum area: 0.7 mm x 0.7 mm (footprint 10.5 m x 10.5 m). Minimum width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: '91',
    ),
    IOFSymbol(
      code: '409',
      name: 'Vegetation: walk, good visibility',
      description: r'An area of good visibility that is difficult to run through, due to, for instance, undergrowth (brambles, heather, low bushes, cut branches). Running speed is reduced to about 20-60% of normal speed. Areas of good visibility that are very difficult to run or impassable are represented using symbol Vegetation: fight (410). The symbol is orientated to north. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: '92',
    ),
    IOFSymbol(
      code: '410',
      name: 'Vegetation: fight',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: '93',
    ),
    IOFSymbol(
      code: '410.1',
      name: 'Vegetation: fight, normal running in one direction',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: '94',
    ),
    IOFSymbol(
      code: '410.2',
      name: 'Vegetation: fight, slow running in one direction',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: '95',
    ),
    IOFSymbol(
      code: '410.3',
      name: 'Vegetation: fight, walk in one direction',
      description: r'An area of dense vegetation (trees or undergrowth) which is barely passable. Running reduced to less than about 20% of normal speed. Where runnability is better in one direction, a regular pattern of white, green 30% or green 60% stripes is left in the screen to show the direction of better running. Minimum area: 0.55 mm x 0.55 mm (footprint 8 m x 8 m). Minimum width: 0.25 mm (footprint 3.8 m).',
      type: 4,
      id: '96',
    ),
    IOFSymbol(
      code: '410.4',
      name: 'Vegetation: fight, minimum width',
      description: r'An area of dense vegetation (trees or undergrowth) which is effectively impassable. Minimum width: 0.35 mm',
      type: 2,
      id: '97',
    ),
    IOFSymbol(
      code: '411',
      name: 'Vegetation, impassable (from ISOM 2017, first edition)',
      description: r'Provided for migration from ISOM 2000. Use either Vegetation: fight (410) or Area that shall not be entered (520) instead.',
      type: 4,
      id: '98',
    ),
    IOFSymbol(
      code: '412',
      name: 'Cultivated land',
      description: r'Cultivated land, normally used for growing crops. Runnability may vary according to the type of crops grown and the time of year. For agroforestry, symbol Forest (405) or Open land with scattered trees (402) may be used instead of yellow. Since the runnability may vary, such areas should be avoided when setting courses. The symbol is combined with symbol Out-of-bounds area (709) to show cultivated land that shall not be entered. The symbol is orientated to north. Minimum area: 3 mm x 3 mm (footprint 45 m x 45 m).',
      type: 16,
      id: '99',
    ),
    IOFSymbol(
      code: '412.1',
      name: 'Cultivated land (black pattern)',
      description: r'Cultivated land. This symbol must be used together with another symbol: - For land used for growing crops, combine with symbol Open land (401). - For agroforrestry, use with symbol Forest (405) or Open land with scattered trees (402). Runnability may vary according to the type of crops or trees, and the time of year. Since the runnability may vary, such areas should be avoided when setting courses. The symbol is orientated to north. Minimum area: 3 mm x 3 mm (footprint 45 m x 45 m).',
      type: 4,
      id: '100',
    ),
    IOFSymbol(
      code: '413',
      name: 'Orchard',
      description: r'Land planted with trees or bushes, normally in a regular pattern. The dot lines may be orientated to show the direction of planting. Must be combined with either symbol Open land (401) or Rough open land (403). May be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: '101',
    ),
    IOFSymbol(
      code: '413.1',
      name: 'Orchard, rough open land',
      description: r'Land planted with trees or bushes, normally in a regular pattern. The dot lines may be orientated to show the direction of planting. Must be combined with either symbol Open land (401) or Rough open land (403). May be combined with symbol Vegetation: slow running, good visibility (407) or Vegetation: walk, good visibility (409) to show reduced runnability. Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: '102',
    ),
    IOFSymbol(
      code: '414',
      name: 'Vineyard or similar',
      description: r'A vineyard or similar cultivated land containing dense rows of plants offering good or normal runnability in the direction of planting. The lines shall be orientated to show the direction of planting. At least three lines shall be clearly visible. Must be combined with either symbol Open land (401) or Rough open land (403). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: '103',
    ),
    IOFSymbol(
      code: '414.1',
      name: 'Vineyard or similar, rough open land',
      description: r'A vineyard or similar cultivated land containing dense rows of plants offering good or normal runnability in the direction of planting. The lines shall be orientated to show the direction of planting. At least three lines shall be clearly visible. Must be combined with either symbol Open land (401) or Rough open land (403). Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: '104',
    ),
    IOFSymbol(
      code: '415',
      name: 'Distinct cultivation boundary',
      description: r'A boundary of cultivated land vegetation (symbols 401, 412, 413, 414) or a boundary between areas of cultivated land when not shown with other symbols (fence, wall, path, etc.). Minimum length: 2 mm (footprint 30 m).',
      type: 2,
      id: '105',
    ),
    IOFSymbol(
      code: '416',
      name: 'Distinct vegetation boundary',
      description: r'A distinct forest edge or vegetation boundary within the forest. Very distinct forest edges and vegetation boundaries may be represented using the cultivation boundary symbol. Only one of the vegetation boundary symbols (black dotted line or dashed green line) can be used on a map. For areas with a lot of rock features, it is recommended to use the green dashed line for vegetation boundaries. A disadvantage with a green line is that it cannot be used to show distinct vegetation boundaries around and within symbol Vegetation: fight (410). An alternative for these situations is to use symbol Distinct cultivation boundary (415). Minimum length, black dot implementation: 5 dots (2.5 mm - footprint 37 m). Minimum length, green line implementation: 4 dashes (1.8 mm - footprint 27 m).',
      type: 2,
      id: '106',
    ),
    IOFSymbol(
      code: '416.1',
      name: 'Distinct vegetation boundary, green dashed line',
      description: r'A distinct forest edge or vegetation boundary within the forest. Very distinct forest edges and vegetation boundaries may be represented using the cultivation boundary symbol. Only one of the vegetation boundary symbols (black dotted line or dashed green line) can be used on a map. For areas with a lot of rock features, it is recommended to use the green dashed line for vegetation boundaries. A disadvantage with a green line is that it cannot be used to show distinct vegetation boundaries around and within symbol Vegetation: fight (410). An alternative for these situations is to use symbol Distinct cultivation boundary (415). Minimum length, black dot implementation: 5 dots (2.5 mm - footprint 37 m). Minimum length, green line implementation: 4 dashes (1.8 mm - footprint 27 m).',
      type: 2,
      id: '107',
    ),
    IOFSymbol(
      code: '417',
      name: 'Prominent large tree',
      description: r'Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: '108',
    ),
    IOFSymbol(
      code: '418',
      name: 'Prominent bush or tree',
      description: r'Use sparingly, as it is easily mistaken for symbol Small knoll (109). Footprint: 9.0 m x 9.0 m.',
      type: 1,
      id: '109',
    ),
    IOFSymbol(
      code: '419',
      name: 'Prominent vegetation feature',
      description: r'The symbol is orientated to north. The definition of the symbol must be given on the map. Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: '110',
    ),
    IOFSymbol(
      code: '501',
      name: 'Paved area, with bounding line',
      description: r'An area with a firm surface such as asphalt, hard gravel, tiles, concrete or the like. Paved areas should be bordered (or framed) by a thin black line where they have a distinct boundary. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 16,
      id: '111',
    ),
    IOFSymbol(
      code: '501.1',
      name: 'Paved area (Lower Brown 50%)',
      description: r'An area with a firm level surface such as asphalt, hard gravel, tiles, concrete or the like.',
      type: 4,
    ),
    IOFSymbol(
      code: '501.2',
      name: 'Paved area, bounding line (below Upper Brown 50%)',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '501.1',
      name: 'Paved area',
      description: r'An area with a firm surface such as asphalt, hard gravel, tiles, concrete or the like. Paved areas should be bordered (or framed) by a thin black line where they have a distinct boundary. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: '112',
    ),
    IOFSymbol(
      code: '501.2',
      name: 'Paved area, bounding line',
      description: r'Paved areas should be bordered (or framed) by a thin black line where they have a distinct boundary.',
      type: 2,
      id: '113',
    ),
    IOFSymbol(
      code: '502',
      name: 'Wide road, minimum width',
      description: r'The width should be drawn to scale, but not smaller than the minimum width (0.3 + 2*0.14 mm - footprint 8.7 m). The outer boundary lines may be replaced with other black line symbols, such as symbol Fence (516), Impassable fence (518), Wall (513) or Impassable wall (515) if the feature is so close to the road edge that it cannot practically be shown as a separate symbol. The space between the black lines is filled with brown (50%). A road with two carriageways can be represented using two wide road symbols side by side, keeping only one of the road edges in the middle.',
      type: 2,
      id: '114',
    ),
    IOFSymbol(
      code: '502.1',
      name: 'Wide road, 0.5 mm (from ISOM2000)',
      description: r'Provided for migration from ISOM2000. Use of this symbol variant is discouraged for new maps.',
      type: 2,
      id: '115',
    ),
    IOFSymbol(
      code: '502.2',
      name: 'Road with two carriageways',
      description: r'The width should be drawn to scale, but not smaller than the minimum width (0.3 + 2*0.14 mm - footprint 8.7 m). The outer boundary lines may be replaced with other black line symbols, such as symbol Fence (516), Impassable fence (518), Wall (513) or Impassable wall (515) if the feature is so close to the road edge that it cannot practically be shown as a separate symbol. The space between the black lines is filled with brown (50%). A road with two carriageways can be represented using two wide road symbols side by side, keeping only one of the road edges in the middle.',
      type: 16,
      id: '116',
    ),
    IOFSymbol(
      code: '501.1',
      name: 'Motorway, outer part',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '501.2',
      name: 'Motorway, inner part',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '503',
      name: 'Road',
      description: r'A maintained road suitable for motor vehicles in all weather. Width less than 5 m.',
      type: 2,
      id: '117',
    ),
    IOFSymbol(
      code: '504',
      name: 'Vehicle track',
      description: r'A track or poorly maintained road suitable for vehicles only when travelling slowly. For distinct junctions the dashes of the symbols are joined at the junction. For indistinct junctions the dashes of the symbols are not joined. Minimum length (isolated): two dashes (6.25 mm - footprint 94 m).',
      type: 2,
      id: '118',
    ),
    IOFSymbol(
      code: '505',
      name: 'Footpath',
      description: r'An easily runnable path, bicycle track or old vehicle track. For distinct junctions the dashes of the symbols are joined at the junction. For indistinct junctions the dashes of the symbols are not joined. Minimum length (isolated): two dashes (4.25 mm - footprint 64 m)',
      type: 2,
      id: '119',
    ),
    IOFSymbol(
      code: '506',
      name: 'Small footpath',
      description: r'A runnable small path or (temporary) forest extraction track which can be followed at competition speed. For distinct junctions the dashes of the symbols are joined at the junction. For indistinct junctions the dashes of the symbols are not joined. Minimum length (isolated): two dashes (2.25 mm - footprint 34 m).',
      type: 2,
      id: '120',
    ),
    IOFSymbol(
      code: '507',
      name: 'Less distinct small footpath',
      description: r'A runnable less distinct / visible small path or forestry extraction track. Minimum length: two sections of double dashes (5.3 mm - footprint 79.5 m).',
      type: 2,
      id: '121',
    ),
    IOFSymbol(
      code: '508',
      name: 'Narrow ride',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Without background: the same runnability as the surroundings. Yellow 100%: easy running. White in green: normal runnability. Green 30%: slow running. Green 60%: walk. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 2,
      id: '122',
    ),
    IOFSymbol(
      code: '508.1',
      name: 'Narrow ride, easy running',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 16,
      id: '123',
    ),
    IOFSymbol(
      code: '508.1.1',
      name: 'Yellow background',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '508.2',
      name: 'Narrow ride, normal runnability',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 16,
      id: '124',
    ),
    IOFSymbol(
      code: '508.4.1',
      name: 'White background',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '508.3',
      name: 'Narrow ride, slow running',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 16,
      id: '125',
    ),
    IOFSymbol(
      code: '508.2.1',
      name: 'Green 20% background',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '508.4',
      name: 'Narrow ride, walk',
      description: r'A forest ride or a prominent trace (forestry extraction track, sandy track, ski track) through the terrain which does not have a distinct runnable path along it. Runnability is shown using a slightly thicker line of yellow, green or white as background. Minimum length: two dashes (3.25 mm - footprint 48 m).',
      type: 16,
      id: '126',
    ),
    IOFSymbol(
      code: '508.3.1',
      name: 'Green 50% background',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '509',
      name: 'Railway',
      description: r'A railway or other kind of railed track. If it is forbidden to run along the railway, it shall be combined with symbol Out-of-bounds route (711). If it is forbidden to cross the railway, it must be combined with symbol Area that shall not be entered (520) or Out-of-bounds area (709). Minimum length (isolated): two dashes (4 mm - footprint 60 m).',
      type: 16,
      id: '127',
    ),
    IOFSymbol(
      code: '509.0.1',
      name: 'Railway helper: inner black dashes',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '509.0.2',
      name: 'Railway, Black background',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '510',
      name: 'Power line, cableway or skilift',
      description: r'Power line, cableway or skilift. The bars show the exact location of the pylons. The line may be broken to improve legibility. If a section of a power line, cableway or skilift goes along a road or path (and does not offer significant additional navigational value) it should be omitted. Minimum length (isolated): 5 mm (footprint: 75 m).',
      type: 2,
      id: '128',
    ),
    IOFSymbol(
      code: '511',
      name: 'Major power line, minimum width',
      description: r'Major power lines should be drawn with a double line. The gap between the lines may indicate the extent of the power line. The lines may be broken to improve legibility. Very large carrying masts shall be represented in plan shape using outline of symbol Building (521) or with symbol High tower (524).',
      type: 2,
      id: '129',
    ),
    IOFSymbol(
      code: '511.1',
      name: 'Major power line',
      description: r'Major power lines should be drawn with a double line. The gap between the lines may indicate the extent of the power line. The lines may be broken to improve legibility. The bars show the exact location of the pylons. Very large carrying masts shall be represented in plan shape using outline of symbol Building (521) or with symbol High tower (524).',
      type: 2,
      id: '130',
    ),
    IOFSymbol(
      code: '511.2',
      name: 'Major power line, large carrying masts',
      description: r'Major power lines should be drawn with a double line. The gap between the lines may indicate the extent of the powerline. The bars show the exact location of the pylons. The lines may be broken to improve legibility. Very large carrying masts shall be represented in plan shape using symbol 521 (building) or with symbol 524 (high tower).',
      type: 16,
      id: '131',
    ),
    IOFSymbol(
      code: '511.9',
      name: 'Large carrying masts',
      description: r'',
      type: 2,
    ),
    IOFSymbol(
      code: '512',
      name: 'Bridge / tunnel',
      description: r'Bridges and tunnels are represented using the same basic symbols. If it is not possible to get through a tunnel (or under a bridge), it shall be omitted. Minimum length (of baseline): 0.4 mm (footprint 6 m). Small bridges connected to a track/path are shown by centring a track dash on the crossing. Tracks/paths are broken for water course crossings without bridges. A small footbridge with no path leading to it is represented with a single dash.',
      type: 2,
      id: '132',
    ),
    IOFSymbol(
      code: '512.1',
      name: 'Bridge / tunnel, minimum size',
      description: r'Bridges and tunnels are represented using the same basic symbols. If it is not possible to get through a tunnel (or under a bridge), it shall be omitted. Minimum length (of baseline): 0.4 mm (footprint 6 m). Small bridges connected to a track/path are shown by centring a track dash on the crossing. Tracks/paths are broken for water course crossings without bridges. A small footbridge with no path leading to it is represented with a single dash.',
      type: 1,
      id: '133',
    ),
    IOFSymbol(
      code: '512.2',
      name: 'Footbridge',
      description: r'A small footbridge with no path leading to it is represented with a single dash. Note: if the stream is wider than 0.25 mm, adjust this symbol so it extends 0.5 mm over both sides of the stream!',
      type: 1,
      id: '134',
    ),
    IOFSymbol(
      code: '513',
      name: 'Wall',
      description: r'A significant wall of stone, concrete, wood or other materials. Minimum height: 1 m. Minimum length (isolated): 1.4 mm (footprint 21 m).',
      type: 2,
      id: '135',
    ),
    IOFSymbol(
      code: '514',
      name: 'Ruined wall',
      description: r'A ruined or less distinct wall. Minimum height 0.5 m. Minimum length: two dashes (3.65 mm - footprint 55 m). If shorter, the object must be exaggerated to the minimum length or changed to symbol Wall (513).',
      type: 2,
      id: '136',
    ),
    IOFSymbol(
      code: '515',
      name: 'Impassable wall',
      description: r'An impassable or uncrossable wall, normally more than 1.5 m high. Minimum length (isolated): 3 mm (footprint 45 m).',
      type: 2,
      id: '137',
    ),
    IOFSymbol(
      code: '516',
      name: 'Fence',
      description: r'If the fence forms an enclosed area, tags should be placed inside. Minimum length (isolated): 1.5 mm (footprint 22.5 m).',
      type: 2,
      id: '138',
    ),
    IOFSymbol(
      code: '517',
      name: 'Ruined fence',
      description: r'A ruined or less distinct fence. If the fence forms an enclosed area, tags should be placed inside. Minimum length: two dashes (3.65 mm - footprint 55 m). If shorter, the symbol must be exaggerated to the minimum length or changed to symbol Fence (516).',
      type: 2,
      id: '139',
    ),
    IOFSymbol(
      code: '518',
      name: 'Impassable fence',
      description: r'An impassable or uncrossable fence, normally more than 1.5 m high. If the fence forms an enclosed area, tags should be placed inside. Minimum length (isolated): 2 mm (footprint 30 m).',
      type: 2,
      id: '140',
    ),
    IOFSymbol(
      code: '519',
      name: 'Crossing point',
      description: r'A way through or over a wall, fence or other linear feature, including a gate or stile. For impassable features, the line shall be broken at the crossing point. For passable features, the line shall not be broken if passing involves a degree of climb.',
      type: 1,
      id: '141',
    ),
    IOFSymbol(
      code: '520',
      name: 'Area that shall not be entered',
      description: r'An out-of-bounds area is a feature such as a private house, a garden, a factory or another industrial area. Only contours and prominent features such as railways and large buildings shall be shown inside an out-of-bounds area. Vertical black stripes may be used for areas where it is important to show a complete representation of the terrain (e.g. when a part of the forest is out-of-bounds). The area shall be discontinued where a path or track goes through. Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur. Course planning symbol 709 can be used for temporary out-of bounds areas. The vertical black stripes version of the symbol is orientated to north. An out-of-bounds area shall not be entered. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: '142',
    ),
    IOFSymbol(
      code: '520.1',
      name: 'Area that shall not be entered, solid colour, bounding line',
      description: r'Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur.',
      type: 2,
      id: '143',
    ),
    IOFSymbol(
      code: '520.2',
      name: 'Area that shall not be entered, stripes',
      description: r'An out-of-bounds area is a feature such as a private house, a garden, a factory or another industrial area. Only contours and prominent features such as railways and large buildings shall be shown inside an out-of-bounds area. Vertical black stripes may be used for areas where it is important to show a complete representation of the terrain (e.g. when a part of the forest is out-of-bounds). The area shall be discontinued where a path or track goes through. Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur. Course planning symbol 709 can be used for temporary out-of bounds areas. The vertical black stripes version of the symbol is orientated to north. An out-of-bounds area shall not be entered. Minimum area: 1 mm x 1 mm (footprint 15 m x 15 m).',
      type: 4,
      id: '144',
    ),
    IOFSymbol(
      code: '520.3',
      name: 'Area that shall not be entered, stripes, bounding line',
      description: r'Out-of-bound areas with a clear border shall be bounded by a black boundary line or another black line. If the border is unclear no black line shall occur.',
      type: 2,
      id: '145',
    ),
    IOFSymbol(
      code: '521',
      name: 'Building',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 4,
      id: '146',
    ),
    IOFSymbol(
      code: '521.1',
      name: 'Building, minimum size',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 1,
      id: '147',
    ),
    IOFSymbol(
      code: '521.2',
      name: 'Large building with outline',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 16,
      id: '148',
    ),
    IOFSymbol(
      code: '521.3',
      name: 'Large building',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 4,
      id: '149',
    ),
    IOFSymbol(
      code: '521.4',
      name: 'Large building, outline',
      description: r'A building is shown with its ground plan so far as the scale permits. Buildings larger than 75 m x 75 m may be represented with a dark grey infill in urban areas. Passages through buildings must have a minimum width of 0.3 mm (footprint 4.5 m). Buildings within forbidden areas are generalised. Areas totally contained within a building shall not be mapped (they shall be represented as being part of the building). Minimum gap indicating a passage between buildings and between buildings and other impassable features should be 0.4 mm. Minimum area: 0.5 mm x 0.5 mm (footprint 7.5 m x 7.5 m).',
      type: 2,
      id: '150',
    ),
    IOFSymbol(
      code: '522',
      name: 'Canopy with outline',
      description: r'An accessible and runnable area with roof. Minimum area (isolated): 0.6 mm x 0.6 mm (footprint 9 m x 9 m). Minimum (inside) width: 0.3 mm (footprint 4.5 m).',
      type: 16,
      id: '151',
    ),
    IOFSymbol(
      code: '522.1',
      name: 'Canopy',
      description: r'An accessible and runnable area with roof. Minimum area (isolated): 0.6 mm x 0.6 mm (footprint 9 m x 9 m). Minimum (inside) width: 0.3 mm (footprint 4.5 m).',
      type: 4,
      id: '152',
    ),
    IOFSymbol(
      code: '522.2',
      name: 'Canopy, outline',
      description: r'An accessible and runnable area with roof. Minimum area (isolated): 0.6 mm x 0.6 mm (footprint 9 m x 9 m). Minimum (inside) width: 0.3 mm (footprint 4.5 m).',
      type: 2,
      id: '153',
    ),
    IOFSymbol(
      code: '523',
      name: 'Ruin',
      description: r'A ruined building. The ground plan of a ruin is shown to scale, down to the minimum size. Ruins that are so small that they cannot be drawn to scale may be represented using a solid line. Minimum area (outside measures): 0.8 mm x 0.8 mm (footprint 12 m x 12 m).',
      type: 2,
      id: '154',
    ),
    IOFSymbol(
      code: '523.1',
      name: 'Ruin, minimum size',
      description: r'A ruined building. The ground plan of a ruin is shown to scale, down to the minimum size. Ruins that are so small that they cannot be drawn to scale may be represented using a solid line. Minimum area (outside measures): 0.8 mm x 0.8 mm (footprint 12 m x 12 m).',
      type: 1,
      id: '155',
    ),
    IOFSymbol(
      code: '524',
      name: 'High tower',
      description: r'A high tower or large pylon. If it is in a forest, it must be visible above the level of the surrounding forest.Towers with a larger footprint must be represented using symbol Building (521). The symbol is orientated to north. Footprint: 21 m in diameter.',
      type: 1,
      id: '156',
    ),
    IOFSymbol(
      code: '525',
      name: 'Small tower',
      description: r'An obvious small tower, platform or seat. Location is at the centre of gravity of the symbol. The symbol is orientated to north. Footprint: 15 m x 15 m.',
      type: 1,
      id: '157',
    ),
    IOFSymbol(
      code: '526',
      name: 'Cairn',
      description: r'A prominent cairn, memorial stone, boundary stone or trigonometric point. Minimum height: 0.5 m. Footprint: 12 m in diameter.',
      type: 1,
      id: '158',
    ),
    IOFSymbol(
      code: '527',
      name: 'Fodder rack',
      description: r'A fodder rack, which is free standing or attached to a tree. Location is at the centre of gravity of the symbol. The symbol is orientated to north. Footprint: 13.5 m x 13.5 m.',
      type: 1,
      id: '159',
    ),
    IOFSymbol(
      code: '528',
      name: 'Prominent line feature',
      description: r'A prominent man-made line feature. For example, a low pipeline (gas, water, oil, heat, etc.) or a bobsleigh / skeleton track that is clearly visible. The definition of the symbol must be given on the map. Minimum length: 1.5 mm (footprint 22.5 m).',
      type: 2,
      id: '160',
    ),
    IOFSymbol(
      code: '529',
      name: 'Prominent impassable line feature',
      description: r'An impassable man-made line feature. For example, a high pipeline (gas, water, oil, heat, etc.) or a bobsleigh / skeleton track. The definition of the symbol must be given on the map. Minimum length: 2 mm (footprint 30 m).',
      type: 2,
      id: '161',
    ),
    IOFSymbol(
      code: '530',
      name: 'Prominent man-made feature – ring',
      description: r'Location is at the centre of gravity of the symbol. The definition of the symbol must be given on the map. Footprint: 12 m in diameter.',
      type: 1,
      id: '162',
    ),
    IOFSymbol(
      code: '531',
      name: 'Prominent man-made feature – x',
      description: r'Location is at the centre of gravity of the symbol. The symbol is orientated to north. The definition of the symbol must be given on the map. Footprint: 12 m x 12 m.',
      type: 1,
      id: '163',
    ),
    IOFSymbol(
      code: '532',
      name: 'Stairway',
      description: r'A distinct stairway through the terrain which helps to climb very steep slopes or to cross over impassable objects. A stairway going through rock passages or between impassable objects may be drawn without border lines. An easily runnable stairway or indistinct stairway should be drawn as a footpath. Steps of a stairway shall be represented in a generalized manner. Minimum length: 3 (graphical) steps. Minimum width: 0.4 mm (IM).',
      type: 2,
      id: '164',
    ),
    IOFSymbol(
      code: '532.1',
      name: 'Stairway, without border lines',
      description: r'A distinct stairway through the terrain which helps to climb very steep slopes or to cross over impassable objects. A stairway going through rock passages or between impassable objects may be drawn without border lines. An easily runnable stairway or indistinct stairway should be drawn as a footpath. Steps of a stairway shall be represented in a generalized manner.',
      type: 2,
      id: '165',
    ),
    IOFSymbol(
      code: '601.1',
      name: 'Magnetic north line',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 2,
      id: '166',
    ),
    IOFSymbol(
      code: '601.2',
      name: 'North lines pattern',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 4,
      id: '167',
    ),
    IOFSymbol(
      code: '601.3',
      name: 'Magnetic north line, blue',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 2,
      id: '168',
    ),
    IOFSymbol(
      code: '601.4',
      name: 'North lines pattern, blue',
      description: r'Magnetic north lines are lines placed on the map pointing to magnetic north, parallel to the sides of the paper. Their spacing on the map shall be 20 mm on the map which represents 300 m on the ground at the scale of 1:15 000. If the map is enlarged to 1:10 000, the spacing of the lines will be 30 mm on the map. North lines shall be broken to improve the legibility of the map, for instance where they would obscure small features. In areas with very few water features, blue lines may be used.',
      type: 4,
      id: '169',
    ),
    IOFSymbol(
      code: '602',
      name: 'Registration mark',
      description: r'At least three registration marks may be placed in the corners of the map. These can be used for printing courses on already printed maps. In addition, it allows a check of colour registration when printing colours separately.',
      type: 1,
      id: '170',
    ),
    IOFSymbol(
      code: '603.0',
      name: 'Spot height, dot',
      description: r'Spot heights are used for the rough assessment of height differences. The height is given to the nearest metre. Water levels are given without the dot. Spot heights must only be used where they do not conflict with other symbols.',
      type: 1,
      id: '171',
    ),
    IOFSymbol(
      code: '603.1',
      name: 'Spot height, text',
      description: r'Spot heights are used for the rough assessment of height differences. The height is given to the nearest metre. Water levels are given without the dot. Spot heights must only be used where they do not conflict with other symbols.',
      type: 8,
      id: '172',
    ),
    IOFSymbol(
      code: '701',
      name: 'Start',
      description: r'The place where the orienteering starts. The centre of the triangle shows the precise position where the orienteering course starts. The start must be on a clearly identifiable point on the map. The triangle points in the direction of the first control.',
      type: 1,
      id: '173',
    ),
    IOFSymbol(
      code: '702',
      name: 'Map issue point',
      description: r'If there is a marked route to the start point, the map issue point is marked using this symbol.',
      type: 1,
      id: '174',
    ),
    IOFSymbol(
      code: '703',
      name: 'Control point',
      description: r'For point features, the centre of the circle shall be the centre of the symbol. For line and area features, the centre of the circle shows the precise position of the control marker. Controls shall only be placed on points that are clearly identifiable on the map. Sections of the circle should be omitted to leave important detail showing. Footprint 75 m',
      type: 1,
      id: '175',
    ),
    IOFSymbol(
      code: '704',
      name: 'Control number',
      description: r'The number of the control is placed close to the control point circle in such a way that it does not obscure important detail. The numbers are orientated to north.',
      type: 8,
      id: '176',
    ),
    IOFSymbol(
      code: '705',
      name: 'Course line',
      description: r'Where controls are to be visited in order, the sequence is shown using straight lines from the start to the first control and then from each control to the next one. Sections of lines should be omitted to leave important detail showing. The line should be drawn via mandatory crossing points. There should be gaps between the line and the control circle in order to increase the readability of the underlying detail close to the control.',
      type: 2,
      id: '177',
    ),
    IOFSymbol(
      code: '706',
      name: 'Finish',
      description: r'The end of the course.',
      type: 1,
      id: '178',
    ),
    IOFSymbol(
      code: '707',
      name: 'Marked route',
      description: r'A marked route that is a part of the course. It is mandatory to follow the marked route. Minimum length: 2 dashes (4.5 mm – footprint: 67.5 m).',
      type: 2,
      id: '179',
    ),
    IOFSymbol(
      code: '708',
      name: 'Out-of-bounds boundary',
      description: r'A boundary which it is not permitted to cross. An out-of-bounds boundary shall not be crossed. Minimum length: 1 mm (footprint: 15 m).',
      type: 2,
      id: '180',
    ),
    IOFSymbol(
      code: '709',
      name: 'Out-of-bounds area',
      description: r'An out-of-bounds area. A bounding line may be drawn if there is no natural boundary, as follows: – a solid line indicates that the boundary is marked continuously (tapes, etc.) in the terrain, – a dashed line indicates intermittent marking in the terrain, – no line indicates no marking in the terrain. An out-of-bounds area shall not be entered. Minimum area: 2 mm x 2 mm (footprint 30 m x 30 m).',
      type: 4,
      id: '181',
    ),
    IOFSymbol(
      code: '709.1',
      name: 'Out-of-bounds area, solid boundary',
      description: r'A solid line indicates that the boundary is marked continuously (tapes, etc.) on the ground.',
      type: 2,
      id: '182',
    ),
    IOFSymbol(
      code: '709.2',
      name: 'Out-of-bounds area, dashed boundary',
      description: r'A dashed line indicates intermittent marking on the ground.',
      type: 2,
      id: '183',
    ),
    IOFSymbol(
      code: '710',
      name: 'Crossing point',
      description: r'A crossing point, for instance through or over a wall or fence, across a road or railway, through a tunnel or out-of-bounds area, or over an uncrossable boundary is drawn on the map with two lines curving outwards. The lines shall reflect the length of the crossing.',
      type: 1,
      id: '184',
    ),
    IOFSymbol(
      code: '711',
      name: 'Out-of-bounds route',
      description: r'A route which is out-of-bounds. Competitors are allowed to cross directly over a forbidden route, but it is forbidden to go along it. An out-of-bounds route shall not be used. Minimum length: 2 symbols (6 mm – footprint 90 m).',
      type: 2,
      id: '185',
    ),
    IOFSymbol(
      code: '711.1',
      name: 'Out-of-bounds route, single cross',
      description: r'A route which is out-of-bounds. Competitors are allowed to cross directly over a forbidden route, but it is forbidden to go along it. An out-of-bounds route shall not be used. Minimum length: 2 symbols (6 mm – footprint 90 m).',
      type: 1,
      id: '186',
    ),
    IOFSymbol(
      code: '712',
      name: 'First aid post',
      description: r'The location of a first aid post.',
      type: 1,
      id: '187',
    ),
    IOFSymbol(
      code: '713',
      name: 'Refreshment point',
      description: r'The location of a refreshment point which is not at a control.',
      type: 1,
      id: '188',
    ),
    IOFSymbol(
      code: '799',
      name: 'Simple Orienteering Course',
      description: r'This symbol provides a simple and quick way to make training courses. The purple line will extend a bit into the finish symbol. This is a shortcoming of this simple approach.',
      type: 2,
      id: '189',
    ),
    IOFSymbol(
      code: '999',
      name: 'OpenOrienteering Logo',
      description: r'The OpenOrienteering Logo.',
      type: 1,
      id: '190',
    ),
  ];

  // Get symbol by code
  static IOFSymbol? getByCode(String code) {
    try {
      return symbols.firstWhere((s) => s.code == code);
    } catch (e) {
      return null;
    }
  }

  // Get all symbols of a specific type
  static List<IOFSymbol> getByType(int type) {
    return symbols.where((s) => s.type == type).toList();
  }

  // Get symbols by category
  static List<IOFSymbol> getByCategory(String category) {
    return symbols.where((s) => s.category == category).toList();
  }

  // Get all available categories
  static List<String> getCategories() {
    return symbols.map((s) => s.category).toSet().toList()..sort();
  }

  // Search symbols by name or code
  static List<IOFSymbol> search(String query) {
    final lowerQuery = query.toLowerCase();
    return symbols.where((s) => 
      s.code.toLowerCase().contains(lowerQuery) ||
      s.name.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Get a sample symbol for preview
  static IOFSymbol getSampleSymbol() {
    return symbols.first;
  }
}

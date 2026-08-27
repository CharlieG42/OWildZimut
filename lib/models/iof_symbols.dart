import 'package:flutter/material.dart';
import 'symbol.dart';

/// Catégories de symboles IOF
enum IOFSymbolCategory {
  // Forêt et végétation
  forest,
  openLand,
  marsh,
  
  // Relief
  earthBank,
  earthWall,
  pit,
  knoll,
  depression,
  
  // Eau
  water,
  lake,
  river,
  stream,
  marshWater,
  
  // Chemins et routes
  path,
  track,
  road,
  trail,
  
  // Bâtiments et constructions
  building,
  ruin,
  fence,
  wall,
  
  // Rochers
  boulder,
  boulderCluster,
  stonyGround,
  
  // Points remarquables
  controlPoint,
  start,
  finish,
  crossingPoint,
  
  // Végétation spéciale
  thicket,
  clearing,
  cultivatedLand,
  vineyard,
  orchard,
  
  // Symboles techniques
  boundary,
  outOfBounds,
  mandatoryPassage,
  forbidden,
}

/// Sous-catégories pour une classification plus fine
enum IOFSymbolSubCategory {
  none,
  // Forêt
  runnable,
  slowRunning,
  walk,
  fight,
  impassable,
  
  // Eau
  passable,
  impassableWater,
  
  // Chemins
  public,
  private,
  forestRoad,
  ride,
  footpath,
  
  // Rochers
  single,
  cluster,
  field,
}

/// Niveau de détail du symbole
enum SymbolDetailLevel {
  basic,
  standard,
  detailed,
  all,
}

/// Définition complète d'un symbole IOF
class IOFSymbolDefinition {
  final String code;
  final String name;
  final String description;
  final IOFSymbolCategory category;
  final IOFSymbolSubCategory subCategory;
  final SymbolType type;
  final Color defaultColor;
  final double defaultSize;
  final String? svgPath;
  final String? imageAsset;
  final SymbolDetailLevel detailLevel;
  final bool isStandard;
  final Map<String, dynamic>? metadata;

  const IOFSymbolDefinition({
    required this.code,
    required this.name,
    required this.description,
    required this.category,
    this.subCategory = IOFSymbolSubCategory.none,
    required this.type,
    required this.defaultColor,
    this.defaultSize = 1.0,
    this.svgPath,
    this.imageAsset,
    this.detailLevel = SymbolDetailLevel.standard,
    this.isStandard = true,
    this.metadata,
  });

  /// Crée un symbole à partir de cette définition
  Symbol createSymbol({
    String? id,
    Offset? position,
    Color? color,
    double? size,
    double? rotation,
    List<Offset>? points,
  }) {
    return Symbol(
      id: id ?? 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      code: code,
      position: position ?? Offset.zero,
      description: description,
      color: color ?? defaultColor,
      size: size ?? defaultSize,
      rotation: rotation ?? 0.0,
      points: points ?? [],
    );
  }

  @override
  String toString() {
    return 'IOFSymbolDefinition(code: $code, name: $name, category: $category)';
  }
}

/// Bibliothèque complète des symboles IOF
class IOFSymbolLibrary {
  static final IOFSymbolLibrary _instance = IOFSymbolLibrary._internal();
  
  factory IOFSymbolLibrary() => _instance;

  IOFSymbolLibrary._internal();

  final Map<String, IOFSymbolDefinition> _symbols = {};
  final Map<IOFSymbolCategory, List<IOFSymbolDefinition>> _symbolsByCategory = {};
  
  /// Initialise la bibliothèque avec tous les symboles IOF standard
  void _initialize() {
    if (_symbols.isNotEmpty) return;

    // Forêt et végétation
    _addSymbol(IOFSymbolDefinition(
      code: '101.1',
      name: 'Forêt blanche',
      description: 'Forêt où la course est possible sans difficulté',
      category: IOFSymbolCategory.forest,
      subCategory: IOFSymbolSubCategory.runnable,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFFFFFF),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '101.2',
      name: 'Forêt jaune',
      description: 'Forêt où la course est légèrement ralentie',
      category: IOFSymbolCategory.forest,
      subCategory: IOFSymbolSubCategory.slowRunning,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFFFF00),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '101.3',
      name: 'Forêt verte',
      description: 'Forêt où la course est très ralentie',
      category: IOFSymbolCategory.forest,
      subCategory: IOFSymbolSubCategory.walk,
      type: SymbolType.area,
      defaultColor: const Color(0xFF00FF00),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '102.1',
      name: 'Terrain ouvert',
      description: 'Terrain ouvert sans végétation significative',
      category: IOFSymbolCategory.openLand,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFFFFFF),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '103.1',
      name: 'Marais blanc',
      description: 'Marais passable',
      category: IOFSymbolCategory.marsh,
      subCategory: IOFSymbolSubCategory.passable,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFFFFFF),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '103.2',
      name: 'Marais jaune',
      description: 'Marais où la course est ralentie',
      category: IOFSymbolCategory.marsh,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFFFF00),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    // Relief
    _addSymbol(IOFSymbolDefinition(
      code: '201.1',
      name: 'Talus de terre',
      description: 'Talus de terre visible',
      category: IOFSymbolCategory.earthBank,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 2.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '202.1',
      name: 'Mur de terre',
      description: 'Mur de terre ou falaise',
      category: IOFSymbolCategory.earthWall,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 2.5,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '203.1',
      name: 'Fosse',
      description: 'Petite fosse ou dépression',
      category: IOFSymbolCategory.pit,
      type: SymbolType.point,
      defaultColor: const Color(0xFF000000),
      defaultSize: 3.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '204.1',
      name: 'Butte',
      description: 'Petite butte ou colline',
      category: IOFSymbolCategory.knoll,
      type: SymbolType.point,
      defaultColor: const Color(0xFF000000),
      defaultSize: 4.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '205.1',
      name: 'Dépression',
      description: 'Dépression dans le terrain',
      category: IOFSymbolCategory.depression,
      type: SymbolType.point,
      defaultColor: const Color(0xFF000000),
      defaultSize: 3.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    // Eau
    _addSymbol(IOFSymbolDefinition(
      code: '301.1',
      name: 'Lac',
      description: 'Grand plan d\'eau',
      category: IOFSymbolCategory.lake,
      type: SymbolType.area,
      defaultColor: const Color(0xFF0000FF),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '302.1',
      name: 'Rivière',
      description: 'Cours d\'eau large',
      category: IOFSymbolCategory.river,
      type: SymbolType.line,
      defaultColor: const Color(0xFF0000FF),
      defaultSize: 3.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '303.1',
      name: 'Ruisseau',
      description: 'Petit cours d\'eau',
      category: IOFSymbolCategory.stream,
      type: SymbolType.line,
      defaultColor: const Color(0xFF0000FF),
      defaultSize: 1.5,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '304.1',
      name: 'Marais bleu',
      description: 'Marais impraticable',
      category: IOFSymbolCategory.marshWater,
      subCategory: IOFSymbolSubCategory.impassable,
      type: SymbolType.area,
      defaultColor: const Color(0xFF0000FF),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    // Chemins et routes
    _addSymbol(IOFSymbolDefinition(
      code: '401.1',
      name: 'Chemin public',
      description: 'Chemin carrossable public',
      category: IOFSymbolCategory.path,
      subCategory: IOFSymbolSubCategory.public,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 3.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '402.1',
      name: 'Chemin privé',
      description: 'Chemin carrossable privé',
      category: IOFSymbolCategory.path,
      subCategory: IOFSymbolSubCategory.private,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 2.5,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '403.1',
      name: 'Chemin forestier',
      description: 'Chemin forestier ou piste',
      category: IOFSymbolCategory.path,
      subCategory: IOFSymbolSubCategory.forestRoad,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 2.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '404.1',
      name: 'Sentier',
      description: 'Sentier piéton',
      category: IOFSymbolCategory.track,
      subCategory: IOFSymbolSubCategory.footpath,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '405.1',
      name: 'Route',
      description: 'Route goudronnée',
      category: IOFSymbolCategory.road,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 4.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    // Bâtiments et constructions
    _addSymbol(IOFSymbolDefinition(
      code: '501.1',
      name: 'Bâtiment',
      description: 'Bâtiment ou maison',
      category: IOFSymbolCategory.building,
      type: SymbolType.area,
      defaultColor: const Color(0xFF000000),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '502.1',
      name: 'Ruine',
      description: 'Ruine ou bâtiment en ruine',
      category: IOFSymbolCategory.ruin,
      type: SymbolType.area,
      defaultColor: const Color(0xFF666666),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '503.1',
      name: 'Clôture',
      description: 'Clôture ou barrière',
      category: IOFSymbolCategory.fence,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '504.1',
      name: 'Mur',
      description: 'Mur en pierre ou béton',
      category: IOFSymbolCategory.wall,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 2.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    // Rochers
    _addSymbol(IOFSymbolDefinition(
      code: '601.1',
      name: 'Rocher isolé',
      description: 'Gros rocher isolé',
      category: IOFSymbolCategory.boulder,
      subCategory: IOFSymbolSubCategory.single,
      type: SymbolType.point,
      defaultColor: const Color(0xFF000000),
      defaultSize: 4.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '602.1',
      name: 'Groupe de rochers',
      description: 'Groupe de petits rochers',
      category: IOFSymbolCategory.boulderCluster,
      subCategory: IOFSymbolSubCategory.cluster,
      type: SymbolType.area,
      defaultColor: const Color(0xFF000000),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '603.1',
      name: 'Terrain rocheux',
      description: 'Zone de terrain très rocheux',
      category: IOFSymbolCategory.stonyGround,
      subCategory: IOFSymbolSubCategory.field,
      type: SymbolType.area,
      defaultColor: const Color(0xFF666666),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    // Points remarquables
    _addSymbol(IOFSymbolDefinition(
      code: '701.1',
      name: 'Point de contrôle',
      description: 'Point de contrôle de course d\'orientation',
      category: IOFSymbolCategory.controlPoint,
      type: SymbolType.point,
      defaultColor: const Color(0xFFFF00FF),
      defaultSize: 6.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '702.1',
      name: 'Départ',
      description: 'Point de départ',
      category: IOFSymbolCategory.start,
      type: SymbolType.point,
      defaultColor: const Color(0xFFFF0000),
      defaultSize: 8.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '703.1',
      name: 'Arrivée',
      description: 'Point d\'arrivée',
      category: IOFSymbolCategory.finish,
      type: SymbolType.point,
      defaultColor: const Color(0xFF00FF00),
      defaultSize: 8.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '704.1',
      name: 'Point de passage obligatoire',
      description: 'Point de passage obligatoire',
      category: IOFSymbolCategory.mandatoryPassage,
      type: SymbolType.point,
      defaultColor: const Color(0xFFFFFF00),
      defaultSize: 6.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    // Végétation spéciale
    _addSymbol(IOFSymbolDefinition(
      code: '801.1',
      name: 'Fourré',
      description: 'Fourré ou buisson épais',
      category: IOFSymbolCategory.thicket,
      type: SymbolType.area,
      defaultColor: const Color(0xFF00FF00),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '802.1',
      name: 'Clairière',
      description: 'Clairière dans la forêt',
      category: IOFSymbolCategory.clearing,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFFFF00),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '803.1',
      name: 'Terre cultivée',
      description: 'Champ cultivé',
      category: IOFSymbolCategory.cultivatedLand,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFFFF00),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    // Symboles techniques
    _addSymbol(IOFSymbolDefinition(
      code: '901.1',
      name: 'Limite de carte',
      description: 'Limite de la zone de course',
      category: IOFSymbolCategory.boundary,
      type: SymbolType.line,
      defaultColor: const Color(0xFF000000),
      defaultSize: 2.0,
      detailLevel: SymbolDetailLevel.basic,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '902.1',
      name: 'Hors limites',
      description: 'Zone hors limites de course',
      category: IOFSymbolCategory.outOfBounds,
      type: SymbolType.area,
      defaultColor: const Color(0xFF800080),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '903.1',
      name: 'Passage obligatoire',
      description: 'Passage obligatoire entre deux points',
      category: IOFSymbolCategory.mandatoryPassage,
      type: SymbolType.line,
      defaultColor: const Color(0xFFFFFF00),
      defaultSize: 2.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));

    _addSymbol(IOFSymbolDefinition(
      code: '904.1',
      name: 'Zone interdite',
      description: 'Zone où le passage est interdit',
      category: IOFSymbolCategory.forbidden,
      type: SymbolType.area,
      defaultColor: const Color(0xFFFF0000),
      defaultSize: 1.0,
      detailLevel: SymbolDetailLevel.standard,
      isStandard: true,
    ));
  }

  void _addSymbol(IOFSymbolDefinition symbol) {
    _symbols[symbol.code] = symbol;
    
    if (!_symbolsByCategory.containsKey(symbol.category)) {
      _symbolsByCategory[symbol.category] = [];
    }
    _symbolsByCategory[symbol.category]!.add(symbol);
  }

  /// Récupère tous les symboles
  List<IOFSymbolDefinition> get allSymbols {
    _initialize();
    return _symbols.values.toList();
  }

  /// Récupère les symboles par catégorie
  List<IOFSymbolDefinition> getSymbolsByCategory(IOFSymbolCategory category) {
    _initialize();
    return _symbolsByCategory[category] ?? [];
  }

  /// Récupère un symbole par son code
  IOFSymbolDefinition? getSymbolByCode(String code) {
    _initialize();
    return _symbols[code];
  }

  /// Récupère les symboles par niveau de détail
  List<IOFSymbolDefinition> getSymbolsByDetailLevel(SymbolDetailLevel level) {
    _initialize();
    switch (level) {
      case SymbolDetailLevel.basic:
        return allSymbols.where((s) => 
          s.detailLevel == SymbolDetailLevel.basic
        ).toList();
      case SymbolDetailLevel.standard:
        return allSymbols.where((s) => 
          s.detailLevel == SymbolDetailLevel.basic ||
          s.detailLevel == SymbolDetailLevel.standard
        ).toList();
      case SymbolDetailLevel.detailed:
        return allSymbols.where((s) => 
          s.detailLevel == SymbolDetailLevel.basic ||
          s.detailLevel == SymbolDetailLevel.standard ||
          s.detailLevel == SymbolDetailLevel.detailed
        ).toList();
      case SymbolDetailLevel.all:
        return allSymbols;
    }
  }

  /// Recherche des symboles par nom ou description
  List<IOFSymbolDefinition> searchSymbols(String query) {
    _initialize();
    final lowerQuery = query.toLowerCase();
    return allSymbols.where((symbol) => 
      symbol.name.toLowerCase().contains(lowerQuery) ||
      symbol.description.toLowerCase().contains(lowerQuery) ||
      symbol.code.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  /// Récupère les catégories disponibles
  List<IOFSymbolCategory> get categories => IOFSymbolCategory.values;

  /// Nombre total de symboles
  int get symbolCount {
    _initialize();
    return _symbols.length;
  }
}

/// Instance globale de la bibliothèque de symboles
final iofSymbolLibrary = IOFSymbolLibrary();

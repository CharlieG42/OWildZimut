import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'layer.dart';
import 'symbol.dart' as symbol_model;
import 'iof_symbols.dart';
import 'map_state.dart';

/// Type de fichier OCAD/OOMAP
enum MapFileType {
  ocad,
  oomap,
  unknown,
}

/// Version du format OCAD
enum MapFileVersion {
  v6,
  v7,
  v8,
  v9,
  v10,
  v11,
  v12,
  unknown,
}

/// Système de coordonnées
enum CoordinateSystem {
  local,
  utm,
  geographic,
  unknown,
}

/// Unité de mesure
enum MapUnit {
  meters,
  millimeters,
  unknown,
}

/// En-tête du fichier OCAD
class MapFileHeader {
  final MapFileVersion version;
  final String versionString;
  final CoordinateSystem coordinateSystem;
  final MapUnit unit;
  final double scale;
  final String mapName;
  final String mapAuthor;
  final String mapOrganization;
  final DateTime? creationDate;
  final DateTime? modificationDate;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final int numberOfColors;
  final int numberOfSymbols;

  MapFileHeader({
    this.version = MapFileVersion.unknown,
    this.versionString = '',
    this.coordinateSystem = CoordinateSystem.unknown,
    this.unit = MapUnit.unknown,
    this.scale = 1.0,
    this.mapName = '',
    this.mapAuthor = '',
    this.mapOrganization = '',
    this.creationDate,
    this.modificationDate,
    this.minX = 0.0,
    this.maxX = 0.0,
    this.minY = 0.0,
    this.maxY = 0.0,
    this.numberOfColors = 0,
    this.numberOfSymbols = 0,
  });

  factory MapFileHeader.fromBytes(Uint8List bytes) {
    // Parseur simplifié pour l'en-tête OCAD
    // À compléter avec une implémentation complète
    // Lire la signature du fichier
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    if (signature == 'OCAD') {
      return MapFileHeader(version: MapFileVersion.v8); // Version par défaut
    } else if (signature == 'OOMAP') {
      // Format OOMAP
      return MapFileHeader();
    }

    return MapFileHeader();
  }

  MapFileHeader copyWith({
    MapFileVersion? version,
    String? versionString,
    CoordinateSystem? coordinateSystem,
    MapUnit? unit,
    double? scale,
    String? mapName,
    String? mapAuthor,
    String? mapOrganization,
    DateTime? creationDate,
    DateTime? modificationDate,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    int? numberOfColors,
    int? numberOfSymbols,
  }) {
    return MapFileHeader(
      version: version ?? this.version,
      versionString: versionString ?? this.versionString,
      coordinateSystem: coordinateSystem ?? this.coordinateSystem,
      unit: unit ?? this.unit,
      scale: scale ?? this.scale,
      mapName: mapName ?? this.mapName,
      mapAuthor: mapAuthor ?? this.mapAuthor,
      mapOrganization: mapOrganization ?? this.mapOrganization,
      creationDate: creationDate ?? this.creationDate,
      modificationDate: modificationDate ?? this.modificationDate,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      minY: minY ?? this.minY,
      maxY: maxY ?? this.maxY,
      numberOfColors: numberOfColors ?? this.numberOfColors,
      numberOfSymbols: numberOfSymbols ?? this.numberOfSymbols,
    );
  }
}

/// Couleur OCAD
class MapFileColor {
  final int number;
  final String name;
  final Color color;
  final bool spotColor;
  final double separation;
  final double angle;
  final double frequency;

  MapFileColor({
    required this.number,
    this.name = '',
    this.color = const Color(0xFF000000),
    this.spotColor = false,
    this.separation = 0.0,
    this.angle = 0.0,
    this.frequency = 0.0,
  });

  factory MapFileColor.fromBytes(Uint8List bytes, int offset) {
    // Parseur de couleur OCAD
    // À compléter
    return MapFileColor(number: 0);
  }
}

/// Symbole OCAD
class MapFileMapSymbol {
  final int number;
  final String name;
  final String description;
  final int colorNumber;
  final symbol_model.MapSymbolType type;
  final List<Uint8List> elements;

  MapFileMapSymbol({
    required this.number,
    this.name = '',
    this.name = '',
    this.colorNumber = 0,
    this.type = symbol_model.MapSymbolType.point,
    this.elements = const [],
  });

  factory MapFileMapSymbol.fromBytes(Uint8List bytes, int offset) {
    // Parseur de symbole OCAD
    // À compléter
    return MapFileMapSymbol(number: 0);
  }

  /// Convertit en symbole IOF
  symbol_model.MapSymbol toIOFSymbol({
    String? id,
    Offset? position,
    double scale = 1.0,
  }) {
    // Trouver la correspondance avec les symboles IOF
    final iofSymbol = iofSymbolLibrary.getSymbolByCode(number.toString());
    
    return symbol_model.MapSymbol(
      id: id ?? 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      name: iofSymbol?.name ?? description,
      strokeColor: iofSymbol?.defaultColor ?? const Color(0xFF000000),
      size: (iofSymbol?.defaultSize ?? 1.0) * scale,
    );
  }
}

/// Élément de dessin OCAD
class MapFileMapElement {
  final int symbolNumber;
  final Offset position;
  final double rotation;
  final double scale;
  final List<Offset> points;
  final symbol_model.MapSymbolType type;

  MapFileMapElement({
    required this.symbolNumber,
    this.position = Offset.zero,
    this.rotation = 0.0,
    this.scale = 1.0,
    this.points = const [],
    this.type = symbol_model.MapSymbolType.point,
  });

  factory MapFileMapElement.fromBytes(Uint8List bytes, int offset) {
    // Parseur d'élément OCAD
    // À compléter
    return MapFileMapElement(symbolNumber: 0);
  }

  /// Convertit en symbole
  symbol_model.MapSymbol toMapSymbol({String? id}) {
    return symbol_model.MapSymbol(
      id: id ?? 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      name: "Élément OCAD $symbolNumber",
      strokeColor: const Color(0xFF000000),
      size: 1.0,
      rotation: rotation,
      points: points,
    );
  }
}

/// Calque OCAD
class MapFileMapLayer {
  final int number;
  final String name;
  final bool visible;
  final bool locked;
  final double opacity;
  final List<MapFileMapElement> elements;

  MapFileMapLayer({
    required this.number,
    this.name = '',
    this.visible = true,
    this.locked = false,
    this.opacity = 1.0,
    this.elements = const [],
  });

  factory MapFileMapLayer.fromBytes(Uint8List bytes, int offset) {
    // Parseur de calque OCAD
    // À compléter
    return MapFileMapLayer(number: 0);
  }

  /// Convertit en Layer OWildZimut
  Layer toOWildZimutLayer() {
    final symbols = elements.map((element) => element.toMapSymbol()).toList();
    
    return Layer(
      id: 'layer_${number}_${DateTime.now().millisecondsSinceEpoch}',
      name: name.isNotEmpty ? name : 'Calque $number',
      type: LayerType.vector,
      visible: visible,
      opacity: opacity,
      zIndex: number,
      locked: locked,
      symbols: symbols,
    );
  }
}

/// Fichier OCAD complet
class MapFileData {
  final MapFileType fileType;
  final String filePath;
  final MapFileHeader header;
  final List<MapFileColor> colors;
  final List<MapFileMapSymbol> symbols;
  final List<MapFileMapLayer> layers;
  final List<MapFileMapElement> objects;
  final Uint8List? rawData;

  MapFileData({
    this.fileType = MapFileType.unknown,
    this.filePath = '',
    required this.header,
    this.colors = const [],
    this.symbols = const [],
    this.layers = const [],
    this.objects = const [],
    this.rawData,
  });

  factory MapFileData.fromBytes(Uint8List bytes) {
    // Détection du type de fichier
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    final fileType = signature == 'OCAD' 
        ? MapFileType.ocad 
        : signature == 'OOMAP' 
            ? MapFileType.oomap 
            : MapFileType.unknown;

    final header = MapFileHeader.fromBytes(bytes);

    // Pour l'instant, on retourne un fichier avec les données brutes
    // Le parsing complet sera implémenté ultérieurement
    return MapFileData(
      fileType: fileType,
      header: header,
      rawData: bytes,
    );
  }

  /// Convertit en MapState OWildZimut
  MapState toMapState() {
    // Convertir les calques OCAD en calques OWildZimut
    final oWildLayers = layers.map((layer) => layer.toOWildZimutLayer()).toList();
    
    return MapState(
      layers: oWildLayers,
      zoomLevel: 1.0,
      panOffset: Offset.zero,
      appVersion: '0.0.002',
    );
  }

  /// Exporte en JSON pour sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'fileType': fileType.name,
      'header': {
        'version': header.version.name,
        'mapName': header.mapName,
        'mapAuthor': header.mapAuthor,
        'scale': header.scale,
        'bounds': {
          'minX': header.minX,
          'maxX': header.maxX,
          'minY': header.minY,
          'maxY': header.maxY,
        },
      },
      'layers': layers.map((layer) => {
        'number': layer.number,
        'name': layer.name,
        'visible': layer.visible,
        'locked': layer.locked,
        'opacity': layer.opacity,
        'elements': layer.elements.length,
      }).toList(),
    };
  }
}

/// Gestionnaire de chargement de fichiers OCAD/OOMAP
class MapFileLoader {
  /// Charge un fichier OCAD/OOMAP à partir de son chemin
  static Future<MapFileData?> loadFromPath(String filePath) async {
    try {
      // Lecture du fichier
      // Note: Dans Flutter, l'accès au système de fichiers nécessite des permissions
      // et l'utilisation de packages comme path_provider ou file_picker
      // Pour l'instant, on simule le chargement
      
      // final file = File(filePath);
      // final bytes = await file.readAsBytes();
      // return MapFileData.fromBytes(bytes);
      
      return null; // À implémenter avec l'accès aux fichiers
    } catch (e) {
      debugPrint('Erreur de chargement du fichier OCAD: $e');
      return null;
    }
  }

  /// Charge un fichier OCAD/OOMAP à partir de bytes
  static MapFileData? loadFromBytes(Uint8List bytes) {
    try {
      return MapFileData.fromBytes(bytes);
    } catch (e) {
      debugPrint('Erreur de parsing du fichier OCAD: $e');
      return null;
    }
  }

  /// Détecte le type de fichier
  static MapFileType detectFileType(Uint8List bytes) {
    if (bytes.length < 4) return MapFileType.unknown;
    
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    if (signature == 'OCAD') return MapFileType.ocad;
    if (signature == 'OOMAP') return MapFileType.oomap;
    
    return MapFileType.unknown;
  }

  /// Valide que les bytes correspondent à un fichier OCAD/OOMAP
  static bool isValidMapFile(Uint8List bytes) {
    if (bytes.length < 4) return false;
    
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    return signature == 'OCAD' || signature == 'OOMAP';
  }
}

/// Exceptions personnalisées
class MapFileParseException implements Exception {
  final String message;
  
  MapFileParseException(this.message);
  
  @override
  String toString() => 'MapFileParseException: $message';
}

class UnsupportedMapFileVersionException implements Exception {
  final MapFileVersion version;
  
  UnsupportedMapFileVersionException(this.version);
  
  @override
  String toString() => 'UnsupportedMapFileVersionException: Version ${version.name} non supportée';
}

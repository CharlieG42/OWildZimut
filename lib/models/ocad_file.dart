import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'layer.dart';
import 'symbol.dart' as symbol_model;
import 'iof_symbols.dart';
import 'map_state.dart';

/// Type de fichier OCAD/OOMAP
enum OCADFileType {
  ocad,
  oomap,
  unknown,
}

/// Version du format OCAD
enum OCADVersion {
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
enum Unit {
  meters,
  millimeters,
  unknown,
}

/// En-tête du fichier OCAD
class OCADHeader {
  final OCADVersion version;
  final CoordinateSystem coordinateSystem;
  final Unit unit;
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

  const OCADHeader({
    this.version = OCADVersion.unknown,
    this.coordinateSystem = CoordinateSystem.unknown,
    this.unit = Unit.unknown,
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

  factory OCADHeader.fromBytes(Uint8List bytes) {
    // Parseur simplifié pour l'en-tête OCAD
    // À compléter avec une implémentation complète
    final header = const OCADHeader();
    
    // Lire la signature du fichier
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    if (signature == 'OCAD') {
      return header.copyWith(version: OCADVersion.v8); // Version par défaut
    } else if (signature == 'OOMAP') {
      // Format OOMAP
      return header;
    }

    return header;
  }

  OCADHeader copyWith({
    OCADVersion? version,
    CoordinateSystem? coordinateSystem,
    Unit? unit,
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
    return OCADHeader(
      version: version ?? this.version,
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
class OCADColor {
  final int number;
  final String name;
  final Color color;
  final bool spotColor;
  final double separation;
  final double angle;
  final double frequency;

  OCADColor({
    required this.number,
    this.name = '',
    this.color = Colors.black,
    this.spotColor = false,
    this.separation = 0.0,
    this.angle = 0.0,
    this.frequency = 0.0,
  });

  factory OCADColor.fromBytes(Uint8List bytes, int offset) {
    // Parseur de couleur OCAD
    // À compléter
    return OCADColor(number: 0);
  }
}

/// Symbole OCAD
class OCADSymbol {
  final int number;
  final String name;
  final String description;
  final int colorNumber;
  final symbol_model.MapSymbolType type;
  final List<Uint8List> elements;

  OCADSymbol({
    required this.number,
    this.name = '',
    this.description = '',
    this.colorNumber = 0,
    this.type = symbol_model.MapSymbolType.point,
    this.elements = const [],
  });

  factory OCADSymbol.fromBytes(Uint8List bytes, int offset) {
    // Parseur de symbole OCAD
    // À compléter
    return OCADSymbol(number: 0);
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
      code: iofSymbol?.code ?? number.toString(),
      position: position ?? Offset.zero,
      description: iofSymbol?.description ?? description,
      color: iofSymbol?.defaultColor ?? Colors.black,
      size: (iofSymbol?.defaultSize ?? 1.0) * scale,
    );
  }
}

/// Élément de dessin OCAD
class OCADElement {
  final int symbolNumber;
  final Offset position;
  final double rotation;
  final double scale;
  final List<Offset> points;
  final symbol_model.MapSymbolType type;

  OCADElement({
    required this.symbolNumber,
    this.position = Offset.zero,
    this.rotation = 0.0,
    this.scale = 1.0,
    this.points = const [],
    this.type = symbol_model.MapSymbolType.point,
  });

  factory OCADElement.fromBytes(Uint8List bytes, int offset) {
    // Parseur d'élément OCAD
    // À compléter
    return OCADElement(symbolNumber: 0);
  }

  /// Convertit en symbole
  symbol_model.MapSymbol toSymbol({String? id}) {
    return symbol_model.MapSymbol(
      id: id ?? 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      code: symbolNumber.toString(),
      position: position,
      description: 'Élément OCAD $symbolNumber',
      color: Colors.black,
      size: 1.0,
      rotation: rotation,
      points: points,
    );
  }
}

/// Calque OCAD
class OCADLayer {
  final int number;
  final String name;
  final bool visible;
  final bool locked;
  final double opacity;
  final List<OCADElement> elements;

  OCADLayer({
    required this.number,
    this.name = '',
    this.visible = true,
    this.locked = false,
    this.opacity = 1.0,
    this.elements = const [],
  });

  factory OCADLayer.fromBytes(Uint8List bytes, int offset) {
    // Parseur de calque OCAD
    // À compléter
    return OCADLayer(number: 0);
  }

  /// Convertit en Layer OWildZimut
  Layer toOWildZimutLayer() {
    final symbols = elements.map((element) => element.toSymbol()).toList();
    
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
class OCADFile {
  final OCADFileType fileType;
  final OCADHeader header;
  final List<OCADColor> colors;
  final List<OCADSymbol> symbols;
  final List<OCADLayer> layers;
  final Uint8List? rawData;

  OCADFile({
    this.fileType = OCADFileType.unknown,
    this.header = const OCADHeader(),
    this.colors = const [],
    this.symbols = const [],
    this.layers = const [],
    this.rawData,
  });

  factory OCADFile.fromBytes(Uint8List bytes) {
    // Détection du type de fichier
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    final fileType = signature == 'OCAD' 
        ? OCADFileType.ocad 
        : signature == 'OOMAP' 
            ? OCADFileType.oomap 
            : OCADFileType.unknown;

    final header = OCADHeader.fromBytes(bytes);

    // Pour l'instant, on retourne un fichier avec les données brutes
    // Le parsing complet sera implémenté ultérieurement
    return OCADFile(
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
class OCADFileLoader {
  /// Charge un fichier OCAD/OOMAP à partir de son chemin
  static Future<OCADFile?> loadFromPath(String filePath) async {
    try {
      // Lecture du fichier
      // Note: Dans Flutter, l'accès au système de fichiers nécessite des permissions
      // et l'utilisation de packages comme path_provider ou file_picker
      // Pour l'instant, on simule le chargement
      
      // final file = File(filePath);
      // final bytes = await file.readAsBytes();
      // return OCADFile.fromBytes(bytes);
      
      return null; // À implémenter avec l'accès aux fichiers
    } catch (e) {
      debugPrint('Erreur de chargement du fichier OCAD: $e');
      return null;
    }
  }

  /// Charge un fichier OCAD/OOMAP à partir de bytes
  static OCADFile? loadFromBytes(Uint8List bytes) {
    try {
      return OCADFile.fromBytes(bytes);
    } catch (e) {
      debugPrint('Erreur de parsing du fichier OCAD: $e');
      return null;
    }
  }

  /// Détecte le type de fichier
  static OCADFileType detectFileType(Uint8List bytes) {
    if (bytes.length < 4) return OCADFileType.unknown;
    
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    if (signature == 'OCAD') return OCADFileType.ocad;
    if (signature == 'OOMAP') return OCADFileType.oomap;
    
    return OCADFileType.unknown;
  }

  /// Valide que les bytes correspondent à un fichier OCAD/OOMAP
  static bool isValidOCADFile(Uint8List bytes) {
    if (bytes.length < 4) return false;
    
    final signature = String.fromCharCodes(bytes.sublist(0, 4));
    return signature == 'OCAD' || signature == 'OOMAP';
  }
}

/// Exceptions personnalisées
class OCADParseException implements Exception {
  final String message;
  
  OCADParseException(this.message);
  
  @override
  String toString() => 'OCADParseException: $message';
}

class UnsupportedOCADVersionException implements Exception {
  final OCADVersion version;
  
  UnsupportedOCADVersionException(this.version);
  
  @override
  String toString() => 'UnsupportedOCADVersionException: Version ${version.name} non supportée';
}

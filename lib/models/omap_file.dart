import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'layer.dart';
import 'symbol.dart' as symbol_model;
import 'iof_symbols.dart';
import 'map_state.dart';

/// Petit utilitaire local pour eviter une dependance supplementaire
/// (equivalent de `firstOrNull` de `package:collection`).
extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

/// OWildZimut ne prend en charge que le format ouvert OMAP (OpenOrienteering
/// Mapper), un format base sur XML. Le format proprietaire OCAD n'est pas
/// et ne sera pas supporte.
///
/// IMPORTANT — portee de ce parseur :
/// Le format OMAP complet est riche (definitions graphiques de symboles,
/// courbes de Bezier, trous dans les surfaces, calques de gabarits/images
/// georeferencees, etc.). Ce parseur lit la geometrie des objets et les
/// associe, quand c'est possible, aux symboles IOF connus d'OWildZimut via
/// leur code. C'est une base fonctionnelle suffisante pour importer la
/// structure d'une carte (calques, positions, tracés) ; le rendu graphique
/// fidele aux definitions de symboles OMAP reste un travail futur.

/// Definition d'une couleur declaree dans le fichier OMAP (modele CMJN).
class OmapColorDefinition {
  final String name;
  final double cyan;
  final double magenta;
  final double yellow;
  final double black;
  final double opacity;

  const OmapColorDefinition({
    required this.name,
    this.cyan = 0,
    this.magenta = 0,
    this.yellow = 0,
    this.black = 0,
    this.opacity = 1.0,
  });

  /// Conversion approximative CMJN (0-1) -> RVB, pour affichage seulement.
  Color toColor() {
    final r = (255 * (1 - cyan) * (1 - black)).round().clamp(0, 255);
    final g = (255 * (1 - magenta) * (1 - black)).round().clamp(0, 255);
    final b = (255 * (1 - yellow) * (1 - black)).round().clamp(0, 255);
    return Color.fromARGB(
      (opacity * 255).round().clamp(0, 255),
      r,
      g,
      b,
    );
  }
}

/// Definition d'un symbole declare dans le fichier OMAP.
class OmapSymbolDefinition {
  final String id;
  final String? code;
  final String name;
  final symbol_model.MapSymbolType type;
  final String? iconBase64; // Icône encodée en base64 si disponible

  const OmapSymbolDefinition({
    required this.id,
    this.code,
    this.name = '',
    this.type = symbol_model.MapSymbolType.point,
    this.iconBase64,
  });
}

/// Type d'objet OMAP (1=point, 2=ligne, 4=surface, 8=texte)
enum OmapObjectType {
  point,
  line,
  area,
  text,
}

/// Un objet geometrique place sur la carte (avant conversion en [symbol_model.MapSymbol]).
class OmapObject {
  final String? symbolId;
  final OmapObjectType type;
  final List<Offset> points;
  final double rotation; // Rotation en radians
  final bool isClosed; // Vrai si c'est un polygone ferme

  const OmapObject({
    this.symbolId,
    this.type = OmapObjectType.point,
    this.points = const [],
    this.rotation = 0,
    this.isClosed = false,
  });

  /// Crée un OmapObject à partir d'une liste de points et d'un type
  factory OmapObject.fromPoints({
    String? symbolId,
    required OmapObjectType type,
    required List<Offset> points,
    double rotation = 0,
    bool isClosed = false,
  }) {
    return OmapObject(
      symbolId: symbolId,
      type: type,
      points: points,
      rotation: rotation,
      isClosed: isClosed || (points.length > 1 && points.first == points.last),
    );
  }
}

/// Informations de géoréférencement extraites du fichier OMAP
class OmapGeoreferencing {
  final int scaleDenominator; // Échelle (ex: 10000 pour 1:10000)
  final String? crsId; // Système de coordonnées (ex: "UTM")
  final String? proj4Spec; // Spécification PROJ.4
  final Offset? refPoint; // Point de référence en coordonnées carte
  final Offset? refPointReal; // Point de référence en coordonnées réelles

  const OmapGeoreferencing({
    this.scaleDenominator = 10000,
    this.crsId,
    this.proj4Spec,
    this.refPoint,
    this.refPointReal,
  });
}

/// Un calque tel que decrit dans le fichier OMAP (correspond a une
/// "part"/"layer" OpenOrienteering Mapper).
class OmapLayerData {
  final String name;
  final List<OmapObject> objects;
  final bool visible;
  final double opacity;

  const OmapLayerData({
    required this.name,
    this.objects = const [],
    this.visible = true,
    this.opacity = 1.0,
  });
}

/// Document OMAP complet, apres analyse du XML.
class OmapDocument {
  final String formatVersion;
  final int scaleDenominator;
  final List<OmapColorDefinition> colors;
  final Map<String, OmapSymbolDefinition> symbolsById;
  final List<OmapLayerData> layers;
  final OmapGeoreferencing? georeferencing;

  const OmapDocument({
    this.formatVersion = '',
    this.scaleDenominator = 10000,
    this.colors = const [],
    this.symbolsById = const {},
    this.layers = const [],
    this.georeferencing,
  });

  /// Nombre total d'objets geometriques lus, toutes couches confondues.
  int get objectCount =>
      layers.fold(0, (sum, layer) => sum + layer.objects.length);

  /// Analyse le contenu XML d'un fichier .omap
  factory OmapDocument.parse(String xmlContent) {
    final document = XmlDocument.parse(xmlContent);
    final mapElement = document.rootElement;

    if (mapElement.name.local != 'map') {
      throw const OmapParseException(
        'Le fichier ne semble pas etre un fichier OMAP valide (element racine <map> introuvable).',
      );
    }

    final formatVersion = mapElement.getAttribute('version') ?? '';

    // Parsing du géoréférencement
    final georeferencing = _parseGeoreferencing(mapElement);
    final scaleDenominator = georeferencing.scaleDenominator;

    final colors = _parseColors(mapElement);
    final symbolsById = _parseSymbols(mapElement);
    final layers = _parseLayers(mapElement);

    return OmapDocument(
      formatVersion: formatVersion,
      scaleDenominator: scaleDenominator,
      colors: colors,
      symbolsById: symbolsById,
      layers: layers,
      georeferencing: georeferencing,
    );
  }

  static OmapGeoreferencing _parseGeoreferencing(XmlElement mapElement) {
    final georefElement = mapElement.findAllElements('georeferencing').firstOrNull;
    
    if (georefElement == null) {
      return OmapGeoreferencing();
    }

    final scaleDenominator = 
        int.tryParse(georefElement.getAttribute('scale') ?? '10000') ?? 10000;
    final crsId = georefElement.getAttribute('id');
    
    // Chercher le spécification PROJ.4
    String? proj4Spec;
    Offset? refPoint;
    Offset? refPointReal;
    
    final projectedCrs = georefElement.findAllElements('projected_crs').firstOrNull;
    if (projectedCrs != null) {
      final specElement = projectedCrs.findAllElements('spec').firstOrNull;
      proj4Spec = specElement?.innerText.trim();
      
      final refPointElement = projectedCrs.findAllElements('ref_point').firstOrNull;
      if (refPointElement != null) {
        final x = double.tryParse(refPointElement.getAttribute('x') ?? '0') ?? 0;
        final y = double.tryParse(refPointElement.getAttribute('y') ?? '0') ?? 0;
        refPointReal = Offset(x, y);
      }
    }
    
    final geographicCrs = georefElement.findAllElements('geographic_crs').firstOrNull;
    if (geographicCrs != null && refPointReal == null) {
      final refPointDeg = geographicCrs.findAllElements('ref_point_deg').firstOrNull;
      if (refPointDeg != null) {
        // Convertir lat/lon en Offset (simplifié)
        final lat = double.tryParse(refPointDeg.getAttribute('lat') ?? '0') ?? 0;
        final lon = double.tryParse(refPointDeg.getAttribute('lon') ?? '0') ?? 0;
        refPointReal = Offset(lon, lat);
      }
    }
    
    // Point de référence dans la carte
    final refPointElement = georefElement.findAllElements('ref_point').firstOrNull;
    if (refPointElement != null && refPoint == null) {
      final x = double.tryParse(refPointElement.getAttribute('x') ?? '0') ?? 0;
      final y = double.tryParse(refPointElement.getAttribute('y') ?? '0') ?? 0;
      refPoint = Offset(x, y);
    }

    return OmapGeoreferencing(
      scaleDenominator: scaleDenominator,
      crsId: crsId,
      proj4Spec: proj4Spec,
      refPoint: refPoint,
      refPointReal: refPointReal,
    );
  }

  static List<OmapColorDefinition> _parseColors(XmlElement mapElement) {
    final colorsElement = mapElement.findAllElements('colors').firstOrNull;
    if (colorsElement == null) return const [];

    return colorsElement.findElements('color').map((c) {
      return OmapColorDefinition(
        name: c.getAttribute('name') ?? '',
        cyan: _percent(c.getAttribute('c')),
        magenta: _percent(c.getAttribute('m')),
        yellow: _percent(c.getAttribute('y')),
        black: _percent(c.getAttribute('k')),
        opacity: double.tryParse(c.getAttribute('opacity') ?? '1') ?? 1.0,
      );
    }).toList();
  }

  static double _percent(String? raw) {
    final value = double.tryParse(raw ?? '0') ?? 0.0;
    // Les fichiers OMAP expriment generalement ces composantes entre 0 et 1,
    // mais on tolere aussi une echelle 0-100.
    return value > 1.0 ? value / 100.0 : value;
  }

  static Map<String, OmapSymbolDefinition> _parseSymbols(XmlElement mapElement) {
    // <symbols> peut se trouver directement sous <map>, ou imbrique dans un
    // element <barrier> (format version 9 et suivants) : recherche recursive.
    final symbolsElements = mapElement.findAllElements('symbols');
    
    final result = <String, OmapSymbolDefinition>{};
    
    for (final symbolsElement in symbolsElements) {
      // Seuls les <symbol> enfants directs de <symbols> definissent des
      // symboles de la palette de la carte (les <symbol> plus profonds sont
      // des sous-elements graphiques internes, ex. motifs de hachures).
      for (final s in symbolsElement.childElements.where((e) => e.name.local == 'symbol')) {
        final id = s.getAttribute('id');
        if (id == null) continue;

        // Extraire l'icône si disponible
        String? iconBase64;
        final iconElement = s.findAllElements('icon').firstOrNull;
        if (iconElement != null) {
          final src = iconElement.getAttribute('src');
          if (src != null && src.startsWith('data:image/png;base64,')) {
            iconBase64 = src.substring('data:image/png;base64,'.length);
          }
        }

        result[id] = OmapSymbolDefinition(
          id: id,
          code: s.getAttribute('code'),
          name: s.getAttribute('name') ?? '',
          type: _mapSymbolTypeFromCode(s.getAttribute('type')),
          iconBase64: iconBase64,
        );
      }
    }
    return result;
  }

  /// Les codes de type utilises par OpenOrienteering Mapper : 1=point,
  /// 2=ligne, 4=surface, 8=texte, 16=symbole combine (on retombe alors sur
  /// "surface", une approximation raisonnable pour l'affichage). On retombe
  /// sur "point" si le code est inconnu.
  static symbol_model.MapSymbolType _mapSymbolTypeFromCode(String? raw) {
    switch (int.tryParse(raw ?? '')) {
      case 2:
        return symbol_model.MapSymbolType.line;
      case 4:
        return symbol_model.MapSymbolType.area;
      case 8:
        return symbol_model.MapSymbolType.text;
      case 16:
        return symbol_model.MapSymbolType.area;
      default:
        return symbol_model.MapSymbolType.point;
    }
  }

  static List<OmapLayerData> _parseLayers(XmlElement mapElement) {
    // Rechercher <parts> ou <part> directement
    final partsElements = mapElement.findAllElements('parts');
    final partElements = mapElement.findAllElements('part');
    
    final result = <OmapLayerData>[];
    
    // Cas 1: <parts> avec des <part> enfants
    for (final partsElement in partsElements) {
      for (final part in partsElement.findElements('part')) {
        _processPartElement(part, result);
      }
    }
    
    // Cas 2: <part> directement sous <map>
    for (final part in partElements) {
      // Vérifier que ce n'est pas déjà traité (enfant de <parts>)
      if (part.parent?.name.local != 'parts') {
        _processPartElement(part, result);
      }
    }
    
    return result;
  }

  static void _processPartElement(XmlElement part, List<OmapLayerData> result) {
    final name = part.getAttribute('name') ?? 'Calque sans nom';
    final visible = part.getAttribute('visible')?.toLowerCase() != 'false';
    final opacity = double.tryParse(part.getAttribute('opacity') ?? '1.0') ?? 1.0;
    
    // Rechercher tous les <objects> sous ce part (à n'importe quel niveau)
    final objectsElements = part.findAllElements('objects');
    final objects = <OmapObject>[];
    
    for (final objectsEl in objectsElements) {
      for (final objectEl in objectsEl.findElements('object')) {
        final object = _parseObject(objectEl);
        if (object.points.isNotEmpty) {
          objects.add(object);
        }
      }
    }
    
    if (objects.isNotEmpty) {
      result.add(OmapLayerData(
        name: name,
        objects: objects,
        visible: visible,
        opacity: opacity,
      ));
    }
  }

  static OmapObject _parseObject(XmlElement objectEl) {
    final symbolId = objectEl.getAttribute('symbol');
    final typeAttr = objectEl.getAttribute('type') ?? '1';
    final type = _parseOmapObjectType(typeAttr);
    
    // Parser les coordonnées
    final coordsEl = objectEl.findAllElements('coords').firstOrNull;
    final points = _parseCoords(coordsEl);
    
    // Parser la rotation
    final patternEl = objectEl.findAllElements('pattern').firstOrNull;
    final rotation = double.tryParse(patternEl?.getAttribute('rotation') ?? '0') ?? 0;
    
    // Détecter si c'est un polygone fermé
    // En OMAP, les polygones ont souvent le dernier point = premier point
    // ou un flag spécial dans les coords
    final isClosed = points.length > 1 && points.first == points.last;
    
    return OmapObject(
      symbolId: symbolId,
      type: type,
      points: points,
      rotation: rotation,
      isClosed: isClosed,
    );
  }

  static OmapObjectType _parseOmapObjectType(String typeAttr) {
    switch (int.tryParse(typeAttr)) {
      case 1:
        return OmapObjectType.point;
      case 2:
        return OmapObjectType.line;
      case 4:
        return OmapObjectType.area;
      case 8:
        return OmapObjectType.text;
      default:
        return OmapObjectType.point;
    }
  }

  static List<Offset> _parseCoords(XmlElement? coordsEl) {
    if (coordsEl == null) return [];

    final coordsText = coordsEl.innerText.trim();
    // Format: "x1 y1;x2 y2;x3 y3" ou "x1 y1 flags;x2 y2 flags"
    // Les coordonnées sont en 0.001 mm (1 unité = 0.001 mm)
    final coords = coordsText.split(';').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    
    final points = <Offset>[];
    for (final coord in coords) {
      // Séparer par espace/tabulation
      final parts = coord.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
      
      if (parts.length >= 2) {
        // Les deux premiers éléments sont x et y
        // Le troisième (si présent) est un flag (1 = point de contrôle, etc.)
        final x = double.tryParse(parts[0]) ?? 0.0;
        final y = double.tryParse(parts[1]) ?? 0.0;
        
        // Convertir de 0.001 mm à mm (pour compatibilité avec Flutter)
        // 1 unité OMAP = 0.001 mm, donc on divise par 1000 pour obtenir des mm
        // Puis on convertit en pixels (1 mm ≈ 3.78 pixels à 96 DPI)
        // Mais pour simplifier, on garde en mm et on laisse le rendu gérer l'échelle
        points.add(Offset(x / 1000.0, y / 1000.0));
      }
    }
    
    return points;
  }

  /// Convertit le document analyse en calques OWildZimut prets a l'emploi.
  List<Layer> toLayers() {
    final result = <Layer>[];

    for (var i = 0; i < layers.length; i++) {
      final omapLayer = layers[i];
      final symbols = <symbol_model.MapSymbol>[];

      for (var j = 0; j < omapLayer.objects.length; j++) {
        final object = omapLayer.objects[j];
        final symbolDef = symbolsById[object.symbolId];
        
        // Trouver le symbole IOF correspondant
        final iofMatch = symbolDef?.code != null
            ? iofSymbolLibrary.getSymbolByCode(symbolDef!.code!)
            : null;

        // Déterminer le type (depuis la définition ou la géométrie)
        final type = symbolDef?.type ?? _guessTypeFromGeometry(object);

        // Trouver la couleur associée au symbole
        Color symbolColor = const Color(0xFF000000);
        if (symbolDef != null && symbolDef.code != null) {
          final iofSymbol = iofSymbolLibrary.getSymbolByCode(symbolDef.code!);
          if (iofSymbol != null) {
            symbolColor = iofSymbol.defaultColor;
          }
        }
        
        // Créer le symbole OWildZimut
        final symbol = symbol_model.MapSymbol(
          id: 'omap_${DateTime.now().millisecondsSinceEpoch}_${i}_$j',
          name: symbolDef?.name ?? iofMatch?.name ?? 'Objet importe',
          type: type,
          position: object.points.isNotEmpty ? object.points.first : Offset.zero,
          points: object.points,
          size: iofMatch?.defaultSize ?? _getDefaultSize(type),
          strokeColor: symbolColor,
          isClosed: object.isClosed,
          rotation: object.rotation,
          layerId: 'omap_layer_${DateTime.now().millisecondsSinceEpoch}_$i',
        );
        
        symbols.add(symbol);
      }

      result.add(Layer(
        id: 'omap_layer_${DateTime.now().millisecondsSinceEpoch}_$i',
        name: omapLayer.name.isNotEmpty ? omapLayer.name : 'Calque importe ${i + 1}',
        type: LayerType.vector,
        zIndex: i + 1,
        visible: omapLayer.visible,
        opacity: omapLayer.opacity,
        symbols: symbols,
      ));
    }

    return result;
  }

  /// Détermine un type de symbole plausible a partir du nombre de points,
  /// quand le fichier ne fournit pas de definition de symbole exploitable.
  static symbol_model.MapSymbolType _guessTypeFromGeometry(OmapObject object) {
    if (object.points.length <= 1) return symbol_model.MapSymbolType.point;
    if (object.isClosed || (object.points.length >= 3 && object.points.first == object.points.last)) {
      return symbol_model.MapSymbolType.area;
    }
    return symbol_model.MapSymbolType.line;
  }

  /// Taille par défaut selon le type
  static double _getDefaultSize(symbol_model.MapSymbolType type) {
    switch (type) {
      case symbol_model.MapSymbolType.point:
        return 5.0;
      case symbol_model.MapSymbolType.line:
        return 2.0;
      case symbol_model.MapSymbolType.area:
        return 1.0;
      case symbol_model.MapSymbolType.text:
        return 12.0;
    }
  }
}

/// Exception levee lorsque le contenu d'un fichier .omap ne peut pas etre
/// interprete.
class OmapParseException implements Exception {
  final String message;
  const OmapParseException(this.message);

  @override
  String toString() => 'OmapParseException: $message';
}

/// Point d'entree utilise par l'interface pour charger un fichier .omap.
class OmapFileLoader {
  /// Analyse le contenu texte d'un fichier .omap et retourne le document
  /// correspondant, ou lance [OmapParseException] si le contenu est invalide.
  static OmapDocument parse(String xmlContent) {
    try {
      return OmapDocument.parse(xmlContent);
    } on OmapParseException {
      rethrow;
    } catch (e) {
      throw OmapParseException('Fichier OMAP illisible : $e');
    }
  }

  /// Construit un nouvel etat de carte a partir d'un document OMAP analyse,
  /// en ajoutant ses calques a la suite de ceux deja presents dans [base].
  static MapState mergeIntoState(MapState base, OmapDocument document) {
    var newState = base;
    final newLayers = document.toLayers();
    
    if (newLayers.isNotEmpty) {
      // Ajouter les nouveaux calques
      final allLayers = [...newState.layers, ...newLayers];
      newState = newState.copyWith(
        layers: allLayers,
        selectedLayerIndex: allLayers.length - 1,
      );
    }
    
    return newState;
  }
}

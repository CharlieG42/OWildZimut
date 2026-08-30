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
    final r = 255 * (1 - cyan) * (1 - black);
    final g = 255 * (1 - magenta) * (1 - black);
    final b = 255 * (1 - yellow) * (1 - black);
    return Color.fromARGB(
      (opacity * 255).round().clamp(0, 255),
      r.round().clamp(0, 255),
      g.round().clamp(0, 255),
      b.round().clamp(0, 255),
    );
  }
}

/// Definition d'un symbole declare dans le fichier OMAP.
class OmapSymbolDefinition {
  final String id;
  final String? code;
  final String name;
  final symbol_model.MapSymbolType type;

  const OmapSymbolDefinition({
    required this.id,
    this.code,
    this.name = '',
    this.type = symbol_model.MapSymbolType.point,
  });
}

/// Un objet geometrique place sur la carte (avant conversion en [symbol_model.MapSymbol]).
class OmapObject {
  final String? symbolId;
  final List<Offset> points;

  const OmapObject({this.symbolId, this.points = const []});
}

/// Un calque tel que decrit dans le fichier OMAP (correspond a une
/// "part"/"layer" OpenOrienteering Mapper).
class OmapLayerData {
  final String name;
  final List<OmapObject> objects;

  const OmapLayerData({required this.name, this.objects = const []});
}

/// Document OMAP complet, apres analyse du XML.
class OmapDocument {
  final String formatVersion;
  final int scaleDenominator;
  final List<OmapColorDefinition> colors;
  final Map<String, OmapSymbolDefinition> symbolsById;
  final List<OmapLayerData> layers;

  const OmapDocument({
    this.formatVersion = '',
    this.scaleDenominator = 10000,
    this.colors = const [],
    this.symbolsById = const {},
    this.layers = const [],
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

    // NB : a partir du format version 9 (Mapper 0.9+), certains blocs (les
    // symboles, les parties de la carte, ...) peuvent etre enveloppes dans
    // un element <barrier>, utilise comme marqueur de compatibilite de
    // version. On recherche donc ces elements n'importe ou sous <map>
    // (recherche recursive), et pas seulement parmi ses enfants directs.
    final georeferencing = mapElement.findAllElements('georeferencing').firstOrNull;
    final scaleDenominator =
        int.tryParse(georeferencing?.getAttribute('scale') ?? '') ?? 10000;

    final colors = _parseColors(mapElement);
    final symbolsById = _parseSymbols(mapElement);
    final layers = _parseLayers(mapElement);

    return OmapDocument(
      formatVersion: formatVersion,
      scaleDenominator: scaleDenominator,
      colors: colors,
      symbolsById: symbolsById,
      layers: layers,
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
    final symbolsElement = mapElement.findAllElements('symbols').firstOrNull;
    if (symbolsElement == null) return const {};

    final result = <String, OmapSymbolDefinition>{};
    // Seuls les <symbol> enfants directs de <symbols> definissent des
    // symboles de la palette de la carte (les <symbol> plus profonds sont
    // des sous-elements graphiques internes, ex. motifs de hachures).
    for (final s in symbolsElement.childElements.where((e) => e.name.local == 'symbol')) {
      final id = s.getAttribute('id');
      if (id == null) continue;

      result[id] = OmapSymbolDefinition(
        id: id,
        code: s.getAttribute('code'),
        name: s.getAttribute('name') ?? '',
        type: _mapSymbolTypeFromCode(s.getAttribute('type')),
      );
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
    // <parts> peut lui aussi etre imbrique dans un element <barrier> :
    // recherche recursive plutot que limitee aux enfants directs de <map>.
    final partsElement = mapElement.findAllElements('parts').firstOrNull;
    if (partsElement == null) return const [];

    final result = <OmapLayerData>[];
    var partIndex = 0;
    for (final part in partsElement.findElements('part')) {
      partIndex++;
      final partName = part.getAttribute('name') ?? 'Partie $partIndex';

      // On recherche les elements <objects> n'importe ou sous <part>, quelle
      // que soit la profondeur d'imbrication (<layer>, <barrier>, ...) :
      // les versions du format ne placent pas toujours <objects> au meme
      // niveau.
      var layerIndex = 0;
      for (final objectsEl in part.findAllElements('objects')) {
        layerIndex++;

        final objects = objectsEl
            .findElements('object')
            .map(_parseObject)
            .where((o) => o.points.isNotEmpty)
            .toList();

        if (objects.isEmpty) continue;

        // Le nom du calque prend, si possible, le nom du <layer> ancetre le
        // plus proche (attribut "name" ou, a defaut, "type").
        final ancestorLayer = _nearestAncestorNamed(objectsEl, 'layer');
        final layerLabel = ancestorLayer?.getAttribute('name') ??
            (ancestorLayer != null ? 'Calque type ${ancestorLayer.getAttribute('type') ?? ''}' : null);

        final name = layerLabel != null && layerLabel.trim().isNotEmpty
            ? '$partName — $layerLabel'
            : (layerIndex > 1 ? '$partName ($layerIndex)' : partName);

        result.add(OmapLayerData(name: name, objects: objects));
      }
    }
    return result;
  }

  /// Remonte l'arborescence XML a partir de [node] pour trouver le premier
  /// ancetre dont le nom local est [name], ou `null` si aucun n'est trouve.
  static XmlElement? _nearestAncestorNamed(XmlElement node, String name) {
    XmlNode? current = node.parent;
    while (current != null) {
      if (current is XmlElement && current.name.local == name) {
        return current;
      }
      current = current.parent;
    }
    return null;
  }

  static OmapObject _parseObject(XmlElement objectEl) {
    final symbolId = objectEl.getAttribute('symbol');
    final coordsEl = objectEl.findElements('coords').firstOrNull;

    final points = <Offset>[];
    if (coordsEl != null) {
      final raw = coordsEl.innerText.trim();
      // Format: "x1 y1 flags;x2 y2 flags;..." (coordonnees en 1/1000 mm)
      for (final chunk in raw.split(';')) {
        final parts = chunk.trim().split(RegExp(r'\s+'));
        if (parts.length < 2) continue;
        final x = int.tryParse(parts[0]);
        final y = int.tryParse(parts[1]);
        if (x == null || y == null) continue;
        points.add(Offset(x / 1000.0, y / 1000.0));
      }
    }

    return OmapObject(symbolId: symbolId, points: points);
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
        final iofMatch = symbolDef?.code != null
            ? iofSymbolLibrary.getSymbolByCode(symbolDef!.code!)
            : null;

        final type = symbolDef?.type ??
            _guessTypeFromGeometry(object.points);

        symbols.add(symbol_model.MapSymbol(
          id: 'omap_${DateTime.now().millisecondsSinceEpoch}_${i}_$j',
          type: type,
          code: symbolDef?.code ?? symbolDef?.id ?? '',
          position: object.points.first,
          description: iofMatch?.description ??
              symbolDef?.name ??
              'Objet importe',
          color: iofMatch?.defaultColor ?? Colors.black,
          size: iofMatch?.defaultSize ?? 1.0,
          points: object.points,
        ));
      }

      result.add(Layer(
        id: 'omap_layer_${DateTime.now().millisecondsSinceEpoch}_$i',
        name: omapLayer.name.isNotEmpty ? omapLayer.name : 'Calque importe ${i + 1}',
        type: LayerType.vector,
        zIndex: i + 1,
        symbols: symbols,
      ));
    }

    return result;
  }

  /// Determine un type de symbole plausible a partir du nombre de points,
  /// quand le fichier ne fournit pas de definition de symbole exploitable.
  static symbol_model.MapSymbolType _guessTypeFromGeometry(List<Offset> points) {
    if (points.length <= 1) return symbol_model.MapSymbolType.point;
    if (points.length >= 3 && points.first == points.last) {
      return symbol_model.MapSymbolType.area;
    }
    return symbol_model.MapSymbolType.line;
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
    for (final layer in document.toLayers()) {
      newState = newState.copyWith(layers: [...newState.layers, layer]);
    }
    if (document.toLayers().isNotEmpty) {
      newState = newState.copyWith(selectedLayerIndex: newState.layers.length - 1);
    }
    return newState;
  }
}

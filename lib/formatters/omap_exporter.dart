import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import '../models/map_state.dart';
import '../models/layer.dart';
import '../models/symbol.dart' as symbol_model;
import '../models/georeferencing.dart';

/// Exporteur OMAP pour générer des fichiers au format OpenOrienteering Mapper XML v9
///
/// Ce formateur permet d'exporter les cartes créées dans OWildZimut vers le format
/// OMAP, compatible avec OpenOrienteering Mapper et d'autres logiciels de cartographie
/// d'orientation.
class OmapExporter {
  /// Exporte un MapState au format OMAP v9
  /// 
  /// [mapState] : L'état de la carte à exporter
  /// [includeMetadata] : Si vrai, inclut les métadonnées (version, nom, etc.)
  /// Retourne une chaîne XML valide
  static String export(MapState mapState, {bool includeMetadata = true}) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    
    builder.element('map', attributes: {
      'xmlns': 'http://openorienteering.org/apps/mapper/xml/v2',
      'version': '9',
    }, nest: () {
      // Métadonnées
      if (includeMetadata) {
        _exportMetadata(builder, mapState);
      }
       
      // Géoréférencement
      if (mapState.georeferencing != null) {
        _exportGeoreferencing(builder, mapState.georeferencing!);
      }
       
      // Palette de couleurs
      _exportColors(builder, mapState);
       
      // Définitions des symboles
      _exportSymbols(builder, mapState);
       
      // Calques (parts) et objets
      _exportLayers(builder, mapState);
    });
    
    return builder.buildDocument().toXmlString(pretty: true);
  }

  /// Exporte les métadonnées du document
  static void _exportMetadata(XmlBuilder builder, MapState mapState) {
    builder.element('notes', nest: () {
      builder.text('Exported from OWildZimut v${mapState.appVersion}');
    });
  }

  /// Exporte les informations de géoréférencement
  static void _exportGeoreferencing(XmlBuilder builder, Georeferencing georef) {
    builder.element('georeferencing', attributes: {
      'scale': georef.scaleDenominator.toString(),
      if (georef.gridScaleFactor != null) 
        'grid_scale_factor': georef.gridScaleFactor!.toStringAsFixed(6),
      if (georef.auxiliaryScaleFactor != null) 
        'auxiliary_scale_factor': georef.auxiliaryScaleFactor!.toStringAsFixed(6),
      if (georef.grivation != null) 
        'grivation': georef.grivation!.toStringAsFixed(2),
    }, nest: () {
      // Point de référence dans la carte
      if (georef.refPoint != null) {
        builder.element('ref_point', attributes: {
          'x': georef.refPoint!.dx.toStringAsFixed(3),
          'y': georef.refPoint!.dy.toStringAsFixed(3),
        });
      }
      
      // Système de coordonnées projetées (si disponible)
      if (georef.crsId != null || georef.proj4Spec != null) {
        builder.element('projected_crs', attributes: {
          if (georef.crsId != null) 'id': georef.crsId!,
        }, nest: () {
          if (georef.proj4Spec != null) {
            builder.element('spec', attributes: {
              'language': 'PROJ.4',
            }, nest: () {
              builder.text(georef.proj4Spec!);
            });
          }
          
          if (georef.crsParameter != null) {
            builder.element('parameter', nest: () {
              builder.text(georef.crsParameter!);
            });
          }
          
          if (georef.refPointReal != null) {
            builder.element('ref_point', attributes: {
              'x': georef.refPointReal!.dx.toStringAsFixed(6),
              'y': georef.refPointReal!.dy.toStringAsFixed(6),
            });
          }
        });
      }
      
      // Système de coordonnées géographiques (si disponible)
      if (georef.geographicCrsId != null || georef.refPointDeg != null) {
        builder.element('geographic_crs', attributes: {
          if (georef.geographicCrsId != null) 'id': georef.geographicCrsId!,
        }, nest: () {
          if (georef.geographicProj4Spec != null) {
            builder.element('spec', attributes: {
              'language': 'PROJ.4',
            }, nest: () {
              builder.text(georef.geographicProj4Spec!);
            });
          }
          
          if (georef.refPointDeg != null) {
            builder.element('ref_point_deg', attributes: {
              'lat': georef.refPointDeg!.latitude.toStringAsFixed(6),
              'lon': georef.refPointDeg!.longitude.toStringAsFixed(6),
            });
          }
        });
      }
    });
  }

  /// Exporte la palette de couleurs
  static void _exportColors(XmlBuilder builder, MapState mapState) {
    // Collecter toutes les couleurs uniques
    final colorSet = <Color>{};
    final colorToId = <Color, int>{};
    var colorIndex = 0;
    
    // Ajouter les couleurs par défaut
    colorSet.add(Colors.black);
    colorSet.add(Colors.white);
    colorSet.add(Colors.blue);
    colorSet.add(Colors.red);
    colorSet.add(Colors.green);
    colorSet.add(Colors.yellow);
    colorSet.add(Colors.brown);
    
    // Ajouter les couleurs des symboles
    for (final layer in mapState.layers) {
      for (final symbol in layer.symbols) {
        colorSet.add(symbol.color);
        if (symbol.strokeColor != null) {
          colorSet.add(symbol.strokeColor!);
        }
        if (symbol.fillColor != null) {
          colorSet.add(symbol.fillColor!);
        }
      }
    }
    
    // Créer une mapping couleur -> ID
    for (final color in colorSet) {
      colorToId[color] = colorIndex++;
    }
    
    builder.element('colors', attributes: {
      'count': colorSet.length.toString(),
    }, nest: () {
      var index = 0;
      for (final color in colorSet) {
        final cmjk = _colorToCmyk(color);
        final colorName = _getColorName(color, index);
        
        builder.element('color', attributes: {
          'priority': index.toString(),
          'name': colorName,
          'c': cmjk.cyan.toStringAsFixed(2),
          'm': cmjk.magenta.toStringAsFixed(2),
          'y': cmjk.yellow.toStringAsFixed(2),
          'k': cmjk.black.toStringAsFixed(2),
          'opacity': color.a.toStringAsFixed(2),
        }, nest: () {
          // Ajouter les spot colors (simplifié)
          builder.element('spotcolors', attributes: {
            'knockout': 'true',
          });
          
          // Ajouter la méthode RGB
          builder.element('rgb', attributes: {
            'method': 'cmyk',
            'r': color.r.toStringAsFixed(3),
            'g': color.g.toStringAsFixed(3),
            'b': color.b.toStringAsFixed(3),
          });
        });
        index++;
      }
    });
  }

  /// Convertit une couleur RVB en CMJN (0-1)
  static ({double cyan, double magenta, double yellow, double black}) _colorToCmyk(Color color) {
    final r = color.r;
    final g = color.g;
    final b = color.b;
    
    // Calcul du noir (K)
    final k = 1 - [r, g, b].reduce((a, b) => a > b ? a : b);
    
    // Éviter la division par zéro
    if (k.isNaN || k == 1.0) {
      return (cyan: 0, magenta: 0, yellow: 0, black: k);
    }
    
    final c = (1 - r - k) / (1 - k);
    final m = (1 - g - k) / (1 - k);
    final y = (1 - b - k) / (1 - k);
    
    return (
      cyan: c.clamp(0, 1),
      magenta: m.clamp(0, 1),
      yellow: y.clamp(0, 1),
      black: k.clamp(0, 1),
    );
  }

  /// Génère un nom pour une couleur
  static String _getColorName(Color color, int index) {
    // Noms de couleurs courants
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.red) return 'Red';
    if (color == Colors.green) return 'Green';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.brown) return 'Brown';
    if (color.toARGB32() == 0xFF0000FF) return 'Pure Blue';
    if (color.toARGB32() == 0xFFFF0000) return 'Pure Red';
    if (color.toARGB32() == 0xFF00FF00) return 'Pure Green';
    
    // Couleur personnalisée
    return 'Custom_$index';
  }

  /// Exporte les définitions des symboles
  static void _exportSymbols(XmlBuilder builder, MapState mapState) {
    // Collecter tous les symboles uniques
    final symbolSet = <symbol_model.MapSymbol>{};
    final symbolToId = <symbol_model.MapSymbol, String>{};
    
    for (final layer in mapState.layers) {
      for (final symbol in layer.symbols) {
        // Utiliser le code IOF comme ID si disponible
        final symbolId = symbol.iofCode ?? symbol.id;
        if (!symbolSet.contains(symbol)) {
          symbolSet.add(symbol);
          symbolToId[symbol] = symbolId;
        }
      }
    }
    
    builder.element('symbols', attributes: {
      'count': symbolSet.length.toString(),
      'id': 'OWildZimut',
    }, nest: () {
      for (final symbol in symbolSet) {
        _exportSymbol(builder, symbol, symbolToId[symbol]!);
      }
    });
  }

  /// Exporte un symbole individuel
  static void _exportSymbol(XmlBuilder builder, symbol_model.MapSymbol symbol, String symbolId) {
    final type = _mapSymbolTypeToOmapType(symbol.type);
    
    builder.element('symbol', attributes: {
      'type': type.toString(),
      'id': symbolId,
      if (symbol.iofCode != null) 'code': symbol.iofCode!,
      'name': symbol.name.isNotEmpty ? symbol.name : 'Unnamed Symbol',
    }, nest: () {
      switch (symbol.type) {
        case symbol_model.MapSymbolType.point:
          _exportPointSymbol(builder, symbol);
          break;
        case symbol_model.MapSymbolType.line:
          _exportLineSymbol(builder, symbol);
          break;
        case symbol_model.MapSymbolType.area:
          _exportAreaSymbol(builder, symbol);
          break;
        case symbol_model.MapSymbolType.text:
          _exportTextSymbol(builder, symbol);
          break;
      }
      
      // Ajouter l'icône si disponible
      if (symbol.iconBase64 != null) {
        builder.element('icon', attributes: {
          'src': 'data:image/png;base64,${symbol.iconBase64!}',
        });
      }
    });
  }

  /// Convertit un type MapSymbol en type OMAP
  static int _mapSymbolTypeToOmapType(symbol_model.MapSymbolType type) {
    switch (type) {
      case symbol_model.MapSymbolType.point:
        return 1;
      case symbol_model.MapSymbolType.line:
        return 2;
      case symbol_model.MapSymbolType.area:
        return 4;
      case symbol_model.MapSymbolType.text:
        return 8;
    }
  }

  /// Exporte un symbole ponctuel
  static void _exportPointSymbol(XmlBuilder builder, symbol_model.MapSymbol symbol) {
    // Taille en 0.001 mm (1 unité OMAP = 0.001 mm)
    final innerRadius = (symbol.size * 1000).round();
    final colorIndex = _findColorIndex(symbol.color);
    
    builder.element('point_symbol', attributes: {
      'inner_radius': innerRadius.toString(),
      'inner_color': colorIndex.toString(),
      'outer_width': '0',
      'outer_color': '-1',
      'elements': '0',
    });
  }

  /// Exporte un symbole linéaire
  static void _exportLineSymbol(XmlBuilder builder, symbol_model.MapSymbol symbol) {
    final colorIndex = _findColorIndex(symbol.color);
    final lineWidth = (symbol.strokeWidth * 1000).round(); // en 0.001 mm
    
    builder.element('line_symbol', attributes: {
      'color': colorIndex.toString(),
      'line_width': lineWidth.toString(),
      'minimum_length': '0',
      'join_style': '0', // 0 = miter, 1 = round, 2 = bevel
      'cap_style': '0',  // 0 = butt, 1 = round, 2 = square
      'start_offset': '0',
      'end_offset': '0',
      'segment_length': '4000',
      'end_length': '0',
    });
  }

  /// Exporte un symbole de surface
  static void _exportAreaSymbol(XmlBuilder builder, symbol_model.MapSymbol symbol) {
    final colorIndex = _findColorIndex(symbol.fillColor ?? symbol.color);
    
    builder.element('area_symbol', attributes: {
      'inner_color': colorIndex.toString(),
      'min_area': '0',
      'patterns': '0',
    });
  }

  /// Exporte un symbole de texte
  static void _exportTextSymbol(XmlBuilder builder, symbol_model.MapSymbol symbol) {
    builder.element('text_symbol', attributes: {
      'font': 'Arial',
      'size': (symbol.size * 1000).round().toString(), // en 0.001 mm
      'color': _findColorIndex(symbol.color).toString(),
      'horizontal_alignment': '1', // 0 = left, 1 = center, 2 = right
      'vertical_alignment': '1',   // 0 = top, 1 = center, 2 = bottom
    });
  }

  /// Trouve l'index d'une couleur dans la palette exportée
  /// (simplification: on utilise l'index basé sur la position dans la palette)
  static int _findColorIndex(Color color) {
    // Pour l'instant, on retourne 0 (noir) par défaut
    // Une implémentation complète nécessiterait de tracker les couleurs exportées
    if (color == Colors.black) return 4; // Black est à l'index 4 dans Villerest
    if (color == Colors.white) return 3; // White est à l'index 3
    if (color.toARGB32() == 0xFF0000FF) return 8; // Blue
    if (color.toARGB32() == 0xFF00FF00) return 27; // Green
    if (color.toARGB32() == 0xFFFF0000) return 6; // Brown
    return 4; // Noir par défaut
  }

  /// Exporte les calques (parts) et leurs objets
  static void _exportLayers(XmlBuilder builder, MapState mapState) {
    builder.element('parts', attributes: {
      'count': mapState.layers.length.toString(),
      'current': (mapState.selectedLayerIndex ?? 0).toString(),
    }, nest: () {
      for (final layer in mapState.layers) {
        _exportLayer(builder, layer);
      }
    });
  }

  /// Exporte un calque individuel
  static void _exportLayer(XmlBuilder builder, Layer layer) {
    builder.element('part', attributes: {
      'name': layer.name,
      'visible': layer.visible.toString(),
      'opacity': layer.opacity.toStringAsFixed(2),
    }, nest: () {
      // Compter les objets valides
      final validObjects = layer.symbols.where((s) => s.points.isNotEmpty).toList();
      
      builder.element('objects', attributes: {
        'count': validObjects.length.toString(),
      }, nest: () {
        for (final symbol in validObjects) {
          _exportObject(builder, symbol);
        }
      });
    });
  }

  /// Exporte un objet (symbole) dans un calque
  static void _exportObject(XmlBuilder builder, symbol_model.MapSymbol symbol) {
    final type = _mapSymbolTypeToOmapType(symbol.type);
    final symbolCode = symbol.iofCode ?? symbol.id;
    
    builder.element('object', attributes: {
      'type': type.toString(),
      'symbol': symbolCode,
    }, nest: () {
      // Coordonnées (en 0.001 mm)
      if (symbol.points.isNotEmpty) {
        builder.element('coords', attributes: {
          'count': symbol.points.length.toString(),
        }, nest: () {
          final coordsText = symbol.points
              .map((p) => '${(p.dx * 1000).round()} ${(p.dy * 1000).round()}')
              .join(';');
          builder.text(coordsText);
        });
      }
       
      // Rotation (si différente de 0)
      if (symbol.rotation != 0) {
        builder.element('pattern', attributes: {
          'rotation': symbol.rotation.toStringAsFixed(2),
        }, nest: () {
          builder.element('coord', attributes: {
            'x': '0',
            'y': '0',
          });
        });
      }
    });
  }
}

/// Extension pour faciliter l'export de MapState
///
/// Ajoute des méthodes utilitaires pour l'export OMAP
extension OmapExportable on MapState {
  /// Exporte cet état de carte au format OMAP
  String toOmapXml() {
    return OmapExporter.export(this);
  }
}

/// Point de référence géographique (latitude/longitude)
class GeographicRefPoint {
  final double latitude;
  final double longitude;

  const GeographicRefPoint(this.latitude, this.longitude);
}

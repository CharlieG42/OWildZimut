import 'package:xml/xml.dart' as xml;
import '../models/map_state.dart';
import '../models/layer.dart';
import '../models/symbol.dart' as symbol_model;
import '../models/georeferencing.dart' as geo;

/// Exportateur OMAP v9
///
/// Cette classe permet d'exporter l'état de la carte au format OMAP
/// (OpenOrienteering Mapper XML format version 9).
///
/// Le format OMAP est le format natif de OpenOrienteering Mapper et permet
/// d'échanger des cartes entre différentes applications.
class OmapExporter {
  /// Exporte l'état de la carte en XML OMAP
  ///
  /// [state] : L'état de la carte à exporter
  /// Retourne la chaîne XML
  static String export(MapState state) {
    final document = xml.XmlDocument();
    
    // Élément racine : OMap
    final root = xml.XmlElement(
      xml.XmlName('OMap'),
      [],
      [],
    );
    root.setAttribute('Version', '9');
    document.root = root;
    
    // Ajouter les métadonnées
    _addMetadata(root, state);
    
    // Ajouter le géoréférencement
    if (state.georeferencing != null) {
      _addGeoreferencing(root, state.georeferencing!);
    }
    
    // Ajouter les couleurs
    _addColors(root, state);
    
    // Ajouter les symboles
    _addSymbols(root, state);
    
    // Ajouter les calques
    _addLayers(root, state);
    
    // Ajouter les objets
    _addObjects(root, state);
    
    return document.toXmlString(pretty: true);
  }

  /// Ajoute les métadonnées
  static void _addMetadata(xml.XmlElement root, MapState state) {
    final metadata = xml.XmlElement(
      xml.XmlName('Metadata'),
      [],
      [],
    );
    
    // Nom de la carte
    metadata.setAttribute('Name', 'Carte OWildZimut');
    
    // Date de création
    metadata.setAttribute('Created', DateTime.now().toIso8601String());
    
    // Échelle
    metadata.setAttribute('Scale', state.scale.toStringAsFixed(0));
    
    root.children.add(metadata);
  }

  /// Ajoute le géoréférencement
  static void _addGeoreferencing(xml.XmlElement root, geo.Georeferencing georef) {
    final geoElement = xml.XmlElement(
      xml.XmlName('Georeferencing'),
      [],
      [],
    );
    
    // Échelle
    geoElement.setAttribute('Scale', georef.scale.toStringAsFixed(3));
    
    // Rotation
    geoElement.setAttribute('Rotation', georef.rotation.toStringAsFixed(3));
    
    // Système de coordonnées
    geoElement.setAttribute('CoordinateSystem', georef.coordinateSystem);
    
    // Points de contrôle au sol
    for (final gcp in georef.groundControlPoints) {
      final gcpElement = xml.XmlElement(
        xml.XmlName('GroundControlPoint'),
        [],
        [],
      );
      gcpElement.setAttribute('Id', gcp.id);
      gcpElement.setAttribute('Name', gcp.name);
      gcpElement.setAttribute('X', gcp.mapPosition.dx.toStringAsFixed(3));
      gcpElement.setAttribute('Y', gcp.mapPosition.dy.toStringAsFixed(3));
      gcpElement.setAttribute('Latitude', gcp.geoPosition.latitude.toStringAsFixed(6));
      gcpElement.setAttribute('Longitude', gcp.geoPosition.longitude.toStringAsFixed(6));
      
      if (gcp.altitude != null) {
        gcpElement.setAttribute('Altitude', gcp.altitude!.toStringAsFixed(3));
      }
      
      gcpElement.setAttribute('Accuracy', gcp.accuracy.toStringAsFixed(3));
      
      geoElement.children.add(gcpElement);
    }
    
    root.children.add(geoElement);
  }

  /// Ajoute les couleurs
  static void _addColors(xml.XmlElement root, MapState state) {
    final colorsElement = xml.XmlElement(
      xml.XmlName('Colors'),
      [],
      [],
    );
    
    // Pour l'instant, on ajoute une couleur par défaut
    // TODO: Extraire toutes les couleurs utilisées dans la carte
    final color = xml.XmlElement(
      xml.XmlName('Color'),
      [],
      [],
    );
    color.setAttribute('Name', 'Noir');
    color.setAttribute('C', '0');
    color.setAttribute('M', '0');
    color.setAttribute('Y', '0');
    color.setAttribute('K', '100');
    color.setAttribute('Spot', '0');
    color.setAttribute('Mix', '0');
    
    colorsElement.children.add(color);
    root.children.add(colorsElement);
  }

  /// Ajoute les symboles
  static void _addSymbols(xml.XmlElement root, MapState state) {
    final symbolsElement = xml.XmlElement(
      xml.XmlName('Symbols'),
      [],
      [],
    );
    
    // Pour l'instant, on ajoute les symboles IOF standard
    // TODO: Exporter les symboles personnalisés
    final symbol = xml.XmlElement(
      xml.XmlName('Symbol'),
      [],
      [],
    );
    symbol.setAttribute('Id', '101.0');
    symbol.setAttribute('Name', 'Roche');
    symbol.setAttribute('Type', 'Point');
    symbol.setAttribute('Color', 'Noir');
    symbol.setAttribute('Size', '0.4');
    
    symbolsElement.children.add(symbol);
    root.children.add(symbolsElement);
  }

  /// Ajoute les calques
  static void _addLayers(xml.XmlElement root, MapState state) {
    final layersElement = xml.XmlElement(
      xml.XmlName('Layers'),
      [],
      [],
    );
    
    for (final layer in state.layers) {
      final layerElement = xml.XmlElement(
        xml.XmlName('Layer'),
        [],
        [],
      );
      
      layerElement.setAttribute('Id', layer.id);
      layerElement.setAttribute('Name', layer.name);
      layerElement.setAttribute('Visible', layer.visible ? '1' : '0');
      layerElement.setAttribute('Opacity', layer.opacity.toStringAsFixed(2));
      layerElement.setAttribute('ZIndex', layer.zIndex.toString());
      layerElement.setAttribute('Locked', layer.locked ? '1' : '0');
      
      // Couleur du calque
      final color = layer.color;
      layerElement.setAttribute(
        'Color',
        '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      );
      
      // Type de calque
      layerElement.setAttribute(
        'Type',
        layer.type == LayerType.vector ? 'Vector' : 'Raster',
      );
      
      // Image de fond pour les calques raster
      if (layer.imagePath != null) {
        final imageElement = xml.XmlElement(
          xml.XmlName('BackgroundImage'),
          [],
          [],
        );
        imageElement.setAttribute('Path', layer.imagePath!);
        imageElement.setAttribute('OffsetX', layer.imageOffset.dx.toStringAsFixed(3));
        imageElement.setAttribute('OffsetY', layer.imageOffset.dy.toStringAsFixed(3));
        imageElement.setAttribute('Scale', layer.imageScale.toStringAsFixed(3));
        
        layerElement.children.add(imageElement);
      }
      
      layersElement.children.add(layerElement);
    }
    
    root.children.add(layersElement);
  }

  /// Ajoute les objets
  static void _addObjects(xml.XmlElement root, MapState state) {
    final objectsElement = xml.XmlElement(
      xml.XmlName('Objects'),
      [],
      [],
    );
    
    for (final layer in state.layers) {
      for (final symbol in layer.symbols) {
        final objectElement = _createObjectElement(symbol, layer.id);
        if (objectElement != null) {
          objectsElement.children.add(objectElement);
        }
      }
    }
    
    root.children.add(objectsElement);
  }

  /// Crée un élément Object pour un symbole
  static xml.XmlElement? _createObjectElement(
    symbol_model.MapSymbol symbol,
    String layerId,
  ) {
    final object = xml.XmlElement(
      xml.XmlName('Object'),
      [],
      [],
    );
    
    // Attributs communs
    object.setAttribute('Id', symbol.id);
    object.setAttribute('Type', _getObjectType(symbol.type));
    object.setAttribute('Layer', layerId);
    
    if (symbol.name.isNotEmpty) {
      object.setAttribute('Name', symbol.name);
    }
    
    // Attributs spécifiques au type
    switch (symbol.type) {
      case symbol_model.MapSymbolType.point:
        object.setAttribute('X', symbol.position.dx.toStringAsFixed(3));
        object.setAttribute('Y', symbol.position.dy.toStringAsFixed(3));
        object.setAttribute('Symbol', symbol.name.isNotEmpty ? symbol.name : '101.0');
        break;
      
      case symbol_model.MapSymbolType.line:
        object.setAttribute('Symbol', symbol.name.isNotEmpty ? symbol.name : '201.0');
        
        for (final point in symbol.points) {
          final pt = xml.XmlElement(
            xml.XmlName('Pt'),
            [],
            [],
          );
          pt.setAttribute('X', point.dx.toStringAsFixed(3));
          pt.setAttribute('Y', point.dy.toStringAsFixed(3));
          object.children.add(pt);
        }
        break;
      
      case symbol_model.MapSymbolType.area:
        object.setAttribute('Symbol', symbol.name.isNotEmpty ? symbol.name : '301.0');
        object.setAttribute('Closed', symbol.isClosed ? '1' : '0');
        
        for (final point in symbol.points) {
          final pt = xml.XmlElement(
            xml.XmlName('Pt'),
            [],
            [],
          );
          pt.setAttribute('X', point.dx.toStringAsFixed(3));
          pt.setAttribute('Y', point.dy.toStringAsFixed(3));
          object.children.add(pt);
        }
        break;
      
      case symbol_model.MapSymbolType.text:
        object.setAttribute('X', symbol.position.dx.toStringAsFixed(3));
        object.setAttribute('Y', symbol.position.dy.toStringAsFixed(3));
        object.setAttribute('Symbol', symbol.name.isNotEmpty ? symbol.name : '0.0');
        object.setAttribute('Text', symbol.text);
        object.setAttribute('Font', 'Arial');
        object.setAttribute('Size', symbol.textStyle.fontSize?.toStringAsFixed(1) ?? '10');
        object.setAttribute('Bold', symbol.textStyle.fontWeight == FontWeight.bold ? '1' : '0');
        object.setAttribute('Italic', symbol.textStyle.fontStyle == FontStyle.italic ? '1' : '0');
        break;
    }
    
    // Style
    if (symbol.strokeColor.value != const Color(0xFF000000).value) {
      object.setAttribute(
        'StrokeColor',
        '#${symbol.strokeColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      );
    }
    
    if (symbol.strokeWidth != 0.35) {
      object.setAttribute('StrokeWidth', symbol.strokeWidth.toStringAsFixed(3));
    }
    
    if (symbol.fillColor.value != const Color(0xFFFFFFFF).value) {
      object.setAttribute(
        'FillColor',
        '#${symbol.fillColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      );
    }
    
    if (symbol.fillOpacity != 1.0) {
      object.setAttribute('FillOpacity', symbol.fillOpacity.toStringAsFixed(2));
    }
    
    return object;
  }

  /// Retourne le type d'objet OMAP pour un type de symbole
  static String _getObjectType(symbol_model.MapSymbolType type) {
    switch (type) {
      case symbol_model.MapSymbolType.point:
        return 'Point';
      case symbol_model.MapSymbolType.line:
        return 'Line';
      case symbol_model.MapSymbolType.area:
        return 'Path';
      case symbol_model.MapSymbolType.text:
        return 'Text';
    }
  }
}

import 'dart:convert';

/// Modèle pour stocker les métadonnées d'une carte (OMAP, GeoPDF, Image).
/// Ces métadonnées sont conservées pour information et peuvent être ajoutées
/// aux fichiers générés par OWildZimut.
class MapMetadata {
  /// Titre de la carte
  final String? title;

  /// Auteur de la carte
  final String? author;

  /// Producteur (ex: "OpenOrienteeringMap")
  final String? producer;

  /// Date de création
  final DateTime? creationDate;

  /// ID unique de la carte (ex: "6a98f787a47e6" pour les GeoPDF OOM)
  final String? mapId;

  /// URL source (ex: lien vers OpenOrienteeringMap)
  final String? sourceUrl;

  /// Chemin du fichier source original (PDF ou image)
  final String? originalFilePath;

  /// Échelle (ex: "10000" pour 1:10000)
  final String? scale;

  /// Style utilisé (ex: "oterrain-LIDAR-5")
  final String? style;

  /// DPI de l'image/PDF
  final String? dpi;

  /// Rotation de la carte (en degrés)
  final double? rotation;

  /// Autres métadonnées personnalisées (clé-valeur)
  final Map<String, String> customFields;

  /// Système de coordonnées (ex: "EPSG:3857", "EPSG:4326")
  final String? crs;

  /// Bounds géographiques (minLon, minLat, maxLon, maxLat)
  final List<double>? geographicBounds;

  const MapMetadata({
    this.title,
    this.author,
    this.producer,
    this.creationDate,
    this.mapId,
    this.sourceUrl,
    this.originalFilePath,
    this.scale,
    this.style,
    this.dpi,
    this.rotation,
    this.customFields = const {},
    this.crs,
    this.geographicBounds,
  });

  /// Crée une MapMetadata vide
  MapMetadata.empty()
      : title = null,
        author = null,
        producer = null,
        creationDate = null,
        mapId = null,
        sourceUrl = null,
        originalFilePath = null,
        scale = null,
        style = null,
        dpi = null,
        rotation = null,
        customFields = const {},
        crs = null,
        geographicBounds = null;

  /// Convertit les métadonnées en XML pour un fichier OMAP
  String toOmapXml() {
    final buffer = StringBuffer();
    buffer.writeln('  <metadata>');
    
    if (title != null) {
      buffer.writeln('    <title>${_escapeXml(title!)}</title>');
    }
    if (author != null) {
      buffer.writeln('    <author>${_escapeXml(author!)}</author>');
    }
    if (producer != null) {
      buffer.writeln('    <producer>${_escapeXml(producer!)}</producer>');
    }
    if (creationDate != null) {
      buffer.writeln('    <creationDate>${creationDate!.toIso8601String()}</creationDate>');
    }
    if (mapId != null) {
      buffer.writeln('    <mapId>$mapId</mapId>');
    }
    if (sourceUrl != null) {
      buffer.writeln('    <sourceUrl>${_escapeXml(sourceUrl!)}</sourceUrl>');
    }
    if (originalFilePath != null) {
      buffer.writeln('    <originalFilePath>${_escapeXml(originalFilePath!)}</originalFilePath>');
    }
    if (scale != null) {
      buffer.writeln('    <scale>$scale</scale>');
    }
    if (style != null) {
      buffer.writeln('    <style>${_escapeXml(style!)}</style>');
    }
    if (dpi != null) {
      buffer.writeln('    <dpi>$dpi</dpi>');
    }
    if (rotation != null) {
      buffer.writeln('    <rotation>$rotation</rotation>');
    }
    if (crs != null) {
      buffer.writeln('    <crs>$crs</crs>');
    }
    if (geographicBounds != null && geographicBounds!.length >= 4) {
      buffer.writeln('    <geographicBounds>'
          '${geographicBounds![0]},${geographicBounds![1]},'
          '${geographicBounds![2]},${geographicBounds![3]}</geographicBounds>');
    }
    
    // Champs personnalisés
    for (final entry in customFields.entries) {
      buffer.writeln('    <${_escapeXml(entry.key)}>${_escapeXml(entry.value)}</${_escapeXml(entry.key)}>');
    }
    
    buffer.writeln('  </metadata>');
    return buffer.toString();
  }

  /// Parse les métadonnées depuis un dictionnaire (format PDF)
  factory MapMetadata.fromPdf(Map<String, dynamic> pdfMetadata) {
    // Parser la date PDF (format: D:YYYYMMDDHHmmSS+HH'MM')
    DateTime? creationDate;
    if (pdfMetadata['/CreationDate'] != null) {
      creationDate = _parsePdfDate(pdfMetadata['/CreationDate'] as String);
    }

    // Extraire les champs personnalisés de l'URL (ex: scale=10000)
    Map<String, String> customFields = {};
    if (pdfMetadata['/URL'] != null) {
      final url = pdfMetadata['/URL'] as String;
      customFields = _parseUrlParameters(url);
    }

    // Extraire les bounds géographiques si disponibles
    List<double>? geographicBounds;
    if (pdfMetadata['geographicBounds'] != null) {
      geographicBounds = (pdfMetadata['geographicBounds'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList();
    }

    return MapMetadata(
      title: pdfMetadata['/Title'] as String?,
      author: pdfMetadata['/Author'] as String?,
      producer: pdfMetadata['/Producer'] as String?,
      creationDate: creationDate,
      mapId: pdfMetadata['/MapID'] as String?,
      sourceUrl: pdfMetadata['/URL'] as String?,
      scale: customFields['scale'],
      style: customFields['style'],
      dpi: customFields['dpi'],
      rotation: customFields['rotation'] != null 
          ? double.tryParse(customFields['rotation']!) 
          : null,
      customFields: customFields,
      crs: pdfMetadata['crs'] as String? ?? 'EPSG:3857', // Par défaut pour OOM
      geographicBounds: geographicBounds,
    );
  }

  /// Parse une date au format PDF (D:YYYYMMDDHHmmSS+HH'MM')
  static DateTime? _parsePdfDate(String pdfDate) {
    // Format: D:20260903052906+00'00'
    final regex = RegExp(r'D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})');
    final match = regex.firstMatch(pdfDate);
    if (match != null) {
      return DateTime.parse(
        '${match.group(1)}-${match.group(2)}-${match.group(3)}T'
        '${match.group(4)}:${match.group(5)}:${match.group(6)}Z',
      );
    }
    return null;
  }

  /// Parse les paramètres de l'URL OpenOrienteeringMap
  static Map<String, String> _parseUrlParameters(String url) {
    final params = <String, String>{};
    final uri = Uri.tryParse(url);
    if (uri != null && uri.queryParameters.isNotEmpty) {
      params.addAll(uri.queryParameters);
    }
    return params;
  }

  /// Échappe les caractères spéciaux pour le XML
  static String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  /// Convertit en JSON pour la sérialisation
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'producer': producer,
      'creationDate': creationDate?.toIso8601String(),
      'mapId': mapId,
      'sourceUrl': sourceUrl,
      'originalFilePath': originalFilePath,
      'scale': scale,
      'style': style,
      'dpi': dpi,
      'rotation': rotation,
      'customFields': customFields,
      'crs': crs,
      'geographicBounds': geographicBounds,
    };
  }

  /// Crée une MapMetadata depuis un JSON
  factory MapMetadata.fromJson(Map<String, dynamic> json) {
    return MapMetadata(
      title: json['title'] as String?,
      author: json['author'] as String?,
      producer: json['producer'] as String?,
      creationDate: json['creationDate'] != null 
          ? DateTime.parse(json['creationDate'] as String) 
          : null,
      mapId: json['mapId'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      originalFilePath: json['originalFilePath'] as String?,
      scale: json['scale'] as String?,
      style: json['style'] as String?,
      dpi: json['dpi'] as String?,
      rotation: json['rotation'] as double?,
      customFields: (json['customFields'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value.toString())),
      crs: json['crs'] as String?,
      geographicBounds: (json['geographicBounds'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  /// Copie avec modification
  MapMetadata copyWith({
    String? title,
    String? author,
    String? producer,
    DateTime? creationDate,
    String? mapId,
    String? sourceUrl,
    String? originalFilePath,
    String? scale,
    String? style,
    String? dpi,
    double? rotation,
    Map<String, String>? customFields,
    String? crs,
    List<double>? geographicBounds,
  }) {
    return MapMetadata(
      title: title ?? this.title,
      author: author ?? this.author,
      producer: producer ?? this.producer,
      creationDate: creationDate ?? this.creationDate,
      mapId: mapId ?? this.mapId,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      originalFilePath: originalFilePath ?? this.originalFilePath,
      scale: scale ?? this.scale,
      style: style ?? this.style,
      dpi: dpi ?? this.dpi,
      rotation: rotation ?? this.rotation,
      customFields: customFields ?? this.customFields,
      crs: crs ?? this.crs,
      geographicBounds: geographicBounds ?? this.geographicBounds,
    );
  }

  @override
  String toString() {
    return 'MapMetadata('
        'title: $title, '
        'author: $author, '
        'crs: $crs, '
        'bounds: $geographicBounds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapMetadata &&
        other.title == title &&
        other.author == author &&
        other.producer == producer &&
        other.creationDate == creationDate &&
        other.mapId == mapId &&
        other.sourceUrl == sourceUrl &&
        other.originalFilePath == originalFilePath &&
        other.scale == scale &&
        other.style == style &&
        other.dpi == dpi &&
        other.rotation == rotation &&
        other.crs == crs &&
        other.geographicBounds == geographicBounds &&
        const DeepCollectionEquality().equals(other.customFields, customFields);
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      author,
      producer,
      creationDate,
      mapId,
      sourceUrl,
      originalFilePath,
      scale,
      style,
      dpi,
      rotation,
      crs,
      geographicBounds,
      const DeepCollectionEquality().hash(customFields),
    );
  }
}

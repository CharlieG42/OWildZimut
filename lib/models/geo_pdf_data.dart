import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'map_metadata.dart';
import 'georeferencing_data.dart';

/// Modèle pour stocker les données extraites d'un GeoPDF.
/// Utilisé pour la conversion en OMAP ou pour la superposition raster.
class GeoPdfData {
  /// Métadonnées du PDF
  final MapMetadata metadata;

  /// Données de géoréférencement
  final GeoreferencingData georef;

  /// Image extraite du PDF (en PNG)
  final Uint8List imageData;

  /// Chemin du fichier PDF original
  final String pdfPath;

  /// Nom de la carte (généré à partir du titre ou du fichier)
  final String mapName;

  const GeoPdfData({
    required this.metadata,
    required this.georef,
    required this.imageData,
    required this.pdfPath,
    required this.mapName,
  });

  /// Génère un nom unique pour la carte à partir du PDF
  static String generateMapName(String pdfPath, [String? title]) {
    // Extraire le nom du fichier sans extension
    final fileName = pdfPath.split('/').last.split('.').first;
    
    // Utiliser le titre si disponible et non vide, sinon le nom du fichier
    final baseName = (title?.isNotEmpty == true) ? title! : fileName;
    
    // Remplacer les caractères spéciaux
    return baseName
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-\s]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Génère un dossier unique pour la carte (avec gestion des doublons)
  static String generateMapDirectory(String baseDir, String mapName) {
    final dir = '$baseDir/$mapName';
    
    // Vérifier si le dossier existe déjà
    if (!Directory(dir).existsSync()) {
      return dir;
    }
    
    // Trouver un nom unique avec _2, _3, etc.
    int suffix = 2;
    while (true) {
      final newDir = '$baseDir/${mapName}_$suffix';
      if (!Directory(newDir).existsSync()) {
        return newDir;
      }
      suffix++;
    }
  }

  /// Convertit les données en contenu OMAP XML
  String toOmapXml() {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<map>
${metadata.toOmapXml()}
  <georeferencing>
    <grid>${georef.toOmapGrid()}</grid>
    <crs>${georef.crs}</crs>
  </georeferencing>
  <background>
    <image src="background.png" />
  </background>
</map>''';
  }

  /// Sauvegarde les données dans un dossier (OMAP + image)
  Future<void> saveToDirectory(String outputDir) async {
    final dir = Directory(outputDir);
    await dir.create(recursive: true);

    // Sauvegarder le fichier OMAP
    final omapPath = '$outputDir/map.omap';
    await File(omapPath).writeAsString(toOmapXml());

    // Sauvegarder l'image de fond
    final imagePath = '$outputDir/background.png';
    await File(imagePath).writeAsBytes(imageData);

    // Sauvegarder les métadonnées au format JSON (optionnel)
    final metadataPath = '$outputDir/metadata.json';
    await File(metadataPath).writeAsString(
      jsonEncode({
        'metadata': metadata.toJson(),
        'georef': {
          'crs': georef.crs,
          'bounds': georef.bounds,
          'width': georef.width,
          'height': georef.height,
          'dpi': georef.dpi,
        },
        'sourcePdf': pdfPath,
      }),
    );
  }

  /// Copie avec modification
  GeoPdfData copyWith({
    MapMetadata? metadata,
    GeoreferencingData? georef,
    Uint8List? imageData,
    String? pdfPath,
    String? mapName,
  }) {
    return GeoPdfData(
      metadata: metadata ?? this.metadata,
      georef: georef ?? this.georef,
      imageData: imageData ?? this.imageData,
      pdfPath: pdfPath ?? this.pdfPath,
      mapName: mapName ?? this.mapName,
    );
  }

  @override
  String toString() {
    return 'GeoPdfData(mapName: $mapName, georef: $georef, metadata: $metadata)';
  }
}

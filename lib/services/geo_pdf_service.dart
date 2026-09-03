import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/map_metadata.dart';
import '../models/georeferencing_data.dart';
import '../models/geo_pdf_data.dart';
import '../ffi/poppler_bindings.dart';
import '../ffi/gdal_bindings.dart';

/// Service pour gérer l'import et la conversion des GeoPDF.
/// Ce service utilise les bindings FFI pour interagir avec Poppler et GDAL.
class GeoPdfService {
  static final GeoPdfService _instance = GeoPdfService._internal();
  factory GeoPdfService() => _instance;
  GeoPdfService._internal();

  /// Chemin du dossier maps à la racine de l'application
  static const String _mapsDirName = 'maps';
  late Directory _mapsDir;

  /// Initialise le service (appelé au démarrage de l'app)
  Future<void> init() async {
    // Initialiser les bindings FFI
    PopplerBindings.init();
    GdalBindings.init();

    // Créer le dossier maps
    final appDir = await getApplicationDocumentsDirectory();
    _mapsDir = Directory(path.join(appDir.path, _mapsDirName));
    if (!await _mapsDir.exists()) {
      await _mapsDir.create(recursive: true);
    }
  }

  /// Vérifie si le service est initialisé
  bool get isInitialized => PopplerBindings.isLoaded && GdalBindings.isLoaded;

  // ============================================================================
  // Conversion GeoPDF → OMAP
  // ============================================================================

  /// Convertit un GeoPDF en OMAP + image de fond.
  /// Retourne le chemin du dossier contenant les fichiers générés.
  Future<String> convertGeoPdfToOmap(String pdfPath) async {
    if (!isInitialized) {
      throw Exception('GeoPdfService not initialized. Call init() first.');
    }

    // Extraire les données du GeoPDF
    final geoPdfData = await _extractGeoPdfData(pdfPath);

    // Générer un nom de dossier unique
    final mapDir = GeoPdfData.generateMapDirectory(
      _mapsDir.path,
      GeoPdfData.generateMapName(pdfPath, geoPdfData.metadata.title),
    );

    // Sauvegarder les données dans le dossier
    await geoPdfData.saveToDirectory(mapDir);

    return mapDir;
  }

  /// Extrait les données d'un GeoPDF (métadonnées, géoréférencement, image)
  Future<GeoPdfData> _extractGeoPdfData(String pdfPath) async {
    // Ouvrir le document PDF avec Poppler
    final docPtr = PopplerBindings.openDocument(pdfPath);
    if (docPtr == PopplerBindings.nullptr) {
      throw Exception('Failed to open PDF: $pdfPath');
    }

    try {
      // Récupérer les métadonnées
      final pdfMetadata = PopplerBindings.getMetadata(docPtr);
      final metadata = MapMetadata.fromPdf(pdfMetadata);

      // Récupérer la première page
      final pageCount = PopplerBindings.getPageCount(docPtr);
      if (pageCount == 0) {
        throw Exception('PDF has no pages');
      }

      final pagePtr = PopplerBindings.getPage(docPtr, 0);
      if (pagePtr == PopplerBindings.nullptr) {
        throw Exception('Failed to get page 0');
      }

      try {
        // Récupérer la taille de la page
        final (width, height) = PopplerBindings.getPageSize(pagePtr);

        // Récupérer les données de géoréférencement (Viewport GEO)
        final geoData = PopplerBindings.getGeoData(pagePtr);
        
        // Si pas de Viewport GEO, essayer avec GDAL
        GeoreferencingData georef;
        if (geoData.isNotEmpty && geoData.containsKey('crs') && geoData.containsKey('bounds')) {
          // Utiliser les données de Poppler
          final gpts = geoData['gpts'] as List<double>? ?? [];
          final lpts = geoData['lpts'] as List<double>? ?? [];
          georef = GeoreferencingData.fromViewport(
            crs: geoData['crs'] as String,
            gpts: gpts,
            lpts: lpts,
            width: width,
            height: height,
            dpi: double.tryParse(metadata.dpi ?? '300') ?? 300.0,
          );
        } else {
          // Essayer avec GDAL
          final gdalData = GdalBindings.getGeoPdfData(pdfPath);
          if (gdalData.containsKey('bounds') && gdalData.containsKey('crs')) {
            final bounds = (gdalData['bounds'] as List<dynamic>).map((e) => (e as num).toDouble()).toList();
            georef = GeoreferencingData(
              crs: gdalData['crs'] as String,
              geographicPoints: [], // Non disponibles via GDAL pour les PDF
              localPoints: [],
              bounds: bounds,
              width: width,
              height: height,
              dpi: double.tryParse(metadata.dpi ?? '300') ?? 300.0,
            );
          } else {
            throw Exception('No georeferencing data found in PDF');
          }
        }

        // Rendre la page en image
        final imageData = PopplerBindings.renderPageToPng(pagePtr);

        // Générer un nom pour la carte
        final mapName = GeoPdfData.generateMapName(
          pdfPath,
          metadata.title,
        );

        return GeoPdfData(
          metadata: metadata.copyWith(
            originalFilePath: pdfPath,
            geographicBounds: georef.bounds,
            crs: georef.crs,
          ),
          georef: georef,
          imageData: imageData,
          pdfPath: pdfPath,
          mapName: mapName,
        );
      } finally {
        // La page est libérée automatiquement avec le document
      }
    } finally {
      PopplerBindings.closeDocument(docPtr);
    }
  }

  // ============================================================================
  // Superposition Raster (Import direct GeoPDF)
  // ============================================================================

  /// Charge un GeoPDF comme image de fond géoréférencée (sans conversion en OMAP).
  /// Retourne un objet contenant toutes les données nécessaires pour l'affichage.
  Future<GeoPdfData> loadGeoPdfAsRaster(String pdfPath) async {
    if (!isInitialized) {
      throw Exception('GeoPdfService not initialized. Call init() first.');
    }

    // Extraire les données (même processus que pour la conversion)
    return await _extractGeoPdfData(pdfPath);
  }

  // ============================================================================
  // Gestion des fichiers
  // ============================================================================

  /// Liste toutes les cartes importées
  Future<List<Directory>> getImportedMaps() async {
    if (!await _mapsDir.exists()) {
      return [];
    }

    final maps = <Directory>[];
    await for (final entity in _mapsDir.list()) {
      if (entity is Directory) {
        // Vérifier si le dossier contient un fichier OMAP ou des données valides
        final files = await entity.list().toList();
        if (files.any((f) => f.path.endsWith('.omap')) ||
            files.any((f) => f.path.endsWith('.png'))) {
          maps.add(entity);
        }
      }
    }
    return maps;
  }

  /// Supprime une carte importée
  Future<void> deleteMap(String mapDirPath) async {
    final dir = Directory(mapDirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// Renomme une carte
  Future<void> renameMap(String oldPath, String newName) async {
    final oldDir = Directory(oldPath);
    final newDir = Directory(path.join(path.dirname(oldPath), newName));
    await oldDir.rename(newDir.path);
  }

  // ============================================================================
  // Utilitaires
  // ============================================================================

  /// Vérifie si un fichier est un GeoPDF
  Future<bool> isGeoPdf(String filePath) async {
    try {
      final docPtr = PopplerBindings.openDocument(filePath);
      if (docPtr == PopplerBindings.nullptr) {
        return false;
      }

      try {
        final pageCount = PopplerBindings.getPageCount(docPtr);
        if (pageCount == 0) return false;

        final pagePtr = PopplerBindings.getPage(docPtr, 0);
        if (pagePtr == PopplerBindings.nullptr) return false;

        final geoData = PopplerBindings.getGeoData(pagePtr);
        return geoData.containsKey('crs') && geoData.containsKey('bounds');
      } finally {
        PopplerBindings.closeDocument(docPtr);
      }
    } catch (e) {
      return false;
    }
  }

  /// Récupère les informations de base d'un GeoPDF (sans charger l'image)
  Future<Map<String, dynamic>> getGeoPdfInfo(String pdfPath) async {
    final docPtr = PopplerBindings.openDocument(pdfPath);
    if (docPtr == PopplerBindings.nullptr) {
      throw Exception('Failed to open PDF');
    }

    try {
      final metadata = PopplerBindings.getMetadata(docPtr);
      final pageCount = PopplerBindings.getPageCount(docPtr);
      
      if (pageCount > 0) {
        final pagePtr = PopplerBindings.getPage(docPtr, 0);
        final (width, height) = PopplerBindings.getPageSize(pagePtr);
        final geoData = PopplerBindings.getGeoData(pagePtr);
        
        return {
          'metadata': MapMetadata.fromPdf(metadata).toJson(),
          'pageCount': pageCount,
          'pageSize': {'width': width, 'height': height},
          'geoData': geoData,
        };
      }
      
      return {
        'metadata': MapMetadata.fromPdf(metadata).toJson(),
        'pageCount': pageCount,
      };
    } finally {
      PopplerBindings.closeDocument(docPtr);
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/map_metadata.dart';
import '../models/georeferencing_data.dart';
import '../models/geo_pdf_data.dart';
import 'geo_pdf_service.dart';

/// Service pour gérer l'import de différents types de fichiers dans OWildZimut.
/// Ce service propose 4 options d'import :
/// 1. Import OMAP (déjà présent)
/// 2. Import Image (géoréférencée manuellement)
/// 3. Conversion GeoPDF → OMAP
/// 4. Import GeoPDF (superposition raster)
class ImportService {
  final GeoPdfService _geoPdfService;
  late Directory _mapsDir;

  ImportService({GeoPdfService? geoPdfService})
      : _geoPdfService = geoPdfService ?? GeoPdfService();

  /// Initialise le service (appelé au démarrage de l'app)
  Future<void> init() async {
    await _geoPdfService.init();
    
    // Créer le dossier maps
    final appDir = await getApplicationDocumentsDirectory();
    _mapsDir = Directory(path.join(appDir.path, 'maps'));
    if (!await _mapsDir.exists()) {
      await _mapsDir.create(recursive: true);
    }
  }

  // ============================================================================
  // 1. Import OMAP (déjà présent)
  // ============================================================================

  /// Importe un fichier OMAP existant
  Future<String?> importOmap() async {
    final file = await pickFile(
      type: FileType.custom,
      allowedExtensions: ['omap'],
      dialogTitle: 'Importer un fichier OMAP',
    );
    
    if (file != null) {
      return await importOmapFromPath(file.path);
    }
    
    return null;
  }

  /// Importe un fichier OMAP à partir d'un chemin
  Future<String?> importOmapFromPath(String filePath) async {
    // TODO: Implémenter le chargement du fichier OMAP
    // Pour l'instant, on retourne simplement le chemin
    return filePath;
  }

  // ============================================================================
  // 2. Import Image (géoréférencée manuellement)
  // ============================================================================

  /// Importe une image et propose une calibration manuelle
  Future<String?> importImage() async {
    final file = await pickFile(
      type: FileType.image,
      dialogTitle: 'Importer une image',
    );
    
    if (file != null) {
      return await importImageFromPath(file.path);
    }
    
    return null;
  }

  /// Importe une image à partir d'un chemin de fichier
  Future<String?> importImageFromPath(String filePath) async {
    // TODO: Ouvrir un dialogue de calibration pour géoréférencer l'image
    // Pour l'instant, on retourne le chemin de l'image
    // Dans une implémentation complète, on créerait un fichier OMAP avec
    // l'image et les données de géoréférencement saisies par l'utilisateur
    return filePath;
  }

  // ============================================================================
  // 3. Conversion GeoPDF → OMAP
  // ============================================================================

  /// Convertit un GeoPDF en OMAP + image de fond et importe le résultat
  Future<String?> importGeoPdfWithConversion() async {
    final file = await pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'PDF'],
      dialogTitle: 'Sélectionner un GeoPDF à convertir',
    );
    
    if (file != null) {
      return await importGeoPdfWithConversionFromPath(file.path);
    }
    
    return null;
  }

  /// Convertit un GeoPDF en OMAP à partir d'un chemin de fichier
  Future<String?> importGeoPdfWithConversionFromPath(String filePath) async {
    try {
      // Vérifier que c'est bien un GeoPDF
      final isGeoPdf = await _geoPdfService.isGeoPdf(filePath);
      if (!isGeoPdf) {
        // TODO: Afficher un message d'erreur
        return null;
      }

      // Convertir le GeoPDF en OMAP
      final mapDir = await _geoPdfService.convertGeoPdfToOmap(filePath);
      
      return mapDir;
    } catch (e) {
      // TODO: Gérer l'erreur
      print('Erreur lors de la conversion GeoPDF → OMAP: $e');
      return null;
    }
  }

  // ============================================================================
  // 4. Import GeoPDF (superposition raster)
  // ============================================================================

  /// Importe un GeoPDF directement comme image de fond géoréférencée
  Future<GeoPdfData?> importGeoPdfAsRaster() async {
    final file = await pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'PDF'],
      dialogTitle: 'Sélectionner un GeoPDF à importer',
    );
    
    if (file != null) {
      return await importGeoPdfAsRasterFromPath(file.path);
    }
    
    return null;
  }

  /// Importe un GeoPDF comme raster à partir d'un chemin de fichier
  Future<GeoPdfData?> importGeoPdfAsRasterFromPath(String filePath) async {
    try {
      // Vérifier que c'est bien un GeoPDF
      final isGeoPdf = await _geoPdfService.isGeoPdf(filePath);
      if (!isGeoPdf) {
        // TODO: Afficher un message d'erreur
        return null;
      }

      // Charger le GeoPDF comme raster
      final geoPdfData = await _geoPdfService.loadGeoPdfAsRaster(filePath);
      
      // Générer un nom de dossier unique
      final mapDir = GeoPdfData.generateMapDirectory(
        _mapsDir.path,
        GeoPdfData.generateMapName(filePath, geoPdfData.metadata.title),
      );

      // Sauvegarder les données dans le dossier
      await geoPdfData.saveToDirectory(mapDir);
      
      return geoPdfData;
    } catch (e) {
      // TODO: Gérer l'erreur
      print('Erreur lors de l\'import GeoPDF: $e');
      return null;
    }
  }

  // ============================================================================
  // Fonctions utilitaires
  // ============================================================================

  /// Ouvre un dialogue pour sélectionner un fichier
  Future<File?> pickFile({
    required FileType type,
    List<String>? allowedExtensions,
    String? dialogTitle,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        dialogTitle: dialogTitle,
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        return File(result.files.first.path!);
      }
    } catch (e) {
      print('Erreur lors de la sélection du fichier: $e');
    }
    
    return null;
  }

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
  Future<bool> deleteMap(String mapDirPath) async {
    try {
      final dir = Directory(mapDirPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        return true;
      }
    } catch (e) {
      print('Erreur lors de la suppression de la carte: $e');
    }
    return false;
  }

  /// Renomme une carte
  Future<bool> renameMap(String oldPath, String newName) async {
    try {
      final oldDir = Directory(oldPath);
      final newDir = Directory(path.join(path.dirname(oldPath), newName));
      await oldDir.rename(newDir.path);
      return true;
    } catch (e) {
      print('Erreur lors du renommage de la carte: $e');
      return false;
    }
  }

  /// Récupère les informations d'un GeoPDF sans l'importer
  Future<Map<String, dynamic>?> getGeoPdfInfo(String pdfPath) async {
    try {
      return await _geoPdfService.getGeoPdfInfo(pdfPath);
    } catch (e) {
      print('Erreur lors de la lecture des infos GeoPDF: $e');
      return null;
    }
  }

  /// Vérifie si un fichier est un GeoPDF
  Future<bool> isGeoPdf(String filePath) async {
    return await _geoPdfService.isGeoPdf(filePath);
  }
}

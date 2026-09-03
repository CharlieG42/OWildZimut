import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

/// Bindings FFI pour la librairie GDAL (lecture des données géospatiales).
/// Cette classe permet d'appeler les fonctions C++ de GDAL depuis Dart.
class GdalBindings {
  static DynamicLibrary? _lib;

  /// Initialise la librairie GDAL
  static void init() {
    if (_lib != null) return;

    // Charger la librairie en fonction de la plateforme
    String libName;
    if (Platform.isWindows) {
      libName = 'gdal.dll';
    } else if (Platform.isLinux) {
      libName = 'libgdal.so';
    } else if (Platform.isMacOS) {
      libName = 'libgdal.dylib';
    } else if (Platform.isAndroid) {
      libName = 'libgdal.so';
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} not supported');
    }

    // Essayer de charger depuis le bundle de l'app
    try {
      _lib = DynamicLibrary.open(libName);
    } catch (e) {
      // Sur Android, essayer de charger depuis le chemin complet
      if (Platform.isAndroid) {
        final bundlePath = path.join(
          Directory.current.path,
          'lib',
          'arm64-v8a', // ou x86_64 selon l'architecture
          libName,
        );
        try {
          _lib = DynamicLibrary.open(bundlePath);
        } catch (e) {
          rethrow;
        }
      } else {
        rethrow;
      }
    }

    // Initialiser GDAL
    _gdalAllRegister();
  }

  /// Vérifie si la librairie est chargée
  static bool get isLoaded => _lib != null;

  // ============================================================================
  // Déclarations des fonctions C++ GDAL
  // ============================================================================

  static final DynamicLibrary _libSafe = _lib ?? (throw Exception('GDAL library not loaded'));

  /// Initialise tous les drivers GDAL
  static final _gdalAllRegister = _libSafe.lookupFunction<
    Void Function(),
    void Function()
  >('GDALAllRegister');

  /// Ouvre un dataset GDAL
  static final _gdalOpen = _libSafe.lookupFunction<
    Pointer<Void> Function(Pointer<Utf8>),
    Pointer<Void> Function(Pointer<Utf8>)
  >('GDALOpen');

  /// Ferme un dataset GDAL
  static final _gdalClose = _libSafe.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('GDALClose');

  /// Récupère le nombre de bandes
  static final _gdalGetRasterCount = _libSafe.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('GDALGetRasterCount');

  /// Récupère la taille du raster
  static final _gdalGetRasterBand = _libSafe.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Int32),
    Pointer<Void> Function(Pointer<Void>, int)
  >('GDALGetRasterBand');

  static final _gdalGetRasterXSize = _libSafe.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('GDALGetRasterXSize');

  static final _gdalGetRasterYSize = _libSafe.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('GDALGetRasterYSize');

  /// Récupère la transformation géométrique (GeoTransform)
  static final _gdalGetGeoTransform = _libSafe.lookupFunction<
    Int32 Function(Pointer<Void>, Pointer<Double>),
    int Function(Pointer<Void>, Pointer<Double>)
  >('GDALGetGeoTransform');

  /// Récupère le système de coordonnées (Projection)
  static final _gdalGetProjectionRef = _libSafe.lookupFunction<
    Pointer<Utf8> Function(Pointer<Void>),
    Pointer<Utf8> Function(Pointer<Void>)
  >('GDALGetProjectionRef');

  /// Lit les données d'une bande raster
  static final _gdalRasterIO = _libSafe.lookupFunction<
    Int32 Function(
      Pointer<Void>, // hBand
      Int32,        // eRasterDataType
      Int32,        // nXOff
      Int32,        // nYOff
      Int32,        // nXSize
      Int32,        // nYSize
      Pointer<Void>, // pData
      Int32,        // nBufXSize
      Int32,        // nBufYSize
      Int32,        // nPixelSpace
      Int32,        // nLineSpace
    ),
    int Function(
      Pointer<Void>,
      int,
      int,
      int,
      int,
      int,
      Pointer<Void>,
      int,
      int,
      int,
      int,
    )
  >('GDALRasterIO');

  /// Récupère les métadonnées du dataset
  static final _gdalGetMetadata = _libSafe.lookupFunction<
    Pointer<Utf8> Function(Pointer<Void>, Pointer<Utf8>),
    Pointer<Utf8> Function(Pointer<Void>, Pointer<Utf8>)
  >('GDALGetMetadata');

  /// Libère un pointeur alloué par GDAL
  static final _vsifree = _libSafe.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('VSIFree');

  // ============================================================================
  // Fonctions Dart wrappers
  // ============================================================================

  /// Ouvre un fichier avec GDAL
  static Pointer<Void> openDataset(String filePath) {
    final pathPtr = filePath.toNativeUtf8();
    try {
      return _gdalOpen(pathPtr);
    } finally {
      malloc.free(pathPtr);
    }
  }

  /// Ferme un dataset GDAL
  static void closeDataset(Pointer<Void> dataset) {
    _gdalClose(dataset);
  }

  /// Récupère la taille du raster
  static (int width, int height) getRasterSize(Pointer<Void> dataset) {
    return (
      _gdalGetRasterXSize(dataset),
      _gdalGetRasterYSize(dataset),
    );
  }

  /// Récupère la transformation géométrique (GeoTransform)
  /// Retourne [minX, pixelWidth, rotationX, maxY, rotationY, pixelHeight]
  static List<double> getGeoTransform(Pointer<Void> dataset) {
    final transformPtr = malloc.call<Pointer<Double>>().cast<Double>()
      ..asTypedList(6);
    
    try {
      final result = _gdalGetGeoTransform(dataset, transformPtr);
      if (result != 0) {
        throw Exception('Failed to get geo transform');
      }
      return transformPtr.asTypedList(6).toList();
    } finally {
      malloc.free(transformPtr);
    }
  }

  /// Récupère le système de coordonnées (WKT)
  static String? getProjection(Pointer<Void> dataset) {
    final projPtr = _gdalGetProjectionRef(dataset);
    if (projPtr == nullptr) {
      return null;
    }
    try {
      return projPtr.toDartString();
    } finally {
      // GDAL alloue la mémoire, il faut la libérer
      _vsifree(projPtr.cast<Void>());
    }
  }

  /// Récupère les métadonnées du dataset
  static Map<String, String> getMetadata(Pointer<Void> dataset) {
    final result = <String, String>{};
    final metadataPtr = _gdalGetMetadata(dataset, nullptr);
    
    if (metadataPtr != nullptr) {
      // Parser les métadonnées (format: "KEY=VALUE\0KEY=VALUE\0...")
      final metadataStr = metadataPtr.toDartString();
      for (final pair in metadataStr.split('\0')) {
        if (pair.isEmpty) continue;
        final parts = pair.split('=');
        if (parts.length == 2) {
          result[parts[0]] = parts[1];
        }
      }
    }
    
    return result;
  }

  /// Lit les données d'une bande raster (simplifié)
  static Uint8List readRasterBand(Pointer<Void> dataset, int bandIndex) {
    final (width, height) = getRasterSize(dataset);
    final band = _gdalGetRasterBand(dataset, bandIndex);
    
    // Allouer un buffer pour les données
    final bufferSize = width * height;
    final bufferPtr = malloc.call<Pointer<Uint8>>().cast<Uint8>()
      ..asTypedList(bufferSize);
    
    try {
      final result = _gdalRasterIO(
        band,
        1, // GF_Read
        0, // nXOff
        0, // nYOff
        width,
        height,
        bufferPtr,
        width,
        height,
        1, // nPixelSpace
        1, // nLineSpace
      );
      
      if (result != 0) {
        throw Exception('Failed to read raster band');
      }
      
      return bufferPtr.asTypedList(bufferSize);
    } finally {
      malloc.free(bufferPtr);
    }
  }

  /// Récupère les données de géoréférencement pour un GeoPDF
  static Map<String, dynamic> getGeoPdfData(String pdfPath) {
    final dataset = openDataset(pdfPath);
    if (dataset == nullptr) {
      throw Exception('Failed to open PDF with GDAL');
    }
    
    try {
      final result = <String, dynamic>{};
      
      // Récupérer la transformation géométrique
      final transform = getGeoTransform(dataset);
      if (transform.isNotEmpty) {
        result['transform'] = transform;
        // Calculer les bounds
        final (width, height) = getRasterSize(dataset);
        final minX = transform[0];
        final maxY = transform[3];
        final maxX = minX + width * transform[1]; // pixelWidth
        final minY = maxY + height * transform[5]; // pixelHeight (négatif)
        result['bounds'] = [minX, minY, maxX, maxY];
      }
      
      // Récupérer le CRS
      final projection = getProjection(dataset);
      if (projection != null) {
        result['crs'] = projection;
        // Extraire l'EPSG si possible
        final epsgMatch = RegExp(r'EPSG:(\d+)').firstMatch(projection);
        if (epsgMatch != null) {
          result['epsg'] = epsgMatch.group(1);
        }
      }
      
      // Récupérer les métadonnées
      final metadata = getMetadata(dataset);
      result['metadata'] = metadata;
      
      return result;
    } finally {
      closeDataset(dataset);
    }
  }

  // ============================================================================
  // Fonctions utilitaires
  // ============================================================================

  /// Charge la librairie
  static final DynamicLibrary _lib = DynamicLibrary.open('gdal');
  static final malloc = _lib.lookupFunction<
    Pointer<Void> Function(Int64),
    Pointer<Void> Function(int)
  >('malloc');
  static final free = _lib.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('free');

  /// Pointer nul
  static final nullptr = Pointer<Void>.fromAddress(0);
}

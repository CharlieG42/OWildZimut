import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

/// Bindings FFI pour la librairie Poppler (lecture des PDF).
/// Cette classe permet d'appeler les fonctions C++ de Poppler depuis Dart.
class PopplerBindings {
  static DynamicLibrary? _lib;

  /// Initialise la librairie Poppler
  static void init() {
    if (_lib != null) return;

    // Charger la librairie en fonction de la plateforme
    String libName;
    if (Platform.isWindows) {
      libName = 'poppler.dll';
    } else if (Platform.isLinux) {
      libName = 'libpoppler.so';
    } else if (Platform.isMacOS) {
      libName = 'libpoppler.dylib';
    } else if (Platform.isAndroid) {
      libName = 'libpoppler.so';
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
  }

  /// Vérifie si la librairie est chargée
  static bool get isLoaded => _lib != null;

  // ============================================================================
  // Fonctions pour lire les métadonnées du PDF
  // ============================================================================

  /// Structure pour stocker les métadonnées du PDF (C-compatible)
  static const int kMaxMetadataLength = 1024;



  // ============================================================================
  // Déclarations des fonctions C++
  // ============================================================================

  // Typedefs pour les fonctions C++
  static final DynamicLibrary _libSafe = _lib ?? (throw Exception('Poppler library not loaded'));

  /// Ouvre un document PDF
  static final _pdfDocOpen = _libSafe.lookupFunction<
    Pointer<Void> Function(Pointer<Utf8>),
    Pointer<Void> Function(Pointer<Utf8>)
  >('pdf_doc_open');

  /// Ferme un document PDF
  static final _pdfDocClose = _libSafe.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('pdf_doc_close');

  /// Récupère les métadonnées du PDF
  static final _pdfDocGetMetadata = _libSafe.lookupFunction<
    Pointer<Utf8> Function(Pointer<Void>, Pointer<Utf8>),
    Pointer<Utf8> Function(Pointer<Void>, Pointer<Utf8>)
  >('pdf_doc_get_metadata');

  /// Récupère le nombre de pages
  static final _pdfDocGetPageCount = _libSafe.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('pdf_doc_get_page_count');

  /// Récupère une page du PDF
  static final _pdfDocGetPage = _libSafe.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Int32),
    Pointer<Void> Function(Pointer<Void>, int)
  >('pdf_doc_get_page');

  /// Récupère la taille de la page (en points)
  static final _pdfPageGetSize = _libSafe.lookupFunction<
    Void Function(Pointer<Void>, Pointer<Double>, Pointer<Double>),
    void Function(Pointer<Void>, Pointer<Double>, Pointer<Double>)
  >('pdf_page_get_size');

  /// Rend une page en image (RGBA)
  static final _pdfPageRenderToImage = _libSafe.lookupFunction<
    Pointer<Uint8> Function(
      Pointer<Void>,
      Double, // scale
      Int32,  // width
      Int32,  // height
      Int32,  // rowstride
    ),
    Pointer<Uint8> Function(
      Pointer<Void>,
      double,
      int,
      int,
      int,
    )
  >('pdf_page_render_to_image');

  /// Libère une image rendue
  static final _pdfFreeImage = _libSafe.lookupFunction<
    Void Function(Pointer<Uint8>),
    void Function(Pointer<Uint8>)
  >('pdf_free_image');

  /// Récupère les données de géoréférencement (Viewport GEO)
  static final _pdfPageGetGeoData = _libSafe.lookupFunction<
    Pointer<Utf8> Function(Pointer<Void>),
    Pointer<Utf8> Function(Pointer<Void>)
  >('pdf_page_get_geo_data');

  // ============================================================================
  // Fonctions Dart wrappers
  // ============================================================================

  /// Ouvre un document PDF
  static Pointer<Void> openDocument(String pdfPath) {
    final pathPtr = pdfPath.toNativeUtf8();
    try {
      return _pdfDocOpen(pathPtr);
    } finally {
      free(pathPtr.cast<Void>());
    }
  }

  /// Ferme un document PDF
  static void closeDocument(Pointer<Void> doc) {
    _pdfDocClose(doc);
  }

  /// Récupère les métadonnées du PDF
  static Map<String, String> getMetadata(Pointer<Void> doc) {
    final result = <String, String>{};
    final keys = ['Title', 'Author', 'Producer', 'CreationDate', 'MapID', 'URL'];
    
    for (final key in keys) {
      final keyPtr = key.toNativeUtf8();
      try {
        final valuePtr = _pdfDocGetMetadata(doc, keyPtr);
        if (valuePtr != nullptr.cast<Utf8>()) {
          result[key] = valuePtr.toDartString();
        }
      } finally {
        free(keyPtr.cast<Void>());
      }
    }
    return result;
  }

  /// Récupère le nombre de pages
  static int getPageCount(Pointer<Void> doc) {
    return _pdfDocGetPageCount(doc);
  }

  /// Récupère une page
  static Pointer<Void> getPage(Pointer<Void> doc, int pageIndex) {
    return _pdfDocGetPage(doc, pageIndex);
  }

  /// Récupère la taille de la page
  static (double width, double height) getPageSize(Pointer<Void> page) {
    final widthPtr = malloc(sizeOf<Double>()).cast<Double>();
    final heightPtr = malloc(sizeOf<Double>()).cast<Double>();
    
    try {
      _pdfPageGetSize(page, widthPtr, heightPtr);
      return (widthPtr.value, heightPtr.value);
    } finally {
      free(widthPtr.cast<Void>());
      free(heightPtr.cast<Void>());
    }
  }

  /// Rend une page en image PNG (RGBA)
  static Uint8List renderPageToPng(Pointer<Void> page, {double scale = 1.0}) {
    final (width, height) = getPageSize(page);
    final scaledWidth = (width * scale).ceil();
    final scaledHeight = (height * scale).ceil();
    final rowStride = scaledWidth * 4; // 4 octets par pixel (RGBA)
    
    final imagePtr = _pdfPageRenderToImage(
      page,
      scale,
      scaledWidth,
      scaledHeight,
      rowStride,
    );
    
    if (imagePtr == nullptr.cast<Uint8>()) {
      throw Exception('Failed to render page to image');
    }
    
    try {
      // Copier les données de l'image
      final imageBytes = imagePtr.asTypedList(scaledWidth * scaledHeight * 4);
      
      // Convertir RGBA en PNG (simplifié : on retourne les données brutes)
      // Note: Pour un vrai PNG, il faudrait utiliser un encodeur PNG
      return imageBytes;
    } finally {
      _pdfFreeImage(imagePtr);
    }
  }

  /// Récupère les données de géoréférencement (Viewport GEO)
  static Map<String, dynamic> getGeoData(Pointer<Void> page) {
    final result = <String, dynamic>{};
    final geoDataPtr = _pdfPageGetGeoData(page);
    
    if (geoDataPtr != nullptr.cast<Utf8>()) {
      final geoData = geoDataPtr.toDartString();
      // Parser le format: "EPSG:3857|minLon,minLat,maxLon,maxLat|gpts|lpts"
      final parts = geoData.split('|');
      if (parts.length >= 2) {
        result['crs'] = parts[0];
        final bounds = parts[1].split(',').map(double.parse).toList();
        if (bounds.length >= 4) {
          result['bounds'] = bounds;
        }
        if (parts.length >= 3) {
          result['gpts'] = parts[2].split(',').map(double.parse).toList();
        }
        if (parts.length >= 4) {
          result['lpts'] = parts[3].split(',').map(double.parse).toList();
        }
      }
    }
    
    return result;
  }

  /// Libère une page
  static void freePage(Pointer<Void> page) {
    // À implémenter dans le code C++
    // Pour l'instant, on ne fait rien (la page est libérée avec le document)
  }

  // ============================================================================
  // Fonctions utilitaires
  // ============================================================================

  /// Alloue de la mémoire
  static final malloc = _libSafe.lookupFunction<
    Pointer<Void> Function(Int64),
    Pointer<Void> Function(int)
  >('malloc');
  
  /// Libère de la mémoire
  static final free = _libSafe.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('free');

  /// Pointer nul
  static final nullptr = Pointer<Void>.fromAddress(0);
}

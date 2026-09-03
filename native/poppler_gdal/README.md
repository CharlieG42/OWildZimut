# Poppler + GDAL Bindings pour OWildZimut

Ce dossier contient le code C++ pour les bindings FFI permettant de lire les fichiers GeoPDF depuis Flutter.

## Structure

```
native/poppler_gdal/
├── CMakeLists.txt          # Configuration CMake pour la compilation
├── src/
│   ├── poppler_bindings.h  # Headers pour les fonctions Poppler
│   ├── poppler_bindings.cpp # Implémentation Poppler
│   ├── gdal_bindings.h     # Headers pour les fonctions GDAL
│   ├── gdal_bindings.cpp    # Implémentation GDAL
│   ├── geopdf_utils.h      # Utilitaires pour les GeoPDF
│   └── geopdf_utils.cpp     # Implémentation des utilitaires
└── README.md
```

## Dépendances

### Pour Windows
- **Poppler** : Télécharger les binaires depuis [poppler.freedesktop.org](https://poppler.freedesktop.org/)
- **GDAL** : Télécharger depuis [gdal.org](https://gdal.org/)
- **CMake** : Pour la compilation

### Pour Android (via NDK)
- **Android NDK** : Version 21+ recommandée
- **Poppler** : À compiler avec le NDK
- **GDAL** : À compiler avec le NDK

### Pour Linux/macOS
- Installer via les paquets système :
  ```bash
  # Ubuntu/Debian
  sudo apt-get install libpoppler-dev libgdal-dev cmake
  
  # macOS (avec Homebrew)
  brew install poppler gdal cmake
  ```

## Compilation

### Windows (Visual Studio)
1. Ouvrir le projet dans Visual Studio avec CMake
2. Configurer les chemins vers Poppler et GDAL
3. Compiler en mode Release
4. Copier les DLL générées dans le dossier `windows/` de Flutter

### Android (NDK)
1. Configurer le NDK dans Android Studio
2. Ajouter le code C++ dans `android/app/src/main/cpp/`
3. Mettre à jour le `CMakeLists.txt` Android
4. Compiler avec Gradle

### Linux/macOS
```bash
mkdir build
cd build
cmake ..
make
```

## Intégration avec Flutter

### Pour Windows
1. Copier les DLL (`poppler.dll`, `gdal.dll`) dans `windows/runner/`
2. Mettre à jour les bindings Dart dans `lib/ffi/`

### Pour Android
1. Copier les librairies compilées dans `android/app/src/main/jniLibs/`
2. Mettre à jour le `CMakeLists.txt` dans `android/app/`

## Fonctions exposées

### Poppler Bindings
- `pdf_init()` : Initialise Poppler
- `pdf_doc_open(path)` : Ouvre un document PDF
- `pdf_doc_close(doc)` : Ferme un document PDF
- `pdf_doc_get_metadata(doc, key)` : Récupère les métadonnées
- `pdf_doc_get_page_count(doc)` : Récupère le nombre de pages
- `pdf_doc_get_page(doc, index)` : Récupère une page
- `pdf_page_get_size(page, width, height)` : Récupère la taille de la page
- `pdf_page_get_geo_data(page)` : Récupère les données de géoréférencement
- `pdf_page_render_to_image(page, scale, width, height, row_stride)` : Rend une page en image
- `pdf_free_image(image)` : Libère une image
- `pdf_free_string(str)` : Libère une chaîne

### GDAL Bindings
- `gdal_init()` : Initialise GDAL
- `gdal_open(path)` : Ouvre un dataset GDAL
- `gdal_close(dataset)` : Ferme un dataset
- `gdal_get_raster_size(dataset, width, height)` : Récupère la taille du raster
- `gdal_get_geo_transform(dataset, transform)` : Récupère la transformation géométrique
- `gdal_get_projection(dataset)` : Récupère le système de coordonnées
- `gdal_get_metadata(dataset)` : Récupère les métadonnées
- `gdal_read_raster_band(dataset, bandIndex, width, height, numComponents)` : Lit une bande raster
- `gdal_free_image(image)` : Libère une image
- `gdal_free_string(str)` : Libère une chaîne

### GeoPDF Utils
- `geopdf_parse(pdfPath)` : Parse un GeoPDF et extrait toutes les informations
- `geopdf_free(info)` : Libère une structure GeoPdfInfo
- `geopdf_to_json(info)` : Convertit en JSON

## Notes

- Les fonctions retournent des pointeurs vers des données allouées dynamiquement.
- **Il est de la responsabilité de l'appelant de libérer la mémoire** avec les fonctions `*_free`.
- Pour les chaînes de caractères, utiliser `pdf_free_string` ou `gdal_free_string`.
- Pour les images, utiliser `pdf_free_image` ou `gdal_free_image`.

## Exemple d'utilisation en Dart

```dart
import 'package:ffi/ffi.dart';
import 'poppler_bindings.dart';

void main() {
  PopplerBindings.init();
  
  final docPtr = PopplerBindings.openDocument('map.pdf');
  try {
    final metadata = PopplerBindings.getMetadata(docPtr);
    print('Title: ${metadata['Title']}');
    
    final pagePtr = PopplerBindings.getPage(docPtr, 0);
    final (width, height) = PopplerBindings.getPageSize(pagePtr);
    print('Page size: $width x $height');
    
    final geoData = PopplerBindings.getGeoData(pagePtr);
    print('CRS: ${geoData['crs']}');
    print('Bounds: ${geoData['bounds']}');
  } finally {
    PopplerBindings.closeDocument(docPtr);
  }
}
```

## Résolution des problèmes

### Erreur "DLL not found" sur Windows
- Vérifier que les DLL sont dans le chemin de l'exécutable
- Copier les DLL dans `windows/runner/`
- Vérifier que les noms correspondent aux bindings Dart

### Erreur "symbol not found" sur Android
- Vérifier que les librairies sont compilées pour la bonne architecture (arm64-v8a, armeabi-v7a, x86_64)
- Vérifier que les librairies sont dans `android/app/src/main/jniLibs/<arch>/`

### Problèmes de mémoire
- Toujours libérer les pointeurs retournés par les fonctions C++
- Utiliser `malloc.free` pour les pointeurs alloués avec `malloc`
- Utiliser les fonctions `*_free` pour les données allouées par Poppler/GDAL

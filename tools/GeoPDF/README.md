# 📄 GeoPDF Import Toolkit pour OWildZimut

Ce dossier contient la **documentation et les scripts** pour compiler et utiliser les fonctionnalités d'import de **GeoPDF** dans OWildZimut.

OWildZimut supporte désormais **deux modes d'import pour les GeoPDF** :

1. **🔄 Conversion GeoPDF → OMAP** : Convertit un PDF géoréférencé en un fichier **OMAP** + image de fond, compatible avec l'architecture existante.
2. **🖼️ Superposition Raster** : Charge directement le GeoPDF comme une **image de fond géoréférencée**, sans conversion.

---

## 🎯 Fonctionnalités

| **Option** | **Description** | **Fichiers générés** | **Calques éditables** | **Géoréférencement** |
|-----------|----------------|----------------------|-----------------------|----------------------|
| **Conversion → OMAP** | Convertit le GeoPDF en format OMAP (XML) + image PNG | `map.omap`, `background.png` | ❌ Non (image statique) | ✅ Oui (dans le fichier OMAP) |
| **Superposition Raster** | Charge le GeoPDF comme image de fond géoréférencée | Aucun (chargement en mémoire) | ❌ Non | ✅ Oui (en mémoire) |

---

## 📦 Prérequis

Pour utiliser les fonctionnalités GeoPDF, vous devez **compiler les librairies natives** pour votre plateforme.
Les dépendances principales sont :

- **[Poppler](https://poppler.freedesktop.org/)** : Pour lire les fichiers PDF et extraire les métadonnées/Viewport GEO.
- **[GDAL](https://gdal.org/)** : Pour le géoréférencement avancé (fallback si Poppler ne trouve pas les données).

---

## 🛠️ Structure des dossiers

```
OWildZimut/
├── lib/
│   ├── ffi/
│   │   ├── poppler_bindings.dart    # Bindings Dart pour Poppler
│   │   └── gdal_bindings.dart       # Bindings Dart pour GDAL
│   ├── models/
│   │   ├── map_metadata.dart         # Modèle des métadonnées
│   │   ├── georeferencing_data.dart  # Données de géoréférencement
│   │   └── geo_pdf_data.dart         # Modèle GeoPDF
│   └── services/
│       ├── geo_pdf_service.dart     # Service principal GeoPDF
│       └── import_service.dart       # Service d'import unifié
├── native/
│   └── poppler_gdal/
│       ├── CMakeLists.txt            # Configuration CMake
│       └── src/
│           ├── poppler_bindings.h/cpp # Wrapper C++ pour Poppler
│           ├── gdal_bindings.h/cpp    # Wrapper C++ pour GDAL
│           └── geopdf_utils.h/cpp     # Utilitaires GeoPDF
├── android/
│   └── app/src/main/
│       ├── cpp/                      # Code NDK pour Android
│       │   ├── CMakeLists.txt
│       │   ├── Android.mk
│       │   └── *.cpp/*.h
│       └── java/
│           └── com/owildzimut/
│               └── GeopdfNative.java   # Bindings JNI
├── windows/
│   └── runner/                       # DLL pour Windows
│       ├── poppler.dll
│       └── gdal.dll
└── tools/
    └── GeoPDF/                       # **Ce dossier**
        ├── README.md                 # Documentation
        ├── compile_windows.bat      # Script de compilation Windows
        ├── compile_windows.sh       # Script de compilation Windows (Bash)
        ├── compile_android.sh        # Script de compilation Android
        └── verify_geopdf.py          # Script de vérification
```

---

## 📖 Comment ça marche ?

### 1️⃣ Extraction des données d'un GeoPDF

Un **GeoPDF** (comme ceux générés par [OpenOrienteeringMap](https://oomap.dna-software.co.uk/)) contient :

- **Métadonnées standard** : Titre, auteur, date de création, etc.
- **Viewport GEO** : Structure Adobe PDF qui définit le géoréférencement avec :
  - **GPTS** : Coordonnées géographiques des coins (ex: `45.97356, 4.0223`).
  - **LPTS** : Coordonnées locales dans le PDF (ex: `0, 0`).
  - **CRS** : Système de coordonnées (ex: `EPSG:3857`).
- **Image raster** : La carte elle-même (PNG/JPG embarquée dans le PDF).

#### Exemple de Viewport GEO dans ton fichier `oom_Villerest.pdf` :
```
Viewport GEO:
- CRS: EPSG:3857
- GPTS: [45.97356, 4.0223, 46.00021, 4.02401, 45.99938, 4.05113, 45.97272, 4.04942]
- LPTS: [0, 1, 0, 0, 1, 0, 1, 1]
- Bounds: [4.0223°E, 45.97272°N, 4.05113°E, 46.00021°N]
```

### 2️⃣ Conversion GeoPDF → OMAP

1. **Poppler** ouvre le PDF et extrait :
   - Métadonnées (`/Title`, `/Author`, etc.).
   - Viewport GEO (si présent).
   - Taille de la page (en points).
2. **L'image de la première page** est rendue en PNG (300 DPI par défaut).
3. Un **fichier OMAP** est généré avec :
   - Métadonnées dans `<metadata>`.
   - Géoréférencement dans `<georeferencing>`.
   - Référence à l'image de fond dans `<background>`.
4. Les fichiers sont sauvegardés dans :
   ```
   [Dossier de l'app]/maps/<nom_carte>/
     ├── map.omap
     ├── background.png
     └── metadata.json (optionnel)
   ```

### 3️⃣ Superposition Raster

1. Même extraction que la conversion (métadonnées + géoréférencement + image).
2. Les données sont **chargées en mémoire** et peuvent être :
   - Affichées directement comme image de fond.
   - Superposées avec d'autres calques.
   - Sauvegardées dans `maps/` si nécessaire.

---

## 🚀 Compilation des librairies natives

### 🪟 **Pour Windows**

#### **Méthode 1 : Avec vcpkg (recommandé)**

1. **Installer vcpkg** :
   ```powershell
   git clone https://github.com/microsoft/vcpkg.git
   cd vcpkg
   .\bootstrap-vcpkg.bat
   ```

2. **Installer les dépendances** :
   ```powershell
   .\vcpkg install poppler gdal --triplet x64-windows
   ```

3. **Compiler les bindings** :
   - Ouvrir **CMake GUI** ou utiliser la ligne de commande :
     ```powershell
     cd OWildZimut\native\poppler_gdal
     mkdir build && cd build
     cmake .. -DCMAKE_TOOLCHAIN_FILE=[chemin_vers_vcpkg]\scripts\buildsystems\vcpkg.cmake -DCMAKE_BUILD_TYPE=Release
     cmake --build . --config Release
     ```

4. **Copier les DLL** :
   - Copier les fichiers générés dans `build/Release/` vers :
     ```
     OWildZimut\windows\runner\poppler.dll
     OWildZimut\windows\runner\gdal.dll
     ```

#### **Méthode 2 : Avec MSYS2**

1. **Installer MSYS2** : [https://www.msys2.org/](https://www.msys2.org/)
2. **Installer les dépendances** :
   ```bash
   pacman -S mingw-w64-x86_64-poppler mingw-w64-x86_64-gdal cmake
   ```
3. **Compiler** :
   ```bash
   cd OWildZimut/native/poppler_gdal
   mkdir build && cd build
   cmake .. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
   cmake --build .
   ```
4. **Copier les DLL** dans `windows/runner/`.

#### **Méthode 3 : Utiliser le script fourni**
Exécuter simplement :
```powershell
cd OWildZimut\tools\GeoPDF
compile_windows.bat
```
*(Le script est généré ci-dessous.)*

---

### 🤖 **Pour Android**

#### **Prérequis**
- **Android NDK** : Version 21+ (installée via Android Studio).
- **CMake** : Version 3.10+. 
- **Java JDK** : Version 8+.

#### **Étapes**

1. **Télécharger le NDK** :
   - Dans Android Studio : `Tools > SDK Manager > Android NDK`.
   - Ou manuellement : [https://developer.android.com/ndk/downloads](https://developer.android.com/ndk/downloads).

2. **Configurer le NDK dans `local.properties`** :
   ```properties
   ndk.dir=[chemin_vers_ndk]
   sdk.dir=[chemin_vers_sdk]
   ```

3. **Compiler Poppler et GDAL pour Android** :
   - **Option A** : Utiliser des librairies pré-compilées (recommandé).
     - Télécharger depuis [Termux](https://github.com/termux/termux-packages) ou [OSGeo4A](https://github.com/OSGeo/gdal/releases).
     - Placer les `.so` dans :
       ```
       android/app/src/main/jniLibs/arm64-v8a/libpoppler.so
       android/app/src/main/jniLibs/arm64-v8a/libgdal.so
       ```
   - **Option B** : Compiler depuis les sources (complexe).
     - Suivre les instructions de [Poppler pour Android](https://github.com/albertlatacz/android-poppler).

4. **Compiler les bindings natifs** :
   - Dans Android Studio, **Build > Make Project** (CMake s’occupera du reste).
   - Ou en ligne de commande :
     ```bash
     cd OWildZimut/android
     ./gradlew assembleDebug
     ```

5. **Vérifier l’intégration** :
   - Les librairies compilées seront dans `android/app/build/intermediates/cmake/`.

#### **Utiliser le script fourni**
Exécuter :
```bash
cd OWildZimut/tools/GeoPDF
./compile_android.sh
```

---

## 📜 Scripts de compilation

### 1️⃣ [`compile_windows.bat`](./compile_windows.bat)
Script pour compiler les librairies **Poppler + GDAL** pour Windows avec **vcpkg**.

---

### 2️⃣ [`compile_windows.sh`](./compile_windows.sh)
Script pour compiler les librairies **Poppler + GDAL** pour Windows avec **MSYS2** (Bash).

---

### 3️⃣ [`compile_android.sh`](./compile_android.sh)
Script pour compiler les librairies **Poppler + GDAL** pour Android avec le **NDK**.

---

## 🔍 Vérification des dépendances

### **Vérifier que Poppler et GDAL sont installés**
Exécuter le script Python fourni :
```bash
python tools/GeoPDF/verify_geopdf.py --check-dependencies
```

### **Tester la lecture d'un GeoPDF**
```bash
python tools/GeoPDF/verify_geopdf.py --test-file assets/oomWeb/oom_Villerest.pdf
```
*(Affiche les métadonnées et le géoréférencement extraits.)*

---

## 🐛 Dépannage

### **Problèmes courants sur Windows**

| **Erreur** | **Solution** |
|------------|--------------|
| `poppler.dll introuvable` | Vérifier que `poppler.dll` est dans `windows/runner/`. |
| `gdal.dll introuvable` | Copier `gdal.dll` dans le même dossier. |
| `Erreur de chargement de la DLL` | Vérifier l'architecture (x64 vs x86). |
| `CMake ne trouve pas Poppler` | Spécifier le chemin avec `-DPOPPLER_DIR=[chemin]`. |

### **Problèmes courants sur Android**

| **Erreur** | **Solution** |
|------------|--------------|
| `libpoppler.so introuvable` | Vérifier que le fichier est dans `jniLibs/arm64-v8a/`. |
| `NDK non trouvé` | Configurer `ndk.dir` dans `local.properties`. |
| `Erreur de compilation C++` | Vérifier la version du NDK (21+ recommandée). |
| `Symboles manquants` | Utiliser les mêmes versions de Poppler/GDAL pour toutes les architectures. |

### **Problèmes généraux**

| **Erreur** | **Solution** |
|------------|--------------|
| `FFI: DynamicLibrary.open failed` | Vérifier que les librairies sont dans le chemin. |
| `PDF non géoréférencé` | Le fichier n'a pas de Viewport GEO. Utiliser l'Option 2 (calibration manuelle). |
| `Permission denied` | Donner les permissions de lecture/écriture sur les dossiers. |

---

## 📚 Exemples d'utilisation

### **1. Conversion GeoPDF → OMAP (Dart)**
```dart
import 'package:owildzimut/services/geo_pdf_service.dart';

final service = GeoPdfService();
await service.init();

// Convertir un GeoPDF en OMAP
await service.convertGeoPdfToOmap('assets/oomWeb/oom_Villerest.pdf');
// Résultat: Dossier créé dans maps/villerest/ avec map.omap + background.png
```

### **2. Superposition Raster (Dart)**
```dart
import 'package:owildzimut/services/geo_pdf_service.dart';

final service = GeoPdfService();
await service.init();

// Charger un GeoPDF comme raster
ginal geoPdfData = await service.loadGeoPdfAsRaster('assets/oomWeb/oom_Villerest.pdf');
// geoPdfData contient: metadata, georef, imageData, mapName
```

### **3. Intégration dans l'UI**
```dart
import 'package:owildzimut/widgets/import_menu.dart';

AppBar(
  actions: [
    ImportMenu(
      importService: ImportService(),
      onImportCompleted: (result) {
        print('Import réussi: $result');
      },
    ),
  ],
)
```

---

## 📊 Fichiers générés par l'import

### **Option A : Conversion GeoPDF → OMAP**
```
maps/
  villerest/
    ├── map.omap          # Fichier OMAP (XML)
    ├── background.png     # Image de fond (PNG)
    └── metadata.json     # Métadonnées (optionnel)
```

**Contenu de `map.omap`** :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<map>
  <metadata>
    <title>OpenOrienteeringMap</title>
    <author>OpenOrienteeringMap</author>
    <crs>EPSG:3857</crs>
    <scale>10000</scale>
    <geographicBounds>4.0223,45.97272,4.05113,46.00021</geographicBounds>
  </metadata>
  <georeferencing>
    <grid>4.0223,45.97272 4.05113,45.97272 4.05113,46.00021 4.0223,46.00021</grid>
    <crs>EPSG:3857</crs>
  </georeferencing>
  <background>
    <image src="background.png" />
  </background>
</map>
```

### **Option B : Superposition Raster**
- **Aucun fichier généré par défaut** (les données sont en mémoire).
- **Optionnel** : Sauvegarder manuellement dans `maps/` avec `geoPdfData.saveToDirectory()`.

---

## 🔗 Ressources utiles

- **Poppler** : [https://poppler.freedesktop.org/](https://poppler.freedesktop.org/)
- **GDAL** : [https://gdal.org/](https://gdal.org/)
- **OpenOrienteeringMap** : [https://oomap.dna-software.co.uk/](https://oomap.dna-software.co.uk/)
- **Flutter FFI** : [https://docs.flutter.dev/development/platform-integration/c-interop](https://docs.flutter.dev/development/platform-integration/c-interop)
- **Android NDK** : [https://developer.android.com/ndk](https://developer.android.com/ndk)

---

## 📝 Notes techniques

### **Gestion des doublons**
- Si un dossier existe déjà dans `maps/`, un suffixe `_2`, `_3`, etc. est ajouté automatiquement.
- Exemple : `maps/villerest/`, `maps/villerest_2/`, `maps/villerest_3/`.

### **Systèmes de coordonnées (CRS)**
- Les GeoPDF d'OpenOrienteeringMap utilisent **EPSG:3857** (Web Mercator).
- Le code supporte aussi **EPSG:4326** (WGS84) et d'autres CRS via GDAL.
- La conversion entre CRS peut être ajoutée si nécessaire.

### **Résolution (DPI)**
- Par défaut, les images sont rendues en **300 DPI** (comme dans les GeoPDF OOM).
- La résolution peut être ajustée dans le code C++ (`pdf_page_render_to_image`).

### **Performances**
- **Windows** : Rapide (Poppler/GDAL optimisés).
- **Android** : Dépend de la puissance du device. Pour les grands PDF, réduire le DPI.

---

## 🎓 FAQ

### **Q: Pourquoi ne pas utiliser un package Dart pur pour les PDF ?**
R: Les packages Dart comme [`pdf`](https://pub.dev/packages/pdf) ne supportent pas :
- La lecture des **Viewport GEO** (spécifique aux GeoPDF).
- L'extraction d'**images haute résolution** depuis un PDF.
- Le **géoréférencement avancé** (nécessite Poppler/GDAL).

### **Q: Puis-je utiliser cette fonctionnalité sans compiler le code C++ ?**
R: Non, les **bindings FFI** nécessitent les librairies natives (Poppler/GDAL).
Cependant, vous pouvez :
1. Utiliser un **backend externe** (ex: un serveur Node.js/Python avec Poppler/GDAL).
2. Utiliser la **calibration manuelle** (Option 2 de l'import d'images).

### **Q: Comment ajouter le support d'autres formats (ex: GeoTIFF) ?**
R: Étendre les bindings GDAL pour supporter d'autres formats. GDAL gère déjà :
- GeoTIFF
- Shapefile
- KML
- Et bien d'autres...

### **Q: Les calques vectoriels du PDF sont-ils conservés ?**
R: **Non**, les GeoPDF générés par OpenOrienteeringMap sont des **images raster** avec géoréférencement.
- Si vous avez besoin de calques vectoriels éditables, utilisez le format **OMAP** ou **OCAD**.
- Une solution future pourrait être d'utiliser **OCR + vectorisation** (ex: avec OpenCV).

---

## 🏁 Conclusion

Avec ce toolkit, OWildZimut peut désormais :
✅ **Importer des GeoPDF** (OpenOrienteeringMap, etc.).
✅ **Convertir les GeoPDF en OMAP** pour une intégration native.
✅ **Charger les GeoPDF comme images géoréférencées**.
✅ **Conserver toutes les métadonnées** (titre, auteur, échelle, etc.).

Pour activer ces fonctionnalités, il suffit de :
1. **Compiler les librairies natives** (voir scripts ci-dessus).
2. **Intégrer le `ImportMenu`** dans votre UI.
3. **Tester avec un GeoPDF** (ex: `assets/oomWeb/oom_Villerest.pdf`).

---

**Besoin d'aide ?** Ouvrez une issue sur GitHub ou consultez la documentation officielle de Poppler/GDAL.

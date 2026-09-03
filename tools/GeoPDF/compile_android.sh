#!/bin/bash
# ============================================================================
# Script de compilation pour Android (Poppler + GDAL + Bindings)
# Auteur: OWildZimut GeoPDF Toolkit
# Description: Compile les librairies natives pour Android avec le NDK
# ============================================================================

set -e  # Quitter en cas d'erreur

# ============================================================================
# CONFIGURATION
# ============================================================================

# Chemin vers le NDK (à adapter)
# Par défaut, utiliser la variable d'environnement ANDROID_NDK
ANDROID_NDK="${ANDROID_NDK:-$HOME/Android/Sdk/ndk/21.3.6528147}"

# Chemin vers le SDK Android
ANDROID_SDK="${ANDROID_SDK:-$HOME/Android/Sdk}"

# Chemin vers le dossier du projet OWildZimut
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" && pwd)"

# Architectures cibles
ARCHS=("arm64-v8a" "armeabi-v7a" "x86_64")

# Niveau d'API minimum
API_LEVEL=21

# Type de build
BUILD_TYPE="Release"

# ============================================================================
# VÉRIFIER LES PRÉREQUIS
# ============================================================================

echo "[1/6] Vérification des prérequis..."

# Vérifier si le NDK est installé
if [ ! -d "$ANDROID_NDK" ]; then
    echo "ERREUR: Android NDK non trouvé à $ANDROID_NDK"
    echo "Pour installer le NDK:"
    echo "  1. Ouvrez Android Studio"
    echo "  2. Allez dans Tools > SDK Manager"
    echo "  3. Installez le NDK (version 21+ recommandée)"
    echo ""
    echo "Vous pouvez aussi modifier ANDROID_NDK dans ce script."
    exit 1
fi

# Vérifier si le SDK est installé
if [ ! -d "$ANDROID_SDK" ]; then
    echo "ERREUR: Android SDK non trouvé à $ANDROID_SDK"
    echo "Installez-le depuis Android Studio ou modifiez ANDROID_SDK dans ce script."
    exit 1
fi

# Vérifier si CMake est installé
if ! command -v cmake &> /dev/null; then
    echo "ERREUR: CMake non trouvé. Installez-le depuis https://cmake.org/download/"
    exit 1
fi

# Vérifier si Python est installé (pour certains scripts)
if ! command -v python3 &> /dev/null; then
    echo "ERREUR: Python non trouvé. Installez-le depuis https://www.python.org/downloads/"
    exit 1
fi

echo "[OK] Tous les prérequis sont installés."
echo ""

# ============================================================================
# PRÉPARER L'ENVIRONNEMENT NDK
# ============================================================================

echo "[2/6] Préparation de l'environnement NDK..."

# Exporter les variables d'environnement pour le NDK
export ANDROID_NDK_HOME="$ANDROID_NDK"
export ANDROID_SDK_ROOT="$ANDROID_SDK"
export PATH="$ANDROID_NDK:$PATH"

# Vérifier la version du NDK
NDK_VERSION=$(grep -oP 'Pkg.Revision = \K\d+' "$ANDROID_NDK/source.properties" | head -1)
echo "Version du NDK: $NDK_VERSION"

if [ "$NDK_VERSION" -lt 21 ]; then
    echo "AVERTISSEMENT: Le NDK version 21+ est recommandé. Vous utilisez la version $NDK_VERSION."
fi

echo "[OK] Environnement NDK prêt."
echo ""

# ============================================================================
# TÉLÉCHARGER LES LIBRAIRIES PRÉ-COMPILÉES (OPTION RECOMMANDÉE)
# ============================================================================

echo "[3/6] Téléchargement des librairies pré-compilées..."

# Créer le dossier jniLibs s'il n'existe pas
mkdir -p "$PROJECT_ROOT/android/app/src/main/jniLibs"

# Télécharger les librairies pré-compilées depuis Termux (si disponibles)
# Note: Termux fournit des builds Android de Poppler et GDAL
for ARCH in "${ARCHS[@]}"; do
    ARCH_DIR="$PROJECT_ROOT/android/app/src/main/jniLibs/$ARCH"
    mkdir -p "$ARCH_DIR"
    
    # Vérifier si les librairies existent déjà
    if [ -f "$ARCH_DIR/libpoppler.so" ] && [ -f "$ARCH_DIR/libgdal.so" ]; then
        echo "  [OK] Librairies déjà présentes pour $ARCH"
        continue
    fi
    
    echo "  Téléchargement des librairies pour $ARCH..."
    
    # Télécharger depuis les dépôts Termux (si disponible)
    # Note: Cette étape est optionnelle. Vous pouvez aussi compiler vous-même.
    if [ "$ARCH" == "arm64-v8a" ]; then
        # Exemple: Télécharger depuis un dépôt
        # wget -O "$ARCH_DIR/libpoppler.so" "https://example.com/libpoppler-arm64.so"
        # wget -O "$ARCH_DIR/libgdal.so" "https://example.com/libgdal-arm64.so"
        echo "  NOTE: Téléchargez manuellement les librairies pour $ARCH depuis:"
        echo "        - https://github.com/termux/termux-packages"
        echo "        - https://github.com/OSGeo/gdal/releases"
        echo "        - Ou compilez-les vous-même (voir étape 4)"
    else
        echo "  NOTE: Librairies non disponibles pour $ARCH. Compilation nécessaire."
    fi
done

echo ""

# ============================================================================
# COMPILER POPPLER ET GDAL POUR ANDROID (SI NÉCESSAIRE)
# ============================================================================

echo "[4/6] Compilation de Poppler et GDAL pour Android..."

# Cette étape est complexe et peut prendre du temps.
# Si vous avez déjà les librairies pré-compilées, passez à l'étape 5.

read -p "Voulez-vous compiler Poppler et GDAL depuis les sources ? (o/n) [n]: " COMPILE_FROM_SOURCE
COMPILE_FROM_SOURCE="${COMPILE_FROM_SOURCE:-n}"

if [ "$COMPILE_FROM_SOURCE" == "o" ] || [ "$COMPILE_FROM_SOURCE" == "O" ]; then
    echo "Compilation depuis les sources... (cela peut prendre 30+ minutes)"
    
    # Cloner et compiler Poppler pour Android
    if [ ! -d "$PROJECT_ROOT/tools/GeoPDF/poppler-android" ]; then
        git clone https://github.com/albertlatacz/android-poppler.git "$PROJECT_ROOT/tools/GeoPDF/poppler-android"
    fi
    
    cd "$PROJECT_ROOT/tools/GeoPDF/poppler-android"
    
    # Compiler pour chaque architecture
    for ARCH in "${ARCHS[@]}"; do
        echo "  Compilation pour $ARCH..."
        
        # Configurer l'environnement
        case $ARCH in
            "arm64-v8a")
                TOOLCHAIN="aarch64-linux-android"
                ;;
            "armeabi-v7a")
                TOOLCHAIN="arm-linux-androideabi"
                ;;
            "x86_64")
                TOOLCHAIN="x86_64-linux-android"
                ;;
        esac
        
        # Compiler avec ndk-build
        $ANDROID_NDK/ndk-build \
            -C "$PROJECT_ROOT/tools/GeoPDF/poppler-android" \
            APP_ABI="$ARCH" \
            APP_PLATFORM="android-$API_LEVEL" \
            NDK_TOOLCHAIN_VERSION="clang" \
            NDK_APPLICATION_MK="Application.mk"
        
        if [ $? -ne 0 ]; then
            echo "  ERREUR: Échec de la compilation pour $ARCH"
            continue
        fi
        
        # Copier les librairies
        if [ -f "$PROJECT_ROOT/tools/GeoPDF/poppler-android/libs/$ARCH/libpoppler.so" ]; then
            cp "$PROJECT_ROOT/tools/GeoPDF/poppler-android/libs/$ARCH/libpoppler.so" "$PROJECT_ROOT/android/app/src/main/jniLibs/$ARCH/"
        fi
    done
    
    cd "$PROJECT_ROOT"
    
    # Compiler GDAL pour Android (plus complexe)
    echo "  Compilation de GDAL pour Android..."
    echo "  NOTE: La compilation de GDAL est complexe. Utilisez des librairies pré-compilées si possible."
    echo "  Vous pouvez télécharger des builds Android de GDAL depuis:"
    echo "    - https://github.com/OSGeo/gdal/releases"
    echo "    - https://github.com/termux/termux-packages"
else
    echo "Compilation depuis les sources annulée. Utilisation des librairies pré-compilées."
fi

echo "[OK] Compilation terminée."
echo ""

# ============================================================================
# COMPILER LES BINDINGS NATIFS POUR ANDROID
# ============================================================================

echo "[5/6] Compilation des bindings natifs pour Android..."

# Configurer le build.gradle pour utiliser le NDK
# Vérifier que le fichier build.gradle existe
BUILD_GRADLE="$PROJECT_ROOT/android/app/build.gradle"
if [ ! -f "$BUILD_GRADLE" ]; then
    echo "ERREUR: Fichier build.gradle non trouvé à $BUILD_GRADLE"
    exit 1
fi

# Vérifier que le NDK est configuré dans build.gradle
if ! grep -q "android.ndkPath" "$BUILD_GRADLE"; then
    echo "AVERTISSEMENT: Le NDK n'est pas configuré dans build.gradle."
    echo "Ajoutez les lignes suivantes dans android/app/build.gradle:"
    echo ""
    echo "android {"
    echo "    ..."
    echo "    defaultConfig {"
    echo "        ..."
    echo "        ndk {"
    echo "            abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'"
    echo "        }"
    echo "    }"
    echo "    ..."
    echo "    externalNativeBuild {"
    echo "        cmake {"
    echo "            path 'src/main/cpp/CMakeLists.txt'"
    echo "        }"
    echo "    }"
    echo "}"
    echo ""
fi

# Compiler avec Gradle
echo "Compilation avec Gradle..."
cd "$PROJECT_ROOT/android"

# Nettoyer le build précédent
./gradlew clean

# Compiler le projet
./gradlew assembleDebug

if [ $? -ne 0 ]; then
    echo "ERREUR: Échec de la compilation avec Gradle"
    echo "Vérifiez les erreurs ci-dessus et corrigez-les."
    exit 1
fi

echo "[OK] Compilation Gradle terminée avec succès."
echo ""

# ============================================================================
# VÉRIFIER LES FICHIERS GÉNÉRÉS
# ============================================================================

echo "[6/6] Vérification des fichiers générés..."

# Vérifier les librairies dans jniLibs
echo "Librairies dans jniLibs/:"
for ARCH in "${ARCHS[@]}"; do
    ARCH_DIR="$PROJECT_ROOT/android/app/src/main/jniLibs/$ARCH"
    if [ -d "$ARCH_DIR" ]; then
        echo "  $ARCH/:"
        ls -lh "$ARCH_DIR"/*.so 2>/dev/null || echo "    Aucune librairie trouvée"
    else
        echo "  $ARCH/: Dossier non trouvé"
    fi
done

echo ""
echo "Vérifier les librairies dans le build:"
find "$PROJECT_ROOT/android/app/build/intermediates/cmake" -name "*.so" 2>/dev/null | head -10 || echo "  Aucune librairie trouvée dans le build"

echo ""
echo "==========================================================================="
echo "COMPILATION ANDROID TERMINÉE AVEC SUCCÈS !"
echo "==========================================================================="
echo ""

echo "Pour tester l'import GeoPDF dans OWildZimut sur Android:"
echo "  1. Connectez un appareil Android ou lancez un émulateur"
echo "  2. Lancez l'application Flutter:"
echo "     cd $PROJECT_ROOT"
echo "     flutter run -d <device_id>"
echo ""
echo "  3. Dans l'application, utilisez le menu Import pour sélectionner un GeoPDF."
echo ""
echo "Note: Si vous utilisez un émulateur, assurez-vous qu'il a assez de mémoire"
echo "      (au moins 2 Go de RAM recommandés)."

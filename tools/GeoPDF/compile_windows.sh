#!/bin/bash
# ============================================================================
# Script de compilation pour Windows (Poppler + GDAL + Bindings)
# Auteur: OWildZimut GeoPDF Toolkit
# Description: Compile les librairies natives pour Windows avec MSYS2
# ============================================================================

set -e  # Quitter en cas d'erreur

# ============================================================================
# CONFIGURATION
# ============================================================================

# Chemin vers MSYS2 (à adapter si nécessaire)
MSYS2_ROOT="${MSYS2_ROOT:-/c/msys64}"

# Chemin vers le dossier du projet OWildZimut
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" && pwd)"

# Architecture cible (x86_64 ou i686)
ARCH="x86_64"

# Type de build (Release ou Debug)
BUILD_TYPE="Release"

# ============================================================================
# VÉRIFIER LES PRÉREQUIS
# ============================================================================

echo "[1/5] Vérification des prérequis..."

# Vérifier si MSYS2 est installé
if [ ! -d "$MSYS2_ROOT" ]; then
    echo "ERREUR: MSYS2 non trouvé à $MSYS2_ROOT"
    echo "Pour installer MSYS2:"
    echo "  1. Téléchargez depuis https://www.msys2.org/"
    echo "  2. Installez dans C:\\msys64 (par défaut)"
    echo "  3. Ajoutez MSYS2 à votre PATH"
    echo ""
    echo "Vous pouvez aussi modifier MSYS2_ROOT dans ce script."
    exit 1
fi

# Vérifier si pacman est disponible
if ! command -v pacman &> /dev/null; then
    echo "ERREUR: pacman (MSYS2) non trouvé. Vérifiez votre installation MSYS2."
    exit 1
fi

# Vérifier si CMake est installé
if ! command -v cmake &> /dev/null; then
    echo "ERREUR: CMake non trouvé. Installez-le depuis https://cmake.org/download/"
    exit 1
fi

# Vérifier si gcc est disponible (via MSYS2)
if ! command -v gcc &> /dev/null; then
    echo "ERREUR: gcc non trouvé. Installez-le avec:"
    echo "  pacman -S mingw-w64-x86_64-gcc"
    exit 1
fi

echo "[OK] Tous les prérequis sont installés."
echo ""

# ============================================================================
# INSTALLER LES DÉPENDANCES AVEC PACMAN
# ============================================================================

echo "[2/5] Installation des dépendances avec pacman..."

# Mettre à jour pacman
pacman -Syu --noconfirm

# Installer les dépendances pour Poppler et GDAL
pacman -S --noconfirm \
    mingw-w64-x86_64-poppler \
    mingw-w64-x86_64-gdal \
    mingw-w64-x86_64-cmake \
    mingw-w64-x86_64-toolchain

if [ $? -ne 0 ]; then
    echo "ERREUR: Échec de l'installation des dépendances avec pacman"
    exit 1
fi

echo "[OK] Dépendances installées avec succès."
echo ""

# ============================================================================
# COMPILER LES BINDINGS POPPLER + GDAL
# ============================================================================

echo "[3/5] Compilation des bindings natifs..."

# Créer le dossier de build
BUILD_DIR="$PROJECT_ROOT/native/poppler_gdal/build"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configurer CMake pour MinGW
cmake .. \
    -G "MinGW Makefiles" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$PROJECT_ROOT/windows/runner"

if [ $? -ne 0 ]; then
    echo "ERREUR: Échec de la configuration CMake"
    cd "$PROJECT_ROOT"
    exit 1
fi

# Compiler le projet
cmake --build . --config "$BUILD_TYPE"

if [ $? -ne 0 ]; then
    echo "ERREUR: Échec de la compilation"
    cd "$PROJECT_ROOT"
    exit 1
fi

echo "[OK] Compilation terminée avec succès."
echo ""

# ============================================================================
# COPIER LES DLL DANS LE DOSSIER WINDOWS
# ============================================================================

echo "[4/5] Copie des DLL dans windows/runner/..."

# Créer le dossier windows/runner s'il n'existe pas
mkdir -p "$PROJECT_ROOT/windows/runner"

# Copier les DLL compilées
if [ -f "$BUILD_DIR/poppler.dll" ]; then
    cp "$BUILD_DIR/poppler.dll" "$PROJECT_ROOT/windows/runner/"
fi

if [ -f "$BUILD_DIR/gdal.dll" ]; then
    cp "$BUILD_DIR/gdal.dll" "$PROJECT_ROOT/windows/runner/"
fi

# Copier les DLL de dépendances depuis MSYS2
# Trouver les DLL nécessaires
MINGW_BIN="$MSYS2_ROOT/mingw64/bin"
for dll in "$MINGW_BIN"/*.dll; do
    if [[ "$dll" == *"poppler"* || "$dll" == *"gdal"* || "$dll" == *"stdc++"* || "$dll" == *"zlib"* ]]; then
        cp "$dll" "$PROJECT_ROOT/windows/runner/"
    fi
done

echo "[OK] DLL copiées avec succès."
echo ""

# ============================================================================
# VÉRIFIER LES FICHIERS GÉNÉRÉS
# ============================================================================

echo "[5/5] Vérification des fichiers générés..."

# Lister les DLL dans windows/runner
ls -lh "$PROJECT_ROOT/windows/runner/"*.dll

if [ $? -ne 0 ]; then
    echo "ERREUR: Aucune DLL trouvée dans windows/runner/"
    exit 1
fi

echo ""
echo "Fichiers clés générés:"
if [ -f "$PROJECT_ROOT/windows/runner/poppler.dll" ]; then
    echo "  - poppler.dll ($(stat -c%s "$PROJECT_ROOT/windows/runner/poppler.dll") octets)"
fi
if [ -f "$PROJECT_ROOT/windows/runner/gdal.dll" ]; then
    echo "  - gdal.dll ($(stat -c%s "$PROJECT_ROOT/windows/runner/gdal.dll") octets)"
fi

echo ""
echo "==========================================================================="
echo "COMPILATION TERMINÉE AVEC SUCCÈS !"
echo "==========================================================================="
echo ""

echo "Pour tester l'import GeoPDF dans OWildZimut:"
echo "  1. Lancez l'application Flutter:"
echo "     cd $PROJECT_ROOT"
echo "     flutter run -d windows"
echo ""
echo "  2. Dans l'application, utilisez le menu Import pour sélectionner un GeoPDF."
echo ""

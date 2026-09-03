@echo off
REM ============================================================================
REM Script de compilation pour Windows (Poppler + GDAL + Bindings)
REM Auteur: OWildZimut GeoPDF Toolkit
REM Description: Compile les librairies natives pour Windows avec vcpkg
REM ============================================================================

SETLOCAL ENABLEDELAYEDEXPANSION

REM ============================================================================
REM CONFIGURATION
REM ============================================================================

REM Chemin vers vcpkg (à adapter)
SET VCPKG_ROOT=%~dp0..\..\vcpkg

REM Chemin vers le dossier du projet OWildZimut
SET PROJECT_ROOT=%~dp0..\..

REM Architecture cible (x64 ou x86)
SET ARCH=x64

REM Type de build (Release ou Debug)
SET BUILD_TYPE=Release

REM ============================================================================
REM VÉRIFIER LES PRÉREQUIS
REM ============================================================================

echo [1/5] Vérification des prérequis...

REM Vérifier si vcpkg existe
IF NOT EXIST "%VCPKG_ROOT%\vcpkg.exe" (
    echo ERREUR: vcpkg non trouvé à %VCPKG_ROOT%
    echo Pour installer vcpkg:
    echo   1. git clone https://github.com/microsoft/vcpkg.git
    echo   2. cd vcpkg
    echo   3. .\bootstrap-vcpkg.bat
    echo
    echo Vous pouvez aussi modifier VCPKG_ROOT dans ce script.
    PAUSE
    EXIT /B 1
)

REM Vérifier si CMake existe
WHERE cmake >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo ERREUR: CMake non trouvé. Installez-le depuis https://cmake.org/download/
    PAUSE
    EXIT /B 1
)

REM Vérifier si Visual Studio est installé
WHERE cl >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Visual Studio non trouvé. Installez-le avec la charge de travail "Desktop development with C++"
    PAUSE
    EXIT /B 1
)

echo [OK] Tous les prérequis sont installés.
echo

REM ============================================================================
REM INSTALLER LES DÉPENDANCES AVEC VCPKG
REM ============================================================================

echo [2/5] Installation des dépendances avec vcpkg...

REM Installer Poppler et GDAL pour Windows %ARCH%
%VCPKG_ROOT%\vcpkg install poppler gdal --triplet %ARCH%-windows

IF %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Échec de l'installation des dépendances avec vcpkg
    PAUSE
    EXIT /B 1
)

echo [OK] Dépendances installées avec succès.
echo

REM ============================================================================
REM COMPILER LES BINDINGS POPPLER + GDAL
REM ============================================================================

echo [3/5] Compilation des bindings natifs...

REM Créer le dossier de build
IF NOT EXIST "%PROJECT_ROOT%\native\poppler_gdal\build" (
    mkdir "%PROJECT_ROOT%\native\poppler_gdal\build"
)

cd "%PROJECT_ROOT%\native\poppler_gdal\build"

REM Configurer CMake avec vcpkg
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE="%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" \
    -DCMAKE_BUILD_TYPE=%BUILD_TYPE% \
    -DCMAKE_INSTALL_PREFIX="%PROJECT_ROOT%\windows\runner"

IF %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Échec de la configuration CMake
    cd "%PROJECT_ROOT%"
    PAUSE
    EXIT /B 1
)

REM Compiler le projet
cmake --build . --config %BUILD_TYPE%

IF %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Échec de la compilation
    cd "%PROJECT_ROOT%"
    PAUSE
    EXIT /B 1
)

echo [OK] Compilation terminée avec succès.
echo

REM ============================================================================
REM COPIER LES DLL DANS LE DOSSIER WINDOWS
REM ============================================================================

echo [4/5] Copie des DLL dans windows/runner/...

REM Créer le dossier windows/runner s'il n'existe pas
IF NOT EXIST "%PROJECT_ROOT%\windows\runner" (
    mkdir "%PROJECT_ROOT%\windows\runner"
)

REM Copier les DLL compilées
copy "%PROJECT_ROOT%\native\poppler_gdal\build\%BUILD_TYPE%\poppler.dll" "%PROJECT_ROOT%\windows\runner\" >nul
copy "%PROJECT_ROOT%\native\poppler_gdal\build\%BUILD_TYPE%\gdal.dll" "%PROJECT_ROOT%\windows\runner\" >nul

REM Copier les DLL de vcpkg (Poppler et GDAL)
copy "%VCPKG_ROOT%\installed\%ARCH%-windows\bin\poppler-*.dll" "%PROJECT_ROOT%\windows\runner\" >nul
copy "%VCPKG_ROOT%\installed\%ARCH%-windows\bin\gdal*.dll" "%PROJECT_ROOT%\windows\runner\" >nul

REM Copier les DLL dépendantes (ex: libstdc++, zlib, etc.)
copy "%VCPKG_ROOT%\installed\%ARCH%-windows\bin\*.dll" "%PROJECT_ROOT%\windows\runner\" >nul

echo [OK] DLL copiées avec succès.
echo

REM ============================================================================
REM VÉRIFIER LES FICHIERS GÉNÉRÉS
REM ============================================================================

echo [5/5] Vérification des fichiers générés...

REM Lister les DLL dans windows/runner
DIR "%PROJECT_ROOT%\windows\runner\*.dll"

IF %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Aucune DLL trouvée dans windows/runner/
    PAUSE
    EXIT /B 1
)

echo
REM Afficher les DLL importantes
echo Fichiers clés générés:
IF EXIST "%PROJECT_ROOT%\windows\runner\poppler.dll" (
    echo   - poppler.dll")
IF EXIST "%PROJECT_ROOT%\windows\runner\gdal.dll" (
    echo   - gdal.dll")

REM Vérifier la taille des DLL
FOR %%F IN ("%PROJECT_ROOT%\windows\runner\poppler.dll" "%PROJECT_ROOT%\windows\runner\gdal.dll") DO (
    IF EXIST %%F (
        FOR %%A IN (%%F) DO (
            SET FILE_SIZE=%%~zA
            echo   %%~nxF: !FILE_SIZE! octets
        )
    )
)

echo
echo ===========================================================================
echo COMPILATION TERMINÉE AVEC SUCCÈS !
echo ===========================================================================
echo

echo Pour tester l'import GeoPDF dans OWildZimut:
    1. Lancez l'application Flutter:
       cd "%PROJECT_ROOT%"
       flutter run -d windows
    
    2. Dans l'application, utilisez le menu Import pour sélectionner un GeoPDF.

echo
PAUSE

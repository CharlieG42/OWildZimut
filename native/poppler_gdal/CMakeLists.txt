cmake_minimum_required(VERSION 3.10)
project(poppler_gdal_bindings LANGUAGES CXX)

# Version du projet
set(PROJECT_VERSION "1.0.0")

# Configuration pour les différentes plateformes
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Trouver les dépendances
find_package(Poppler REQUIRED)
find_package(GDAL REQUIRED)

# Inclure les headers
include_directories(
    ${Poppler_INCLUDE_DIRS}
    ${GDAL_INCLUDE_DIR}
)

# Lier les librairies
link_directories(
    ${Poppler_LIBRARY_DIRS}
    ${GDAL_LIBRARY_DIR}
)

# Source files
set(SOURCES
    src/poppler_bindings.cpp
    src/gdal_bindings.cpp
    src/geopdf_utils.cpp
)

# Créer la librairie partagée
if(WIN32)
    add_library(poppler_gdal SHARED ${SOURCES})
    target_link_libraries(poppler_gdal PRIVATE 
        ${Poppler_LIBRARIES}
        ${GDAL_LIBRARY}
        poppler
        gdal
    )
    # Sur Windows, renommer la librairie pour correspondre aux bindings Dart
    set_target_properties(poppler_gdal PROPERTIES OUTPUT_NAME poppler)
    set_target_properties(poppler_gdal PROPERTIES OUTPUT_NAME gdal)
else()
    # Pour Linux/Android/Mac
    add_library(poppler_gdal SHARED ${SOURCES})
    target_link_libraries(poppler_gdal PRIVATE 
        ${Poppler_LIBRARIES}
        ${GDAL_LIBRARY}
        poppler
        gdal
    )
endif()

# Configuration spécifique pour Android
if(ANDROID)
    # Utiliser le NDK
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdata-sections -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--build-id=sha1,--warn-shared-textrel,--fatal-warnings,--no-undefined,--build-id,--no-threads,--strip-all")
endif()

# Installation
install(TARGETS poppler_gdal
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

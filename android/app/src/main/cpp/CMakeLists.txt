cmake_minimum_required(VERSION 3.10.2)

# Projet pour les bindings natifs Android
project("owildzimut_native")

# Configuration pour Android
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Trouver le NDK
include_directories(
    ${ANDROID_NDK}/sources/cxx-stl/llvm-libc++/include
    ${ANDROID_NDK}/sources/cxx-stl/llvm-libc++abi/unwind/include
    ${ANDROID_NDK}/sources/android/cpplib
)

# Ajouter les sources
add_library(owildzimut_native SHARED
    geopdf_bindings.cpp
    poppler_wrapper.cpp
    gdal_wrapper.cpp
)

# Configuration spécifique pour Android
target_compile_options(owildzimut_native PRIVATE
    -fdata-sections
    -ffunction-sections
    -funwind-tables
    -fstack-protector-strong
    -no-canonical-prefixes
)

target_link_options(owildzimut_native PRIVATE
    -Wl,--build-id=sha1
    -Wl,--warn-shared-textrel
    -Wl,--fatal-warnings
    -Wl,--no-undefined
    -Wl,--no-threads
    -Wl,--strip-all
)

# Trouver les librairies pré-compilées
# Note: Pour Android, il est recommandé de pré-compiler Poppler et GDAL
# et de les inclure dans le projet

# Chemin vers les librairies pré-compilées (à adapter)
set(POPPLER_LIB_PATH ${CMAKE_SOURCE_DIR}/../../../../native/poppler_gdal/lib/android/${ANDROID_ABI})
set(GDAL_LIB_PATH ${CMAKE_SOURCE_DIR}/../../../../native/poppler_gdal/lib/android/${ANDROID_ABI})

# Lier les librairies
if(EXISTS ${POPPLER_LIB_PATH}/libpoppler.so)
    target_link_libraries(owildzimut_native PRIVATE 
        ${POPPLER_LIB_PATH}/libpoppler.so
        ${GDAL_LIB_PATH}/libgdal.so
    )
else()
    # Si les librairies ne sont pas disponibles, afficher un avertissement
    message(WARNING "Poppler/GDAL libraries not found for ABI ${ANDROID_ABI}. Please compile them first.")
endif()

# Inclure les headers
include_directories(
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/../../../../native/poppler_gdal/src
)

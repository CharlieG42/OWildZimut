#include "gdal_bindings.h"
#include <gdal_priv.h>

// Implémentation des fonctions GDAL pour Android
// Ces fonctions sont des wrappers autour de GDAL pour faciliter l'intégration

// Note: Ces fonctions sont déjà implémentées dans gdal_bindings.cpp
// Ce fichier est un wrapper pour Android si nécessaire

// Exemple d'adaptation pour Android : initialisation spécifique
void gdal_android_init() {
    GDALAllRegister();
    // Configuration spécifique pour Android
}

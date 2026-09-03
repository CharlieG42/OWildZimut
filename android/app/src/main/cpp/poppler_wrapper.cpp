#include "poppler_bindings.h"
#include <poppler/PDFDoc.h>
#include <poppler/Page.h>
#include <poppler/GlobalParams.h>
#include <cstring>
#include <sstream>
#include <iomanip>

// Implémentation des fonctions Poppler pour Android
// Ces fonctions sont des wrappers autour de Poppler pour faciliter l'intégration

// Note: Ces fonctions sont déjà implémentées dans poppler_bindings.cpp
// Ce fichier est un wrapper pour Android si nécessaire

// Si on utilise directement poppler_bindings.cpp, ce fichier peut être vide
// ou contenir des adaptations spécifiques à Android

// Exemple d'adaptation pour Android : gestion de la mémoire
void* android_malloc(size_t size) {
    return malloc(size);
}

void android_free(void* ptr) {
    free(ptr);
}

#ifndef GDAL_BINDINGS_H
#define GDAL_BINDINGS_H

#include <gdal_priv.h>
#include <string>

// Initialise GDAL (appelé une fois au démarrage)
extern "C" void gdal_init();

// Ouvre un dataset GDAL
extern "C" GDALDatasetH gdal_open(const char* path);

// Ferme un dataset GDAL
extern "C" void gdal_close(GDALDatasetH dataset);

// Récupère la taille du raster
extern "C" void gdal_get_raster_size(GDALDatasetH dataset, int* width, int* height);

// Récupère la transformation géométrique (GeoTransform)
// Retourne 0 en cas de succès, -1 en cas d'échec
extern "C" int gdal_get_geo_transform(GDALDatasetH dataset, double* transform);

// Récupère le système de coordonnées (WKT)
// Retourne une chaîne allouée dynamiquement (à libérer avec gdal_free_string)
extern "C" const char* gdal_get_projection(GDALDatasetH dataset);

// Récupère les métadonnées du dataset
// Retourne une chaîne au format "KEY=VALUE\0KEY=VALUE\0..." (à libérer avec gdal_free_string)
extern "C" const char* gdal_get_metadata(GDALDatasetH dataset);

// Lit les données d'une bande raster (simplifié pour les images RGB)
// Retourne un buffer RGBA alloué dynamiquement (à libérer avec gdal_free_image)
extern "C" unsigned char* gdal_read_raster_band(
    GDALDatasetH dataset,
    int bandIndex,
    int* width,
    int* height,
    int* numComponents
);

// Libère une image allouée par GDAL
extern "C" void gdal_free_image(unsigned char* image);

// Libère une chaîne allouée par GDAL
extern "C" void gdal_free_string(const char* str);

// Récupère les données de géoréférencement d'un GeoPDF
extern "C" const char* gdal_get_geopdf_data(const char* pdfPath);

#endif // GDAL_BINDINGS_H

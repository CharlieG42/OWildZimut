#ifndef GEOPDF_UTILS_H
#define GEOPDF_UTILS_H

#include <string>
#include <vector>
#include <map>

// Structure pour stocker les données de géoréférencement d'un GeoPDF
struct GeoPdfInfo {
    std::string crs;           // Système de coordonnées (ex: "EPSG:3857")
    std::vector<double> bounds; // Bounds géographiques (minLon, minLat, maxLon, maxLat)
    std::vector<double> gpts;   // Coordonnées géographiques des coins (8 valeurs)
    std::vector<double> lpts;   // Coordonnées locales des coins (8 valeurs)
    int width;                 // Largeur du PDF en points
    int height;                // Hauteur du PDF en points
    double dpi;                // Résolution en DPI
    std::map<std::string, std::string> metadata; // Métadonnées du PDF
};

// Parse un GeoPDF et extrait les informations de géoréférencement
extern "C" GeoPdfInfo* geopdf_parse(const char* pdfPath);

// Libère une structure GeoPdfInfo
extern "C" void geopdf_free(GeoPdfInfo* info);

// Convertit une structure GeoPdfInfo en chaîne JSON
extern "C" const char* geopdf_to_json(GeoPdfInfo* info);

#endif // GEOPDF_UTILS_H

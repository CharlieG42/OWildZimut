#include "gdal_bindings.h"
#include <gdal_priv.h>
#include <cstring>
#include <sstream>
#include <iomanip>
#include <vector>

// Initialise GDAL (appelé une fois au démarrage)
extern "C" void gdal_init() {
    GDALAllRegister();
}

// Ouvre un dataset GDAL
extern "C" GDALDatasetH gdal_open(const char* path) {
    return GDALOpen(path, GA_ReadOnly);
}

// Ferme un dataset GDAL
extern "C" void gdal_close(GDALDatasetH dataset) {
    if (dataset) {
        GDALClose(dataset);
    }
}

// Récupère la taille du raster
extern "C" void gdal_get_raster_size(GDALDatasetH dataset, int* width, int* height) {
    if (!dataset) {
        *width = 0;
        *height = 0;
        return;
    }
    
    *width = GDALGetRasterXSize(dataset);
    *height = GDALGetRasterYSize(dataset);
}

// Récupère la transformation géométrique (GeoTransform)
extern "C" int gdal_get_geo_transform(GDALDatasetH dataset, double* transform) {
    if (!dataset || !transform) {
        return -1;
    }
    
    return GDALGetGeoTransform(dataset, transform);
}

// Récupère le système de coordonnées (WKT)
extern "C" const char* gdal_get_projection(GDALDatasetH dataset) {
    if (!dataset) {
        return nullptr;
    }
    
    const char* proj = GDALGetProjectionRef(dataset);
    if (!proj || strlen(proj) == 0) {
        return nullptr;
    }
    
    // Allouer une copie de la chaîne
    char* copy = new char[strlen(proj) + 1];
    strcpy(copy, proj);
    return copy;
}

// Récupère les métadonnées du dataset
extern "C" const char* gdal_get_metadata(GDALDatasetH dataset) {
    if (!dataset) {
        return nullptr;
    }
    
    char** metadata = GDALGetMetadata(dataset, nullptr);
    if (!metadata) {
        return nullptr;
    }
    
    // Calculer la taille totale nécessaire
    size_t totalSize = 0;
    int count = 0;
    while (metadata[count] != nullptr) {
        totalSize += strlen(metadata[count]) + 1; // +1 pour le séparateur
        count++;
    }
    
    // Allouer le buffer de résultat
    char* result = new char[totalSize + 1];
    result[0] = '\0';
    
    // Concatenér les métadonnées
    char* ptr = result;
    for (int i = 0; i < count; i++) {
        strcpy(ptr, metadata[i]);
        ptr += strlen(metadata[i]);
        *ptr = '\0';
        ptr++;
    }
    *ptr = '\0';
    
    return result;
}

// Lit les données d'une bande raster
extern "C" unsigned char* gdal_read_raster_band(
    GDALDatasetH dataset,
    int bandIndex,
    int* width,
    int* height,
    int* numComponents
) {
    if (!dataset) {
        *width = 0;
        *height = 0;
        *numComponents = 0;
        return nullptr;
    }
    
    GDALRasterBandH band = GDALGetRasterBand(dataset, bandIndex);
    if (!band) {
        *width = 0;
        *height = 0;
        *numComponents = 0;
        return nullptr;
    }
    
    *width = GDALGetRasterBandXSize(band);
    *height = GDALGetRasterBandYSize(band);
    *numComponents = 1; // Par bande
    
    // Allouer le buffer pour les données
    size_t bufferSize = *width * *height;
    unsigned char* buffer = new unsigned char[bufferSize];
    
    // Lire les données
    CPLErr err = GDALRasterIO(
        band,
        GF_Read,
        0, 0, // Offset
        *width, *height, // Taille
        buffer,
        *width, *height, // Taille du buffer
        GDT_Byte, // Type de données
        0, 0 // Espacement
    );
    
    if (err != CE_None) {
        delete[] buffer;
        return nullptr;
    }
    
    return buffer;
}

// Libère une image allouée par GDAL
extern "C" void gdal_free_image(unsigned char* image) {
    if (image) {
        delete[] image;
    }
}

// Libère une chaîne allouée par GDAL
extern "C" void gdal_free_string(const char* str) {
    if (str) {
        delete[] str;
    }
}

// Récupère les données de géoréférencement d'un GeoPDF
extern "C" const char* gdal_get_geopdf_data(const char* pdfPath) {
    GDALDatasetH dataset = GDALOpen(pdfPath, GA_ReadOnly);
    if (!dataset) {
        return nullptr;
    }
    
    std::ostringstream oss;
    
    // Récupérer la transformation géométrique
    double transform[6];
    if (GDALGetGeoTransform(dataset, transform) == CE_None) {
        oss << "transform=" << std::fixed << std::setprecision(15);
        for (int i = 0; i < 6; i++) {
            if (i > 0) oss << ",";
            oss << transform[i];
        }
        oss << "|";
        
        // Calculer les bounds
        int width = GDALGetRasterXSize(dataset);
        int height = GDALGetRasterYSize(dataset);
        
        double minX = transform[0];
        double maxY = transform[3];
        double maxX = minX + width * transform[1]; // pixelWidth
        double minY = maxY + height * transform[5]; // pixelHeight (négatif)
        
        oss << "bounds=" << minX << "," << minY << "," << maxX << "," << maxY << "|";
    }
    
    // Récupérer le CRS
    const char* proj = GDALGetProjectionRef(dataset);
    if (proj && strlen(proj) > 0) {
        oss << "crs=" << proj << "|";
        
        // Extraire l'EPSG si possible
        std::string projStr(proj);
        size_t epsgPos = projStr.find("EPSG:");
        if (epsgPos != std::string::npos) {
            size_t endPos = projStr.find_first_not_of("0123456789", epsgPos + 5);
            if (endPos != std::string::npos) {
                oss << "epsg=" << projStr.substr(epsgPos + 5, endPos - (epsgPos + 5)) << "|";
            } else {
                oss << "epsg=" << projStr.substr(epsgPos + 5) << "|";
            }
        }
    }
    
    // Récupérer les métadonnées
    char** metadata = GDALGetMetadata(dataset, nullptr);
    if (metadata) {
        oss << "metadata=";
        int count = 0;
        while (metadata[count] != nullptr) {
            if (count > 0) oss << ";";
            oss << metadata[count];
            count++;
        }
    }
    
    GDALClose(dataset);
    
    // Allouer une copie de la chaîne
    std::string result = oss.str();
    if (result.empty()) {
        return nullptr;
    }
    
    char* copy = new char[result.length() + 1];
    strcpy(copy, result.c_str());
    return copy;
}

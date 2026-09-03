#include "geopdf_utils.h"
#include "poppler_bindings.h"
#include "gdal_bindings.h"
#include <cstring>
#include <sstream>
#include <iomanip>
#include <cjson/cJSON.h> // Utiliser une librairie JSON légère

// Parse un GeoPDF et extrait les informations de géoréférencement
GeoPdfInfo* geopdf_parse(const char* pdfPath) {
    GeoPdfInfo* info = new GeoPdfInfo();
    info->dpi = 300.0; // DPI par défaut
    
    // Essayer d'abord avec Poppler (pour les Viewport GEO)
    PDFDoc* doc = pdf_doc_open(pdfPath);
    if (doc) {
        try {
            // Récupérer les métadonnées
            const char* title = pdf_doc_get_metadata(doc, "Title");
            if (title) {
                info->metadata["title"] = title;
                pdf_free_string(title);
            }
            
            const char* author = pdf_doc_get_metadata(doc, "Author");
            if (author) {
                info->metadata["author"] = author;
                pdf_free_string(author);
            }
            
            const char* producer = pdf_doc_get_metadata(doc, "Producer");
            if (producer) {
                info->metadata["producer"] = producer;
                pdf_free_string(producer);
            }
            
            const char* creationDate = pdf_doc_get_metadata(doc, "CreationDate");
            if (creationDate) {
                info->metadata["creationDate"] = creationDate;
                pdf_free_string(creationDate);
            }
            
            const char* mapId = pdf_doc_get_metadata(doc, "MapID");
            if (mapId) {
                info->metadata["mapId"] = mapId;
                pdf_free_string(mapId);
            }
            
            const char* url = pdf_doc_get_metadata(doc, "URL");
            if (url) {
                info->metadata["url"] = url;
                // Parser les paramètres de l'URL pour extraire scale, style, dpi, etc.
                std::string urlStr(url);
                size_t queryPos = urlStr.find('?');
                if (queryPos != std::string::npos) {
                    std::string query = urlStr.substr(queryPos + 1);
                    size_t pos = 0;
                    while (pos < query.length()) {
                        size_t ampPos = query.find('&', pos);
                        if (ampPos == std::string::npos) ampPos = query.length();
                        std::string param = query.substr(pos, ampPos - pos);
                        size_t eqPos = param.find('=');
                        if (eqPos != std::string::npos) {
                            std::string key = param.substr(0, eqPos);
                            std::string value = param.substr(eqPos + 1);
                            info->metadata["url_" + key] = value;
                            
                            // Extraire les paramètres importants
                            if (key == "scale") {
                                info->metadata["scale"] = value;
                            } else if (key == "style") {
                                info->metadata["style"] = value;
                            } else if (key == "dpi") {
                                info->dpi = std::stod(value);
                                info->metadata["dpi"] = value;
                            } else if (key == "rotation") {
                                info->metadata["rotation"] = value;
                            }
                        }
                        pos = ampPos + 1;
                    }
                }
                pdf_free_string(url);
            }
            
            // Récupérer la première page
            int pageCount = pdf_doc_get_page_count(doc);
            if (pageCount > 0) {
                Page* page = pdf_doc_get_page(doc, 0);
                if (page) {
                    // Récupérer la taille de la page
                    double w, h;
                    pdf_page_get_size(page, &w, &h);
                    info->width = static_cast<int>(w);
                    info->height = static_cast<int>(h);
                    
                    // Récupérer les données de géoréférencement
                    const char* geoDataStr = pdf_page_get_geo_data(page);
                    if (geoDataStr) {
                        // Parser la chaîne: "EPSG:3857|minLon,minLat,maxLon,maxLat|gpts|lpts"
                        std::string geoData(geoDataStr);
                        size_t pos = 0;
                        
                        // Parser le CRS
                        size_t pipePos = geoData.find('|', pos);
                        if (pipePos != std::string::npos) {
                            info->crs = geoData.substr(pos, pipePos - pos);
                            pos = pipePos + 1;
                        }
                        
                        // Parser les bounds
                        pipePos = geoData.find('|', pos);
                        if (pipePos != std::string::npos) {
                            std::string boundsStr = geoData.substr(pos, pipePos - pos);
                            std::istringstream boundsStream(boundsStr);
                            std::string token;
                            while (std::getline(boundsStream, token, ',')) {
                                info->bounds.push_back(std::stod(token));
                            }
                            pos = pipePos + 1;
                        }
                        
                        // Parser GPTS
                        pipePos = geoData.find('|', pos);
                        if (pipePos != std::string::npos) {
                            std::string gptsStr = geoData.substr(pos, pipePos - pos);
                            std::istringstream gptsStream(gptsStr);
                            std::string token;
                            while (std::getline(gptsStream, token, ',')) {
                                info->gpts.push_back(std::stod(token));
                            }
                            pos = pipePos + 1;
                        }
                        
                        // Parser LPTS
                        pipePos = geoData.find('|', pos);
                        if (pipePos != std::string::npos) {
                            std::string lptsStr = geoData.substr(pos, pipePos - pos);
                            std::istringstream lptsStream(lptsStr);
                            std::string token;
                            while (std::getline(lptsStream, token, ',')) {
                                info->lpts.push_back(std::stod(token));
                            }
                        }
                        
                        pdf_free_string(geoDataStr);
                    }
                    
                    // Si pas de Viewport GEO, essayer avec GDAL
                    if (info->bounds.empty()) {
                        GDALDatasetH gdalDataset = gdal_open(pdfPath);
                        if (gdalDataset) {
                            double transform[6];
                            if (gdal_get_geo_transform(gdalDataset, transform) == 0) {
                                info->bounds.push_back(transform[0]); // minX
                                info->bounds.push_back(transform[3] + 
                                    GDALGetRasterYSize(gdalDataset) * transform[5]); // minY
                                info->bounds.push_back(transform[0] + 
                                    GDALGetRasterXSize(gdalDataset) * transform[1]); // maxX
                                info->bounds.push_back(transform[3]); // maxY
                            }
                            
                            const char* proj = gdal_get_projection(gdalDataset);
                            if (proj) {
                                info->crs = proj;
                                gdal_free_string(proj);
                            }
                            
                            gdal_close(gdalDataset);
                        }
                    }
                }
            }
        } catch (...) {
            // En cas d'erreur, nettoyer
        }
        
        pdf_doc_close(doc);
    }
    
    // Si on n'a pas de bounds, essayer avec GDAL directement
    if (info->bounds.empty()) {
        GDALDatasetH dataset = gdal_open(pdfPath);
        if (dataset) {
            double transform[6];
            if (gdal_get_geo_transform(dataset, transform) == 0) {
                info->bounds.push_back(transform[0]); // minX
                info->bounds.push_back(transform[3] + 
                    GDALGetRasterYSize(dataset) * transform[5]); // minY
                info->bounds.push_back(transform[0] + 
                    GDALGetRasterXSize(dataset) * transform[1]); // maxX
                info->bounds.push_back(transform[3]); // maxY
            }
            
            const char* proj = gdal_get_projection(dataset);
            if (proj) {
                info->crs = proj;
                gdal_free_string(proj);
            }
            
            // Récupérer la taille
            int w, h;
            gdal_get_raster_size(dataset, &w, &h);
            if (info->width == 0) info->width = w;
            if (info->height == 0) info->height = h;
            
            gdal_close(dataset);
        }
    }
    
    return info;
}

// Libère une structure GeoPdfInfo
void geopdf_free(GeoPdfInfo* info) {
    if (info) {
        delete info;
    }
}

// Convertit une structure GeoPdfInfo en chaîne JSON
const char* geopdf_to_json(GeoPdfInfo* info) {
    if (!info) return nullptr;
    
    cJSON* root = cJSON_CreateObject();
    
    // Ajouter le CRS
    cJSON_AddStringToObject(root, "crs", info->crs.c_str());
    
    // Ajouter les bounds
    cJSON* boundsArray = cJSON_AddArrayToObject(root, "bounds");
    for (double bound : info->bounds) {
        cJSON_AddNumberToArray(boundsArray, bound);
    }
    
    // Ajouter GPTS
    cJSON* gptsArray = cJSON_AddArrayToObject(root, "gpts");
    for (double pt : info->gpts) {
        cJSON_AddNumberToArray(gptsArray, pt);
    }
    
    // Ajouter LPTS
    cJSON* lptsArray = cJSON_AddArrayToObject(root, "lpts");
    for (double pt : info->lpts) {
        cJSON_AddNumberToArray(lptsArray, pt);
    }
    
    // Ajouter la taille
    cJSON_AddNumberToObject(root, "width", info->width);
    cJSON_AddNumberToObject(root, "height", info->height);
    cJSON_AddNumberToObject(root, "dpi", info->dpi);
    
    // Ajouter les métadonnées
    cJSON* metadataObj = cJSON_AddObjectToObject(root, "metadata");
    for (const auto& pair : info->metadata) {
        cJSON_AddStringToObject(metadataObj, pair.first.c_str(), pair.second.c_str());
    }
    
    // Convertir en chaîne
    char* jsonStr = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    
    return jsonStr;
}

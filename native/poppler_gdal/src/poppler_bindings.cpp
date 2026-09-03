#include "poppler_bindings.h"
#include <poppler/PDFDoc.h>
#include <poppler/Page.h>
#include <poppler/GlobalParams.h>
#include <cstring>
#include <sstream>
#include <iomanip>

// Initialise Poppler (appelé une fois au démarrage)
extern "C" void pdf_init() {
    globalParams = new GlobalParams();
    // Initialiser les paramètres globaux de Poppler
    globalParams->setEnableFreeType(true);
    globalParams->setEnableCMS(false);
}

// Ouvre un document PDF
extern "C" PDFDoc* pdf_doc_open(const char* path) {
    return new PDFDoc(new GooString(path));
}

// Ferme un document PDF
extern "C" void pdf_doc_close(PDFDoc* doc) {
    delete doc;
}

// Récupère les métadonnées du PDF
extern "C" const char* pdf_doc_get_metadata(PDFDoc* doc, const char* key) {
    if (!doc) return nullptr;
    
    const char* metadata = nullptr;
    if (strcmp(key, "Title") == 0) {
        metadata = doc->getInfo()->getTitle()->getCString();
    } else if (strcmp(key, "Author") == 0) {
        metadata = doc->getInfo()->getAuthor()->getCString();
    } else if (strcmp(key, "Producer") == 0) {
        metadata = doc->getInfo()->getProducer()->getCString();
    } else if (strcmp(key, "CreationDate") == 0) {
        metadata = doc->getInfo()->getCreationDate()->getCString();
    } else if (strcmp(key, "MapID") == 0) {
        // Métadonnée personnalisée (non standard)
        metadata = doc->getInfo()->getCustomMetadata("MapID")->getCString();
    } else if (strcmp(key, "URL") == 0) {
        metadata = doc->getInfo()->getURL()->getCString();
    }
    
    if (metadata && strlen(metadata) > 0) {
        // Allouer une copie de la chaîne (car la chaîne originale peut être libérée)
        char* copy = new char[strlen(metadata) + 1];
        strcpy(copy, metadata);
        return copy;
    }
    return nullptr;
}

// Récupère le nombre de pages
extern "C" int pdf_doc_get_page_count(PDFDoc* doc) {
    if (!doc) return 0;
    return doc->getNumPages();
}

// Récupère une page
extern "C" Page* pdf_doc_get_page(PDFDoc* doc, int index) {
    if (!doc) return nullptr;
    if (index < 0 || index >= doc->getNumPages()) return nullptr;
    return doc->getPage(index + 1); // Les pages sont 1-indexed dans Poppler
}

// Libère une page
extern "C" void pdf_page_free(Page* page) {
    // Dans Poppler, les pages sont gérées par le document, pas besoin de les libérer manuellement
    // Mais on peut les supprimer si elles ont été créées avec new
    // delete page; // À décommenter si nécessaire
}

// Récupère la taille de la page (en points)
extern "C" void pdf_page_get_size(Page* page, double* width, double* height) {
    if (!page) return;
    
    double w, h;
    page->getSize(&w, &h);
    *width = w;
    *height = h;
}

// Structure pour stocker les données de géoréférencement
struct GeoData {
    std::string crs;
    std::vector<double> gpts;  // Coordonnées géographiques (8 valeurs)
    std::vector<double> lpts;  // Coordonnées locales (8 valeurs)
    std::vector<double> bounds; // Bounds calculés (4 valeurs: minLon, minLat, maxLon, maxLat)
};

// Parse le Viewport GEO d'une page PDF
GeoData parseGeoViewport(Page* page) {
    GeoData data;
    data.crs = "EPSG:3857"; // Par défaut pour OpenOrienteeringMap
    
    // Accéder à l'objet de la page
    Object pageObj = page->getPageObject();
    
    // Vérifier si la page a un Viewport GEO
    if (pageObj.isDict("VP")) {
        Object vpArray = pageObj.getArray("VP");
        if (vpArray.isArray() && vpArray.arrayGetLength() > 0) {
            Object viewport = vpArray.arrayGet(0);
            if (viewport.isDict()) {
                // Lire le BBox
                if (viewport.isArray("BBox")) {
                    Object bbox = viewport.getArray("BBox");
                    if (bbox.arrayGetLength() >= 4) {
                        for (int i = 0; i < 4; i++) {
                            data.bounds.push_back(bbox.arrayGet(i).getNum());
                        }
                    }
                }
                
                // Lire la mesure (Measure)
                if (viewport.isDict("Measure")) {
                    Object measure = viewport.getDict("Measure");
                    
                    // Lire le type
                    if (measure.isName("Subtype")) {
                        Object subtype = measure.getName("Subtype");
                        if (subtype.isName() && subtype.getName() == "GEO") {
                            // C'est un Viewport GEO
                            data.crs = "EPSG:3857"; // Par défaut, à améliorer
                            
                            // Lire GPTS (Geo Points)
                            if (measure.isArray("GPTS")) {
                                Object gpts = measure.getArray("GPTS");
                                for (int i = 0; i < gpts.arrayGetLength(); i++) {
                                    data.gpts.push_back(gpts.arrayGet(i).getNum());
                                }
                            }
                            
                            // Lire LPTS (Local Points)
                            if (measure.isArray("LPTS")) {
                                Object lpts = measure.getArray("LPTS");
                                for (int i = 0; i < lpts.arrayGetLength(); i++) {
                                    data.lpts.push_back(lpts.arrayGet(i).getNum());
                                }
                            }
                            
                            // Lire le GCS (Coordinate System)
                            if (measure.isDict("GCS")) {
                                Object gcs = measure.getDict("GCS");
                                if (gcs.isInt("EPSG")) {
                                    data.crs = "EPSG:" + std::to_string(gcs.getInt("EPSG"));
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Calculer les bounds si GPTS est disponible
    if (data.gpts.size() >= 8) {
        std::vector<double> lons = {data.gpts[0], data.gpts[2], data.gpts[4], data.gpts[6]};
        std::vector<double> lats = {data.gpts[1], data.gpts[3], data.gpts[5], data.gpts[7]};
        
        double minLon = *std::min_element(lons.begin(), lons.end());
        double maxLon = *std::max_element(lons.begin(), lons.end());
        double minLat = *std::min_element(lats.begin(), lats.end());
        double maxLat = *std::max_element(lats.begin(), lats.end());
        
        data.bounds = {minLon, minLat, maxLon, maxLat};
    }
    
    return data;
}

// Récupère les données de géoréférencement (Viewport GEO)
extern "C" const char* pdf_page_get_geo_data(Page* page) {
    if (!page) return nullptr;
    
    GeoData geoData = parseGeoViewport(page);
    
    // Formater les données en chaîne
    std::ostringstream oss;
    oss << geoData.crs << "|";
    
    // Ajouter les bounds
    for (size_t i = 0; i < geoData.bounds.size(); i++) {
        if (i > 0) oss << ",";
        oss << std::fixed << std::setprecision(6) << geoData.bounds[i];
    }
    oss << "|";
    
    // Ajouter GPTS
    for (size_t i = 0; i < geoData.gpts.size(); i++) {
        if (i > 0) oss << ",";
        oss << std::fixed << std::setprecision(6) << geoData.gpts[i];
    }
    oss << "|";
    
    // Ajouter LPTS
    for (size_t i = 0; i < geoData.lpts.size(); i++) {
        if (i > 0) oss << ",";
        oss << std::fixed << std::setprecision(6) << geoData.lpts[i];
    }
    
    // Allouer une copie de la chaîne
    std::string result = oss.str();
    char* copy = new char[result.length() + 1];
    strcpy(copy, result.c_str());
    return copy;
}

// Rend une page en image RGBA
extern "C" unsigned char* pdf_page_render_to_image(
    Page* page,
    double scale,
    int* width,
    int* height,
    int* row_stride
) {
    if (!page) return nullptr;
    
    // Calculer la taille de l'image
    double pageWidth, pageHeight;
    page->getSize(&pageWidth, &pageHeight);
    
    int imgWidth = static_cast<int>(pageWidth * scale);
    int imgHeight = static_cast<int>(pageHeight * scale);
    int stride = imgWidth * 4; // 4 octets par pixel (RGBA)
    
    // Allouer le buffer pour l'image
    unsigned char* buffer = new unsigned char[stride * imgHeight];
    memset(buffer, 0, stride * imgHeight); // Initialiser à transparent
    
    // Rendre la page dans le buffer
    // Note: Poppler n'a pas de fonction native pour rendre en RGBA directement.
    // On utilise SplashOutputDev pour rendre en RGB, puis on ajoute l'alpha.
    // Cela nécessite plus de code, mais voici une version simplifiée.
    
    // Pour l'instant, on retourne un buffer vide (à implémenter complètement)
    // TODO: Implémenter le rendu complet avec SplashOutputDev
    
    *width = imgWidth;
    *height = imgHeight;
    *row_stride = stride;
    
    return buffer;
}

// Libère une image rendue
extern "C" void pdf_free_image(unsigned char* image) {
    if (image) {
        delete[] image;
    }
}

// Libère une chaîne allouée par Poppler
extern "C" void pdf_free_string(const char* str) {
    if (str) {
        delete[] str;
    }
}

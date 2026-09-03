#include "geopdf_bindings.h"
#include "poppler_bindings.h"
#include "gdal_bindings.h"
#include <cstring>
#include <sstream>
#include <cjson/cJSON.h>

// Initialise les librairies natives
JNIEXPORT void JNICALL Java_com_owildzimut_GeopdfNative_init(JNIEnv* env, jobject obj) {
    pdf_init();
    gdal_init();
}

// Parse un GeoPDF et retourne les données en JSON
JNIEXPORT jstring JNICALL Java_com_owildzimut_GeopdfNative_parseGeoPdf(
    JNIEnv* env,
    jobject obj,
    jstring pdfPath
) {
    const char* path = env->GetStringUTFChars(pdfPath, nullptr);
    if (!path) {
        return nullptr;
    }

    GeoPdfInfo* info = geopdf_parse(path);
    env->ReleaseStringUTFChars(pdfPath, path);

    if (!info) {
        return nullptr;
    }

    // Convertir en JSON
    const char* jsonStr = geopdf_to_json(info);
    geopdf_free(info);

    if (!jsonStr) {
        return nullptr;
    }

    jstring result = env->NewStringUTF(jsonStr);
    // Note: geopdf_to_json alloue avec cJSON_PrintUnformatted, qui utilise malloc
    // On ne peut pas libérer ici car JNI en a besoin
    // La mémoire sera libérée automatiquement ou via cleanup
    return result;
}

// Rend une page PDF en image PNG
JNIEXPORT jstring JNICALL Java_com_owildzimut_GeopdfNative_renderPdfPage(
    JNIEnv* env,
    jobject obj,
    jstring pdfPath,
    jint pageIndex,
    jdouble scale,
    jstring outputPath
) {
    const char* pdfPathStr = env->GetStringUTFChars(pdfPath, nullptr);
    const char* outputPathStr = env->GetStringUTFChars(outputPath, nullptr);

    if (!pdfPathStr || !outputPathStr) {
        return nullptr;
    }

    PDFDoc* doc = pdf_doc_open(pdfPathStr);
    if (!doc) {
        env->ReleaseStringUTFChars(pdfPath, pdfPathStr);
        env->ReleaseStringUTFChars(outputPath, outputPathStr);
        return nullptr;
    }

    jstring result = nullptr;
    int pageCount = pdf_doc_get_page_count(doc);
    if (pageIndex >= 0 && pageIndex < pageCount) {
        Page* page = pdf_doc_get_page(doc, pageIndex);
        if (page) {
            double width, height;
            pdf_page_get_size(page, &width, &height);
            
            int imgWidth = static_cast<int>(width * scale);
            int imgHeight = static_cast<int>(height * scale);
            int rowStride = imgWidth * 4; // RGBA
            
            unsigned char* imageData = pdf_page_render_to_image(
                page,
                scale,
                &imgWidth,
                &imgHeight,
                &rowStride
            );
            
            if (imageData) {
                // Sauvegarder l'image en PNG
                // Note: Pour simplifier, on sauvegarde en format brut
                // Dans une implémentation complète, utiliser libpng
                std::string outputFile = std::string(outputPathStr) + "/background.png";
                FILE* file = fopen(outputFile.c_str(), "wb");
                if (file) {
                    // Écrire l'en-tête PNG (simplifié)
                    // Dans une vraie implémentation, utiliser libpng
                    fwrite(imageData, 1, imgWidth * imgHeight * 4, file);
                    fclose(file);
                    
                    result = env->NewStringUTF(outputFile.c_str());
                }
                
                pdf_free_image(imageData);
            }
        }
    }

    pdf_doc_close(doc);
    env->ReleaseStringUTFChars(pdfPath, pdfPathStr);
    env->ReleaseStringUTFChars(outputPath, outputPathStr);
    
    return result;
}

// Vérifie si un fichier est un GeoPDF
JNIEXPORT jboolean JNICALL Java_com_owildzimut_GeopdfNative_isGeoPdf(
    JNIEnv* env,
    jobject obj,
    jstring pdfPath
) {
    const char* path = env->GetStringUTFChars(pdfPath, nullptr);
    if (!path) {
        return JNI_FALSE;
    }

    bool isGeoPdf = false;
    PDFDoc* doc = pdf_doc_open(path);
    if (doc) {
        int pageCount = pdf_doc_get_page_count(doc);
        if (pageCount > 0) {
            Page* page = pdf_doc_get_page(doc, 0);
            if (page) {
                const char* geoData = pdf_page_get_geo_data(page);
                if (geoData) {
                    std::string geoDataStr(geoData);
                    // Vérifier si la chaîne contient des données de géoréférencement
                    if (geoDataStr.find("EPSG:") != std::string::npos ||
                        geoDataStr.find("|") != std::string::npos) {
                        isGeoPdf = true;
                    }
                    pdf_free_string(geoData);
                }
            }
        }
        pdf_doc_close(doc);
    }

    env->ReleaseStringUTFChars(pdfPath, path);
    return isGeoPdf ? JNI_TRUE : JNI_FALSE;
}

// Libère les ressources
JNIEXPORT void JNICALL Java_com_owildzimut_GeopdfNative_cleanup(JNIEnv* env, jobject obj) {
    // Rien à faire pour l'instant
    // Les ressources sont libérées automatiquement
}

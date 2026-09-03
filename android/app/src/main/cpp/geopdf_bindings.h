#ifndef GEOPDF_BINDINGS_H
#define GEOPDF_BINDINGS_H

#include <jni.h>
#include <string>

// Structure pour stocker les données de géoréférencement
struct GeoPdfData {
    std::string crs;
    std::string bounds; // "minLon,minLat,maxLon,maxLat"
    std::string gpts;   // "x1,y1,x2,y2,..."
    std::string lpts;   // "x1,y1,x2,y2,..."
    int width;
    int height;
    double dpi;
    std::string metadataJson;
};

// Fonctions JNI pour Android
#ifdef __cplusplus
extern "C" {
#endif

// Initialise les librairies natives
JNIEXPORT void JNICALL Java_com_owildzimut_GeopdfNative_init(JNIEnv* env, jobject obj);

// Parse un GeoPDF et retourne les données en JSON
JNIEXPORT jstring JNICALL Java_com_owildzimut_GeopdfNative_parseGeoPdf(
    JNIEnv* env,
    jobject obj,
    jstring pdfPath
);

// Rend une page PDF en image PNG (retourne le chemin du fichier)
JNIEXPORT jstring JNICALL Java_com_owildzimut_GeopdfNative_renderPdfPage(
    JNIEnv* env,
    jobject obj,
    jstring pdfPath,
    jint pageIndex,
    jdouble scale,
    jstring outputPath
);

// Vérifie si un fichier est un GeoPDF
JNIEXPORT jboolean JNICALL Java_com_owildzimut_GeopdfNative_isGeoPdf(
    JNIEnv* env,
    jobject obj,
    jstring pdfPath
);

// Libère les ressources
JNIEXPORT void JNICALL Java_com_owildzimut_GeopdfNative_cleanup(JNIEnv* env, jobject obj);

#ifdef __cplusplus
}
#endif

#endif // GEOPDF_BINDINGS_H

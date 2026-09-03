#ifndef POPPLER_BINDINGS_H
#define POPPLER_BINDINGS_H

#include <poppler/PDFDoc.h>
#include <poppler/Page.h>
#include <poppler/GlobalParams.h>
#include <string>
#include <vector>
#include <map>

// Initialise Poppler (appelé une fois au démarrage)
extern "C" void pdf_init();

// Ouvre un document PDF
extern "C" PDFDoc* pdf_doc_open(const char* path);

// Ferme un document PDF
extern "C" void pdf_doc_close(PDFDoc* doc);

// Récupère les métadonnées du PDF
extern "C" const char* pdf_doc_get_metadata(PDFDoc* doc, const char* key);

// Récupère le nombre de pages
extern "C" int pdf_doc_get_page_count(PDFDoc* doc);

// Récupère une page
extern "C" Page* pdf_doc_get_page(PDFDoc* doc, int index);

// Libère une page
extern "C" void pdf_page_free(Page* page);

// Récupère la taille de la page (en points)
extern "C" void pdf_page_get_size(Page* page, double* width, double* height);

// Récupère les données de géoréférencement (Viewport GEO)
// Retourne une chaîne au format: "EPSG:3857|minLon,minLat,maxLon,maxLat|gpts|lpts"
extern "C" const char* pdf_page_get_geo_data(Page* page);

// Rend une page en image RGBA (32 bits par pixel)
// Le caller est responsable de libérer la mémoire avec pdf_free_image
extern "C" unsigned char* pdf_page_render_to_image(
    Page* page,
    double scale,
    int* width,
    int* height,
    int* row_stride
);

// Libère une image rendue
extern "C" void pdf_free_image(unsigned char* image);

// Libère une chaîne allouée par Poppler
extern "C" void pdf_free_string(const char* str);

#endif // POPPLER_BINDINGS_H

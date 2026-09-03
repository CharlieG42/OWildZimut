package com.owildzimut;

/**
 * Classe Java pour interagir avec les bindings natifs (C++) pour la gestion des GeoPDF.
 * Cette classe utilise JNI pour appeler les fonctions natives compilées avec le NDK.
 */
public class GeopdfNative {
    
    // Charger la librairie native
    static {
        System.loadLibrary("owildzimut_native");
    }
    
    /**
     * Initialise les librairies natives (Poppler et GDAL).
     * Doit être appelé une fois au démarrage de l'application.
     */
    public static native void init();
    
    /**
     * Parse un fichier GeoPDF et retourne les données de géoréférencement au format JSON.
     * 
     * @param pdfPath Chemin vers le fichier PDF
     * @return JSON contenant les métadonnées et le géoréférencement
     */
    public static native String parseGeoPdf(String pdfPath);
    
    /**
     * Rend une page PDF en image PNG et sauvegarde le résultat.
     * 
     * @param pdfPath Chemin vers le fichier PDF
     * @param pageIndex Index de la page à rendre (0 pour la première page)
     * @param scale Facteur d'échelle (1.0 = taille originale)
     * @param outputPath Dossier de sortie pour l'image
     * @return Chemin vers l'image générée
     */
    public static native String renderPdfPage(String pdfPath, int pageIndex, double scale, String outputPath);
    
    /**
     * Vérifie si un fichier est un GeoPDF (contient des données de géoréférencement).
     * 
     * @param pdfPath Chemin vers le fichier PDF
     * @return true si c'est un GeoPDF, false sinon
     */
    public static native boolean isGeoPdf(String pdfPath);
    
    /**
     * Libère les ressources allouées par les fonctions natives.
     * Doit être appelé à la fermeture de l'application.
     */
    public static native void cleanup();
}

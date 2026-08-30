import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Chargeur de fichiers pour OWildZimut
///
/// Cette classe fournit des méthodes pour charger et sauvegarder des fichiers
/// OMAP, images, etc.
class FileLoader {
  /// Charge un fichier OMAP depuis le système de fichiers
  /// 
  /// Retourne le contenu du fichier sous forme de chaîne, ou null si annulé.
  static Future<String?> loadOmapFile() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'Fichiers OMAP',
        extensions: ['omap', 'xml'],
      );
      
      final xfile = await openFile(acceptedTypeGroups: [typeGroup]);
      
      if (xfile != null) {
        final fileContent = await File(xfile.path).readAsString();
        return fileContent;
      }
      return null;
    } catch (e) {
      debugPrint('Erreur lors du chargement du fichier OMAP: $e');
      return null;
    }
  }

  /// Sauvegarde un fichier OMAP
  /// 
  /// [omapXml] : Le contenu XML à sauvegarder
  /// Retourne le chemin du fichier sauvegardé, ou null si annulé.
  static Future<String?> saveOmapFile(String omapXml) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'carte_${DateTime.now().millisecondsSinceEpoch}.omap';
      final filePath = path.join(directory.path, fileName);
      
      final file = File(filePath);
      await file.writeAsString(omapXml);
      
      return filePath;
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde du fichier OMAP: $e');
      return null;
    }
  }

  /// Charge un fichier image (jpg, jpeg, png)
  /// 
  /// Retourne le chemin du fichier, ou null si annulé.
  static Future<String?> loadImageFile() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'Images',
        extensions: ['jpg', 'jpeg', 'png'],
      );
      
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      
      if (file != null) {
        return file.path;
      }
      return null;
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'image: $e');
      return null;
    }
  }

  /// Charge un fichier de n'importe quel type
  /// 
  /// Retourne le chemin du fichier, ou null si annulé.
  static Future<String?> loadAnyFile() async {
    try {
      final file = await openFile();
      
      if (file != null) {
        return file.path;
      }
      return null;
    } catch (e) {
      debugPrint('Erreur lors du chargement du fichier: $e');
      return null;
    }
  }
}

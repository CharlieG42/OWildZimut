import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['omap', 'xml'],
        dialogTitle: 'Ouvrir un fichier OMAP',
      );
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final filePath = file.path;
        
        if (filePath != null) {
          final fileContent = await File(filePath).readAsString();
          return fileContent;
        }
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
      String? filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Enregistrer la carte OMAP',
        fileName: 'carte_${DateTime.now().millisecondsSinceEpoch}.omap',
        allowedExtensions: ['omap'],
      );
      
      if (filePath != null) {
        final file = File(filePath);
        await file.writeAsString(omapXml);
        return filePath;
      }
      return null;
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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        dialogTitle: 'Ouvrir une image',
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      
      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Ouvrir un fichier',
      );
      
      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
      }
      return null;
    } catch (e) {
      debugPrint('Erreur lors du chargement du fichier: $e');
      return null;
    }
  }
}

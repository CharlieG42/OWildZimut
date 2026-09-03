import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/import_service.dart';

/// Menu d'import pour OWildZimut.
/// Propose 4 options :
/// 1. Import OMAP
/// 2. Import Image
/// 3. Conversion GeoPDF → OMAP
/// 4. Import GeoPDF (superposition raster)
class ImportMenu extends StatelessWidget {
  final ImportService importService;
  final Function(String?)? onImportCompleted;
  final Function(String)? onError;

  const ImportMenu({
    super.key,
    required this.importService,
    this.onImportCompleted,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.add),
      tooltip: 'Importer',
      itemBuilder: (context) => [
        _buildMenuItem(
          context,
          'omap',
          Icons.map,
          'Import OMAP',
          'Fichier carte OpenOrienteering (OMAP)',
        ),
        _buildMenuItem(
          context,
          'image',
          Icons.image,
          'Import Image',
          'Image géoréférencée manuellement',
        ),
        _buildMenuItem(
          context,
          'geopdf_convert',
          Icons.transform,
          'Conversion GeoPDF → OMAP',
          'Convertit un PDF géoréférencé en carte OMAP',
        ),
        _buildMenuItem(
          context,
          'geopdf_raster',
          Icons.layers,
          'Import GeoPDF (Raster)',
          'Charge un PDF comme image de fond géoréférencée',
        ),
      ],
      onSelected: (value) => _handleSelection(context, value),
    );
  }

  /// Construit un élément de menu
  PopupMenuItem<String> _buildMenuItem(
    BuildContext context,
    String value,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  /// Gère la sélection d'une option du menu
  Future<void> _handleSelection(BuildContext context, String value) async {
    try {
      String? result;
      
      switch (value) {
        case 'omap':
          result = await importService.importOmap();
          break;
        case 'image':
          result = await importService.importImage();
          break;
        case 'geopdf_convert':
          final file = await importService.pickFile(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'PDF'],
            dialogTitle: 'Sélectionner un GeoPDF à convertir',
          );
          if (file != null) {
            result = await importService.importGeoPdfWithConversionFromPath(file.path);
          }
          break;
        case 'geopdf_raster':
          final file = await importService.pickFile(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'PDF'],
            dialogTitle: 'Sélectionner un GeoPDF à importer',
          );
          if (file != null) {
            final geoPdfData = await importService.importGeoPdfAsRasterFromPath(file.path);
            result = geoPdfData?.mapName;
          }
          break;
      }

      if (result != null && onImportCompleted != null) {
        onImportCompleted!(result);
        
        // Afficher un message de succès
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Import réussi: $result'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (onError != null) {
        onError!('Erreur lors de l\'import: $e');
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Bouton pour l'import avec icône et texte
class ImportButton extends StatelessWidget {
  final ImportService importService;
  final Function(String?)? onImportCompleted;
  final Function(String)? onError;

  const ImportButton({
    super.key,
    required this.importService,
    this.onImportCompleted,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Importer',
      onPressed: () => _showImportDialog(context),
    );
  }

  Future<void> _showImportDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importer une carte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Import OMAP'),
              subtitle: const Text('Fichier carte OpenOrienteering'),
              onTap: () {
                Navigator.pop(context);
                _handleImport(context, 'omap');
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Import Image'),
              subtitle: const Text('Image géoréférencée manuellement'),
              onTap: () {
                Navigator.pop(context);
                _handleImport(context, 'image');
              },
            ),
            ListTile(
              leading: const Icon(Icons.transform),
              title: const Text('Conversion GeoPDF → OMAP'),
              subtitle: const Text('Convertit un PDF géoréférencé en carte OMAP'),
              onTap: () {
                Navigator.pop(context);
                _handleImport(context, 'geopdf_convert');
              },
            ),
            ListTile(
              leading: const Icon(Icons.layers),
              title: const Text('Import GeoPDF (Raster)'),
              subtitle: const Text('Charge un PDF comme image de fond'),
              onTap: () {
                Navigator.pop(context);
                _handleImport(context, 'geopdf_raster');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImport(BuildContext context, String type) async {
    try {
      String? result;
      
      switch (type) {
        case 'omap':
          result = await importService.importOmap();
          break;
        case 'image':
          result = await importService.importImage();
          break;
        case 'geopdf_convert':
          final file = await importService.pickFile(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'PDF'],
            dialogTitle: 'Sélectionner un GeoPDF à convertir',
          );
          if (file != null) {
            result = await importService.importGeoPdfWithConversionFromPath(file.path);
          }
          break;
        case 'geopdf_raster':
          final file = await importService.pickFile(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'PDF'],
            dialogTitle: 'Sélectionner un GeoPDF à importer',
          );
          if (file != null) {
            final geoPdfData = await importService.importGeoPdfAsRasterFromPath(file.path);
            result = geoPdfData?.mapName;
          }
          break;
      }

      if (result != null && onImportCompleted != null) {
        onImportCompleted!(result);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Import réussi: $result'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (onError != null) {
        onError!('Erreur lors de l\'import: $e');
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

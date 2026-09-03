import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/import_service.dart';

/// Dialogue pour l'import avec prévisualisation des informations
class ImportDialog extends StatefulWidget {
  final ImportService importService;
  final Function(String?) onImportCompleted;

  const ImportDialog({
    super.key,
    required this.importService,
    required this.onImportCompleted,
  });

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  String? _selectedFile;
  Map<String, dynamic>? _fileInfo;
  bool _isLoading = false;
  bool _isGeoPdf = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Importer une carte'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bouton pour sélectionner un fichier
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Sélectionner un fichier'),
            ),
            const SizedBox(height: 8),
            // Afficher les formats acceptés
            Text(
              'Formats acceptés: OMAP, PDF, PNG, JPG, JPEG',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Afficher le fichier sélectionné
            if (_selectedFile != null) ...[
              Text(
                'Fichier: ${_selectedFile!.split('/').last}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
            
            // Afficher les informations du fichier
            if (_fileInfo != null) ...[
              _buildInfoCard(context),
              const SizedBox(height: 16),
            ],
            
            // Afficher l'erreur
            if (_error != null) ...[
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Boutons d'import
            if (_selectedFile != null && _fileInfo != null) ...[
              if (_isGeoPdf) ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _importAsOmap,
                  icon: const Icon(Icons.transform),
                  label: const Text('Convertir en OMAP'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _importAsRaster,
                  icon: const Icon(Icons.layers),
                  label: const Text('Importer comme raster'),
                ),
              ] else if (_fileInfo!['type'] == 'omap') ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _importAsOmapFile,
                  icon: const Icon(Icons.map),
                  label: const Text('Importer OMAP'),
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _importAsImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Importer comme image'),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
      ],
    );
  }

  /// Sélectionne un fichier
  Future<void> _pickFile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final file = await widget.importService.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'PDF', 'png', 'jpg', 'jpeg', 'omap'],
        dialogTitle: 'Sélectionner un fichier à importer',
      );

      if (file != null) {
        setState(() {
          _selectedFile = file.path;
          _fileInfo = null;
          _isGeoPdf = false;
        });

        // Récupérer les informations du fichier
        await _loadFileInfo(file.path);
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Charge les informations du fichier
  Future<void> _loadFileInfo(String filePath) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (filePath.toLowerCase().endsWith('.pdf')) {
        // Vérifier si c'est un GeoPDF
        final isGeoPdf = await widget.importService.isGeoPdf(filePath);
        setState(() {
          _isGeoPdf = isGeoPdf;
        });

        if (isGeoPdf) {
          // Récupérer les informations du GeoPDF
          final info = await widget.importService.getGeoPdfInfo(filePath);
          setState(() {
            _fileInfo = info;
          });
        } else {
          setState(() {
            _fileInfo = {'type': 'pdf'};
          });
        }
      } else if (filePath.endsWith('.omap') || filePath.endsWith('.OMAP')) {
        setState(() {
          _fileInfo = {'type': 'omap'};
        });
      } else {
        // Image
        setState(() {
          _fileInfo = {'type': 'image'};
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur lors de la lecture du fichier: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Construit la carte d'informations
  Widget _buildInfoCard(BuildContext context) {
    if (_fileInfo == null) return const SizedBox();

    final type = _fileInfo!['type'] as String? ?? 'unknown';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type: ${_getTypeLabel(type)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            
            if (type == 'geopdf' || _isGeoPdf) ...[
              if (_fileInfo!['metadata'] != null) ...[
                _buildMetadataRow(context, 'Titre', _fileInfo!['metadata']['title']),
                _buildMetadataRow(context, 'Auteur', _fileInfo!['metadata']['author']),
                _buildMetadataRow(context, 'Date', _fileInfo!['metadata']['creationDate']),
                _buildMetadataRow(context, 'Échelle', _fileInfo!['metadata']['scale']),
                _buildMetadataRow(context, 'CRS', _fileInfo!['metadata']['crs']),
                if (_fileInfo!['metadata']['bounds'] != null) ...[
                  Text(
                    'Bounds: ${_fileInfo!['metadata']['bounds']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  /// Construit une ligne de métadonnées
  Widget _buildMetadataRow(BuildContext context, String label, dynamic value) {
    if (value == null) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Retourne le label pour un type de fichier
  String _getTypeLabel(String type) {
    switch (type) {
      case 'geopdf':
        return 'GeoPDF';
      case 'pdf':
        return 'PDF';
      case 'omap':
        return 'OMAP';
      case 'image':
        return 'Image';
      default:
        return type;
    }
  }

  /// Importe comme OMAP (fichier OMAP existant)
  Future<void> _importAsOmapFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await widget.importService.importOmapFromPath(_selectedFile!);
      if (result != null) {
        widget.onImportCompleted(result);
        if (context.mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Importe comme OMAP (conversion GeoPDF)
  Future<void> _importAsOmap() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await widget.importService.importGeoPdfWithConversionFromPath(_selectedFile!);
      if (result != null) {
        widget.onImportCompleted(result);
        if (context.mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Importe comme raster
  Future<void> _importAsRaster() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final geoPdfData = await widget.importService.importGeoPdfAsRasterFromPath(_selectedFile!);
      if (geoPdfData != null) {
        widget.onImportCompleted(geoPdfData.mapName);
        if (context.mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Importe comme image
  Future<void> _importAsImage() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await widget.importService.importImageFromPath(_selectedFile!);
      if (result != null) {
        widget.onImportCompleted(result);
        if (context.mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

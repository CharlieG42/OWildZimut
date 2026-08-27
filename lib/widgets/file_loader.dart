import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../models/map_file.dart';
import '../models/map_state.dart';

/// Widget pour charger des fichiers OMap/OOMAP
class MapFileLoaderWidget extends StatefulWidget {
  final ValueChanged<MapState> onFileLoaded;
  final bool showPreview;

  const MapFileLoaderWidget({
    super.key,
    required this.onFileLoaded,
    this.showPreview = true,
  });

  @override
  State<MapFileLoaderWidget> createState() => _MapFileLoaderWidgetState();
}

class _MapFileLoaderWidgetState extends State<MapFileLoaderWidget> {
  bool _isLoading = false;
  String? _errorMessage;
  MapFileData? _loadedFile;
  MapState? _previewState;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bouton de chargement
        FilledButton.icon(
          onPressed: _loadFile,
          icon: const Icon(Icons.folder_open),
          label: const Text('Charger OMap/OOMAP'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 8),
        
        // Message d'erreur
        if (_errorMessage != null)
          Text(
            _errorMessage!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        
        const SizedBox(height: 8),
        
        // Indicateur de chargement
        if (_isLoading)
          const LinearProgressIndicator(),
        
        // Aperçu du fichier chargé
        if (_loadedFile != null && widget.showPreview)
          _buildPreview(context),
      ],
    );
  }

  Widget _buildPreview(BuildContext context) {
    if (_previewState == null) return const SizedBox();
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Fichier: ${_loadedFile!.header.mapName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Calques: ${_previewState!.layers.length}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Symboles: ${_previewState!.layers.fold(0, (sum, layer) => sum + layer.symbolCount)}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _cancelLoad,
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _confirmLoad,
                  child: const Text('Importer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _loadedFile = null;
      _previewState = null;
    });

    try {
      // Utiliser file_picker pour sélectionner un fichier
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ocd', 'oomap', 'OCD', 'OOMAP'],
        dialogTitle: 'Sélectionner un fichier OMap ou OOMAP',
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // Lire le fichier
        Uint8List? bytes;
        if (file.path != null) {
          // Sur mobile/desktop, on peut lire directement le fichier
          final fileObject = File(file.path!);
          bytes = await fileObject.readAsBytes();
        } else if (file.bytes != null) {
          // Sur web, on utilise les bytes directement
          bytes = file.bytes!;
        }

        if (bytes != null) {
          // Vérifier que c'est un fichier OMap/OOMAP valide
          if (MapFileLoader.isValidMapFile(bytes)) {
            // Charger le fichier
            final ocadFile = MapFileLoader.loadFromBytes(bytes);
            
            if (ocadFile != null) {
              setState(() {
                _loadedFile = ocadFile;
                _previewState = ocadFile.toMapState();
                _isLoading = false;
              });
            } else {
              setState(() {
                _errorMessage = 'Impossible de charger le fichier. Format non supporté.';
                _isLoading = false;
              });
            }
          } else {
            setState(() {
              _errorMessage = 'Le fichier sélectionné n\'est pas un fichier OMap/OOMAP valide.';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Impossible de lire le fichier.';
            _isLoading = false;
          });
        }
      } else {
        // L'utilisateur a annulé la sélection
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _confirmLoad() {
    if (_previewState != null) {
      widget.onFileLoaded(_previewState!);
      setState(() {
        _loadedFile = null;
        _previewState = null;
      });
    }
  }

  void _cancelLoad() {
    setState(() {
      _loadedFile = null;
      _previewState = null;
      _errorMessage = null;
    });
  }
}

/// Dialogue pour charger un fichier OMap/OOMAP
class MapFileLoaderDialog extends StatelessWidget {
  final ValueChanged<MapState> onFileLoaded;

  const MapFileLoaderDialog({
    super.key,
    required this.onFileLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Charger une carte OMap/OOMAP'),
      content: SizedBox(
        width: double.maxFinite,
        child: MapFileLoaderWidget(
          onFileLoaded: (mapState) {
            Navigator.of(context).pop();
            onFileLoaded(mapState);
          },
          showPreview: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

/// Bouton pour charger un fichier OMap/OOMAP
class MapFileLoadButton extends StatelessWidget {
  final ValueChanged<MapState> onFileLoaded;
  final String? tooltip;
  final IconData? icon;
  final String? label;

  const MapFileLoadButton({
    super.key,
    required this.onFileLoaded,
    this.tooltip = 'Charger un fichier OMap/OOMAP',
    this.icon = Icons.folder_open,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => MapFileLoaderDialog(
            onFileLoaded: onFileLoaded,
          ),
        );
      },
      tooltip: tooltip,
    );
  }
}

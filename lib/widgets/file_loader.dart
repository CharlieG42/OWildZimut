import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:typed_data';
import '../models/map_file.dart';
import '../models/map_state.dart';
import '../models/layer.dart';

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
  String? _selectedFilePath;
  String? _errorMessage;
  bool _isLoading = false;

  /// Extensions de fichiers supportées
  static final List<String> _supportedExtensions = [
    '.ocd',  // OCAD
    '.oomap', // OOMAP
    '.ocd8', // OCAD 8/9
    '.ocd10', // OCAD 10/11
    '.ocd12', // OCAD 12
  ];

  /// Ouvre le sélecteur de fichiers
  Future<void> _pickFile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Configuration du filtre pour les fichiers OCAD/OOMAP
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _supportedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        await _processFile(result.files.single.path!);
      }
    } on Exception catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la sélection: ${e.toString()}';
        _isLoading = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Traite le fichier sélectionné
  Future<void> _processFile(String filePath) async {
    try {
      setState(() {
        _selectedFilePath = filePath;
        _isLoading = true;
        _errorMessage = null;
      });

      // Vérifie l'extension
      final ext = path.extension(filePath).toLowerCase();
      if (!_supportedExtensions.contains(ext)) {
        setState(() {
          _errorMessage = 'Extension de fichier non supportée: $ext';
          _isLoading = false;
        });
        return;
      }

      // Lit le fichier
      final file = File(filePath);
      if (!await file.exists()) {
        setState(() {
          _errorMessage = 'Fichier introuvable: $filePath';
          _isLoading = false;
        });
        return;
      }

      // Charge le fichier
      final mapFile = await _loadMapFile(filePath);

      if (mapFile != null) {
        // Crée un nouvel état avec le fichier chargé
        final newState = MapState(
          appVersion: '0.0.002',
          currentFile: filePath,
          fileName: path.basename(filePath),
        );

        // Ajoute les calques depuis le fichier
        final stateWithLayers = _createLayersFromMapFile(newState, mapFile);

        widget.onFileLoaded(stateWithLayers);

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Impossible de charger le fichier';
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

  /// Charge un fichier de carte
  Future<MapFileData?> _loadMapFile(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      // Détecte le type de fichier
      final ext = path.extension(filePath).toLowerCase();

      if (ext == '.ocd' || ext.startsWith('.ocd')) {
        return _parseOcadFile(bytes, filePath);
      } else if (ext == '.oomap') {
        return _parseOomapFile(bytes, filePath);
      }

      return null;
    } catch (e) {
      debugPrint('Erreur de chargement du fichier: $e');
      return null;
    }
  }

  /// Parse un fichier OCAD (format binaire simplifié)
  MapFileData _parseOcadFile(Uint8List bytes, String filePath) {
    // OCAD 8/9/10/11/12 ont des headers similaires
    // Format: [Header][Symbols][Objects]
    
    final header = _readOcadHeader(bytes);
    
    if (header == null) {
      throw FormatException('Header OCAD invalide');
    }

    // Pour l'instant, on crée un MapFileData basique avec les infos du header
    return MapFileData(
      fileType: MapFileType.ocad,
      filePath: filePath,
      header: header,
      layers: [], // À implémenter
      symbols: [], // À implémenter
      objects: [], // À implémenter
    );
  }

  /// Lit le header d'un fichier OCAD
  MapFileHeader? _readOcadHeader(Uint8List bytes) {
    if (bytes.length < 32) {
      return null;
    }

    // OCAD 8/9: "OCAD" au début
    // OCAD 10+: signature différente
    final magic = String.fromCharCodes(bytes.sublist(0, 4));
    
    if (magic == 'OCAD') {
      // OCAD 8/9
      final versionByte = bytes[4];
      return MapFileHeader(
        version: versionByte == 8 ? MapFileVersion.v8 : MapFileVersion.v9,
        versionString: versionByte == 8 ? '8' : '9',
        coordinateSystem: CoordinateSystem.local,
        unit: MapUnit.millimeters,
        scale: 1.0,
        mapName: '',
        mapAuthor: '',
        mapOrganization: '',
        creationDate: null,
        modificationDate: null,
        minX: 0.0,
        maxX: 0.0,
        minY: 0.0,
        maxY: 0.0,
        numberOfColors: 0,
        numberOfSymbols: 0,
      );
    } else if (bytes.length > 16 && bytes[16] == 0x0A && bytes[17] == 0x0D) {
      // OCAD 10/11/12
      final version = bytes[20];
      final versionString = version == 10 ? '10' : version == 11 ? '11' : '12';
      final mapVersion = version == 10 ? MapFileVersion.v10 : version == 11 ? MapFileVersion.v11 : MapFileVersion.v12;
      
      return MapFileHeader(
        version: mapVersion,
        versionString: versionString,
        coordinateSystem: CoordinateSystem.local,
        unit: MapUnit.millimeters,
        scale: 1.0,
        mapName: '',
        mapAuthor: '',
        mapOrganization: '',
        creationDate: null,
        modificationDate: null,
        minX: 0.0,
        maxX: 0.0,
        minY: 0.0,
        maxY: 0.0,
        numberOfColors: 0,
        numberOfSymbols: 0,
      );
    }

    return null;
  }

  /// Parse un fichier OOMAP (format XML)
  MapFileData _parseOomapFile(Uint8List bytes, String filePath) {
    try {
      // OOMAP est un format basé XML
      // Pour l'instant, on détecte juste le type
      return MapFileData(
        fileType: MapFileType.oomap,
        filePath: filePath,
        header: MapFileHeader(
          version: MapFileVersion.unknown,
          versionString: '1.0',
          coordinateSystem: CoordinateSystem.local,
          unit: MapUnit.meters,
          scale: 1.0,
          mapName: '',
          mapAuthor: '',
          mapOrganization: '',
          creationDate: null,
          modificationDate: null,
          minX: 0.0,
          maxX: 0.0,
          minY: 0.0,
          maxY: 0.0,
          numberOfColors: 0,
          numberOfSymbols: 0,
        ),
        layers: [],
        symbols: [],
        objects: [],
      );
    } catch (e) {
      throw FormatException('Erreur de parsing OOMAP: $e');
    }
  }

  /// Crée des calques à partir d'un MapFileData
  MapState _createLayersFromMapFile(MapState state, MapFileData mapFile) {
    // Ajoute un calque principal
    var newState = state.addLayer(
      path.basenameWithoutExtension(mapFile.filePath),
      LayerType.vector,
    );

    // Si on a des calques dans le fichier, on les ajoute
    // (À implémenter quand le parsing sera complet)

    return newState;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton pour ouvrir un fichier
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _pickFile,
          icon: const Icon(Icons.folder_open),
          label: const Text('Ouvrir un fichier'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 8),

        // Affichage du fichier sélectionné
        if (_selectedFilePath != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Fichier: ${path.basename(_selectedFilePath!)}',
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Message d'erreur
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),

        // Indicateur de chargement
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),

        // Liste des extensions supportées
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Text(
            'Formats supportés: ${_supportedExtensions.join(", ")}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

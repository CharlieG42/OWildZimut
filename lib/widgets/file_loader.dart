import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as path;

import '../models/omap_file.dart';
import '../models/map_state.dart';

/// Widget pour importer un fichier de carte au format OMAP (OpenOrienteering
/// Mapper). Le format OCAD n'est pas supporte : OWildZimut ne travaille
/// qu'avec des formats ouverts.
class MapFileLoaderWidget extends StatefulWidget {
  final MapState currentState;
  final ValueChanged<MapState> onFileLoaded;

  const MapFileLoaderWidget({
    super.key,
    required this.currentState,
    required this.onFileLoaded,
  });

  @override
  State<MapFileLoaderWidget> createState() => _MapFileLoaderWidgetState();
}

class _MapFileLoaderWidgetState extends State<MapFileLoaderWidget> {
  String? _selectedFilePath;
  String? _errorMessage;
  String? _infoMessage;
  bool _isLoading = false;

  static const List<String> _supportedExtensions = ['.omap'];
  static const List<String> _supportedExtensionsNoDot = ['omap'];

  Future<void> _pickFile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _infoMessage = null;
      });

      final typeGroup = XTypeGroup(
        label: 'Cartes OMAP',
        extensions: _supportedExtensionsNoDot,
      );

      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file != null) {
        await _processFile(file.path);
      }
    } on Exception catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la selection : ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _processFile(String filePath) async {
    setState(() {
      _selectedFilePath = filePath;
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      final ext = path.extension(filePath).toLowerCase();
      if (!_supportedExtensions.contains(ext)) {
        setState(() {
          _errorMessage = 'Extension de fichier non supportee : $ext '
              '(seul le format .omap est pris en charge)';
        });
        return;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        setState(() => _errorMessage = 'Fichier introuvable : $filePath');
        return;
      }

      final xmlContent = await file.readAsString(encoding: utf8);
      final document = OmapFileLoader.parse(xmlContent);

      final newState = OmapFileLoader.mergeIntoState(widget.currentState, document);
      widget.onFileLoaded(newState);

      setState(() {
        _infoMessage = document.objectCount > 0
            ? '${document.layers.length} calque(s) et ${document.objectCount} objet(s) importes depuis ${path.basename(filePath)}.'
            : 'Fichier lu, mais aucun objet exploitable n\'a ete trouve.';
      });
    } on OmapParseException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Erreur lors du chargement : ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _pickFile,
          icon: const Icon(Icons.folder_open),
          label: const Text('Ouvrir un fichier OMAP'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 8),
        if (_selectedFilePath != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Fichier : ${path.basename(_selectedFilePath!)}',
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (_infoMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              _infoMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Text(
            'Format supporte : ${_supportedExtensions.join(", ")}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

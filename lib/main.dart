import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'models/map_state.dart';
import 'models/layer.dart';
import 'models/symbol.dart' as symbol_model;
import 'models/iof_symbols.dart';
import 'models/omap_file.dart';
import 'models/georeferencing.dart' as geo;
import 'services/undo_manager.dart' as undo_service;
import 'widgets/map_view.dart';
import 'widgets/layer_panel.dart';
import 'widgets/tool_bar.dart';
import 'widgets/symbol_selector.dart';
import 'widgets/file_loader.dart';
import 'screens/about_dialog.dart' as app_about;
import 'formatters/omap_exporter.dart';
import 'dart:io';

void main() {
  runApp(const OWildZimutApp());
}

/// Largeur en dessous de laquelle l'interface bascule en mise en page mobile
/// (une seule colonne, outils et calques dans des tiroirs)
const double kMobileBreakpoint = 700;

/// Application principale OWildZimut
class OWildZimutApp extends StatelessWidget {
  const OWildZimutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OWildZimut',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

/// Écran principal de l'application
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MapState _mapState;
  String _currentTool = 'select';
  bool _advancedMode = false;
  
  // Gestion de l'historique
  final undo_service.MapUndoManager _undoManager = undo_service.MapUndoManager(maxHistoryLength: 50);
  
  // Clipboard pour copier/coller
  List<symbol_model.MapSymbol> _clipboard = [];

  @override
  void initState() {
    super.initState();
    _mapState = MapState.initial();
    _undoManager.pushState(_mapState);
  }

  // ============================================================================
  // GESTION DES CALQUES
  // ============================================================================

  void _addLayer() {
    setState(() {
      _mapState = _mapState.addLayer(
        Layer(
          id: 'layer_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Nouveau calque ${_mapState.layers.length + 1}',
          type: LayerType.vector,
        ),
      );
      _pushStateToHistory();
    });
  }

  void _removeLayer(String layerId) {
    setState(() {
      _mapState = _mapState.removeLayer(layerId);
      _pushStateToHistory();
    });
  }

  void _selectLayer(int? index) {
    setState(() {
      if (index != null) {
        _mapState = _mapState.selectLayer(index);
      }
    });
  }

  void _setLayerVisibility(String layerId, bool visible) {
    setState(() {
      final newLayers = _mapState.layers.map((l) {
        if (l.id == layerId) {
          return l.copyWith(visible: visible);
        }
        return l;
      }).toList();
      _mapState = _mapState.copyWith(layers: newLayers);
      _pushStateToHistory();
    });
  }

  void _setLayerOpacity(String layerId, double opacity) {
    setState(() {
      final newLayers = _mapState.layers.map((l) {
        if (l.id == layerId) {
          return l.copyWith(opacity: opacity);
        }
        return l;
      }).toList();
      _mapState = _mapState.copyWith(layers: newLayers);
      _pushStateToHistory();
    });
  }

  void _moveLayerUp(String layerId) {
    setState(() {
      final index = _mapState.layers.indexWhere((l) => l.id == layerId);
      if (index > 0) {
        _mapState = _mapState.moveLayer(index, index - 1);
        _pushStateToHistory();
      }
    });
  }

  void _moveLayerDown(String layerId) {
    setState(() {
      final index = _mapState.layers.indexWhere((l) => l.id == layerId);
      if (index >= 0 && index < _mapState.layers.length - 1) {
        _mapState = _mapState.moveLayer(index, index + 1);
        _pushStateToHistory();
      }
    });
  }

  // ============================================================================
  // GESTION DES SYMBOLES
  // ============================================================================

  void _addSymbol(symbol_model.MapSymbol symbol) {
    setState(() {
      _mapState = _mapState.addSymbol(symbol);
      _pushStateToHistory();
    });
  }

  void _selectSymbol(String symbolId, {bool multiSelect = false}) {
    setState(() {
      _mapState = _mapState.selectSymbol(symbolId, multiSelect: multiSelect);
    });
  }

  void _selectSymbols(Set<String> symbolIds) {
    setState(() {
      _mapState = _mapState.selectSymbols(symbolIds);
    });
  }

  void _selectAllSymbols() {
    setState(() {
      _mapState = _mapState.selectAllSymbols();
    });
  }

  void _clearSelection() {
    setState(() {
      _mapState = _mapState.clearSelection();
    });
  }

  void _deleteSelectedSymbols() {
    if (_mapState.selectedSymbolIds.isEmpty) return;
    
    setState(() {
      _mapState = _mapState.removeSelectedSymbols();
      _pushStateToHistory();
    });
  }

  void _moveSymbols(Set<String> symbolIds, Offset delta) {
    setState(() {
      _mapState = _mapState.moveSymbols(symbolIds, delta);
      _pushStateToHistory();
    });
  }

  // ============================================================================
  // GESTION DU CLIPBOARD
  // ============================================================================

  void _copySelectedSymbols() {
    setState(() {
      _clipboard = _mapState.copyToClipboard();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Symboles copiés')),
      );
    }
  }

  void _pasteSymbols() {
    if (_clipboard.isEmpty) return;
    
    // Calculer un décalage pour éviter de coller au même endroit
    final offset = const Offset(20, 20);
    
    setState(() {
      _mapState = _mapState.pasteFromClipboard(_clipboard, offset);
      _pushStateToHistory();
    });
  }

  // ============================================================================
  // GESTION DE LA VUE
  // ============================================================================

  void _setZoom(double zoom) {
    setState(() {
      _mapState = _mapState.copyWith(zoom: zoom);
    });
  }

  void _setPanOffset(Offset offset) {
    setState(() {
      _mapState = _mapState.copyWith(cameraPosition: offset);
    });
  }

  void _resetView() {
    setState(() {
      _mapState = _mapState.resetView();
    });
  }

  void _zoomIn() {
    setState(() {
      _mapState = _mapState.zoomBy(1.2);
    });
  }

  void _zoomOut() {
    setState(() {
      _mapState = _mapState.zoomBy(0.833);
    });
  }

  // ============================================================================
  // GESTION DES OUTILS
  // ============================================================================

  void _selectTool(String tool) {
    setState(() {
      _currentTool = tool;
      // Effacer la sélection si on change d'outil (sauf pour la sélection)
      if (tool != 'select') {
        _mapState = _mapState.clearSelection();
      }
    });
  }

  // ============================================================================
  // GESTION DE L'HISTORIQUE
  // ============================================================================

  void _pushStateToHistory() {
    _undoManager.pushState(_mapState);
  }

  void _undo() {
    final newState = _undoManager.undo();
    if (newState != null) {
      setState(() {
        _mapState = newState;
      });
    }
  }

  void _redo() {
    final newState = _undoManager.redo();
    if (newState != null) {
      setState(() {
        _mapState = newState;
      });
    }
  }

  // ============================================================================
  // GESTION DES FICHIERS
  // ============================================================================

  Future<void> _loadOmapFile() async {
    try {
      final fileContent = await FileLoader.loadOmapFile();
      if (fileContent == null) return;
      
      final omapDocument = OmapFileLoader.parse(fileContent);
      
      if (mounted) {
        setState(() {
          _mapState = OmapFileLoader.mergeIntoState(_mapState, omapDocument);
          _pushStateToHistory();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fichier OMAP chargé (${omapDocument.layers.length} calques, ${omapDocument.objectCount} objets)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement: $e')),
        );
      }
    }
  }

  Future<void> _exportOmapFile() async {
    try {
      final omapXml = OmapExporter.export(_mapState);
      final filePath = await FileLoader.saveOmapFile(omapXml);
      
      if (filePath != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Carte exportée vers: $filePath')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'export: $e')),
        );
      }
    }
  }

  Future<void> _loadImage() async {
    try {
      final imagePath = await FileLoader.loadImageFile();
      if (imagePath == null) return;
      
      if (mounted) {
        setState(() {
          _mapState = _mapState.addLayer(
            Layer.imageBackground(
              id: 'image_${DateTime.now().millisecondsSinceEpoch}',
              name: 'Image ${_mapState.layers.length + 1}',
              imagePath: imagePath,
            ),
          );
          _pushStateToHistory();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement de l\'image: $e')),
        );
      }
    }
  }

  Future<void> _saveProject() async {
    try {
      // Pour l'instant, on exporte en OMAP
      await _exportOmapFile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde: $e')),
        );
      }
    }
  }

  Future<void> _loadProject() async {
    try {
      await _loadOmapFile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement: $e')),
        );
      }
    }
  }

  // ============================================================================
  // GESTION DU MODE AVANCÉ
  // ============================================================================

  void _toggleAdvancedMode() {
    setState(() {
      _advancedMode = !_advancedMode;
      _mapState = _mapState.copyWith(advancedMode: _advancedMode);
    });
  }

  // ============================================================================
  // BUILD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;
    
    return KeyboardShortcuts.wrapWithShortcuts(
      context: context,
      mapState: _mapState,
      onToolSelected: _selectTool,
      onUndo: _undo,
      onRedo: _redo,
      onDeleteSelected: _deleteSelectedSymbols,
      onCopySelected: _copySelectedSymbols,
      onPaste: _pasteSymbols,
      onSelectAll: _selectAllSymbols,
      onClearSelection: _clearSelection,
      onZoomIn: _zoomIn,
      onZoomOut: _zoomOut,
      onResetView: _resetView,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OWildZimut'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => app_about.showAboutDialog(context),
              tooltip: 'À propos',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProject,
              tooltip: 'Sauvegarder',
            ),
            IconButton(
              icon: const Icon(Icons.folder_open),
              onPressed: _loadProject,
              tooltip: 'Ouvrir',
            ),
            PopupMenuButton<String>(
              tooltip: 'Exporter',
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'omap',
                  child: ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Exporter OMAP'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'image',
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Importer une image'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'omap':
                    _exportOmapFile();
                    break;
                  case 'image':
                    _loadImage();
                    break;
                }
              },
            ),
          ],
        ),
        body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        // Barre d'outils compacte pour mobile
        bottomNavigationBar: isMobile 
            ? CompactToolBar(
                currentTool: _currentTool,
                selectedSymbolIds: _mapState.selectedSymbolIds,
                canUndo: _undoManager.canUndo,
                canRedo: _undoManager.canRedo,
                onToolSelected: _selectTool,
                onUndo: _undo,
                onRedo: _redo,
                onDeleteSelected: _deleteSelectedSymbols,
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onResetView: _resetView,
              )
            : null,
      ),
    );
  }

  /// Layout pour les grands écrans (bureau)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Barre d'outils (gauche)
        ToolBar(
          currentTool: _currentTool,
          selectedLayerIndex: _mapState.selectedLayerIndex,
          selectedSymbolIds: _mapState.selectedSymbolIds,
          canUndo: _undoManager.canUndo,
          canRedo: _undoManager.canRedo,
          advancedMode: _advancedMode,
          onToolSelected: _selectTool,
          onUndo: _undo,
          onRedo: _redo,
          onDeleteSelected: _deleteSelectedSymbols,
          onCopySelected: _copySelectedSymbols,
          onPaste: _pasteSymbols,
          onSelectAll: _selectAllSymbols,
          onClearSelection: _clearSelection,
          onZoomIn: _zoomIn,
          onZoomOut: _zoomOut,
          onResetView: _resetView,
          onToggleAdvancedMode: _toggleAdvancedMode,
        ),
        
        // Zone de carte (centre)
        Expanded(
          child: MapView(
            layers: _mapState.layers,
            zoom: _mapState.zoom,
            cameraPosition: _mapState.cameraPosition,
            selectedLayerIndex: _mapState.selectedLayerIndex,
            currentTool: _currentTool,
            selectedSymbolIds: _mapState.selectedSymbolIds,
            onPanUpdate: _setPanOffset,
            onZoomChanged: _setZoom,
            onSelectionRectChanged: (rect) {
              // Sélectionner les symboles dans le rectangle
              setState(() {
                // TODO: Implémenter la sélection par rectangle
              });
            },
            onSymbolAdded: _addSymbol,
            onSymbolSelected: (symbolId) {
              _selectSymbol(symbolId, multiSelect: false);
            },
            onSymbolsSelected: _selectSymbols,
            onSymbolsMoved: _moveSymbols,
            onSymbolsDeleted: (symbolIds) {
              setState(() {
                _mapState = _mapState.copyWith(selectedSymbolIds: symbolIds);
                _deleteSelectedSymbols();
              });
            },
          ),
        ),
        
        // Panneau des calques (droite)
        LayerPanel(
          layers: _mapState.layers,
          selectedLayerIndex: _mapState.selectedLayerIndex,
          onAddLayer: _addLayer,
          onRemoveLayer: _removeLayer,
          onLayerSelected: _selectLayer,
          onLayerVisibilityChanged: _setLayerVisibility,
          onLayerOpacityChanged: _setLayerOpacity,
          onLayerMoveUp: _moveLayerUp,
          onLayerMoveDown: _moveLayerDown,
        ),
      ],
    );
  }

  /// Layout pour les petits écrans (mobile)
  Widget _buildMobileLayout() {
    return Row(
      children: [
        // Zone de carte (prend tout l'espace)
        Expanded(
          child: MapView(
            layers: _mapState.layers,
            zoom: _mapState.zoom,
            cameraPosition: _mapState.cameraPosition,
            selectedLayerIndex: _mapState.selectedLayerIndex,
            currentTool: _currentTool,
            selectedSymbolIds: _mapState.selectedSymbolIds,
            onPanUpdate: _setPanOffset,
            onZoomChanged: _setZoom,
            onSelectionRectChanged: (rect) {
              setState(() {
                // TODO: Implémenter la sélection par rectangle
              });
            },
            onSymbolAdded: _addSymbol,
            onSymbolSelected: (symbolId) {
              _selectSymbol(symbolId, multiSelect: false);
            },
            onSymbolsSelected: _selectSymbols,
            onSymbolsMoved: _moveSymbols,
            onSymbolsDeleted: (symbolIds) {
              setState(() {
                _mapState = _mapState.copyWith(selectedSymbolIds: symbolIds);
                _deleteSelectedSymbols();
              });
            },
          ),
        ),
      ],
    );
  }
}

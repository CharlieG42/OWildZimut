import 'package:flutter/material.dart';
import 'models/map_state.dart';
import 'models/layer.dart';
import 'models/symbol.dart' as symbol_model;
import 'models/omap_file.dart';
import 'services/undo_manager.dart' as undo_service;
import 'widgets/map_view.dart';
import 'widgets/layer_panel.dart';
import 'widgets/tool_bar.dart';
import 'widgets/file_loader.dart';
import 'widgets/background_image_picker.dart';
import 'widgets/recenter_controls.dart';
import 'screens/about_dialog.dart' as app_about;
import 'formatters/omap_exporter.dart';

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
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          margin: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
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
  final bool _toolBarExpanded = true;
  bool _advancedMode = false;
  
  // Gestion de l'historique
  final undo_service.UndoManager _undoManager = undo_service.UndoManager(maxHistoryLength: 50);
  
  // Clipboard pour copier/coller
  List<symbol_model.MapSymbol> _clipboard = [];
  
  final GlobalKey _mapViewKey = GlobalKey();

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
        'Nouveau calque ${_mapState.layers.length + 1}',
        LayerType.vector,
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
      _mapState = _mapState.selectLayer(index);
    });
  }

  void _setLayerVisibility(String layerId, bool visible) {
    setState(() {
      _mapState = _mapState.setLayerVisibility(layerId, visible);
      _pushStateToHistory();
    });
  }

  void _setLayerOpacity(String layerId, double opacity) {
    setState(() {
      _mapState = _mapState.setLayerOpacity(layerId, opacity);
      _pushStateToHistory();
    });
  }

  void _moveLayerUp(String layerId) {
    setState(() {
      _mapState = _mapState.moveLayerUp(layerId);
      _pushStateToHistory();
    });
  }

  void _moveLayerDown(String layerId) {
    setState(() {
      _mapState = _mapState.moveLayerDown(layerId);
      _pushStateToHistory();
    });
  }

  // ============================================================================
  // GESTION DES SYMBOLES
  // ============================================================================

  void _addSymbol(symbol_model.MapSymbol symbol) {
    setState(() {
      _mapState = _mapState.addSymbolToSelectedLayer(symbol);
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
      _mapState = _mapState.copyWith(selectedSymbolIds: symbolIds);
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
      _mapState = _mapState.moveSelectedSymbols(delta);
      _pushStateToHistory();
    });
  }

  // ============================================================================
  // GESTION DU CLIPBOARD
  // ============================================================================

  void _copySelectedSymbols() {
    setState(() {
      _clipboard = _mapState.copySelectedSymbols();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Symboles copiés')),
    );
  }

  void _pasteSymbols() {
    if (_clipboard.isEmpty || _mapState.selectedLayerIndex == null) return;
    
    // Calculer un décalage pour éviter de coller au même endroit
    final offset = Offset(20, 20);
    
    setState(() {
      _mapState = _mapState.pasteSymbols(_clipboard, offset);
      _pushStateToHistory();
    });
  }

  // ============================================================================
  // GESTION DE LA VUE
  // ============================================================================

  void _setZoomLevel(double zoom) {
    setState(() {
      _mapState = _mapState.setZoomLevel(zoom);
    });
  }

  void _setPanOffset(Offset offset) {
    setState(() {
      _mapState = _mapState.setPanOffset(offset);
    });
  }

  void _zoomBy(double factor, Offset focalPoint) {
    setState(() {
      _mapState = _mapState.zoomBy(factor, focalPoint);
    });
  }

  void _panBy(Offset delta) {
    setState(() {
      _mapState = _mapState.panBy(delta);
    });
  }

  void _resetView() {
    setState(() {
      _mapState = _mapState.resetView();
    });
  }

  void _zoomIn() {
    setState(() {
      _mapState = _mapState.setZoomLevel(_mapState.zoomLevel * 1.2);
    });
  }

  void _zoomOut() {
    setState(() {
      _mapState = _mapState.setZoomLevel(_mapState.zoomLevel / 1.2);
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
      
      setState(() {
        _mapState = OmapFileLoader.mergeIntoState(_mapState, omapDocument);
        _pushStateToHistory();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier OMAP chargé (${omapDocument.layers.length} calques, ${omapDocument.objectCount} objets)')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement: $e')),
      );
    }
  }

  Future<void> _exportOmapFile() async {
    try {
      final omapXml = _mapState.toOmapXml();
      final filePath = await FileLoader.saveOmapFile(omapXml);
      
      if (filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Carte exportée vers: $filePath')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'export: $e')),
      );
    }
  }

  Future<void> _loadImage() async {
    try {
      final imagePath = await pickBackgroundImage();
      if (imagePath == null) return;
      
      setState(() {
        _mapState = _mapState.addImageBackgroundLayer(
          'Image ${_mapState.layers.length + 1}',
          imagePath.path,
        );
        _pushStateToHistory();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement de l\'image: $e')),
      );
    }
  }

  Future<void> _saveProject() async {
    try {
      // Pour l'instant, on exporte en OMAP
      await _exportOmapFile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde: $e')),
      );
    }
  }

  Future<void> _loadProject() async {
    await _loadOmapFile();
  }

  // ============================================================================
  // GESTION DU MODE AVANCÉ
  // ============================================================================

  void _toggleAdvancedMode() {
    setState(() {
      _advancedMode = !_advancedMode;
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
              onPressed: () => showDialog(
                context: context,
                builder: (context) => app_about.AboutDialog(appVersion: '1.0.0'),
              ),
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
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: _exportOmapFile,
              tooltip: 'Exporter OMAP',
            ),
            PopupMenuButton<String>(
              tooltip: 'Plus d\'options',
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'image',
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Importer une image'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'omap',
                  child: ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Importer OMAP'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'image':
                    _loadImage();
                    break;
                  case 'omap':
                    _loadOmapFile();
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
          selectedLayerIndex: _mapState.selectedLayerIndex ?? 0,
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
          child: Stack(
            children: [
              MapView(
                key: _mapViewKey,
                layers: _mapState.layers,
                zoomLevel: _mapState.zoomLevel,
                panOffset: _mapState.panOffset,
                selectedLayerIndex: _mapState.selectedLayerIndex,
                currentTool: _currentTool,
                selectedSymbolIds: _mapState.selectedSymbolIds,
                onPanUpdate: _setPanOffset,
                onZoomChanged: _setZoomLevel,
                onSelectionRectChanged: (rect) {
                  // Sélectionner les symboles dans le rectangle
                  setState(() {
                    _mapState = _mapState.selectSymbolsInRect(rect);
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
              Positioned(
                right: 16,
                bottom: 16,
                child: RecenterControls(
                  onPanBy: _panBy,
                  onResetView: _resetView,
                ),
              ),
            ],
          ),
        ),
        
        // Panneau des calques (droite)
        SizedBox(
          width: 250,
          child: LayerPanel(
            layers: _mapState.layers,
            selectedLayerIndex: _mapState.selectedLayerIndex,
            onAddLayer: _addLayer,
            onLayerRemoved: _removeLayer,
            onLayerSelected: _selectLayer,
            onLayerVisibilityChanged: _setLayerVisibility,
            onLayerOpacityChanged: _setLayerOpacity,
            onLayerMoveUp: _moveLayerUp,
            onLayerMoveDown: _moveLayerDown,
          ),
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
          child: Stack(
            children: [
              MapView(
                key: _mapViewKey,
                layers: _mapState.layers,
                zoomLevel: _mapState.zoomLevel,
                panOffset: _mapState.panOffset,
                selectedLayerIndex: _mapState.selectedLayerIndex,
                currentTool: _currentTool,
                selectedSymbolIds: _mapState.selectedSymbolIds,
                onPanUpdate: _setPanOffset,
                onZoomChanged: _setZoomLevel,
                onSelectionRectChanged: (rect) {
                  setState(() {
                    _mapState = _mapState.selectSymbolsInRect(rect);
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
              Positioned(
                right: 16,
                bottom: 16,
                child: RecenterControls(
                  onPanBy: _panBy,
                  onResetView: _resetView,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'models/map_state.dart';
import 'models/layer.dart';
import 'models/symbol.dart' as symbol_model;
import 'models/iof_symbols.dart';
import 'widgets/map_view.dart';
import 'widgets/layer_panel.dart';
import 'widgets/tool_bar.dart';
import 'widgets/symbol_selector.dart';
import 'widgets/file_loader.dart';
import 'widgets/file_loader.dart';
import 'screens/about_dialog.dart' as app_about;

void main() {
  runApp(const OWildZimutApp());
}

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
          margin: EdgeInsets.all(4),
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
      home: MainScreen(),
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
  bool _toolBarExpanded = true;
  final bool _layerPanelExpanded = true;

  @override
  void initState() {
    super.initState();
    // Initialisation avec quelques calques par défaut
    _mapState = MapState(
      appVersion: '0.0.002',
    );
    // Ajout de calques par défaut
    _mapState = _mapState.addLayer('Carte de base', LayerType.vector);
    _mapState = _mapState.addLayer('Végétation', LayerType.vector);
    _mapState = _mapState.addLayer('Chemins', LayerType.vector);
  }

  /// Ajoute un nouveau calque
  void _addLayer() {
    setState(() {
      _mapState = _mapState.addLayer(
        'Nouveau calque ${_mapState.layers.length + 1}',
        LayerType.vector,
      );
    });
  }

  /// Supprime un calque
  void _removeLayer(String layerId) {
    setState(() {
      _mapState = _mapState.removeLayer(layerId);
    });
  }

  /// Modifie la visibilité d'un calque
  void _setLayerVisibility(String layerId, bool visible) {
    setState(() {
      _mapState = _mapState.setLayerVisibility(layerId, visible);
    });
  }

  /// Modifie l'opacité d'un calque
  void _setLayerOpacity(String layerId, double opacity) {
    setState(() {
      _mapState = _mapState.setLayerOpacity(layerId, opacity);
    });
  }

  /// Monte un calque dans la pile (augmente z-index)
  void _moveLayerUp(String layerId) {
    setState(() {
      final layer = _mapState.layers.firstWhere((l) => l.id == layerId);
      final currentZIndex = layer.zIndex;
      if (currentZIndex < _mapState.layers.length) {
        _mapState = _mapState.setLayerZIndex(layerId, currentZIndex + 1);
      }
    });
  }

  /// Descend un calque dans la pile (diminue z-index)
  void _moveLayerDown(String layerId) {
    setState(() {
      final layer = _mapState.layers.firstWhere((l) => l.id == layerId);
      final currentZIndex = layer.zIndex;
      if (currentZIndex > 1) {
        _mapState = _mapState.setLayerZIndex(layerId, currentZIndex - 1);
      }
    });
  }

  /// Sélectionne un calque
  void _selectLayer(int index) {
    setState(() {
      _mapState = _mapState.selectLayer(index);
    });
  }

  /// Modifie le niveau de zoom
  void _setZoomLevel(double zoom) {
    setState(() {
      _mapState = _mapState.setZoomLevel(zoom);
    });
  }

  /// Modifie le décalage de la vue
  void _setPanOffset(Offset offset) {
    setState(() {
      _mapState = _mapState.setPanOffset(offset);
    });
  }

  /// Réinitialise la vue
  void _resetView() {
    setState(() {
      _mapState = _mapState.resetView();
    });
  }

  /// Change l'outil sélectionné
  void _setCurrentTool(String tool) {
    setState(() {
      _currentTool = tool;
    });
  }

  /// Zoom avant
  void _zoomIn() {
    setState(() {
      _mapState = _mapState.setZoomLevel(_mapState.zoomLevel * 1.2);
    });
  }

  /// Zoom arrière
  void _zoomOut() {
    setState(() {
      _mapState = _mapState.setZoomLevel(_mapState.zoomLevel / 1.2);
    });
  }

  /// Ajoute un symbole au calque sélectionné
  void _addSymbol(symbol_model.MapSymbol symbol) {
    if (_mapState.selectedLayerIndex == null) return;

    setState(() {
      _mapState = _mapState.addSymbolToSelectedLayer(symbol);
    });
  }

  /// Ouvre le sélecteur de symboles
  void _openSymbolSelector() {
    showDialog(
      context: context,
      builder: (context) => const SymbolSelectorDialog(
        detailLevel: SymbolDetailLevel.standard,
      ),
    ).then((selectedSymbol) {
      if (selectedSymbol != null) {
        _addSymbol(selectedSymbol);
      }
    });
  }

  /// Affiche le dialogue "À propos"
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => app_about.AboutDialog(appVersion: _mapState.appVersion),
    );
  }

  /// Ouvre le sélecteur de fichiers
  void _openFileLoader() {
    showDialog(
      context: context,
      builder: (context) => MapFileLoaderWidget(
        onFileLoaded: (newState) {
          setState(() {
            _mapState = newState;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// Toggle l'expansion de la barre d'outils
  void _toggleToolBar() {
    setState(() {
      _toolBarExpanded = !_toolBarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OWildZimut'),
        actions: [
          // Bouton pour ouvrir un fichier
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _openFileLoader,
            tooltip: 'Ouvrir un fichier OCAD/OOMAP',
          ),
          // Bouton pour ouvrir le sélecteur de symboles
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _openSymbolSelector,
            tooltip: 'Ajouter un symbole IOF',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
            tooltip: 'À propos',
          ),
        ],
      ),
      body: Row(
        children: [
          // Barre d'outils à gauche
          SizedBox(
            width: _toolBarExpanded ? 200 : 40,
            child: ToolBar(
              currentTool: _currentTool,
              onToolChanged: _setCurrentTool,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onResetView: _resetView,
              isExpanded: _toolBarExpanded,
              onToggleExpand: _toggleToolBar,
            ),
          ),
          // Zone de carte centrale
          Expanded(
            child: MapView(
              layers: _mapState.layers,
              zoomLevel: _mapState.zoomLevel,
              panOffset: _mapState.panOffset,
              selectedLayerIndex: _mapState.selectedLayerIndex,
              currentTool: _currentTool,
              onPanUpdate: _setPanOffset,
              onZoomChanged: _setZoomLevel,
              onSymbolAdded: _addSymbol,
            ),
          ),
          // Panneau des calques à droite
          SizedBox(
            width: _layerPanelExpanded ? 280 : 40,
            child: LayerPanel(
              layers: _mapState.layers,
              selectedLayerIndex: _mapState.selectedLayerIndex,
              onLayerSelected: _selectLayer,
              onLayerVisibilityChanged: (visible) {
                if (_mapState.selectedLayerIndex != null) {
                  final layer = _mapState.layers[_mapState.selectedLayerIndex!];
                  _setLayerVisibility(layer.id, visible);
                }
              },
              onLayerOpacityChanged: _setLayerOpacity,
              onAddLayer: _addLayer,
              onLayerRemoved: _removeLayer,
              onLayerMoveUp: _moveLayerUp,
              onLayerMoveDown: _moveLayerDown,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'models/map_state.dart';
import 'models/layer.dart';
import 'widgets/map_view.dart';
import 'widgets/layer_panel.dart';
import 'widgets/tool_bar.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialisation avec quelques calques par défaut
    _mapState = MapState(
      appVersion: '0.0.001',
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

  /// Affiche le dialogue "À propos"
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => app_about.AboutDialog(appVersion: _mapState.appVersion),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OWildZimut'),
        actions: [
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
            width: 200,
            child: ToolBar(
              currentTool: _currentTool,
              onToolChanged: _setCurrentTool,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onResetView: _resetView,
            ),
          ),
          // Zone de carte centrale
          Expanded(
            child: MapView(
              layers: _mapState.layers,
              zoomLevel: _mapState.zoomLevel,
              panOffset: _mapState.panOffset,
              selectedLayerIndex: _mapState.selectedLayerIndex,
              onPanUpdate: _setPanOffset,
              onZoomChanged: _setZoomLevel,
            ),
          ),
          // Panneau des calques à droite
          SizedBox(
            width: 300,
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

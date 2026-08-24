import 'package:flutter/material.dart';
import 'models/layer.dart';
import 'models/map_state.dart';
import 'widgets/layer_panel.dart';
import 'widgets/map_view.dart';
import 'widgets/tool_bar.dart';
import 'screens/about_dialog.dart';

void main() {
  runApp(const OWildZimutApp());
}

/// Application principale
class OWildZimutApp extends StatelessWidget {
  const OWildZimutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OWildZimut',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MapEditorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Écran principal de l'éditeur de cartes
class MapEditorScreen extends StatefulWidget {
  const MapEditorScreen({super.key});

  @override
  State<MapEditorScreen> createState() => _MapEditorScreenState();
}

class _MapEditorScreenState extends State<MapEditorScreen> {
  late MapState _mapState;
  String _currentTool = 'select';

  @override
  void initState() {
    super.initState();
    // Initialiser avec des calques par défaut
    _mapState = MapState(appVersion: '0.0.001')
        .addLayer('Végétation', LayerType.vector)
        .addLayer('Chemins', LayerType.vector)
        .addLayer('Contrôles', LayerType.vector);
  }

  /// Ajoute un nouveau calque
  void _addLayer() {
    setState(() {
      _mapState = _mapState.addLayer('Nouveau Calque', LayerType.vector);
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

  /// Monte un calque dans la pile
  void _moveLayerUp(String layerId) {
    final layer = _mapState.layers.firstWhere((l) => l.id == layerId);
    setState(() {
      _mapState = _mapState.setLayerZIndex(layerId, layer.zIndex + 1);
    });
  }

  /// Descend un calque dans la pile
  void _moveLayerDown(String layerId) {
    final layer = _mapState.layers.firstWhere((l) => l.id == layerId);
    setState(() {
      _mapState = _mapState.setLayerZIndex(layerId, layer.zIndex - 1);
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

  /// Réinitialise la vue
  void _resetView() {
    setState(() {
      _mapState = _mapState.resetView();
    });
  }

  /// Change l'outil courant
  void _setTool(String tool) {
    setState(() {
      _currentTool = tool;
    });
  }

  /// Affiche la boîte de dialogue À propos
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(appVersion: _mapState.appVersion),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OWildZimut'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showAboutDialog,
            tooltip: 'À propos',
          ),
        ],
      ),
      body: Row(
        children: [
          // Panneau des calques (gauche)
          SizedBox(
            width: 300,
            child: LayerPanel(
              layers: _mapState.layers,
              selectedLayerIndex: _mapState.selectedLayerIndex,
              onLayerSelected: _selectLayer,
              onLayerVisibilityChanged: _setLayerVisibility,
              onLayerOpacityChanged: _setLayerOpacity,
              onAddLayer: _addLayer,
              onLayerRemoved: _removeLayer,
              onLayerMoveUp: _moveLayerUp,
              onLayerMoveDown: _moveLayerDown,
            ),
          ),
          
          // Vue de la carte (centre)
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
          
          // Barre d'outils (droite)
          SizedBox(
            width: 200,
            child: ToolBar(
              currentTool: _currentTool,
              onToolChanged: _setTool,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onResetView: _resetView,
            ),
          ),
        ],
      ),
      // Barre de raccourcis clavier
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.keyPlus, control: true): 
            const ZoomInIntent(),
        const SingleActivator(LogicalKeyboardKey.keyMinus, control: true): 
            const ZoomOutIntent(),
        const SingleActivator(LogicalKeyboardKey.digit0, control: true): 
            const ResetViewIntent(),
      },
      actions: {
        ZoomInIntent: CallbackAction(onInvoke: (_) => _zoomIn()),
        ZoomOutIntent: CallbackAction(onInvoke: (_) => _zoomOut()),
        ResetViewIntent: CallbackAction(onInvoke: (_) => _resetView()),
      },
    );
  }
}

// Intents pour les raccourcis clavier
class ZoomInIntent extends Intent {}
class ZoomOutIntent extends Intent {}
class ResetViewIntent extends Intent {}

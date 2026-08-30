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
import 'widgets/background_image_picker.dart';
import 'screens/about_dialog.dart' as app_about;

void main() {
  runApp(const OWildZimutApp());
}

/// Largeur en dessous de laquelle l'interface bascule en mise en page mobile
/// (une seule colonne, outils et calques dans des tiroirs), pensee pour des
/// telephones de type S23+ (ecran ~384dp de large en mode portrait).
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

/// Ecran principal de l'application
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MapState _mapState;
  String _currentTool = 'select';
  bool _toolBarExpanded = true;

  final GlobalKey _mapViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mapState = const MapState(appVersion: '0.0.006');
    _mapState = _mapState.addLayer('Carte de base', LayerType.vector);
    _mapState = _mapState.addLayer('Vegetation', LayerType.vector);
    _mapState = _mapState.addLayer('Chemins', LayerType.vector);
  }

  void _addLayer() {
    setState(() {
      _mapState = _mapState.addLayer(
        'Nouveau calque ${_mapState.layers.length + 1}',
        LayerType.vector,
      );
    });
  }

  void _removeLayer(String layerId) {
    setState(() {
      _mapState = _mapState.removeLayer(layerId);
    });
  }

  void _setLayerVisibility(String layerId, bool visible) {
    setState(() {
      _mapState = _mapState.setLayerVisibility(layerId, visible);
    });
  }

  void _setLayerOpacity(String layerId, double opacity) {
    setState(() {
      _mapState = _mapState.setLayerOpacity(layerId, opacity);
    });
  }

  void _moveLayerUp(String layerId) {
    setState(() {
      final layer = _mapState.layers.firstWhere((l) => l.id == layerId);
      final currentZIndex = layer.zIndex;
      if (currentZIndex < _mapState.layers.length) {
        _mapState = _mapState.setLayerZIndex(layerId, currentZIndex + 1);
      }
    });
  }

  void _moveLayerDown(String layerId) {
    setState(() {
      final layer = _mapState.layers.firstWhere((l) => l.id == layerId);
      final currentZIndex = layer.zIndex;
      if (currentZIndex > 1) {
        _mapState = _mapState.setLayerZIndex(layerId, currentZIndex - 1);
      }
    });
  }

  void _selectLayer(int index) {
    setState(() {
      _mapState = _mapState.selectLayer(index);
    });
  }

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

  void _resetView() {
    setState(() {
      _mapState = _mapState.resetView();
    });
  }

  void _setCurrentTool(String tool) {
    setState(() {
      _currentTool = tool;
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

  void _addSymbol(symbol_model.MapSymbol symbol) {
    if (_mapState.selectedLayerIndex == null) return;

    setState(() {
      _mapState = _mapState.addSymbolToSelectedLayer(symbol);
    });
  }

  /// Position, dans le repere de la carte, du centre actuellement visible
  /// dans la zone de dessin. Utilise pour placer un symbole choisi depuis le
  /// selecteur bien au centre de la vue plutot qu'a l'origine (0,0).
  Offset _visibleCenterInMapCoordinates() {
    final renderBox = _mapViewKey.currentContext?.findRenderObject() as RenderBox?;
    final screenCenter = renderBox != null
        ? Offset(renderBox.size.width / 2, renderBox.size.height / 2)
        : Offset.zero;
    return (screenCenter - _mapState.panOffset) / _mapState.zoomLevel;
  }

  void _openSymbolSelector() {
    showDialog(
      context: context,
      builder: (context) => const SymbolSelectorDialog(
        detailLevel: SymbolDetailLevel.standard,
      ),
    ).then((selectedSymbol) {
      if (selectedSymbol is symbol_model.MapSymbol) {
        final centered = selectedSymbol.copyWith(
          position: _visibleCenterInMapCoordinates(),
        );
        _addSymbol(centered);
      }
    });
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => app_about.AboutDialog(appVersion: _mapState.appVersion),
    );
  }

  void _openFileLoader() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MapFileLoaderWidget(
                currentState: _mapState,
                onFileLoaded: (newState) {
                  setState(() {
                    _mapState = newState;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ouvre le selecteur de fichiers pour importer une image de fond de carte
  /// (jpg, jpeg ou png) et l'ajoute comme nouveau calque raster.
  Future<void> _openBackgroundImagePicker() async {
    final file = await pickBackgroundImage();
    if (file == null) return;

    setState(() {
      _mapState = _mapState.addImageBackgroundLayer(file.name, file.path);
    });
  }

  void _toggleToolBar() {
    setState(() {
      _toolBarExpanded = !_toolBarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;
    return isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context);
  }

  List<Widget> _appBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.folder_open),
        onPressed: _openFileLoader,
        tooltip: 'Ouvrir un fichier OMAP',
      ),
      IconButton(
        icon: const Icon(Icons.image_outlined),
        onPressed: _openBackgroundImagePicker,
        tooltip: 'Importer un fond de carte (jpg, jpeg, png)',
      ),
      IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: _openSymbolSelector,
        tooltip: 'Ajouter un symbole IOF',
      ),
      IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: _showAboutDialog,
        tooltip: 'A propos',
      ),
    ];
  }

  /// Mise en page pour grand ecran (tablette large, desktop) : trois
  /// colonnes fixes, comme dans les versions precedentes.
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OWildZimut'),
        actions: _appBarActions(),
      ),
      body: Row(
        children: [
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
          Expanded(child: _buildMapView()),
          SizedBox(
            width: 280,
            child: LayerPanel(
              layers: _mapState.layers,
              selectedLayerIndex: _mapState.selectedLayerIndex,
              onLayerSelected: _selectLayer,
              onLayerVisibilityChanged: _onLayerVisibilityChanged,
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

  /// Mise en page pour telephone (S23+ et similaires) : la carte occupe tout
  /// l'ecran, les outils et les calques sont dans des tiroirs (Drawer)
  /// accessibles depuis la barre d'application, et une barre d'outils
  /// compacte et defilante reste toujours visible en bas.
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OWildZimut'),
        actions: _appBarActions(),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Builder(
            builder: (drawerContext) => SingleChildScrollView(
              child: ToolBar(
                currentTool: _currentTool,
                onToolChanged: (tool) {
                  _setCurrentTool(tool);
                  Scaffold.of(drawerContext).closeDrawer();
                },
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onResetView: _resetView,
                isExpanded: true,
                onToggleExpand: () => Scaffold.of(drawerContext).closeDrawer(),
              ),
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: LayerPanel(
            layers: _mapState.layers,
            selectedLayerIndex: _mapState.selectedLayerIndex,
            onLayerSelected: _selectLayer,
            onLayerVisibilityChanged: _onLayerVisibilityChanged,
            onLayerOpacityChanged: _setLayerOpacity,
            onAddLayer: _addLayer,
            onLayerRemoved: _removeLayer,
            onLayerMoveUp: _moveLayerUp,
            onLayerMoveDown: _moveLayerDown,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMapView()),
          _buildMobileQuickToolbar(),
        ],
      ),
    );
  }

  /// Barre d'outils compacte, toujours visible et defilante horizontalement,
  /// affichee en bas de l'ecran sur mobile pour un acces rapide aux outils
  /// de dessin sans devoir ouvrir le tiroir.
  Widget _buildMobileQuickToolbar() {
    final tools = <(String value, IconData icon, String label)>[
      ('select', Icons.select_all, 'Selection'),
      ('point', Icons.circle, 'Point'),
      ('line', Icons.polyline, 'Ligne'),
      ('polygon', Icons.check, 'Polygone'),
      ('text', Icons.text_fields, 'Texte'),
    ];

    return Material(
      elevation: 4,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    tooltip: 'Outils',
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const VerticalDivider(width: 1),
                for (final tool in tools)
                  IconButton(
                    icon: Icon(tool.$2),
                    tooltip: tool.$3,
                    onPressed: () => _setCurrentTool(tool.$1),
                    color: _currentTool == tool.$1
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                const VerticalDivider(width: 1),
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  tooltip: 'Zoom avant',
                  onPressed: _zoomIn,
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  tooltip: 'Zoom arriere',
                  onPressed: _zoomOut,
                ),
                IconButton(
                  icon: const Icon(Icons.exposure_zero),
                  tooltip: 'Reinitialiser la vue',
                  onPressed: _resetView,
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.layers),
                    tooltip: 'Calques',
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLayerVisibilityChanged(bool visible) {
    if (_mapState.selectedLayerIndex != null) {
      final layer = _mapState.layers[_mapState.selectedLayerIndex!];
      _setLayerVisibility(layer.id, visible);
    }
  }

  Widget _buildMapView() {
    return MapView(
      key: _mapViewKey,
      layers: _mapState.layers,
      zoomLevel: _mapState.zoomLevel,
      panOffset: _mapState.panOffset,
      selectedLayerIndex: _mapState.selectedLayerIndex,
      currentTool: _currentTool,
      onPanUpdate: _setPanOffset,
      onZoomChanged: _setZoomLevel,
      onSymbolAdded: _addSymbol,
    );
  }
}

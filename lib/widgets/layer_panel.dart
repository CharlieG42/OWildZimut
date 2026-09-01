import 'package:flutter/material.dart';
import 'layer_item.dart';
import '../models/layer.dart';

/// Panneau de gestion des calques
typedef LayerVisibilityCallback = void Function(String layerId, bool visible);
typedef LayerOpacityCallback = void Function(String layerId, double opacity);
typedef LayerVisibilityCallback = void Function(String layerId, bool visible);

class LayerPanel extends StatefulWidget {
  final List<Layer> layers;
  final int? selectedLayerIndex;
  final ValueChanged<int> onLayerSelected;
  final LayerVisibilityCallback onLayerVisibilityChanged;
  final LayerOpacityCallback onLayerOpacityChanged;
  final VoidCallback onAddLayer;
  final ValueChanged<String> onLayerRemoved;
  final ValueChanged<String> onLayerMoveUp;
  final ValueChanged<String> onLayerMoveDown;

  const LayerPanel({
    super.key,
    required this.layers,
    this.selectedLayerIndex,
    required this.onLayerSelected,
    required this.onLayerVisibilityChanged,
    required this.onLayerOpacityChanged,
    required this.onAddLayer,
    required this.onLayerRemoved,
    required this.onLayerMoveUp,
    required this.onLayerMoveDown,
  });

  @override
  State<LayerPanel> createState() => _LayerPanelState();
}

class _LayerPanelState extends State<LayerPanel> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return _buildCollapsedPanel(context);
    }
    return _buildExpandedPanel(context);
  }

  Widget _buildCollapsedPanel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => setState(() => _isExpanded = true),
          tooltip: 'Développer le panneau des calques',
        ),
        const SizedBox(height: 4),
        if (widget.selectedLayerIndex != null && widget.layers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.layers[widget.selectedLayerIndex!].name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedPanel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.all(4),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Calques',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: widget.onAddLayer,
                  tooltip: 'Ajouter un calque',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    maxWidth: 28,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 18),
                  onPressed: () => setState(() => _isExpanded = false),
                  tooltip: 'Réduire le panneau',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    maxWidth: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(4),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ListView.builder(
                primary: false,
                itemCount: widget.layers.length,
                itemBuilder: (context, displayIndex) {
                  // widget.layers est ordonné du plus bas (index 0) au plus
                  // haut (dernier index) de la pile. Le panneau doit afficher
                  // le calque le plus haut EN PREMIER (convention standard :
                  // le calque en haut de la liste est au-dessus des autres
                  // sur la carte) — on affiche donc la liste inversée.
                  final index = widget.layers.length - 1 - displayIndex;
                  final layer = widget.layers[index];
                  return LayerItem(
                    layer: layer,
                    isSelected: widget.selectedLayerIndex == index,
                    onTap: () => widget.onLayerSelected(index),
                    onVisibilityChanged: (visible) =>
                        widget.onLayerVisibilityChanged(layer.id, visible),
                    onOpacityChanged: (opacity) =>
                        widget.onLayerOpacityChanged(layer.id, opacity),
                    onMoveUp: () => widget.onLayerMoveUp(layer.id),
                    onMoveDown: () => widget.onLayerMoveDown(layer.id),
                    onRemove: () => widget.onLayerRemoved(layer.id),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.selectedLayerIndex != null && widget.layers.isNotEmpty)
          Card(
            margin: const EdgeInsets.all(4),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                'Sélectionné: ${widget.layers[widget.selectedLayerIndex!].name}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

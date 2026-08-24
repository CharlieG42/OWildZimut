import 'package:flutter/material.dart';
import 'layer_item.dart';
import '../models/layer.dart';

/// Panneau de gestion des calques
class LayerPanel extends StatelessWidget {
  final List<Layer> layers;
  final int? selectedLayerIndex;
  final ValueChanged<int> onLayerSelected;
  final ValueChanged<String> onLayerVisibilityChanged;
  final ValueChanged<String, double> onLayerOpacityChanged;
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        // En-tête du panneau
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const Text(
                'Calques',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAddLayer,
                tooltip: 'Ajouter un calque',
              ),
            ],
          ),
        ),
        
        // Liste des calques
        Expanded(
          child: ListView.builder(
            itemCount: layers.length,
            itemBuilder: (context, index) {
              final layer = layers[index];
              return LayerItem(
                layer: layer,
                isSelected: selectedLayerIndex == index,
                onTap: () => onLayerSelected(index),
                onVisibilityChanged: (visible) => 
                    onLayerVisibilityChanged(layer.id),
                onOpacityChanged: (opacity) => 
                    onLayerOpacityChanged(layer.id, opacity),
                onMoveUp: () => onLayerMoveUp(layer.id),
                onMoveDown: () => onLayerMoveDown(layer.id),
                onRemove: () => onLayerRemoved(layer.id),
              );
            },
          ),
        ),
        
        // Info sur le calque sélectionné
        if (selectedLayerIndex != null && layers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Sélectionné: ${layers[selectedLayerIndex!].name}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}

// Helper pour les callbacks avec deux paramètres
typedef void LayerOpacityCallback(String layerId, double opacity);

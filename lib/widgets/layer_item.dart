import 'package:flutter/material.dart';
import '../models/layer.dart';

/// Widget pour afficher un élément de calque dans la liste
class LayerItem extends StatelessWidget {
  final Layer layer;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onVisibilityChanged;
  final ValueChanged<double>? onOpacityChanged;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback? onRemove;

  const LayerItem({
    super.key,
    required this.layer,
    this.isSelected = false,
    this.onTap,
    this.onVisibilityChanged,
    this.onOpacityChanged,
    this.onMoveUp,
    this.onMoveDown,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface,
      elevation: isSelected ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                layer.visible ? Icons.visibility : Icons.visibility_off,
                color: layer.visible ? Colors.green : Colors.grey,
              ),
              onPressed: () => onVisibilityChanged?.call(!layer.visible),
              tooltip: layer.visible ? 'Masquer' : 'Afficher',
            ),
            Expanded(
              child: Text(
                layer.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 100,
              child: Slider(
                value: layer.opacity,
                onChanged: onOpacityChanged,
                min: 0,
                max: 1,
                label: '${(layer.opacity * 100).round()}%',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward, size: 18),
              onPressed: onMoveUp,
              tooltip: 'Monter',
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward, size: 18),
              onPressed: onMoveDown,
              tooltip: 'Descendre',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
              onPressed: onRemove,
              tooltip: 'Supprimer',
            ),
          ],
        ),
      ),
    );
  }
}

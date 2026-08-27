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
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface,
      elevation: isSelected ? 3 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  layer.visible ? Icons.visibility : Icons.visibility_off,
                  color: layer.visible ? Colors.green : Colors.grey,
                  size: 16,
                ),
                onPressed: () => onVisibilityChanged?.call(!layer.visible),
                tooltip: layer.visible ? 'Masquer' : 'Afficher',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, maxWidth: 24),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    layer.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                child: Slider(
                  value: layer.opacity,
                  onChanged: onOpacityChanged,
                  min: 0,
                  max: 1,
                  label: '${(layer.opacity * 100).round()}%',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_upward, size: 14),
                onPressed: onMoveUp,
                tooltip: 'Monter',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 20, maxWidth: 20),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, size: 14),
                onPressed: onMoveDown,
                tooltip: 'Descendre',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 20, maxWidth: 20),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 14),
                onPressed: onRemove,
                tooltip: 'Supprimer',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 20, maxWidth: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

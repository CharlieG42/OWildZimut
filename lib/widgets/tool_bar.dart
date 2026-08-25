import 'package:flutter/material.dart';

/// Barre d'outils pour l'éditeur de cartes
class ToolBar extends StatelessWidget {
  final String currentTool;
  final ValueChanged<String> onToolChanged;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetView;

  const ToolBar({
    super.key,
    required this.currentTool,
    required this.onToolChanged,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Outils',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ..._buildToolButtons(),
              ],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text(
                  'Zoom',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: onZoomIn,
                      tooltip: 'Zoom avant',
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: onZoomOut,
                      tooltip: 'Zoom arrière',
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.exposure_zero),
                  onPressed: onResetView,
                  tooltip: 'Réinitialiser la vue',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildToolButtons() {
    final tools = [
      {'name': 'Selection', 'icon': Icons.select, 'value': 'select'},
      {'name': 'Point', 'icon': Icons.circle, 'value': 'point'},
      {'name': 'Ligne', 'icon': Icons.polyline, 'value': 'line'},
      {'name': 'Polygone', 'icon': Icons.polygon, 'value': 'polygon'},
      {'name': 'Texte', 'icon': Icons.text_fields, 'value': 'text'},
    ];

    return tools.map((tool) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: OutlinedButton.icon(
          icon: Icon(tool['icon'] as IconData),
          label: Text(tool['name'] as String),
          onPressed: () => onToolChanged(tool['value'] as String),
          style: OutlinedButton.styleFrom(
            backgroundColor: currentTool == tool['value']
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
          ),
        ),
      );
    }).toList();
  }
}

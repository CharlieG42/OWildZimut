import 'package:flutter/material.dart';

/// Barre d'outils pour l'éditeur de cartes
class ToolBar extends StatelessWidget {
  final String currentTool;
  final ValueChanged<String> onToolChanged;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetView;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  const ToolBar({
    super.key,
    required this.currentTool,
    required this.onToolChanged,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetView,
    this.isExpanded = true,
    this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return _buildCollapsedToolbar(context);
    }
    return _buildExpandedToolbar(context);
  }

  Widget _buildCollapsedToolbar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onToggleExpand,
          tooltip: 'Développer la barre d\'outils',
        ),
        const SizedBox(height: 8),
        ..._buildToolIcons(context),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
        IconButton(
          icon: const Icon(Icons.zoom_in),
          onPressed: onZoomIn,
          tooltip: 'Zoom avant',
          padding: const EdgeInsets.all(4),
        ),
        IconButton(
          icon: const Icon(Icons.zoom_out),
          onPressed: onZoomOut,
          tooltip: 'Zoom arrière',
          padding: const EdgeInsets.all(4),
        ),
        IconButton(
          icon: const Icon(Icons.exposure_zero),
          onPressed: onResetView,
          tooltip: 'Réinitialiser la vue',
          padding: const EdgeInsets.all(4),
        ),
      ],
    );
  }

  Widget _buildExpandedToolbar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.all(4),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Outils',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 18),
                      onPressed: onToggleExpand,
                      tooltip: 'Réduire la barre d\'outils',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        maxWidth: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildToolButtons(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(4),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Zoom',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_in, size: 20),
                      onPressed: onZoomIn,
                      tooltip: 'Zoom avant',
                      padding: const EdgeInsets.all(4),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.zoom_out, size: 20),
                      onPressed: onZoomOut,
                      tooltip: 'Zoom arrière',
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                IconButton(
                  icon: const Icon(Icons.exposure_zero, size: 20),
                  onPressed: onResetView,
                  tooltip: 'Réinitialiser la vue',
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildToolIcons(BuildContext context) {
    final tools = [
      {'name': 'Sélection', 'icon': Icons.select_all, 'value': 'select'},
      {'name': 'Point', 'icon': Icons.circle, 'value': 'point'},
      {'name': 'Ligne', 'icon': Icons.polyline, 'value': 'line'},
      {'name': 'Polygone', 'icon': Icons.check, 'value': 'polygon'},
      {'name': 'Texte', 'icon': Icons.text_fields, 'value': 'text'},
    ];

    return tools.map((tool) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: IconButton(
          icon: Icon(tool['icon'] as IconData, size: 20),
          onPressed: () => onToolChanged(tool['value'] as String),
          tooltip: tool['name'] as String,
          style: IconButton.styleFrom(
            backgroundColor: currentTool == tool['value']
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            foregroundColor: currentTool == tool['value']
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildToolButtons(BuildContext context) {
    final tools = [
      {
        'name': 'Sélection',
        'icon': Icons.select_all,
        'value': 'select',
        'color': Colors.orange
      },
      {
        'name': 'Point',
        'icon': Icons.circle,
        'value': 'point',
        'color': Colors.green
      },
      {
        'name': 'Ligne',
        'icon': Icons.polyline,
        'value': 'line',
        'color': Colors.blue
      },
      {
        'name': 'Polygone',
        'icon': Icons.check,
        'value': 'polygon',
        'color': Colors.purple
      },
      {
        'name': 'Texte',
        'icon': Icons.text_fields,
        'value': 'text',
        'color': Colors.teal
      },
    ];

    return tools.map((tool) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: OutlinedButton.icon(
          icon: Icon(
            tool['icon'] as IconData,
            size: 16,
            color: currentTool == tool['value']
                ? Colors.white
                : tool['color'] as Color?,
          ),
          label: Text(
            tool['name'] as String,
            style: TextStyle(
              fontSize: 12,
              color: currentTool == tool['value'] ? Colors.white : null,
            ),
          ),
          onPressed: () => onToolChanged(tool['value'] as String),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            backgroundColor: currentTool == tool['value']
                ? (tool['color'] as Color?)
                : null,
            side: BorderSide(
              color: currentTool == tool['value']
                  ? (tool['color'] as Color?) ?? Colors.grey
                  : Colors.grey,
            ),
          ),
        ),
      );
    }).toList();
  }
}

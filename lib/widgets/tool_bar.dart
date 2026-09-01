import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/map_state.dart';

/// Barre d'outils principale pour OWildZimut
///
/// Cette barre d'outils fournit un accès rapide aux outils de dessin,
/// aux actions d'édition, et aux commandes de vue.
class ToolBar extends StatelessWidget {
  final String currentTool;
  final int selectedLayerIndex;
  final Set<String> selectedSymbolIds;
  final bool canUndo;
  final bool canRedo;
  final bool advancedMode;
  final ValueChanged<String> onToolSelected;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onDeleteSelected;
  final VoidCallback onCopySelected;
  final VoidCallback onPaste;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetView;
  final VoidCallback onToggleAdvancedMode;

  const ToolBar({
    super.key,
    required this.currentTool,
    required this.selectedLayerIndex,
    this.selectedSymbolIds = const {},
    this.canUndo = false,
    this.canRedo = false,
    this.advancedMode = false,
    required this.onToolSelected,
    required this.onUndo,
    required this.onRedo,
    required this.onDeleteSelected,
    required this.onCopySelected,
    required this.onPaste,
    required this.onSelectAll,
    required this.onClearSelection,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetView,
    required this.onToggleAdvancedMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(right: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        children: [
          // Section : Outils de dessin
          _buildSectionHeader(context, 'Outils'),
          _buildToolButtons(context),
          const Divider(height: 8),
          
          // Section : Édition
          _buildSectionHeader(context, 'Édition'),
          _buildEditButtons(context),
          const Divider(height: 8),
          
          // Section : Vue
          _buildSectionHeader(context, 'Vue'),
          _buildViewButtons(context),
          const Divider(height: 8),
          
          // Section : Sélection
          if (selectedSymbolIds.isNotEmpty) ...[
            _buildSectionHeader(context, 'Sélection'),
            _buildSelectionInfo(context),
            const Divider(height: 8),
          ],
          
          // Section : Mode avancé
          if (advancedMode) ...[
            _buildSectionHeader(context, 'Avancé'),
            _buildAdvancedButtons(context),
            const Divider(height: 8),
          ],
          
          // Bouton mode avancé
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Tooltip(
              message: advancedMode ? 'Mode débutant' : 'Mode avancé',
              child: IconButton(
                icon: Icon(advancedMode ? Icons.school : Icons.tune),
                onPressed: onToggleAdvancedMode,
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Info version
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'v0.0.007',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit l'en-tête d'une section
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Construit les boutons des outils de dessin
  Widget _buildToolButtons(BuildContext context) {
    return Column(
      children: [
        _buildToolButton(context, 'select', Icons.select_all, 'Sélection', 'S'),
        _buildToolButton(context, 'point', Icons.circle, 'Point', 'P'),
        _buildToolButton(context, 'line', Icons.polyline, 'Ligne', 'L'),
        _buildToolButton(context, 'polygon', Icons.hexagon, 'Polygone', 'G'),
        _buildToolButton(context, 'text', Icons.text_fields, 'Texte', 'T'),
      ],
    );
  }

  /// Construit un bouton d'outil
  Widget _buildToolButton(
    BuildContext context,
    String tool,
    IconData icon,
    String label,
    String shortcut,
  ) {
    final isSelected = currentTool == tool;
    
    return Tooltip(
      message: '$label ($shortcut)',
      child: IconButton(
        icon: Icon(icon),
        onPressed: () => onToolSelected(tool),
        style: IconButton.styleFrom(
          backgroundColor: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// Construit les boutons d'édition
  Widget _buildEditButtons(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          message: 'Annuler (Ctrl+Z)',
          child: IconButton(
            icon: const Icon(Icons.undo),
            onPressed: canUndo ? onUndo : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        Tooltip(
          message: 'Rétablir (Ctrl+Y)',
          child: IconButton(
            icon: const Icon(Icons.redo),
            onPressed: canRedo ? onRedo : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Tooltip(
          message: 'Copier (Ctrl+C)',
          child: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: selectedSymbolIds.isNotEmpty ? onCopySelected : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        Tooltip(
          message: 'Coller (Ctrl+V)',
          child: IconButton(
            icon: const Icon(Icons.paste),
            onPressed: onPaste,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Tooltip(
          message: 'Supprimer (Del)',
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: selectedSymbolIds.isNotEmpty ? onDeleteSelected : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
              foregroundColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  /// Construit les boutons de vue
  Widget _buildViewButtons(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          message: 'Zoom avant (+)',
          child: IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: onZoomIn,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        Tooltip(
          message: 'Zoom arrière (-)',
          child: IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: onZoomOut,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Tooltip(
          message: 'Réinitialiser la vue',
          child: IconButton(
            icon: const Icon(Icons.explore),
            onPressed: onResetView,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }

  /// Construit les informations de sélection
  Widget _buildSelectionInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(
            '${selectedSymbolIds.length}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'sélectionné(s)',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: 'Tout sélectionner (Ctrl+A)',
                child: IconButton(
                  icon: const Icon(Icons.select_all, size: 16),
                  onPressed: onSelectAll,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Tooltip(
                message: 'Effacer la sélection (Échap)',
                child: IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: onClearSelection,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit les boutons avancés
  Widget _buildAdvancedButtons(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          message: 'Grouper',
          child: IconButton(
            icon: const Icon(Icons.group),
            onPressed: selectedSymbolIds.length >= 2 ? () {} : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        Tooltip(
          message: 'Dégrouper',
          child: IconButton(
            icon: const Icon(Icons.group_off),
            onPressed: null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Tooltip(
          message: 'Aligner horizontalement',
          child: IconButton(
            icon: const Icon(Icons.align_horizontal_left),
            onPressed: selectedSymbolIds.length >= 2 ? () {} : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        Tooltip(
          message: 'Aligner verticalement',
          child: IconButton(
            icon: const Icon(Icons.align_vertical_top),
            onPressed: selectedSymbolIds.length >= 2 ? () {} : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Barre d'outils compacte pour les petits écrans
///
/// Cette version compacte est utilisée pour les écrans mobiles
/// où l'espace est limité.
class CompactToolBar extends StatelessWidget {
  final String currentTool;
  final Set<String> selectedSymbolIds;
  final bool canUndo;
  final bool canRedo;
  final ValueChanged<String> onToolSelected;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onDeleteSelected;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetView;

  const CompactToolBar({
    super.key,
    required this.currentTool,
    this.selectedSymbolIds = const {},
    this.canUndo = false,
    this.canRedo = false,
    required this.onToolSelected,
    required this.onUndo,
    required this.onRedo,
    required this.onDeleteSelected,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Outils
            _buildCompactToolButton(context, 'select', Icons.select_all, 'Sélection'),
            _buildCompactToolButton(context, 'point', Icons.circle, 'Point'),
            _buildCompactToolButton(context, 'line', Icons.polyline, 'Ligne'),
            _buildCompactToolButton(context, 'polygon', Icons.hexagon, 'Polygone'),
            _buildCompactToolButton(context, 'text', Icons.text_fields, 'Texte'),
            const VerticalDivider(),
            
            // Édition
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: canUndo ? onUndo : null,
              tooltip: 'Annuler',
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: canRedo ? onRedo : null,
              tooltip: 'Rétablir',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: selectedSymbolIds.isNotEmpty ? onDeleteSelected : null,
              tooltip: 'Supprimer',
              style: IconButton.styleFrom(foregroundColor: Colors.red),
            ),
            const VerticalDivider(),
            
            // Vue
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
            IconButton(
              icon: const Icon(Icons.explore),
              onPressed: onResetView,
              tooltip: 'Réinitialiser',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactToolButton(
    BuildContext context,
    String tool,
    IconData icon,
    String tooltip,
  ) {
    final isSelected = currentTool == tool;
    
    return IconButton(
      icon: Icon(icon),
      onPressed: () => onToolSelected(tool),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: isSelected 
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Gestionnaire des raccourcis clavier
///
/// Cette classe gère les raccourcis clavier pour l'application.
class KeyboardShortcuts {
  static Map<LogicalKeySet, Intent> shortcuts = {
    // Sélection
    LogicalKeySet(
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.controlLeft,
    ): SelectAllIntent(),
    
    LogicalKeySet(
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.controlRight,
    ): SelectAllIntent(),
    
    // Annuler/Rétablir
    LogicalKeySet(
      LogicalKeyboardKey.keyZ,
      LogicalKeyboardKey.controlLeft,
    ): UndoIntent(),
    
    LogicalKeySet(
      LogicalKeyboardKey.keyZ,
      LogicalKeyboardKey.controlRight,
    ): UndoIntent(),
    
    LogicalKeySet(
      LogicalKeyboardKey.keyY,
      LogicalKeyboardKey.controlLeft,
    ): RedoIntent(),
    
    LogicalKeySet(
      LogicalKeyboardKey.keyY,
      LogicalKeyboardKey.controlRight,
    ): RedoIntent(),
    
    // Copier/Coller
    LogicalKeySet(
      LogicalKeyboardKey.keyC,
      LogicalKeyboardKey.controlLeft,
    ): CopyIntent(),
    
    LogicalKeySet(
      LogicalKeyboardKey.keyC,
      LogicalKeyboardKey.controlRight,
    ): CopyIntent(),
    
    LogicalKeySet(
      LogicalKeyboardKey.keyV,
      LogicalKeyboardKey.controlLeft,
    ): PasteIntent(),
    
    LogicalKeySet(
      LogicalKeyboardKey.keyV,
      LogicalKeyboardKey.controlRight,
    ): PasteIntent(),
    
    // Supprimer
    LogicalKeySet(LogicalKeyboardKey.delete): DeleteIntent(),
    LogicalKeySet(LogicalKeyboardKey.backspace): DeleteIntent(),
    
    // Échap
    LogicalKeySet(LogicalKeyboardKey.escape): EscapeIntent(),
    
    // Outils
    LogicalKeySet(LogicalKeyboardKey.keyS): SelectToolIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyP): PointToolIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyL): LineToolIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyG): PolygonToolIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyT): TextToolIntent(),
    
    // Zoom
    LogicalKeySet(LogicalKeyboardKey.add): ZoomInIntent(),
    LogicalKeySet(LogicalKeyboardKey.equal): ZoomInIntent(),
    LogicalKeySet(LogicalKeyboardKey.minus): ZoomOutIntent(),
    LogicalKeySet(LogicalKeyboardKey.digit0): ResetViewIntent(),
  };

  /// Enveloppe un widget avec la gestion des raccourcis clavier
  static Widget wrapWithShortcuts({
    required Widget child,
    required BuildContext context,
    required MapState mapState,
    required ValueChanged<String> onToolSelected,
    required VoidCallback onUndo,
    required VoidCallback onRedo,
    required VoidCallback onDeleteSelected,
    required VoidCallback onCopySelected,
    required VoidCallback onPaste,
    required VoidCallback onSelectAll,
    required VoidCallback onClearSelection,
    required VoidCallback onZoomIn,
    required VoidCallback onZoomOut,
    required VoidCallback onResetView,
  }) {
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: {
          // Sélection
          SelectAllIntent: CallbackAction(onInvoke: (_) {
            onSelectAll();
            return null;
          }),
          
          // Édition
          UndoIntent: CallbackAction(onInvoke: (_) {
            onUndo();
            return null;
          }),
          
          RedoIntent: CallbackAction(onInvoke: (_) {
            onRedo();
            return null;
          }),
          
          CopyIntent: CallbackAction(onInvoke: (_) {
            if (mapState.selectedSymbolIds.isNotEmpty) {
              onCopySelected();
            }
            return null;
          }),
          
          PasteIntent: CallbackAction(onInvoke: (_) {
            onPaste();
            return null;
          }),
          
          DeleteIntent: CallbackAction(onInvoke: (_) {
            if (mapState.selectedSymbolIds.isNotEmpty) {
              onDeleteSelected();
            }
            return null;
          }),
          
          EscapeIntent: CallbackAction(onInvoke: (_) {
            onClearSelection();
            return null;
          }),
          
          // Outils
          SelectToolIntent: CallbackAction(onInvoke: (_) {
            onToolSelected('select');
            return null;
          }),
          
          PointToolIntent: CallbackAction(onInvoke: (_) {
            onToolSelected('point');
            return null;
          }),
          
          LineToolIntent: CallbackAction(onInvoke: (_) {
            onToolSelected('line');
            return null;
          }),
          
          PolygonToolIntent: CallbackAction(onInvoke: (_) {
            onToolSelected('polygon');
            return null;
          }),
          
          TextToolIntent: CallbackAction(onInvoke: (_) {
            onToolSelected('text');
            return null;
          }),
          
          // Vue
          ZoomInIntent: CallbackAction(onInvoke: (_) {
            onZoomIn();
            return null;
          }),
          
          ZoomOutIntent: CallbackAction(onInvoke: (_) {
            onZoomOut();
            return null;
          }),
          
          ResetViewIntent: CallbackAction(onInvoke: (_) {
            onResetView();
            return null;
          }),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

// Intents pour les raccourcis clavier
class SelectAllIntent extends Intent {}
class UndoIntent extends Intent {}
class RedoIntent extends Intent {}
class CopyIntent extends Intent {}
class PasteIntent extends Intent {}
class DeleteIntent extends Intent {}
class EscapeIntent extends Intent {}
class SelectToolIntent extends Intent {}
class PointToolIntent extends Intent {}
class LineToolIntent extends Intent {}
class PolygonToolIntent extends Intent {}
class TextToolIntent extends Intent {}
class ZoomInIntent extends Intent {}
class ZoomOutIntent extends Intent {}
class ResetViewIntent extends Intent {}

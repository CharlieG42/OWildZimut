import 'package:flutter/material.dart';

/// Pas de déplacement (en pixels écran) appliqué à chaque appui sur une
/// flèche.
const double _kPanStep = 80;

/// Petit pavé directionnel superposé à la carte, permettant de recentrer /
/// déplacer la vue par petits pas (utile après l'import d'un OMAP ou d'une
/// image de fond dont le contenu apparaît hors champ), en complément du
/// déplacement tactile et du bouton "Réinitialiser la vue".
class RecenterControls extends StatelessWidget {
  final ValueChanged<Offset> onPanBy;
  final VoidCallback onResetView;

  const RecenterControls({
    super.key,
    required this.onPanBy,
    required this.onResetView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: _arrowButton(
                context,
                Icons.keyboard_arrow_up,
                'Déplacer vers le haut',
                () => onPanBy(const Offset(0, _kPanStep)),
              ),
            ),
            Positioned(
              bottom: 0,
              child: _arrowButton(
                context,
                Icons.keyboard_arrow_down,
                'Déplacer vers le bas',
                () => onPanBy(const Offset(0, -_kPanStep)),
              ),
            ),
            Positioned(
              left: 0,
              child: _arrowButton(
                context,
                Icons.keyboard_arrow_left,
                'Déplacer vers la gauche',
                () => onPanBy(const Offset(_kPanStep, 0)),
              ),
            ),
            Positioned(
              right: 0,
              child: _arrowButton(
                context,
                Icons.keyboard_arrow_right,
                'Déplacer vers la droite',
                () => onPanBy(const Offset(-_kPanStep, 0)),
              ),
            ),
            Tooltip(
              message: 'Recentrer la vue',
              child: IconButton(
                icon: const Icon(Icons.center_focus_strong),
                onPressed: onResetView,
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrowButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}

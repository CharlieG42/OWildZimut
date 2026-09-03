import 'package:flutter/material.dart';
import '../models/iof_symbols_v3.dart';

/// Variante V3 (voir models/iof_symbols_v3.dart).
/// Aperçu carré d'un symbole IOF, avec un rendu fidèle à sa géométrie réelle
/// (et non un simple rond/trait générique) :
/// - Point : dessine chaque sous-élément du symbole composite (traits,
///   points, hachures) à sa position réelle, plus le cercle central s'il a
///   une couleur déclarée. C'est ce niveau de détail qui permet de
///   reconnaître un symbole (ex. marais, point de contrôle) d'un coup d'œil.
/// - Ligne : échantillon de trait avec la vraie couleur/épaisseur/pointillés.
/// - Surface : carré rempli avec la vraie couleur.
/// - Texte : aperçu "Aa".
///
/// Widget dédié à la visionneuse V3 (iof_symbols_viewer_v3.dart).
class IOFSymbolPreviewV3 extends StatelessWidget {
  final IOFSymbolV3 symbol;
  final double size;
  final bool showBackground;

  const IOFSymbolPreviewV3({
    super.key,
    required this.symbol,
    this.size = 40,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBackground
          ? BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            )
          : null,
      child: CustomPaint(
        size: Size(size, size),
        painter: _IOFSymbolPreviewPainterV3(symbol),
      ),
    );
  }
}

class _IOFSymbolPreviewPainterV3 extends CustomPainter {
  final IOFSymbolV3 symbol;

  _IOFSymbolPreviewPainterV3(this.symbol);

  /// Échelle mm -> pixels d'aperçu. Les coordonnées des éléments de symbole
  /// couvrent en général +/- 1 à 2 mm autour du centre ; on choisit un
  /// facteur qui remplit correctement le carré d'aperçu.
  static const double _mmToPreviewPx = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final geom = symbol.geometry;

    switch (symbol.type) {
      case 1:
        _paintPoint(canvas, center, geom);
        break;
      case 2:
        _paintLine(canvas, size, geom);
        break;
      case 4:
        _paintArea(canvas, size, geom);
        break;
      default:
        _paintText(canvas, size);
    }
  }

  void _paintPoint(Canvas canvas, Offset center, IOFSymbolGeometryV3? geom) {
    if (geom == null) {
      _paintFallbackDot(canvas, center);
      return;
    }

    var paintedSomething = false;

    // Sous-éléments (traits/points/hachures qui composent le pictogramme).
    for (final element in geom.elements) {
      final positions = element.pattern.isEmpty ? [Offset.zero] : element.pattern;
      for (final offset in positions) {
        final localOffset = Offset(offset.dx, offset.dy) * _mmToPreviewPx;
        _paintElementShape(canvas, center + localOffset, element);
        paintedSomething = true;
      }
    }

    // Cercle/point central, uniquement s'il a une couleur déclarée (beaucoup
    // de symboles composites le laissent transparent : tout le dessin vient
    // alors des éléments ci-dessus).
    final radiusMm = geom.pointRadiusMm;
    final centerColor = geom.getColor();
    if (radiusMm != null && centerColor != Colors.transparent) {
      final r = (radiusMm * _mmToPreviewPx).clamp(1.0, 16.0);
      canvas.drawCircle(center, r, Paint()..color = centerColor);
      paintedSomething = true;
    }

    if (!paintedSomething) {
      _paintFallbackDot(canvas, center);
    }
  }

  void _paintElementShape(Canvas canvas, Offset shapeCenter, IOFSymbolElementV3 element) {
    final sub = element.symbol;
    final localCoords = element.coords
        .map((o) => shapeCenter + Offset(o.dx, o.dy) * _mmToPreviewPx)
        .toList();

    switch (sub.symbolType) {
      case 'line':
        final color = sub.getColor();
        final paint = Paint()
          ..color = color == Colors.transparent ? symbol.displayColor : color
          ..style = PaintingStyle.stroke
          ..strokeWidth = ((sub.lineWidthMm ?? 0.1) * _mmToPreviewPx).clamp(0.6, 4.0)
          ..strokeCap = StrokeCap.round;
        if (localCoords.length == 1) {
          canvas.drawCircle(localCoords.first, paint.strokeWidth / 2, paint..style = PaintingStyle.fill);
        } else if (localCoords.length > 1) {
          final path = Path()..moveTo(localCoords.first.dx, localCoords.first.dy);
          for (final p in localCoords.skip(1)) {
            path.lineTo(p.dx, p.dy);
          }
          canvas.drawPath(path, paint);
        }
        break;
      case 'area':
        if (localCoords.length >= 3) {
          final color = sub.getColor();
          final path = Path()..moveTo(localCoords.first.dx, localCoords.first.dy);
          for (final p in localCoords.skip(1)) {
            path.lineTo(p.dx, p.dy);
          }
          path.close();
          canvas.drawPath(
            path,
            Paint()..color = color == Colors.transparent ? symbol.displayColor : color,
          );
        }
        break;
      case 'point':
      default:
        final color = sub.getColor();
        final r = ((sub.pointRadiusMm ?? 0.15) * _mmToPreviewPx).clamp(0.8, 10.0);
        canvas.drawCircle(
          shapeCenter,
          r,
          Paint()..color = color == Colors.transparent ? symbol.displayColor : color,
        );
        break;
    }
  }

  void _paintFallbackDot(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 4, Paint()..color = symbol.displayColor);
  }

  void _paintLine(Canvas canvas, Size size, IOFSymbolGeometryV3? geom) {
    final y = size.height / 2;
    final start = Offset(size.width * 0.12, y);
    final end = Offset(size.width * 0.88, y);
    final color = geom?.getColor() ?? Colors.transparent;
    final paint = Paint()
      ..color = color == Colors.transparent ? symbol.displayColor : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = ((geom?.lineWidthMm ?? 0.2) * _mmToPreviewPx).clamp(1.0, 6.0)
      ..strokeCap = StrokeCap.round;

    if (geom?.isDashed == true) {
      final dash = ((geom?.dashLengthMm ?? 1.0) * _mmToPreviewPx / 3).clamp(2.0, 10.0);
      final gap = ((geom?.breakLengthMm ?? 0.5) * _mmToPreviewPx / 3).clamp(1.5, 8.0);
      var x = start.dx;
      while (x < end.dx) {
        final xEnd = (x + dash).clamp(start.dx, end.dx);
        canvas.drawLine(Offset(x, y), Offset(xEnd, y), paint);
        x += dash + gap;
      }
    } else {
      canvas.drawLine(start, end, paint);
    }
  }

  void _paintArea(Canvas canvas, Size size, IOFSymbolGeometryV3? geom) {
    final color = geom?.getColor() ?? Colors.transparent;
    final rect = Rect.fromLTWH(size.width * 0.12, size.height * 0.12, size.width * 0.76, size.height * 0.76);
    canvas.drawRect(
      rect,
      Paint()..color = color == Colors.transparent ? symbol.displayColor.withValues(alpha: 0.6) : color,
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.black26
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _paintText(Canvas canvas, Size size) {
    final painter = TextPainter(
      text: TextSpan(
        text: 'Aa',
        style: TextStyle(color: symbol.displayColor, fontSize: size.height * 0.5, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset((size.width - painter.width) / 2, (size.height - painter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant _IOFSymbolPreviewPainterV3 oldDelegate) => oldDelegate.symbol != symbol;
}

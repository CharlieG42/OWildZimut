import 'package:flutter/material.dart';
import '../models/layer.dart';

/// Widget pour afficher et interagir avec la carte
class MapView extends StatefulWidget {
  final List<Layer> layers;
  final double zoomLevel;
  final Offset panOffset;
  final int? selectedLayerIndex;
  final ValueChanged<Offset>? onPanUpdate;
  final ValueChanged<double>? onZoomChanged;

  const MapView({
    super.key,
    required this.layers,
    required this.zoomLevel,
    required this.panOffset,
    this.selectedLayerIndex,
    this.onPanUpdate,
    this.onZoomChanged,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Offset _dragStart = Offset.zero;
  Offset _lastFocalPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastFocalPoint = details.focalPoint;
      },
      onScaleUpdate: (details) {
        if (details.scale != 1.0) {
          widget.onZoomChanged?.call(widget.zoomLevel * details.scale);
        }

        if (details.pointerCount >= 2) {
          final delta = details.focalPoint - _lastFocalPoint;
          widget.onPanUpdate?.call(widget.panOffset + delta);
          _lastFocalPoint = details.focalPoint;
        }
      },
      onScaleEnd: (details) {
        _lastFocalPoint = Offset.zero;
      },
      child: Listener(
        onPointerDown: (details) {
          _dragStart = details.localPosition;
        },
        onPointerMove: (details) {
          if (
              details.buttons == 2) {
            final delta = details.localPosition - _dragStart;
            widget.onPanUpdate?.call(widget.panOffset + delta);
            _dragStart = details.localPosition;
          }
        },
        child: InteractiveViewer(
          panEnabled: false,
          minScale: 0.1,
          maxScale: 10.0,
          child: Transform.translate(
            offset: widget.panOffset,
            child: Transform.scale(
              scale: widget.zoomLevel,
              child: CustomPaint(
                size: Size.infinite,
                painter: _MapPainter(
                  layers: widget.layers,
                  zoomLevel: widget.zoomLevel,
                  selectedLayerIndex: widget.selectedLayerIndex,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter personnalisé pour dessiner la carte et les calques
class _MapPainter extends CustomPainter {
  final List<Layer> layers;
  final double zoomLevel;
  final int? selectedLayerIndex;

  _MapPainter({
    required this.layers,
    required this.zoomLevel,
    this.selectedLayerIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    _drawGrid(canvas, size);

    for (var i = 0; i < layers.length; i++) {
      final layer = layers[i];
      if (!layer.visible) continue;

      final opacity = layer.opacity;
      _drawLayer(canvas, layer, i == selectedLayerIndex, opacity);
    }

    _drawOriginMarker(canvas);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;

    for (var x = -size.width; x <= size.width * 2; x += gridSize) {
      canvas.drawLine(
        Offset(x, -size.height),
        Offset(x, size.height * 2),
        paint,
      );
    }

    for (var y = -size.height; y <= size.height * 2; y += gridSize) {
      canvas.drawLine(
        Offset(-size.width, y),
        Offset(size.width * 2, y),
        paint,
      );
    }
  }

  void _drawLayer(Canvas canvas, Layer layer, bool isSelected, double opacity) {
    final paint = Paint()
      ..color = layer.color.withValues(alpha: (opacity * 255).round())
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      100.0 * layer.zIndex,
      100.0 * layer.zIndex,
      200.0,
      200.0,
    );

    canvas.drawRect(rect, paint);

    if (isSelected) {
      final borderPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawRect(rect, borderPaint);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: layer.name,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(rect.left + 10, rect.top + 10),
    );
  }

  void _drawOriginMarker(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(-10, 0),
      const Offset(10, 0),
      paint,
    );
    canvas.drawLine(
      const Offset(0, -10),
      const Offset(0, 10),
      paint,
    );

    canvas.drawCircle(
      const Offset(0, 0),
      5,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) {
    return oldDelegate.layers != layers ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.selectedLayerIndex != selectedLayerIndex;
  }
}

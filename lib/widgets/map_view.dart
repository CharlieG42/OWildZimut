import 'dart:io';

import 'package:flutter/material.dart';
import '../models/layer.dart';
import '../models/symbol.dart' as symbol_model;

/// Widget pour afficher et interagir avec la carte
class MapView extends StatefulWidget {
  final List<Layer> layers;
  final double zoomLevel;
  final Offset panOffset;
  final int? selectedLayerIndex;
  final String currentTool;
  final ValueChanged<Offset>? onPanUpdate;
  final ValueChanged<double>? onZoomChanged;
  final Function(symbol_model.MapSymbol)? onSymbolAdded;

  const MapView({
    super.key,
    required this.layers,
    required this.zoomLevel,
    required this.panOffset,
    this.selectedLayerIndex,
    this.currentTool = 'select',
    this.onPanUpdate,
    this.onZoomChanged,
    this.onSymbolAdded,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Offset _dragStart = Offset.zero;
  Offset _lastFocalPoint = Offset.zero;
  List<Offset> _currentPoints = [];
  bool _isDrawing = false;

  @override
  Widget build(BuildContext context) {
    // Calques tries du plus bas au plus haut (les images de fond ont un
    // zIndex negatif ou nul et se retrouvent donc dessinees en premier).
    final sortedLayers = [...widget.layers]
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

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
      onTapDown: (details) {
        if (widget.currentTool != 'select' &&
            widget.selectedLayerIndex != null &&
            widget.layers.isNotEmpty) {
          final localPosition = _getLocalPosition(details.localPosition);

          switch (widget.currentTool) {
            case 'point':
              _handlePointTap(localPosition);
              break;
            case 'line':
            case 'polygon':
              setState(() {
                _isDrawing = true;
                _currentPoints = [localPosition];
              });
              break;
            case 'text':
              _handleTextTap(localPosition);
              break;
          }
        }
      },
      onTapUp: (details) {
        if (_isDrawing &&
            (widget.currentTool == 'line' || widget.currentTool == 'polygon')) {
          final localPosition = _getLocalPosition(details.localPosition);

          if (widget.currentTool == 'line') {
            setState(() {
              _currentPoints.add(localPosition);
            });
          } else if (widget.currentTool == 'polygon') {
            setState(() {
              _currentPoints.add(localPosition);
              // Fermer le polygone si on clique pres du premier point
              if (_currentPoints.length > 2 &&
                  (localPosition - _currentPoints.first).distance < 20) {
                _currentPoints.add(_currentPoints.first);
                _finalizeDrawing();
              }
            });
          }
        }
      },
      onDoubleTap: () {
        if (_isDrawing && widget.currentTool == 'line') {
          _finalizeDrawing();
        }
      },
      child: Listener(
        onPointerDown: (details) {
          _dragStart = details.localPosition;
        },
        onPointerMove: (details) {
          if (details.buttons == 2) {
            final delta = details.localPosition - _dragStart;
            widget.onPanUpdate?.call(widget.panOffset + delta);
            _dragStart = details.localPosition;
          }
        },
        child: InteractiveViewer(
          panEnabled: false,
          minScale: 0.1,
          maxScale: 10.0,
          child: ClipRect(
            child: Transform.translate(
              offset: widget.panOffset,
              child: Transform.scale(
                scale: widget.zoomLevel,
                child: Stack(
                  children: [
                    // Fond blanc + grille
                    CustomPaint(
                      size: Size.infinite,
                      painter: _GridPainter(zoomLevel: widget.zoomLevel),
                    ),
                    // Images de fond (calques raster), du plus bas au plus haut
                    for (final layer in sortedLayers)
                      if (layer.isImageBackground) _buildImageLayer(layer),
                    // Symboles des calques vectoriels
                    CustomPaint(
                      size: Size.infinite,
                      painter: _SymbolsPainter(
                        layers: sortedLayers,
                        zoomLevel: widget.zoomLevel,
                      ),
                    ),
                    // Zone de dessin en cours
                    if (_isDrawing && _currentPoints.isNotEmpty)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _DrawingPainter(
                            points: _currentPoints,
                            tool: widget.currentTool,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le widget d'affichage d'un calque image de fond.
  Widget _buildImageLayer(Layer layer) {
    return Positioned(
      left: layer.imageOffset.dx,
      top: layer.imageOffset.dy,
      child: IgnorePointer(
        child: Opacity(
          opacity: layer.visible ? layer.opacity : 0,
          child: Transform.scale(
            scale: layer.imageScale,
            alignment: Alignment.topLeft,
            child: Image.file(
              File(layer.imagePath!),
              fit: BoxFit.none,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 200,
                height: 120,
                color: Colors.red.withValues(alpha: 0.15),
                alignment: Alignment.center,
                child: const Text(
                  'Image de fond illisible',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Offset _getLocalPosition(Offset screenPosition) {
    // Convertir la position ecran en position dans le systeme de
    // coordonnees de la carte
    final offset = (screenPosition - widget.panOffset) / widget.zoomLevel;
    return offset;
  }

  void _handlePointTap(Offset position) {
    final symbol = symbol_model.MapSymbol(
      id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      type: symbol_model.MapSymbolType.point,
      code: 'point',
      position: position,
      description: 'Point',
      color: widget.layers[widget.selectedLayerIndex!].color,
      size: 5.0,
    );
    widget.onSymbolAdded?.call(symbol);
  }

  void _handleTextTap(Offset position) {
    final symbol = symbol_model.MapSymbol(
      id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      type: symbol_model.MapSymbolType.text,
      code: 'text',
      position: position,
      description: 'Nouveau texte',
      color: Colors.black,
      size: 12.0,
    );
    widget.onSymbolAdded?.call(symbol);
  }

  void _finalizeDrawing() {
    if (_currentPoints.isEmpty || widget.selectedLayerIndex == null) return;

    final symbol = symbol_model.MapSymbol(
      id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      type: widget.currentTool == 'line' ? symbol_model.MapSymbolType.line : symbol_model.MapSymbolType.area,
      code: widget.currentTool,
      position: _currentPoints.first,
      description: widget.currentTool == 'line' ? 'Ligne' : 'Polygone',
      color: widget.layers[widget.selectedLayerIndex!].color,
      size: 2.0,
      points: List.from(_currentPoints),
    );

    widget.onSymbolAdded?.call(symbol);

    setState(() {
      _isDrawing = false;
      _currentPoints = [];
    });
  }
}

/// Painter charge du fond blanc, de la grille et du marqueur d'origine.
class _GridPainter extends CustomPainter {
  final double zoomLevel;

  _GridPainter({required this.zoomLevel});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    _drawGrid(canvas, size);
    _drawOriginMarker(canvas);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5 / zoomLevel
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;
    final scaledGridSize = gridSize * zoomLevel;

    final startX = -size.width;
    final endX = size.width * 2;
    final startY = -size.height;
    final endY = size.height * 2;

    for (var x = startX; x <= endX; x += scaledGridSize) {
      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
    }

    for (var y = startY; y <= endY; y += scaledGridSize) {
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
    }
  }

  void _drawOriginMarker(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0 / zoomLevel
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(-10, 0), const Offset(10, 0), paint);
    canvas.drawLine(const Offset(0, -10), const Offset(0, 10), paint);

    canvas.drawCircle(
      const Offset(0, 0),
      5 / zoomLevel,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.zoomLevel != zoomLevel;
}

/// Painter charge de dessiner les symboles des calques vectoriels.
class _SymbolsPainter extends CustomPainter {
  final List<Layer> layers;
  final double zoomLevel;

  _SymbolsPainter({required this.layers, required this.zoomLevel});

  @override
  void paint(Canvas canvas, Size size) {
    for (final layer in layers) {
      if (!layer.visible || layer.type != LayerType.vector) continue;
      for (final symbol in layer.symbols) {
        _drawMapSymbol(canvas, symbol, layer.opacity);
      }
    }
  }

  void _drawMapSymbol(Canvas canvas, symbol_model.MapSymbol symbol, double layerOpacity) {
    final effectiveOpacity = symbol.color.a * layerOpacity;
    final paint = Paint()
      ..color = symbol.color.withValues(alpha: effectiveOpacity)
      ..strokeWidth = symbol.size / zoomLevel
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: effectiveOpacity)
      ..strokeWidth = symbol.size / zoomLevel / 2
      ..style = PaintingStyle.stroke;

    switch (symbol.type) {
      case symbol_model.MapSymbolType.point:
        canvas.drawCircle(symbol.position, symbol.size / zoomLevel, paint);
        canvas.drawCircle(symbol.position, symbol.size / zoomLevel, borderPaint);
        break;
      case symbol_model.MapSymbolType.line:
        if (symbol.points.length > 1) {
          final path = Path();
          path.moveTo(symbol.points[0].dx, symbol.points[0].dy);
          for (var i = 1; i < symbol.points.length; i++) {
            path.lineTo(symbol.points[i].dx, symbol.points[i].dy);
          }
          canvas.drawPath(path, paint..style = PaintingStyle.stroke);
        }
        break;
      case symbol_model.MapSymbolType.area:
        if (symbol.points.length > 2) {
          final path = Path();
          path.moveTo(symbol.points[0].dx, symbol.points[0].dy);
          for (var i = 1; i < symbol.points.length; i++) {
            path.lineTo(symbol.points[i].dx, symbol.points[i].dy);
          }
          path.close();
          canvas.drawPath(path, paint..style = PaintingStyle.fill);
          canvas.drawPath(path, borderPaint);
        }
        break;
      case symbol_model.MapSymbolType.text:
        final textPainter = TextPainter(
          text: TextSpan(
            text: symbol.description,
            style: TextStyle(
              color: symbol.color.withValues(alpha: effectiveOpacity),
              fontSize: symbol.size / zoomLevel,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, symbol.position);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _SymbolsPainter oldDelegate) {
    return oldDelegate.layers != layers || oldDelegate.zoomLevel != zoomLevel;
  }
}

/// Painter pour afficher le dessin en cours
class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final String tool;

  _DrawingPainter({
    required this.points,
    required this.tool,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    if (tool == 'line') {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    } else if (tool == 'polygon') {
      if (points.length > 1) {
        final path = Path();
        path.moveTo(points[0].dx, points[0].dy);
        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        if (points.length > 2) {
          path.lineTo(points[0].dx, points[0].dy);
        }
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, paint);
      }
    }

    for (final point in points) {
      canvas.drawCircle(point, 3.0, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.tool != tool;
  }
}

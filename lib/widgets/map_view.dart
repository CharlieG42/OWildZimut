import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../models/layer.dart';
import '../models/symbol.dart' as symbol_model;


/// Widget pour afficher et interagir avec la carte
///
/// Ce widget gère :
/// - L'affichage des calques (vectoriels et raster)
/// - Le zoom et le défilement
/// - Le dessin des symboles (points, lignes, polygones)
/// - La sélection multiple
/// - Le drag & drop des symboles
/// - Les feedbacks visuels
class MapView extends StatefulWidget {
  final List<Layer> layers;
  final double zoomLevel;
  final Offset panOffset;
  final int? selectedLayerIndex;
  final String currentTool;
  final Set<String> selectedSymbolIds;
  final ValueChanged<Offset>? onPanUpdate;
  final ValueChanged<double>? onZoomChanged;
  final ValueChanged<Rect>? onSelectionRectChanged;
  final ValueChanged<Offset>? onTap;
  final ValueChanged<String>? onSymbolSelected;
  final ValueChanged<Set<String>>? onSymbolsSelected;
  final Function(symbol_model.MapSymbol)? onSymbolAdded;    //foncion dans model/symbol.dart
  final Function(String, Offset)? onSymbolMoved;
  final Function(Set<String>, Offset)? onSymbolsMoved;
  final Function(String)? onSymbolDeleted;
  final Function(Set<String>)? onSymbolsDeleted;

  const MapView({
    super.key,
    required this.layers,
    required this.zoomLevel,
    required this.panOffset,
    this.selectedLayerIndex,
    this.currentTool = 'select',
    this.selectedSymbolIds = const {},
    this.onPanUpdate,
    this.onZoomChanged,
    this.onSelectionRectChanged,
    this.onTap,
    this.onSymbolSelected,
    this.onSymbolsSelected,
    this.onSymbolAdded,
    this.onSymbolMoved,
    this.onSymbolsMoved,
    this.onSymbolDeleted,
    this.onSymbolsDeleted,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Offset? _dragStart;
  Offset? _dragCurrent;
  Offset _lastFocalPoint = Offset.zero;
  bool _isPanningView = false;
  PointerDeviceKind? _lastPointerKind;
  List<Offset> _currentPoints = [];
  bool _isDrawing = false;
  Rect? _selectionRect;
  String? _hoveredSymbolId;

  @override
  Widget build(BuildContext context) {
    // Calques triés du plus bas au plus haut
    final sortedLayers = [...widget.layers]
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return Focus(
      autofocus: true,
      onKey: _handleKeyPress,
      child: MouseRegion(
        cursor: _getCursorForCurrentState(),
        onHover: (details) {
          final localPosition = _getLocalPosition(details.localPosition);
          _updateHoveredSymbol(localPosition, sortedLayers);
        },
        onExit: (details) {
          setState(() {
            _hoveredSymbolId = null;
          });
        },
        child: GestureDetector(
          onScaleStart: (details) {
            _lastFocalPoint = details.focalPoint;
            if (details.pointerCount >= 2) return;
            _handleGestureStart(details.localFocalPoint);
          },
          onScaleUpdate: (details) {
            if (details.scale != 1.0) {
              widget.onZoomChanged?.call(widget.zoomLevel * details.scale);
            }

            if (details.pointerCount >= 2) {
              final delta = details.focalPoint - _lastFocalPoint;
              widget.onPanUpdate?.call(widget.panOffset + delta);
              _lastFocalPoint = details.focalPoint;
              return;
            }

            _handleGestureUpdate(details.focalPoint, details.localFocalPoint);
          },
          onScaleEnd: (details) {
            _lastFocalPoint = Offset.zero;
            _handleGestureEnd();
          },
          onTapDown: (details) {
            final localPosition = _getLocalPosition(details.localPosition);
            _handleTapDown(localPosition, details, sortedLayers);
          },
          onTapUp: (details) {
            final localPosition = _getLocalPosition(details.localPosition);
            _handleTapUp(localPosition, sortedLayers);
          },
          onDoubleTap: () {
            if (_isDrawing && widget.currentTool == 'line') {
              _finalizeDrawing();
            }
          },
          onLongPressStart: (details) {
            final localPosition = _getLocalPosition(details.localPosition);
            _startSelectionRect(localPosition);
          },
          onLongPressMoveUpdate: (details) {
            final localPosition = _getLocalPosition(details.localPosition);
            _updateSelectionRect(localPosition);
          },
          onLongPressEnd: (details) {
            _finalizeSelectionRect();
          },
          child: Listener(
            onPointerDown: (details) {
              _dragStart = details.localPosition;
              _lastPointerKind = details.kind;
            },
            onPointerMove: (details) {
              if (details.buttons == 2) {
                // Bouton droit : défilement
                final delta = details.localPosition - _dragStart!;
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
                        // Images de fond (calques raster)
                        for (final layer in sortedLayers)
                          if (layer.isImageBackground) _buildImageLayer(layer),
                        // Symboles des calques vectoriels
                        CustomPaint(
                          size: Size.infinite,
                          painter: _SymbolsPainter(
                            layers: sortedLayers,
                            zoomLevel: widget.zoomLevel,
                            selectedSymbolIds: widget.selectedSymbolIds,
                            hoveredSymbolId: _hoveredSymbolId,
                          ),
                        ),
                        // Rectangle de sélection
                        if (_selectionRect != null)
                          Positioned(
                            left: _selectionRect!.left,
                            top: _selectionRect!.top,
                            child: CustomPaint(
                              size: Size(
                                _selectionRect!.width,
                                _selectionRect!.height,
                              ),
                              painter: _SelectionRectPainter(),
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
        ),
      ),
    );
  }

  /// Retourne le curseur approprié selon l'état actuel
  SystemMouseCursor _getCursorForCurrentState() {
    if (widget.currentTool != 'select') {
      switch (widget.currentTool) {
        case 'point':
          return SystemMouseCursors.precise;
        case 'line':
        case 'polygon':
          return SystemMouseCursors.cell;
        case 'text':
          return SystemMouseCursors.text;
        default:
          return SystemMouseCursors.basic;
      }
    }
    
    if (widget.selectedSymbolIds.isNotEmpty) {
      return SystemMouseCursors.move;
    }
    
    return SystemMouseCursors.basic;
  }

  /// Convertit les coordonnées de l'écran aux coordonnées de la carte
  Offset _getLocalPosition(Offset screenPosition) {
    // Inverser le pan et le zoom
    return (screenPosition - widget.panOffset) / widget.zoomLevel;
  }

  /// Met à jour le symbole survolé
  void _updateHoveredSymbol(Offset localPosition, List<Layer> sortedLayers) {
    String? newHoveredId;
    
    // Parcourir les calques du haut vers le bas
    for (final layer in sortedLayers.reversed) {
      if (!layer.visible) continue;
      
      // Trouver le symbole le plus proche
      for (final symbol in layer.symbols.reversed) {
        if (symbol.contains(localPosition)) {
          newHoveredId = symbol.id;
          break;
        }
      }
      
      if (newHoveredId != null) break;
    }
    
    if (newHoveredId != _hoveredSymbolId) {
      setState(() {
        _hoveredSymbolId = newHoveredId;
      });
    }
  }

  /// Gère l'appui sur l'écran
  void _handleTapDown(Offset localPosition, TapDownDetails details, List<Layer> sortedLayers) {
    if (widget.currentTool != 'select' &&
        widget.selectedLayerIndex != null &&
        widget.layers.isNotEmpty) {
      
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
    } else if (widget.currentTool == 'select') {
      // Sélection simple
      final symbolId = _findSymbolAtPosition(localPosition, sortedLayers);
      if (symbolId != null) {
        widget.onSymbolSelected?.call(symbolId);
      } else {
        // Cliquer sur un espace vide : effacer la sélection
        widget.onSymbolsSelected?.call(const {});
      }
    }
  }

  /// Gère le relâchement après un appui
  void _handleTapUp(Offset localPosition, List<Layer> sortedLayers) {
    if (_isDrawing &&
        (widget.currentTool == 'line' || widget.currentTool == 'polygon')) {
      
      if (widget.currentTool == 'line') {
        setState(() {
          _currentPoints.add(localPosition);
        });
      } else if (widget.currentTool == 'polygon') {
        setState(() {
          _currentPoints.add(localPosition);
          // Fermer le polygone si on clique près du premier point
          if (_currentPoints.length > 2 &&
              (localPosition - _currentPoints.first).distance < 20) {
            _currentPoints.add(_currentPoints.first);
            _finalizeDrawing();
          }
        });
      }
    }
  }

  /// Trouve le symbole à une position donnée
  String? _findSymbolAtPosition(Offset localPosition, List<Layer> sortedLayers) {
    // Parcourir les calques du haut vers le bas
    for (final layer in sortedLayers.reversed) {
      if (!layer.visible) continue;
      
      // Trouver le symbole le plus proche
      for (final symbol in layer.symbols.reversed) {
        if (symbol.contains(localPosition)) {
          return symbol.id;
        }
      }
    }
    return null;
  }

  /// Démarre le rectangle de sélection
  void _startSelectionRect(Offset localPosition) {
    setState(() {
      _dragStart = localPosition;
      _dragCurrent = localPosition;
      _selectionRect = Rect.fromLTWH(
        localPosition.dx,
        localPosition.dy,
        0,
        0,
      );
    });
  }

  /// Met à jour le rectangle de sélection
  void _updateSelectionRect(Offset localPosition) {
    if (_dragStart == null) return;
    
    final start = _dragStart!;
    final end = localPosition;
    
    final left = start.dx < end.dx ? start.dx : end.dx;
    final top = start.dy < end.dy ? start.dy : end.dy;
    final width = (end.dx - start.dx).abs();
    final height = (end.dy - start.dy).abs();
    
    setState(() {
      _dragCurrent = localPosition;
      _selectionRect = Rect.fromLTWH(left, top, width, height);
    });
    
    widget.onSelectionRectChanged?.call(_selectionRect!);
  }

  /// Finalise le rectangle de sélection
  void _finalizeSelectionRect() {
    if (_selectionRect == null) return;
    
    widget.onSelectionRectChanged?.call(_selectionRect!);
    
    setState(() {
      _dragStart = null;
      _dragCurrent = null;
      _selectionRect = null;
    });
  }

  /// Gère le début du geste (1 seul point de contact ; le cas 2+ doigts est
  /// traité directement dans onScaleStart/onScaleUpdate)
  void _handleGestureStart(Offset localFocalPoint) {
    final isTouch = _lastPointerKind == PointerDeviceKind.touch ||
        _lastPointerKind == PointerDeviceKind.stylus;
    final localPosition = _getLocalPosition(localFocalPoint);

    if (widget.currentTool == 'select' && widget.selectedSymbolIds.isNotEmpty) {
      // Déplacer les symboles sélectionnés
      _dragStart = localPosition;
    } else if (widget.currentTool == 'select' && isTouch) {
      // Écran tactile (doigt ou stylet) : un glissé simple déplace la vue,
      // comme sur une carte. Le rectangle de sélection reste accessible via
      // un appui long + glissé (onLongPressStart/onLongPressMoveUpdate).
      _isPanningView = true;
    } else if (widget.currentTool == 'select') {
      // Souris : démarrer un rectangle de sélection (comportement inchangé)
      setState(() {
        _dragStart = localPosition;
        _dragCurrent = localPosition;
        _selectionRect = Rect.fromLTWH(
          localPosition.dx,
          localPosition.dy,
          0,
          0,
        );
      });
    } else if (_isDrawing && (widget.currentTool == 'line' || widget.currentTool == 'polygon')) {
      // Continuer le dessin
      _dragStart = localPosition;
    }
  }

  /// Gère la mise à jour du geste (1 seul point de contact)
  void _handleGestureUpdate(Offset focalPoint, Offset localFocalPoint) {
    if (_isPanningView) {
      final delta = focalPoint - _lastFocalPoint;
      widget.onPanUpdate?.call(widget.panOffset + delta);
      _lastFocalPoint = focalPoint;
      return;
    }

    final localPosition = _getLocalPosition(localFocalPoint);

    if (widget.currentTool == 'select' && widget.selectedSymbolIds.isNotEmpty && _dragStart != null) {
      // Déplacer les symboles sélectionnés
      final delta = localPosition - _dragStart!;
      widget.onSymbolsMoved?.call(widget.selectedSymbolIds, delta);
      _dragStart = localPosition;
      _dragCurrent = localPosition;
    } else if (widget.currentTool == 'select' && _dragStart != null) {
      // Mettre à jour le rectangle de sélection
      _updateSelectionRect(localPosition);
    } else if (_isDrawing && (widget.currentTool == 'line' || widget.currentTool == 'polygon')) {
      // Mettre à jour le point temporaire
      setState(() {
        _dragCurrent = localPosition;
      });
    }
  }

  /// Gère la fin du geste (1 seul point de contact)
  void _handleGestureEnd() {
    if (_isPanningView) {
      _isPanningView = false;
      return;
    }

    if (_isDrawing && widget.currentTool == 'line' && _dragCurrent != null) {
      // Ajouter le point temporaire
      setState(() {
        _currentPoints.add(_dragCurrent!);
        _dragCurrent = null;
      });
    }

    setState(() {
      _dragStart = null;
      _dragCurrent = null;
      _selectionRect = null;
    });
  }

  /// Gère la création d'un point
  void _handlePointTap(Offset localPosition) {
    if (widget.selectedLayerIndex == null || widget.onSymbolAdded == null) return;
    
    final symbol = symbol_model.MapSymbol.point(
      id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      position: localPosition,
      color: Colors.black,
      size: 5.0,
    );
    
    widget.onSymbolAdded!(symbol);
  }

  /// Gère la création d'un texte
  void _handleTextTap(Offset localPosition) {
    if (widget.selectedLayerIndex == null || widget.onSymbolAdded == null) return;
    
    final symbol = symbol_model.MapSymbol.text(
      id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
      text: 'Nouveau texte',
      position: localPosition,
      color: Colors.black,
      fontSize: 12.0,
    );
    
    widget.onSymbolAdded!(symbol);
  }

  /// Finalise le dessin en cours
  void _finalizeDrawing() {
    if (_currentPoints.isEmpty || widget.onSymbolAdded == null) return;
    
    symbol_model.MapSymbol symbol;
    
    if (widget.currentTool == 'line') {
      symbol = symbol_model.MapSymbol.line(
        id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
        points: List<Offset>.from(_currentPoints),
        color: Colors.black,
        strokeWidth: 2.0,
      );
    } else if (widget.currentTool == 'polygon') {
      symbol = symbol_model.MapSymbol.area(
        id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
        points: List<Offset>.from(_currentPoints),
        isClosed: true,
        fillColor: Colors.blue.withValues(alpha: 0.3),
        strokeColor: Colors.blue,
        strokeWidth: 1.0,
      );
    } else {
      return;
    }
    
    widget.onSymbolAdded!(symbol);
    
    setState(() {
      _currentPoints.clear();
      _isDrawing = false;
    });
  }

  /// Gère les raccourcis clavier
  KeyEventResult _handleKeyPress(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      
      // Supprimer
      if (key == LogicalKeyboardKey.delete || key == LogicalKeyboardKey.backspace) {
        if (widget.selectedSymbolIds.isNotEmpty) {
          widget.onSymbolsDeleted?.call(widget.selectedSymbolIds);
          return KeyEventResult.handled;
        }
      }
      
      // Échap (annuler le dessin en cours)
      if (key == LogicalKeyboardKey.escape) {
        if (_isDrawing) {
          setState(() {
            _currentPoints.clear();
            _isDrawing = false;
          });
          return KeyEventResult.handled;
        }
        // Effacer la sélection
        widget.onSymbolsSelected?.call(const {});
        return KeyEventResult.handled;
      }
    }
    
    return KeyEventResult.ignored;
  }

  /// Construit le widget d'affichage d'un calque image de fond
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
}

/// Painter pour la grille
class _GridPainter extends CustomPainter {
  final double zoomLevel;

  _GridPainter({required this.zoomLevel});

  @override
  void paint(Canvas canvas, Size size) {
    // Fond blanc
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Grille (adaptée au zoom)
    final gridSize = 100.0 / zoomLevel;
    if (gridSize > 5) {
      final gridPaint = Paint()
        ..color = Colors.grey.withValues(alpha: 0.2)
        ..strokeWidth = 0.5;

      // Lignes verticales
      for (var x = -size.width; x <= size.width * 2; x += gridSize) {
        canvas.drawLine(
          Offset(x, -size.height),
          Offset(x, size.height * 2),
          gridPaint,
        );
      }

      // Lignes horizontales
      for (var y = -size.height; y <= size.height * 2; y += gridSize) {
        canvas.drawLine(
          Offset(-size.width, y),
          Offset(size.width * 2, y),
          gridPaint,
        );
      }
    }

    // Marqueur d'origine
    canvas.drawCircle(
      Offset.zero,
      3.0,
      Paint()..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.zoomLevel != zoomLevel;
  }
}

/// Painter pour les symboles
class _SymbolsPainter extends CustomPainter {
  final List<Layer> layers;
  final double zoomLevel;
  final Set<String> selectedSymbolIds;
  final String? hoveredSymbolId;

  _SymbolsPainter({
    required this.layers,
    required this.zoomLevel,
    this.selectedSymbolIds = const {},
    this.hoveredSymbolId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner chaque calque
    for (final layer in layers) {
      if (!layer.visible) continue;
      
      // Appliquer l'opacité du calque
      final layerOpacity = layer.opacity;
      
      for (final symbol in layer.symbols) {
        final isSelected = selectedSymbolIds.contains(symbol.id);
        final isHovered = hoveredSymbolId == symbol.id;
        
        _drawSymbol(
          canvas,
          symbol,
          layerOpacity,
          isSelected,
          isHovered,
        );
      }
    }
  }

  void _drawSymbol(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    double layerOpacity,
    bool isSelected,
    bool isHovered,
  ) {
    final effectiveOpacity = symbol.opacity * layerOpacity;
    
    switch (symbol.type) {
      case symbol_model.MapSymbolType.point:
        _drawPointSymbol(canvas, symbol, effectiveOpacity, isSelected, isHovered);
        break;
      case symbol_model.MapSymbolType.line:
        _drawLineSymbol(canvas, symbol, effectiveOpacity, isSelected, isHovered);
        break;
      case symbol_model.MapSymbolType.area:
        _drawAreaSymbol(canvas, symbol, effectiveOpacity, isSelected, isHovered);
        break;
      case symbol_model.MapSymbolType.text:
        _drawTextSymbol(canvas, symbol, effectiveOpacity, isSelected, isHovered);
        break;
    }
  }

  /// Dessine un [path] en pointillés (tiret de longueur [dashLength],
  /// espace de longueur [gapLength]) plutôt qu'en trait continu.
  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLength, double gapLength) {
    if (dashLength <= 0) {
      canvas.drawPath(path, paint);
      return;
    }
    final period = dashLength + (gapLength > 0 ? gapLength : 0.01);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += period;
      }
    }
  }

  void _drawPointSymbol(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    double opacity,
    bool isSelected,
    bool isHovered,
  ) {
    final center = symbol.position;
    final radius = symbol.size / 2;
    
    // Couleur de base
    final baseColor = symbol.color.withValues(alpha: opacity);
    
    // Dessiner le cercle
    final paint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, paint);
    
    // Contour pour la sélection
    if (isSelected) {
      final outlinePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 / zoomLevel;
      
      canvas.drawCircle(center, radius + 2.0, outlinePaint);
    }
    
    // Surbrillance au survol
    if (isHovered) {
      final hoverPaint = Paint()
        ..color = Colors.yellow.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, radius + 1.0, hoverPaint);
    }
  }

  void _drawLineSymbol(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    double opacity,
    bool isSelected,
    bool isHovered,
  ) {
    if (symbol.points.length < 2) return;
    
    final path = Path();
    path.moveTo(symbol.points[0].dx, symbol.points[0].dy);
    
    for (var i = 1; i < symbol.points.length; i++) {
      path.lineTo(symbol.points[i].dx, symbol.points[i].dy);
    }
    
    // Dessiner la ligne
    final paint = Paint()
      ..color = symbol.color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = symbol.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (symbol.isDashed) {
      _drawDashedPath(canvas, path, paint, symbol.dashLength ?? 4.0, symbol.gapLength ?? 1.0);
    } else {
      canvas.drawPath(path, paint);
    }
    
    // Contour pour la sélection
    if (isSelected) {
      final outlinePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 / zoomLevel;
      
      canvas.drawPath(path, outlinePaint);
    }
    
    // Surbrillance au survol
    if (isHovered) {
      final hoverPaint = Paint()
        ..color = Colors.yellow.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = symbol.strokeWidth + 2.0;
      
      canvas.drawPath(path, hoverPaint);
    }
  }

  void _drawAreaSymbol(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    double opacity,
    bool isSelected,
    bool isHovered,
  ) {
    if (symbol.points.length < 3) return;
    
    final path = Path();
    path.moveTo(symbol.points[0].dx, symbol.points[0].dy);
    
    for (var i = 1; i < symbol.points.length; i++) {
      path.lineTo(symbol.points[i].dx, symbol.points[i].dy);
    }
    
    if (symbol.isClosed) {
      path.close();
    }
    
    // Remplissage
    if (symbol.fillColor != null) {
      final fillPaint = Paint()
        ..color = symbol.fillColor!.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(path, fillPaint);
    }
    
    // Contour
    if (symbol.strokeColor != null && symbol.strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = symbol.strokeColor!.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = symbol.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      canvas.drawPath(path, strokePaint);
    }
    
    // Contour pour la sélection
    if (isSelected) {
      final outlinePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 / zoomLevel
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      canvas.drawPath(path, outlinePaint);
    }
    
    // Surbrillance au survol
    if (isHovered) {
      final hoverPaint = Paint()
        ..color = Colors.yellow.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(path, hoverPaint);
    }
  }

  void _drawTextSymbol(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    double opacity,
    bool isSelected,
    bool isHovered,
  ) {
    if (symbol.text == null || symbol.text!.isEmpty) return;
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: symbol.text,
        style: TextStyle(
          color: symbol.color.withValues(alpha: opacity),
          fontSize: symbol.fontSize ?? 12.0,
          fontFamily: symbol.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: symbol.textAlign ?? TextAlign.left,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      symbol.position,
    );
    
    // Rectangle de sélection
    if (isSelected) {
      final rect = Rect.fromLTWH(
        symbol.position.dx,
        symbol.position.dy - (symbol.fontSize ?? 12.0),
        textPainter.width,
        textPainter.height,
      );
      
      final outlinePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0 / zoomLevel;
      
      canvas.drawRect(rect, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SymbolsPainter oldDelegate) {
    return oldDelegate.layers != layers ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.selectedSymbolIds != selectedSymbolIds ||
        oldDelegate.hoveredSymbolId != hoveredSymbolId;
  }
}

/// Painter pour le rectangle de sélection
class _SelectionRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Rectangle semi-transparent
    final fillPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), fillPaint);
    
    // Bordure
    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Painter pour le dessin en cours
class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final String tool;

  _DrawingPainter({required this.points, required this.tool});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    if (tool == 'line' || tool == 'polygon') {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Dessiner les points de contrôle
    for (final point in points) {
      canvas.drawCircle(point, 3.0, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.tool != tool;
  }
}

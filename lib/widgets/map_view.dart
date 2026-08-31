import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final double zoom;
  final Offset cameraPosition;
  final int? selectedLayerIndex;
  final String currentTool;
  final Set<String> selectedSymbolIds;
  final ValueChanged<Offset>? onPanUpdate;
  final ValueChanged<double>? onZoomChanged;
  final ValueChanged<Rect>? onSelectionRectChanged;
  final ValueChanged<Offset>? onTap;
  final ValueChanged<String>? onSymbolSelected;
  final ValueChanged<Set<String>>? onSymbolsSelected;
  final Function(symbol_model.MapSymbol)? onSymbolAdded;
  final Function(String, Offset)? onSymbolMoved;
  final Function(Set<String>, Offset)? onSymbolsMoved;
  final Function(String)? onSymbolDeleted;
  final Function(Set<String>)? onSymbolsDeleted;

  const MapView({
    super.key,
    required this.layers,
    required this.zoom,
    required this.cameraPosition,
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
      onKeyEvent: _handleKeyEvent,
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
          },
          onScaleUpdate: (details) {
            if (details.scale != 1.0) {
              widget.onZoomChanged?.call(widget.zoom * details.scale);
            }

            if (details.pointerCount >= 2) {
              final delta = details.focalPoint - _lastFocalPoint;
              widget.onPanUpdate?.call(widget.cameraPosition + delta);
              _lastFocalPoint = details.focalPoint;
            }
          },
          onScaleEnd: (details) {
            _lastFocalPoint = Offset.zero;
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
          onPanStart: (details) {
            _handlePanStart(details);
          },
          onPanUpdate: (details) {
            _handlePanUpdate(details, sortedLayers);
          },
          onPanEnd: (details) {
            _handlePanEnd(details);
          },
          child: Listener(
            onPointerDown: (details) {
              _dragStart = details.localPosition;
            },
            onPointerMove: (details) {
              if (details.buttons == 2) {
                // Bouton droit : défilement
                final delta = details.localPosition - _dragStart!;
                widget.onPanUpdate?.call(widget.cameraPosition + delta);
                _dragStart = details.localPosition;
              }
            },
            child: InteractiveViewer(
              panEnabled: false,
              minScale: 0.1,
              maxScale: 10.0,
              child: ClipRect(
                child: Transform.translate(
                  offset: widget.cameraPosition,
                  child: Transform.scale(
                    scale: widget.zoom,
                    child: Stack(
                      children: [
                        // Fond blanc + grille
                        CustomPaint(
                          size: Size.infinite,
                          painter: _GridPainter(zoom: widget.zoom),
                        ),
                        // Images de fond (calques raster)
                        for (final layer in sortedLayers)
                          if (layer.isImageBackground) _buildImageLayer(layer),
                        // Symboles des calques vectoriels
                        CustomPaint(
                          size: Size.infinite,
                          painter: _SymbolsPainter(
                            layers: sortedLayers,
                            zoom: widget.zoom,
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
                                dragCurrent: _dragCurrent,
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
        case 'area':
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
    return (screenPosition - widget.cameraPosition) / widget.zoom;
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
        case 'area':
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
        (widget.currentTool == 'line' || widget.currentTool == 'area')) {
      
      if (widget.currentTool == 'line') {
        setState(() {
          _currentPoints.add(localPosition);
        });
      } else if (widget.currentTool == 'area') {
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

  /// Gère le début du drag
  void _handlePanStart(DragStartDetails details) {
    final localPosition = _getLocalPosition(details.localPosition);
    
    if (widget.currentTool == 'select' && widget.selectedSymbolIds.isNotEmpty) {
      // Déplacer les symboles sélectionnés
      _dragStart = localPosition;
    } else if (widget.currentTool == 'select') {
      // Démarrer un rectangle de sélection
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
    } else if (_isDrawing && (widget.currentTool == 'line' || widget.currentTool == 'area')) {
      // Continuer le dessin
      _dragStart = localPosition;
    }
  }

  /// Gère le drag en cours
  void _handlePanUpdate(DragUpdateDetails details, List<Layer> sortedLayers) {
    final localPosition = _getLocalPosition(details.localPosition);
    
    if (widget.currentTool == 'select' && widget.selectedSymbolIds.isNotEmpty && _dragStart != null) {
      // Déplacer les symboles sélectionnés
      final delta = localPosition - _dragStart!;
      widget.onSymbolsMoved?.call(widget.selectedSymbolIds, delta);
      _dragStart = localPosition;
      _dragCurrent = localPosition;
    } else if (widget.currentTool == 'select' && _dragStart != null) {
      // Mettre à jour le rectangle de sélection
      _updateSelectionRect(localPosition);
    } else if (_isDrawing && (widget.currentTool == 'line' || widget.currentTool == 'area')) {
      // Mettre à jour le point temporaire
      setState(() {
        _dragCurrent = localPosition;
      });
    }
  }

  /// Gère la fin du drag
  void _handlePanEnd(DragEndDetails details) {
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
      strokeColor: const Color(0xFF000000),
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
      textStyle: const TextStyle(color: Color(0xFF000000), fontSize: 12.0),
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
        strokeColor: const Color(0xFF000000),
        strokeWidth: 2.0,
      );
    } else if (widget.currentTool == 'area') {
      symbol = symbol_model.MapSymbol.area(
        id: 'symbol_${DateTime.now().millisecondsSinceEpoch}',
        points: List<Offset>.from(_currentPoints),
        isClosed: true,
        fillColor: const Color(0x4D2196F3),
        strokeColor: const Color(0xFF2196F3),
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
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
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
                color: const Color(0x26F44336),
                alignment: Alignment.center,
                child: const Text(
                  'Image de fond illisible',
                  style: const TextStyle(fontSize: 10, color: Color(0xFFF44336)),
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
  final double zoom;

  _GridPainter({required this.zoom});

  @override
  void paint(Canvas canvas, Size size) {
    // Fond blanc
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    // Grille (adaptée au zoom)
    final gridSize = 100.0 / zoom;
    if (gridSize > 5) {
      final gridPaint = Paint()
        ..color = const Color(0x339E9E9E)
        ..strokeWidth = 0.5;

      // Lignes verticales
      for (var x = -size.width; x <= size.width * 2; x += gridSize) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          gridPaint,
        );
      }

      // Lignes horizontales
      for (var y = -size.height; y <= size.height * 2; y += gridSize) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          gridPaint,
        );
      }

      // Lignes plus épaisses tous les 500mm
      final majorGridSize = 500.0 / zoom;
      if (majorGridSize > 20) {
        final majorGridPaint = Paint()
          ..color = const Color(0x669E9E9E)
          ..strokeWidth = 1.0;

        for (var x = -size.width; x <= size.width * 2; x += majorGridSize) {
          canvas.drawLine(
            Offset(x, 0),
            Offset(x, size.height),
            majorGridPaint,
          );
        }

        for (var y = -size.height; y <= size.height * 2; y += majorGridSize) {
          canvas.drawLine(
            Offset(0, y),
            Offset(size.width, y),
            majorGridPaint,
          );
        }
      }
    }

    // Axes
    final axisPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), axisPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.zoom != zoom;
  }
}

/// Painter pour les symboles
class _SymbolsPainter extends CustomPainter {
  final List<Layer> layers;
  final double zoom;
  final Set<String> selectedSymbolIds;
  final String? hoveredSymbolId;

  _SymbolsPainter({
    required this.layers,
    required this.zoom,
    this.selectedSymbolIds = const {},
    this.hoveredSymbolId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner les calques du bas vers le haut
    for (final layer in layers) {
      if (!layer.visible) continue;
      
      // Opacité du calque
      final layerOpacity = layer.opacity;
      
      for (final symbol in layer.symbols) {
        // Appliquer l'opacité du calque
        final effectiveOpacity = layerOpacity * (symbol.visible ? 1.0 : 0.0);
        
        if (effectiveOpacity == 0) continue;
        
        _drawSymbol(canvas, symbol, effectiveOpacity);
      }
    }
  }

  /// Dessine un symbole
  void _drawSymbol(Canvas canvas, symbol_model.MapSymbol symbol, double opacity) {
    final paint = Paint();
    final isSelected = selectedSymbolIds.contains(symbol.id);
    final isHovered = hoveredSymbolId == symbol.id;
    
    // Appliquer l'opacité
    paint.color = symbol.strokeColor.withValues(alpha: opacity);
    
    switch (symbol.type) {
      case symbol_model.MapSymbolType.point:
        _drawPoint(canvas, symbol, paint, isSelected, isHovered);
        break;
      case symbol_model.MapSymbolType.line:
        _drawLine(canvas, symbol, paint, isSelected, isHovered);
        break;
      case symbol_model.MapSymbolType.area:
        _drawArea(canvas, symbol, paint, isSelected, isHovered);
        break;
      case symbol_model.MapSymbolType.text:
        _drawText(canvas, symbol, isSelected, isHovered);
        break;
    }
  }

  /// Dessine un point
  void _drawPoint(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    Paint paint,
    bool isSelected,
    bool isHovered,
  ) {
    final center = symbol.position;
    final radius = symbol.size / 2;
    
    // Fond (pour les points remplis)
    if (symbol.fillColor != const Color(0x00000000)) {
      final fillPaint = Paint()
        ..color = symbol.fillColor.withValues(alpha: symbol.fillOpacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, radius, fillPaint);
    }
    
    // Contour
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = symbol.strokeWidth / zoom;
    
    canvas.drawCircle(center, radius, paint);
    
    // Feedback visuel pour la sélection
    if (isSelected) {
      _drawSelectionFeedback(canvas, symbol.boundingBox);
    } else if (isHovered) {
      _drawHoverFeedback(canvas, symbol.boundingBox);
    }
  }

  /// Dessine une ligne
  void _drawLine(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    Paint paint,
    bool isSelected,
    bool isHovered,
  ) {
    if (symbol.points.isEmpty) return;
    
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = symbol.strokeWidth / zoom;
    
    // Dessiner la ligne
    final path = Path();
    path.moveTo(symbol.points.first.dx, symbol.points.first.dy);
    
    for (var i = 1; i < symbol.points.length; i++) {
      path.lineTo(symbol.points[i].dx, symbol.points[i].dy);
    }
    
    canvas.drawPath(path, paint);
    
    // Feedback visuel pour la sélection
    if (isSelected) {
      _drawSelectionFeedback(canvas, symbol.boundingBox);
    } else if (isHovered) {
      _drawHoverFeedback(canvas, symbol.boundingBox);
    }
  }

  /// Dessine une surface
  void _drawArea(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    Paint paint,
    bool isSelected,
    bool isHovered,
  ) {
    if (symbol.points.isEmpty) return;
    
    // Remplissage
    final fillPaint = Paint()
      ..color = symbol.fillColor.withValues(alpha: symbol.fillOpacity)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(symbol.points.first.dx, symbol.points.first.dy);
    
    for (var i = 1; i < symbol.points.length; i++) {
      path.lineTo(symbol.points[i].dx, symbol.points[i].dy);
    }
    
    if (symbol.isClosed && symbol.points.length > 1) {
      path.close();
    }
    
    canvas.drawPath(path, fillPaint);
    
    // Contour
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = symbol.strokeWidth / zoom;
    
    canvas.drawPath(path, paint);
    
    // Feedback visuel pour la sélection
    if (isSelected) {
      _drawSelectionFeedback(canvas, symbol.boundingBox);
    } else if (isHovered) {
      _drawHoverFeedback(canvas, symbol.boundingBox);
    }
  }

  /// Dessine du texte
  void _drawText(
    Canvas canvas,
    symbol_model.MapSymbol symbol,
    bool isSelected,
    bool isHovered,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: symbol.text,
        style: symbol.textStyle.copyWith(
          color: symbol.textStyle.color?.withValues(alpha: symbol.textStyle.color?.alpha ?? 1.0),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Positionner le texte
    final offset = Offset(
      symbol.position.dx - textPainter.width / 2,
      symbol.position.dy - textPainter.height / 2,
    );
    
    textPainter.paint(canvas, offset);
    
    // Feedback visuel pour la sélection
    if (isSelected) {
      _drawSelectionFeedback(canvas, symbol.boundingBox);
    } else if (isHovered) {
      _drawHoverFeedback(canvas, symbol.boundingBox);
    }
  }

  /// Dessine le feedback de sélection
  void _drawSelectionFeedback(Canvas canvas, Rect bounds) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 1.5 / zoom
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.left - 2,
        bounds.top - 2,
        bounds.width + 4,
        bounds.height + 4,
      ),
      paint,
    );
  }

  /// Dessine le feedback de survol
  void _drawHoverFeedback(Canvas canvas, Rect bounds) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3).withValues(alpha: 0.5)
      ..strokeWidth = 1.0 / zoom
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.left - 1,
        bounds.top - 1,
        bounds.width + 2,
        bounds.height + 2,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SymbolsPainter oldDelegate) {
    return oldDelegate.layers != layers ||
        oldDelegate.zoom != zoom ||
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
      ..color = const Color(0xFF2196F3).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), fillPaint);
    
    // Bordure
    final borderPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SelectionRectPainter oldDelegate) => false;
}

/// Painter pour le dessin en cours
class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final String tool;
  final Offset? dragCurrent;

  _DrawingPainter({
    required this.points,
    required this.tool,
    this.dragCurrent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    
    final paint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    switch (tool) {
      case 'line':
        _drawLinePreview(canvas, paint);
        break;
      case 'area':
        _drawAreaPreview(canvas, paint);
        break;
    }
  }

  /// Dessine l'aperçu de la ligne en cours
  void _drawLinePreview(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    // Ajouter le point temporaire
    if (dragCurrent != null) {
      path.lineTo(dragCurrent!.dx, dragCurrent!.dy);
    }
    
    canvas.drawPath(path, paint);
    
    // Dessiner les points de contrôle
    _drawControlPoints(canvas, paint);
  }

  /// Dessine l'aperçu de la surface en cours
  void _drawAreaPreview(Canvas canvas, Paint paint) {
    if (points.length < 2) {
      _drawLinePreview(canvas, paint);
      return;
    }
    
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    // Ajouter le point temporaire
    if (dragCurrent != null) {
      path.lineTo(dragCurrent!.dx, dragCurrent!.dy);
    }
    
    // Fermer le polygone
    if (points.length > 1) {
      path.lineTo(points.first.dx, points.first.dy);
    }
    
    // Remplissage semi-transparent
    final fillPaint = Paint()
      ..color = const Color(0xFF2196F3).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
    
    // Dessiner les points de contrôle
    _drawControlPoints(canvas, paint);
  }

  /// Dessine les points de contrôle
  void _drawControlPoints(Canvas canvas, Paint paint) {
    final controlPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;
    
    for (final point in points) {
      canvas.drawCircle(point, 3.0, controlPaint);
    }
    
    if (dragCurrent != null) {
      canvas.drawCircle(dragCurrent!, 3.0, controlPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.tool != tool ||
        oldDelegate.dragCurrent != dragCurrent;
  }
}

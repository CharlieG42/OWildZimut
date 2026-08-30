import 'package:flutter/material.dart';

/// Gère les animations de feedback visuel pour OWildZimut
///
/// Cette classe fournit des animations pour améliorer l'expérience utilisateur
/// lors des interactions avec la carte.
class FeedbackAnimations {
  /// Affiche une animation de rectangle de sélection
  static void showSelectionRectAnimation(
    BuildContext context,
    Rect rect, [
    Duration duration = const Duration(milliseconds: 500),
  ]) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedSelectionRect(
        rect: rect,
        duration: duration,
        onComplete: () => overlayEntry?.remove(),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// Affiche une animation lors de l'ajout d'un symbole
  static void showSymbolAddedAnimation(
    BuildContext context,
    Offset position, [
    Duration duration = const Duration(milliseconds: 300),
  ]) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => SymbolAddedAnimation(
        position: position,
        duration: duration,
        onComplete: () => overlayEntry?.remove(),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// Affiche une animation lors de la suppression d'un symbole
  static void showSymbolDeletedAnimation(
    BuildContext context,
    Offset position, [
    Duration duration = const Duration(milliseconds: 300),
  ]) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => SymbolDeletedAnimation(
        position: position,
        duration: duration,
        onComplete: () => overlayEntry?.remove(),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// Affiche une animation de copier/coller
  static void showCopyPasteAnimation(
    BuildContext context,
    Offset fromPosition,
    Offset toPosition, [
    Duration duration = const Duration(milliseconds: 400),
  ]) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CopyPasteAnimation(
        fromPosition: fromPosition,
        toPosition: toPosition,
        duration: duration,
        onComplete: () => overlayEntry?.remove(),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// Affiche un message temporaire (style toast)
  static void showToast(
    BuildContext context,
    String message, [
    Duration duration = const Duration(seconds: 2),
  ]) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => ToastMessage(
        message: message,
        duration: duration,
        onComplete: () => overlayEntry?.remove(),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

/// Animation de rectangle de sélection
class AnimatedSelectionRect extends StatefulWidget {
  final Rect rect;
  final Duration duration;
  final VoidCallback onComplete;

  const AnimatedSelectionRect({
    super.key,
    required this.rect,
    required this.duration,
    required this.onComplete,
  });

  @override
  State<AnimatedSelectionRect> createState() => _AnimatedSelectionRectState();
}

class _AnimatedSelectionRectState extends State<AnimatedSelectionRect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color> _colorAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _colorAnimation = ColorTween(
      begin: const Color.fromRGBO(0, 0, 255, 0.5),
      end: Colors.transparent,
    ).animate(_controller) as Animation<Color>;
    
    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(_controller);
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SelectionRectPainter(
            rect: widget.rect,
            color: _colorAnimation.value,
            opacity: _opacityAnimation.value,
          ),
        );
      },
    );
  }
}

/// Painter pour le rectangle de sélection animé
class SelectionRectPainter extends CustomPainter {
  final Rect rect;
  final Color color;
  final double opacity;

  SelectionRectPainter({
    required this.rect,
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Animation lors de l'ajout d'un symbole
class SymbolAddedAnimation extends StatefulWidget {
  final Offset position;
  final Duration duration;
  final VoidCallback onComplete;

  const SymbolAddedAnimation({
    super.key,
    required this.position,
    required this.duration,
    required this.onComplete,
  });

  @override
  State<SymbolAddedAnimation> createState() => _SymbolAddedAnimationState();
}

class _SymbolAddedAnimationState extends State<SymbolAddedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _scaleAnimation = Tween(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: const Icon(
                Icons.add_circle,
                color: Colors.green,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animation lors de la suppression d'un symbole
class SymbolDeletedAnimation extends StatefulWidget {
  final Offset position;
  final Duration duration;
  final VoidCallback onComplete;

  const SymbolDeletedAnimation({
    super.key,
    required this.position,
    required this.duration,
    required this.onComplete,
  });

  @override
  State<SymbolDeletedAnimation> createState() => _SymbolDeletedAnimationState();
}

class _SymbolDeletedAnimationState extends State<SymbolDeletedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _scaleAnimation = Tween(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(_controller);
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animation de copier/coller
class CopyPasteAnimation extends StatefulWidget {
  final Offset fromPosition;
  final Offset toPosition;
  final Duration duration;
  final VoidCallback onComplete;

  const CopyPasteAnimation({
    super.key,
    required this.fromPosition,
    required this.toPosition,
    required this.duration,
    required this.onComplete,
  });

  @override
  State<CopyPasteAnimation> createState() => _CopyPasteAnimationState();
}

class _CopyPasteAnimationState extends State<CopyPasteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _positionAnimation = Tween<Offset>(
      begin: widget.fromPosition,
      end: widget.toPosition,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: const Icon(
              Icons.content_copy,
              color: Colors.blue,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}

/// Message temporaire (style toast)
class ToastMessage extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onComplete;

  const ToastMessage({
    super.key,
    required this.message,
    required this.duration,
    required this.onComplete,
  });

  @override
  State<ToastMessage> createState() => _ToastMessageState();
}

class _ToastMessageState extends State<ToastMessage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 50),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Attendre un peu avant de disparaître
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _controller.reverse().then((_) => widget.onComplete());
          }
        });
      }
      if (status == AnimationStatus.dismissed) {
        widget.onComplete();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: _positionAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Center(
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animation de pulsation pour mettre en évidence un élément
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final int pulseCount;
  final VoidCallback? onComplete;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.pulseCount = 2,
    this.onComplete,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _pulseCount = 0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _scaleAnimation = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseCount++;
        if (_pulseCount >= widget.pulseCount) {
          _controller.reverse().then((_) {
            widget.onComplete?.call();
          });
        } else {
          _controller.reverse().then((_) {
            if (mounted) {
              _controller.forward();
            }
          });
        }
      }
      if (status == AnimationStatus.dismissed && _pulseCount > 0) {
        widget.onComplete?.call();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Animation de fondu pour les transitions
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onComplete;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.onComplete,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Animation de glissement pour les panneaux
class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Edge edge;
  final VoidCallback? onComplete;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.edge = Edge.right,
    this.onComplete,
  });

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    switch (widget.edge) {
      case Edge.top:
        _positionAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(_controller);
        break;
      case Edge.bottom:
        _positionAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(_controller);
        break;
      case Edge.left:
        _positionAnimation = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(_controller);
        break;
      case Edge.right:
        _positionAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(_controller);
        break;
    }
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: _positionAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Direction pour SlideInAnimation
enum Edge { top, bottom, left, right }

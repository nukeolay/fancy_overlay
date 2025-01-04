import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:fancy_overlay/src/overlays/falling_widgets/falling_model.dart';

class FallingWidgets extends StatefulWidget {
  const FallingWidgets({required this.config, super.key});
  final FallingWidgetsOverlayConfig config;

  @override
  State<FallingWidgets> createState() => _FallingWidgetsState();
}

class _FallingWidgetsState extends State<FallingWidgets>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final Size _screenSize;
  late List<FallingModel> _fallingWidgets;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      _fallingWidgets.removeWhere((e) => e.isOffScreen);
      final offScreenWidgets =
          widget.config.numberOfWidgets - _fallingWidgets.length;
      if (offScreenWidgets > 0) {
        _fallingWidgets.addAll(
          List.generate(
            offScreenWidgets,
            (_) => FallingModel(
              config: widget.config,
              screenSize: _screenSize,
            ),
          ),
        );
      }
      for (final e in _fallingWidgets) {
        e.updatePosition();
      }
      setState(() {});
    })
      ..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _fallingWidgets = List.generate(
      widget.config.numberOfWidgets,
      (_) => FallingModel(
        config: widget.config.copyWith(
          positionStrategy: const FallingWidgetRandomPositionStrategy(),
        ),
        screenSize: _screenSize,
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _fallingWidgets.map(
        (e) {
          return Positioned(
            key: e.key,
            left: e.x,
            top: e.y,
            child: _AnimatedScale(
              scale: e.scale,
              duration: widget.config.appearDuration,
              child: Transform.rotate(
                angle: e.rotation,
                child: e.widget,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _AnimatedScale extends StatefulWidget {
  const _AnimatedScale({
    required this.scale,
    required this.duration,
    required this.child,
  });
  final double scale;
  final Duration duration;
  final Widget child;

  @override
  State<_AnimatedScale> createState() => _AnimatedScaleState();
}

class _AnimatedScaleState extends State<_AnimatedScale>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      upperBound: widget.scale,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _controller.value,
      child: widget.child,
    );
  }
}

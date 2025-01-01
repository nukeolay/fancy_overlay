import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class FallingWidgetsOverlay extends StatefulWidget {
  const FallingWidgetsOverlay({
    required this.config,
    super.key,
  });

  final FallingWidgetsOverlayConfig config;

  @override
  State<FallingWidgetsOverlay> createState() => _FallingWidgetsOverlayState();
}

class _FallingWidgetsOverlayState extends State<FallingWidgetsOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  late final Size _screenSize;
  List<_FallingWidget>? _fallingWidgets;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _fallingWidgets = List.generate(
      widget.config.numberOfWidgets,
      (index) => _createFallingWidget(index),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _FallingWidget _createFallingWidget(int index) {
    final size = _randomDouble(
      widget.config.minSize,
      widget.config.maxSize,
    );
    final initialX = _randomDouble(
      0,
      _screenSize.width,
    );
    final initialY = _randomDouble(
      -_screenSize.height, // Allow starting off-screen
      _screenSize.height,
    );
    final speed = _randomDouble(
      widget.config.minSpeed,
      widget.config.maxSpeed,
    );
    final widgetIndex = _random.nextInt(
      widget.config.children.length,
    );

    return _FallingWidget(
      widget: widget.config.children[widgetIndex],
      size: size,
      opacity: widget.config.opacity,
      initialX: initialX,
      initialY: initialY,
      drift: widget.config.drift,
      rotationSpeed: widget.config.rotationSpeed,
      horizontalOffset: widget.config.horizontalOffset,
      speed: speed,
      screenHeight: _screenSize.height,
      screenWidth: _screenSize.width,
    );
  }

  double _randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.none,
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: FadeTransition(
        opacity: AlwaysStoppedAnimation(widget.config.opacity),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final displayedWidgets = _fallingWidgets?.where(
              (fallingWidget) {
                return fallingWidget.isOnScreen;
              },
            );
            _fallingWidgets?.forEach((fallingWidget) {
              // Reset the widget if it moves off-screen
              if (fallingWidget.isAfterScreen) {
                fallingWidget.resetPosition();
              }
            });
            return Stack(
              children: displayedWidgets?.map(
                    (fallingWidget) {
                      fallingWidget.updatePosition(_controller.value);
                      return Positioned(
                        left: fallingWidget.x,
                        top: fallingWidget.y,
                        child: Transform.rotate(
                          angle: fallingWidget.rotation,
                          child: Transform.scale(
                            scale: fallingWidget.size,
                            child: fallingWidget.widget,
                          ),
                        ),
                      );
                    },
                  ).toList() ??
                  [],
            );
          },
        ),
      ),
    );
  }
}

class _FallingWidget {
  _FallingWidget({
    required this.widget,
    required this.size,
    required this.opacity,
    required this.initialX,
    required this.initialY,
    required this.drift,
    required this.rotationSpeed,
    required this.horizontalOffset,
    required this.speed,
    required this.screenHeight,
    required this.screenWidth,
  }) {
    // Initialize position
    x = initialX;
    y = initialY;
  }

  final Widget widget;
  final double size;
  final double opacity;
  final double initialX;
  final double initialY;
  final double drift;
  final double rotationSpeed;
  final double horizontalOffset;
  final double speed;
  final double screenHeight;
  final double screenWidth;

  double x = 0.0;
  double y = 0.0;
  double rotation = 0.0;

  void updatePosition(double elapsed) {
    y += speed;
    x = initialX +
        drift * sin(y / screenHeight * 2 * pi) +
        horizontalOffset * screenWidth / 2;
    rotation += rotationSpeed / 60.0; // Simulate smooth rotation
  }

  void resetPosition() {
    y = -size; // Start just above the screen
    x = initialX; // Reset to the initial horizontal position
  }

  bool get isBeforeScreen => y < -size;
  bool get isAfterScreen => y >= screenHeight;
  bool get isOnScreen => !isBeforeScreen && !isAfterScreen;
}

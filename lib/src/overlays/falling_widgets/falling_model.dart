import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:fancy_overlay/src/utils/random_double.dart';

final _random = Random();

class FallingModel {
  FallingModel._({
    required this.key,
    required this.widget,
    required this.initialPosition,
    required this.x,
    required this.y,
    required this.scale,
    required this.opacity,
    required this.rotationSpeed,
    required this.xSpeed,
    required this.ySpeed,
    required this.screenHeight,
    required this.screenWidth,
  });

  factory FallingModel({
    required FallingWidgetsOverlayConfig config,
    required Size screenSize,
  }) {
    final size = _random.randomDouble(
      config.minScale,
      config.maxScale,
    );
    final ySpeed = _random.randomDouble(
      config.minYSpeed,
      config.maxYSpeed,
    );
    final xSpeed = _random.randomDouble(
      config.minXSpeed,
      config.maxXSpeed,
    );
    final widgetIndex = _random.nextInt(
      config.children.length,
    );

    return FallingModel._(
      key: UniqueKey(),
      widget: config.children[widgetIndex],
      initialPosition: config.positionStrategy,
      x: config.positionStrategy.x(screenSize),
      y: config.positionStrategy.y(screenSize),
      scale: size,
      opacity: config.opacity,
      rotationSpeed: config.rotationSpeed,
      ySpeed: ySpeed,
      xSpeed: xSpeed,
      screenHeight: screenSize.height,
      screenWidth: screenSize.width,
    );
  }

  final Key key;
  final Widget widget;
  final FallingWidgetPositionStrategy initialPosition;
  final double scale;
  final double opacity;
  final double rotationSpeed;
  final double xSpeed;
  final double ySpeed;
  final double screenHeight;
  final double screenWidth;

  double x;
  double y;
  double rotation = 0.0;

  void updatePosition() {
    y += ySpeed;
    x += xSpeed;
    rotation += rotationSpeed / 60.0;
  }

  bool get isOffScreen =>
      y > screenHeight || y < 0 || x > screenWidth || x < -screenWidth;
}

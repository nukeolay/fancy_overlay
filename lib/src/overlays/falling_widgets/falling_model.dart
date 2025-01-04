import 'dart:math';

import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:fancy_overlay/src/utils/random_double.dart';
import 'package:flutter/widgets.dart';

final _random = Random();

class FallingModel {
  FallingModel._({
    required this.key,
    required this.widget,
    required this.x,
    required this.y,
    required this.scale,
    required this.opacity,
    required this.rotationSpeed,
    required this.xSpeed,
    required this.ySpeed,
    required this.horizontalOffset,
    required this.screenHeight,
    required this.screenWidth,
  });

  factory FallingModel({
    required FallingWidgetsOverlayConfig config,
    required Size screenSize,
    double? x,
    double? y,
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
      x: x ?? _random.randomDouble(0, screenSize.width),
      y: y ?? _random.randomDouble(0, screenSize.height),
      scale: size,
      opacity: config.opacity,
      rotationSpeed: config.rotationSpeed,
      horizontalOffset: config.horizontalOffset,
      ySpeed: ySpeed,
      xSpeed: xSpeed,
      screenHeight: screenSize.height,
      screenWidth: screenSize.width,
    );
  }

  factory FallingModel.fromTopSide({
    required FallingWidgetsOverlayConfig config,
    required Size screenSize,
  }) {
    return FallingModel(
      config: config,
      screenSize: screenSize,
      x: Random().randomDouble(0, screenSize.width),
      y: 0,
    );
  }

  final Key key;
  final Widget widget;
  final double scale;
  final double opacity;
  final double rotationSpeed;
  final double xSpeed;
  final double ySpeed;
  final double horizontalOffset;
  final double screenHeight;
  final double screenWidth;

  late double x;
  late double y;
  double rotation = 0.0;

  void updatePosition() {
    y += ySpeed;
    x = x + xSpeed + horizontalOffset * screenWidth / 2;
    rotation += rotationSpeed / 60.0;
  }

  bool get isOffScreen =>
      y > screenHeight || y < 0 || x > screenWidth || x < -screenWidth;
}

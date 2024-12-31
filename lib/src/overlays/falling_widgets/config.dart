import 'package:flutter/widgets.dart';

class FallingWidgetsOverlayConfig {
  const FallingWidgetsOverlayConfig({
    required this.children,
    this.numberOfWidgets = 200,
    this.minSpeed = 0.5,
    this.maxSpeed = 2.0,
    this.minSize = 0.25,
    this.maxSize = 3.0,
    this.drift = 20.0,
    this.rotationSpeed = 2.0,
    this.horizontalOffset = 0.0,
    this.minOpacity = 0.2,
    this.maxOpacity = 0.8,
  });

  final List<Widget> children;
  final int numberOfWidgets;
  final double minSpeed;
  final double maxSpeed;
  final double minSize;
  final double maxSize;
  final double drift;
  final double rotationSpeed;
  final double horizontalOffset; // Range: -1.0 to 1.0
  final double minOpacity;
  final double maxOpacity;

  FallingWidgetsOverlayConfig copyWith({
    List<Widget>? children,
    int? numberOfWidgets,
    double? minSpeed,
    double? maxSpeed,
    double? minSize,
    double? maxSize,
    double? drift,
    double? rotationSpeed,
    double? horizontalOffset,
    double? minOpacity,
    double? maxOpacity,
  }) {
    return FallingWidgetsOverlayConfig(
      children: children ?? this.children,
      numberOfWidgets: numberOfWidgets ?? this.numberOfWidgets,
      minSpeed: minSpeed ?? this.minSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      minSize: minSize ?? this.minSize,
      maxSize: maxSize ?? this.maxSize,
      drift: drift ?? this.drift,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      horizontalOffset: horizontalOffset ?? this.horizontalOffset,
      minOpacity: minOpacity ?? this.minOpacity,
      maxOpacity: maxOpacity ?? this.maxOpacity,
    );
  }
}

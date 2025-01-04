import 'package:flutter/widgets.dart';

class FallingWidgetsOverlayConfig {
  const FallingWidgetsOverlayConfig({
    required this.children,
    this.numberOfWidgets = 200,
    this.minYSpeed = 0.5,
    this.maxYSpeed = 1.0,
    this.minXSpeed = 0,
    this.maxXSpeed = 0,
    this.minScale = 0.25,
    this.maxScale = 1.5,
    this.rotationSpeed = 0.5,
    this.appearDuration = const Duration(milliseconds: 2000),
    this.horizontalOffset = 0.0,
    this.opacity = 0.5,
  });

  final List<Widget> children;
  final int numberOfWidgets;
  final double minYSpeed;
  final double maxYSpeed;
  final double minXSpeed;
  final double maxXSpeed;
  final double minScale;
  final double maxScale;
  final double rotationSpeed;
  final Duration appearDuration;
  final double horizontalOffset; // Range: -1.0 to 1.0
  final double opacity; // Range: -1.0 to 1.0

  FallingWidgetsOverlayConfig copyWith({
    List<Widget>? children,
    int? numberOfWidgets,
    double? minYSpeed,
    double? maxYSpeed,
    double? minXSpeed,
    double? maxXSpeed,
    double? minScale,
    double? maxScale,
    double? rotationSpeed,
    Duration? appearDuration,
    double? horizontalOffset,
    double? opacity,
  }) {
    return FallingWidgetsOverlayConfig(
      children: children ?? this.children,
      numberOfWidgets: numberOfWidgets ?? this.numberOfWidgets,
      minYSpeed: minYSpeed ?? this.minYSpeed,
      maxYSpeed: maxYSpeed ?? this.maxYSpeed,
      minXSpeed: minXSpeed ?? this.minXSpeed,
      maxXSpeed: maxXSpeed ?? this.maxXSpeed,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      appearDuration: appearDuration ?? this.appearDuration,
      horizontalOffset: horizontalOffset ?? this.horizontalOffset,
      opacity: opacity ?? this.opacity,
    );
  }
}

import 'package:flutter/widgets.dart';

class VignetteOverlayConfig {
  const VignetteOverlayConfig({
    this.intensity = 0.8,
    this.sepiaStrength = 0.1, // Strength of the sepia filter
    this.radius = 2.0,
    this.edgeFalloff = 2.0,
  });

  final double intensity; // Intensity of the vignette (0.0 - 1.0)
  final double sepiaStrength; // Strength of the sepia filter
  final double radius; // Radius of the inner vignette corners
  final double edgeFalloff; // Width of the vignette falloff from each edge

  double cornerRadiusFor(Size size) {
    final shortestSide = size.shortestSide;
    if (shortestSide <= 0 || radius <= 0) return 0;

    return shortestSide * radius / 30;
  }

  double edgeFalloffFor(Size size) {
    final shortestSide = size.shortestSide;
    if (shortestSide <= 0 || edgeFalloff <= 0) return 0;

    return shortestSide * edgeFalloff / 30;
  }

  VignetteOverlayConfig copyWith({
    double? intensity,
    double? sepiaStrength,
    double? radius,
    double? edgeFalloff,
  }) {
    return VignetteOverlayConfig(
      intensity: intensity ?? this.intensity,
      sepiaStrength: sepiaStrength ?? this.sepiaStrength,
      radius: radius ?? this.radius,
      edgeFalloff: edgeFalloff ?? this.edgeFalloff,
    );
  }
}

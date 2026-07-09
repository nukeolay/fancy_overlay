import 'package:flutter/widgets.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

/// Configuration class for the [VignetteOverlay].
///
/// This class provides options to customize the darkness of the vignette, the
/// sepia tint strength, the inner corner radius, and the width of the edge
/// falloff.
///
/// Example usage:
/// ```dart
/// final config = VignetteOverlayConfig(
///   intensity: 0.8,
///   sepiaStrength: 0.1,
///   radius: 2,
///   edgeFalloff: 2,
/// );
/// ```
class VignetteOverlayConfig {
  /// Creates a configuration for the [VignetteOverlay].
  ///
  /// The default configuration uses:
  /// - `intensity`: `0.8`.
  /// - `sepiaStrength`: `0.1`.
  /// - `radius`: `2.0`.
  /// - `edgeFalloff`: `2.0`.
  const VignetteOverlayConfig({
    this.intensity = 0.8,
    this.sepiaStrength = 0.1,
    this.radius = 2.0,
    this.edgeFalloff = 2.0,
  });

  /// The opacity of the dark vignette around the screen edges.
  ///
  /// Values are typically between `0.0` (transparent) and `1.0` (fully opaque).
  /// Defaults to `0.8`.
  final double intensity;

  /// The strength of the sepia color filter applied to the overlay.
  ///
  /// Values are typically between `0.0` (no sepia tint) and `1.0` (full tint).
  /// Defaults to `0.1`.
  final double sepiaStrength;

  /// The radius of the inner vignette corners.
  ///
  /// The value is scaled relative to the current screen size. Higher values
  /// create rounder inner corners. Defaults to `2.0`.
  final double radius;

  /// The width of the blurred vignette falloff from each screen edge.
  ///
  /// The value is scaled relative to the current screen size. Higher values
  /// make the dark edge extend farther toward the center. Defaults to `2.0`.
  final double edgeFalloff;

  /// Calculates the inner corner radius for the provided [size].
  double cornerRadiusFor(Size size) {
    final shortestSide = size.shortestSide;
    if (shortestSide <= 0 || radius <= 0) return 0;

    return shortestSide * radius / 30;
  }

  /// Calculates the vignette falloff width for the provided [size].
  double edgeFalloffFor(Size size) {
    final shortestSide = size.shortestSide;
    if (shortestSide <= 0 || edgeFalloff <= 0) return 0;

    return shortestSide * edgeFalloff / 30;
  }

  /// Returns a new configuration with updated values.
  ///
  /// This method allows you to copy an existing configuration and override
  /// specific values while keeping the others unchanged.
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

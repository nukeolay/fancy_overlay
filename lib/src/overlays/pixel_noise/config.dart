import 'dart:ui';

import 'package:fancy_overlay/fancy_overlay.dart';

/// Configuration class for the [PixelNoiseOverlay].
class PixelNoiseOverlayConfig {
  /// Creates a configuration for the [PixelNoiseOverlay].
  const PixelNoiseOverlayConfig({
    this.pixelSize = 10.0,
    this.opacity = 0.1,
    this.noiseFrequency = 0.02,
    this.colorPalette = const [
      Color(0xFF00FF00),
      Color(0xFF0000FF),
      Color(0xFFFF0000),
      Color(0xFFFFFF00),
    ],
  });

  /// Size of each square drawn by the noise overlay.
  final double pixelSize;

  /// Opacity of non-noise squares.
  final double opacity;

  /// Frequency of full-opacity noise squares.
  final double noiseFrequency;

  /// Colors used by the noise squares.
  final List<Color> colorPalette;

  /// Validates values that are required by the pixel-noise painter.
  ///
  /// Throws an [ArgumentError] in both debug and release builds when a value
  /// would make the effect unsafe to render.
  void validate() {
    if (!pixelSize.isFinite || pixelSize <= 0) {
      throw ArgumentError.value(
        pixelSize,
        'pixelSize',
        'must be finite and greater than zero',
      );
    }
    if (!opacity.isFinite || opacity < 0 || opacity > 1) {
      throw ArgumentError.value(
        opacity,
        'opacity',
        'must be finite and between zero and one',
      );
    }
    if (!noiseFrequency.isFinite || noiseFrequency < 0 || noiseFrequency > 1) {
      throw ArgumentError.value(
        noiseFrequency,
        'noiseFrequency',
        'must be finite and between zero and one',
      );
    }
    if (colorPalette.isEmpty) {
      throw ArgumentError.value(
        colorPalette,
        'colorPalette',
        'must not be empty',
      );
    }
  }

  /// Returns a new configuration with selected values replaced.
  PixelNoiseOverlayConfig copyWith({
    double? pixelSize,
    double? opacity,
    double? noiseFrequency,
    List<Color>? colorPalette,
  }) {
    return PixelNoiseOverlayConfig(
      pixelSize: pixelSize ?? this.pixelSize,
      opacity: opacity ?? this.opacity,
      noiseFrequency: noiseFrequency ?? this.noiseFrequency,
      colorPalette: colorPalette ?? this.colorPalette,
    );
  }
}

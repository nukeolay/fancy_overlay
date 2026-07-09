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

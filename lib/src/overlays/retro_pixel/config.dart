import 'dart:ui';

import 'package:fancy_overlay/fancy_overlay.dart';

/// Configuration class for the [RetroPixelOverlay].
///
/// This class provides options to customize the appearance and behavior of the
/// retro pixelated overlay effect. It controls aspects like pixel size, opacity,
/// glitch frequency, and color palette.
///
/// Example usage:
/// ```dart
/// final config = RetroPixelOverlayConfig(
///   pixelSize: 10.0,
///   opacity: 0.1,
///   glitchFrequency: 0.02,
///   colorPalette: [
///     Color(0xFF00FF00),
///     Color(0xFF0000FF),
///     Color(0xFFFF0000),
///     Color(0xFFFFFF00),
///   ],
/// );
/// ```
class RetroPixelOverlayConfig {
  /// Creates a configuration for the [RetroPixelOverlay].
  ///
  /// The default configuration uses:
  /// - `pixelSize`: 10.0
  /// - `opacity`: 0.1
  /// - `glitchFrequency`: 0.02
  /// - `colorPalette`: Green, Blue, Red, and Yellow.
  const RetroPixelOverlayConfig({
    this.pixelSize = 10.0,
    this.opacity = 0.1,
    this.glitchFrequency = 0.02,
    this.colorPalette = const [
      Color(0xFF00FF00),
      Color(0xFF0000FF),
      Color(0xFFFF0000),
      Color(0xFFFFFF00),
    ],
  });

  /// Size of the pixels in the overlay.
  /// Defaults to `10.0`.
  final double pixelSize;

  /// Opacity of the overlay (`0` = fully transparent, `1` = fully opaque).
  /// Defaults to `0.1`, which provides a subtle overlay effect.
  final double opacity;

  /// Frequency of glitches (`0` = no glitches, `1` = constant glitches).
  /// Defaults to `0.02`, introducing occasional glitch artifacts.
  final double glitchFrequency;

  /// Defines the colors of the pixels in the overlay. Defaults to a palette
  /// consisting of Green, Blue, Red, and Yellow.
  final List<Color> colorPalette;

  /// Returns a new configuration with updated values.
  ///
  /// This method allows you to copy an existing configuration and override specific
  /// values while keeping the others unchanged.
  RetroPixelOverlayConfig copyWith({
    double? pixelSize,
    double? opacity,
    double? glitchFrequency,
    List<Color>? colorPalette,
  }) {
    return RetroPixelOverlayConfig(
      pixelSize: pixelSize ?? this.pixelSize,
      opacity: opacity ?? this.opacity,
      glitchFrequency: glitchFrequency ?? this.glitchFrequency,
      colorPalette: colorPalette ?? this.colorPalette,
    );
  }
}

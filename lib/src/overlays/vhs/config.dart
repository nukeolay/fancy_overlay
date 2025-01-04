import 'dart:ui';

import 'package:fancy_overlay/fancy_overlay.dart';

/// Configuration class for the [VhsOverlay].
///
/// This class provides options to customize the appearance and behavior of the
/// VHS overlay effect, including scanline color, dot size, number of dots, and
/// optional animation for scanlines.
///
/// Example usage:
/// ```dart
/// final config = VhsOverlayConfig(
///   scanlineColor: FancyColor(Colors.grey),
///   dotColor: FancyRandomColor(),
///   dotSize: 2,
///   dotsNumber: 300,
///   animateScanlines: false,
/// );
/// ```
class VhsOverlayConfig {
  /// Creates a configuration for the [VhsOverlay].
  ///
  /// The default configuration uses:
  /// - `scanlineColor`: Semi-transparent gray.
  /// - `dotColor`: Random colors.
  /// - `dotSize`: 2.
  /// - `dotsNumber`: 300.
  /// - `animateScanlines`: `false`.
  const VhsOverlayConfig({
    this.scanlineColor = const FancyColor(
      Color.fromRGBO(150, 150, 150, 0.2),
    ),
    this.dotColor = const FancyRandomColor(),
    this.dotSize = 2,
    this.dotsNumber = 300,
    this.animateScanlines = false,
  });

  /// The color of the horizontal scanlines.
  ///
  /// Defaults to a semi-transparent gray (`Color.fromRGBO(150, 150, 150, 0.2)`).
  final FancyColor scanlineColor;

  /// The color of the random dots simulating noise.
  ///
  /// Defaults to [FancyRandomColor], which generates random colors for the dots.
  final FancyColor dotColor;

  /// The size of the dots in the overlay.
  ///
  /// Larger values create bigger dots, while smaller values result in finer noise.
  /// Defaults to `2.0`.
  final double dotSize;

  /// The number of dots rendered in the overlay.
  ///
  /// Higher values increase the density of the noise, while lower values make
  /// the overlay appear less cluttered. Defaults to `300`.
  final int dotsNumber;

  /// Whether the scanlines should animate.
  ///
  /// If set to `true`, the scanlines will move to simulate the VHS playback effect.
  /// Defaults to `false`.
  final bool animateScanlines;

  /// Returns a new configuration with updated values.
  ///
  /// This method allows you to copy an existing configuration and override specific
  /// values while keeping the others unchanged.
  VhsOverlayConfig copyWith({
    FancyColor? scanlineColor,
    FancyColor? dotColor,
    double? dotSize,
    int? dotsNumber,
    bool? animateScanlines,
  }) {
    return VhsOverlayConfig(
      scanlineColor: scanlineColor ?? this.scanlineColor,
      dotColor: dotColor ?? this.dotColor,
      dotSize: dotSize ?? this.dotSize,
      dotsNumber: dotsNumber ?? this.dotsNumber,
      animateScanlines: animateScanlines ?? this.animateScanlines,
    );
  }
}

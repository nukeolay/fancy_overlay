import 'package:fancy_overlay/fancy_overlay.dart';

/// Configuration class for the [PixelizeOverlay].
class PixelizeOverlayConfig {
  /// Creates a configuration for backdrop pixelation.
  const PixelizeOverlayConfig({
    this.pixelSize = 5.0,
  });

  /// Size of each pixelated backdrop block.
  final double pixelSize;

  /// Returns a new configuration with selected values replaced.
  PixelizeOverlayConfig copyWith({
    double? pixelSize,
  }) {
    return PixelizeOverlayConfig(
      pixelSize: pixelSize ?? this.pixelSize,
    );
  }
}

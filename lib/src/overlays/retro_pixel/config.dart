import 'dart:ui';

class RetroPixelOverlayConfig {
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
  final double pixelSize;

  /// Opacity of the overlay (0 = fully transparent, 1 = fully opaque).
  final double opacity;

  /// Frequency of glitches (0 = no glitches, 1 = constant glitches).
  final double glitchFrequency;

  /// Retro-style color palette.
  final List<Color> colorPalette;

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

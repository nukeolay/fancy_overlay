/// Configuration for a liquid distortion effect.
class LiquidDistortionOverlayConfig {
  /// Creates the balanced liquid distortion configuration used by default.
  const LiquidDistortionOverlayConfig({
    this.distortionStrength = 0.35,
    this.waveScale = 160.0,
    this.speed = 0.18,
    this.direction = 0.0,
    this.chromaticAberration = 0.8,
  });

  /// Creates a subtle liquid distortion configuration.
  const LiquidDistortionOverlayConfig.mild()
      : this(
          distortionStrength: 0.12,
          waveScale: 220.0,
          speed: 0.10,
          direction: -0.35,
          chromaticAberration: 0.2,
        );

  /// Creates the balanced liquid distortion configuration.
  const LiquidDistortionOverlayConfig.balanced() : this();

  /// Creates a pronounced liquid distortion configuration.
  const LiquidDistortionOverlayConfig.heavy()
      : this(
          distortionStrength: 0.65,
          waveScale: 110.0,
          speed: 0.30,
          direction: 0.35,
          chromaticAberration: 2.0,
        );

  /// Intensity of the coordinate displacement.
  final double distortionStrength;

  /// Scale of the generated distortion waves.
  final double waveScale;

  /// Rate at which the distortion animation advances.
  final double speed;

  /// Direction applied to the distortion flow.
  final double direction;

  /// Separation applied to color channels.
  final double chromaticAberration;

  /// Throws [ArgumentError] when a value is unsafe for the effect.
  void validate() {
    _validateUnitInterval(distortionStrength, 'distortionStrength');
    _validatePositive(waveScale, 'waveScale');
    _validateUnitInterval(speed, 'speed');
    _validateFinite(direction, 'direction');
    _validateNonNegative(chromaticAberration, 'chromaticAberration');
  }

  /// Returns a copy with selected controls replaced.
  LiquidDistortionOverlayConfig copyWith({
    double? distortionStrength,
    double? waveScale,
    double? speed,
    double? direction,
    double? chromaticAberration,
  }) {
    return LiquidDistortionOverlayConfig(
      distortionStrength: distortionStrength ?? this.distortionStrength,
      waveScale: waveScale ?? this.waveScale,
      speed: speed ?? this.speed,
      direction: direction ?? this.direction,
      chromaticAberration: chromaticAberration ?? this.chromaticAberration,
    );
  }

  static void _validateUnitInterval(double value, String name) {
    if (!value.isFinite || value < 0 || value > 1) {
      throw ArgumentError.value(
        value,
        name,
        'must be finite and between zero and one',
      );
    }
  }

  static void _validatePositive(double value, String name) {
    if (!value.isFinite || value <= 0) {
      throw ArgumentError.value(
        value,
        name,
        'must be finite and greater than zero',
      );
    }
  }

  static void _validateFinite(double value, String name) {
    if (!value.isFinite) {
      throw ArgumentError.value(value, name, 'must be finite');
    }
  }

  static void _validateNonNegative(double value, String name) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(
        value,
        name,
        'must be finite and non-negative',
      );
    }
  }
}

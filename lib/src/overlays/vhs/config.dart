import 'package:fancy_overlay/fancy_overlay.dart';

/// Configuration for the shader-backed [VhsOverlay].
class VhsOverlayConfig {
  /// Creates the Heavy VHS-on-CRT configuration used by default.
  const VhsOverlayConfig({
    this.scanlineIntensity = 0.55,
    this.noiseIntensity = 0.35,
    this.chromaAberration = 2.5,
    this.trackingIntensity = 0.45,
    this.distortionIntensity = 0.25,
    this.curvature = 0.08,
    this.vignetteIntensity = 0.55,
    this.flickerIntensity = 0.08,
  });

  /// Creates a subtle treatment suitable for content-heavy screens.
  const VhsOverlayConfig.mild()
      : this(
          scanlineIntensity: 0.18,
          noiseIntensity: 0.06,
          chromaAberration: 0.8,
          trackingIntensity: 0.12,
          distortionIntensity: 0.08,
          curvature: 0.025,
          vignetteIntensity: 0.22,
          flickerIntensity: 0.02,
        );

  /// Creates a visible effect that keeps ordinary UI readable.
  const VhsOverlayConfig.balanced()
      : this(
          scanlineIntensity: 0.35,
          noiseIntensity: 0.18,
          chromaAberration: 1.5,
          trackingIntensity: 0.28,
          distortionIntensity: 0.16,
          curvature: 0.05,
          vignetteIntensity: 0.38,
          flickerIntensity: 0.05,
        );

  /// Creates the same Heavy treatment as the unnamed constructor.
  const VhsOverlayConfig.heavy() : this();

  /// Strength of the dark horizontal scanline modulation.
  final double scanlineIntensity;

  /// Strength of the time-varying tape noise.
  final double noiseIntensity;

  /// RGB channel displacement in logical pixels.
  final double chromaAberration;

  /// Strength of the localized moving tracking band.
  final double trackingIntensity;

  /// Strength of the global horizontal signal distortion.
  final double distortionIntensity;

  /// Strength of the CRT coordinate curvature.
  final double curvature;

  /// Strength of the dark CRT edge vignette.
  final double vignetteIntensity;

  /// Strength of the animated brightness variation.
  final double flickerIntensity;

  /// Throws [ArgumentError] when a shader uniform is unsafe.
  void validate() {
    _validateUnitInterval(scanlineIntensity, 'scanlineIntensity');
    _validateUnitInterval(noiseIntensity, 'noiseIntensity');
    _validateNonNegative(chromaAberration, 'chromaAberration');
    _validateUnitInterval(trackingIntensity, 'trackingIntensity');
    _validateUnitInterval(distortionIntensity, 'distortionIntensity');
    _validateUnitInterval(curvature, 'curvature');
    _validateUnitInterval(vignetteIntensity, 'vignetteIntensity');
    _validateUnitInterval(flickerIntensity, 'flickerIntensity');
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

  static void _validateNonNegative(double value, String name) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(
        value,
        name,
        'must be finite and non-negative',
      );
    }
  }

  /// Returns a copy with selected signal controls replaced.
  VhsOverlayConfig copyWith({
    double? scanlineIntensity,
    double? noiseIntensity,
    double? chromaAberration,
    double? trackingIntensity,
    double? distortionIntensity,
    double? curvature,
    double? vignetteIntensity,
    double? flickerIntensity,
  }) {
    return VhsOverlayConfig(
      scanlineIntensity: scanlineIntensity ?? this.scanlineIntensity,
      noiseIntensity: noiseIntensity ?? this.noiseIntensity,
      chromaAberration: chromaAberration ?? this.chromaAberration,
      trackingIntensity: trackingIntensity ?? this.trackingIntensity,
      distortionIntensity: distortionIntensity ?? this.distortionIntensity,
      curvature: curvature ?? this.curvature,
      vignetteIntensity: vignetteIntensity ?? this.vignetteIntensity,
      flickerIntensity: flickerIntensity ?? this.flickerIntensity,
    );
  }
}

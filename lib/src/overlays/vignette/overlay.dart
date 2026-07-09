import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

/// A widget that adds a dark vignette and optional sepia tint over the screen.
///
/// The [VignetteOverlay] draws a blurred inset shadow around the screen edges
/// and applies a sepia color filter to the content behind it. It can be used to
/// give the application a warmer, cinematic, or aged-photo look.
///
/// Example usage:
/// ```dart
/// VignetteOverlay(
///   config: VignetteOverlayConfig(
///     intensity: 0.8,
///     sepiaStrength: 0.1,
///     radius: 2,
///     edgeFalloff: 2,
///   ),
/// );
/// ```
///
/// See [VignetteOverlayConfig] for a detailed explanation of configuration
/// options.
class VignetteOverlay extends StatelessWidget {
  /// Creates a [VignetteOverlay] with the provided configuration.
  const VignetteOverlay({
    this.config = const VignetteOverlayConfig(),
    super.key,
  });

  /// The configuration that determines the appearance of the vignette effect.
  final VignetteOverlayConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          const Color(0xFF704214).withValues(alpha: config.sepiaStrength),
          BlendMode.color,
        ),
        child: CustomPaint(
          painter: _VignettePainter(config: config),
        ),
      ),
    );
  }
}

class _VignettePainter extends CustomPainter {
  const _VignettePainter({
    required this.config,
  });

  final VignetteOverlayConfig config;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final edgeFalloff = config.edgeFalloffFor(size);
    if (edgeFalloff <= 0) return;

    final innerInset = edgeFalloff.clamp(0, size.shortestSide / 2).toDouble();
    final innerRect = rect.deflate(innerInset);
    final cornerRadius = config.cornerRadiusFor(size);
    if (innerRect.isEmpty) {
      final paint = Paint()
        ..color = Colors.black.withValues(alpha: config.intensity);
      canvas.drawRect(rect, paint);
      return;
    }

    final shadowPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(edgeFalloff))
      ..addRRect(
        RRect.fromRectAndRadius(
          innerRect,
          Radius.circular(cornerRadius),
        ),
      );
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: config.intensity)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        edgeFalloff / 2,
      );

    canvas
      ..save()
      ..clipRect(rect)
      ..drawPath(shadowPath, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _VignettePainter oldDelegate) {
    return oldDelegate.config.intensity != config.intensity ||
        oldDelegate.config.radius != config.radius ||
        oldDelegate.config.edgeFalloff != config.edgeFalloff;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_VignettePainter('
        'mode: blurred inset shadow, '
        'intensity: ${config.intensity}, '
        'radius: ${config.radius}, '
        'edgeFalloff: ${config.edgeFalloff}'
        ')';
  }
}

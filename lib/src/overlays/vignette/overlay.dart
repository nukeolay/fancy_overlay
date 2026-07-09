import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class VignetteOverlay extends StatelessWidget {
  const VignetteOverlay({
    this.config = const VignetteOverlayConfig(),
    super.key,
  });

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

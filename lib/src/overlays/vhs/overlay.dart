import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class VhsOverlay extends StatefulWidget {
  const VhsOverlay({
    this.config = const VhsOverlayConfig(),
    super.key,
  });

  final VhsOverlayConfig config;

  @override
  State<VhsOverlay> createState() => _VhsOverlayState();
}

class _VhsOverlayState extends State<VhsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _noiseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();
    _noiseAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return AnimatedBuilder(
      animation: _noiseAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _VhsPainter(
            animationValue: _noiseAnimation.value,
            config: widget.config,
          ),
        );
      },
    );
  }
}

class _VhsPainter extends CustomPainter {
  const _VhsPainter({
    required this.animationValue,
    required this.config,
  });

  final double animationValue;
  final VhsOverlayConfig config;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Add scanlines
    for (double y = 0; y < size.height; y += 4) {
      paint.color = config.color.scanline.color;
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }

    // Add random noise with random colors
    final random = Random();
    for (int i = 0; i <= config.dotsNumber; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      paint.color = config.color.dot.color;
      canvas.drawRect(
        Rect.fromPoints(
          Offset(x, y),
          Offset(x + config.dotSize, y + config.dotSize),
        ),
        paint,
      );
    }
    if (config.animateScanlines) {
      final scanlinesPaint = Paint()..color = config.color.scanline.color;
      for (double y = 0; y < size.height; y += config.dotSize * 4) {
        canvas.drawRect(
          Rect.fromLTWH(
            0,
            y + sin(animationValue * pi * 2 + y * 0.1) * 2,
            size.width,
            1,
          ),
          scanlinesPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VhsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.config.dotSize != config.dotSize ||
        oldDelegate.config.dotsNumber != config.dotsNumber ||
        oldDelegate.config.animateScanlines != config.animateScanlines ||
        oldDelegate.config.color != config.color;
  }
}

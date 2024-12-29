import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class VhsColor {
  const VhsColor({
    required this.scanline,
    required this.dot,
    required this.filter,
  });

  const VhsColor.standard()
      : scanline = const FancyColor(Color.fromRGBO(0, 0, 0, 0.2)),
        dot = const FancyRandomColor(),
        filter = null;

  const VhsColor.random()
      : scanline = const FancyRandomColor(),
        dot = const FancyRandomColor(),
        filter = const FancyRandomColor();

  final FancyColor scanline;
  final FancyColor dot;
  final FancyColor? filter;
}

class VhsOverlayConfig {
  const VhsOverlayConfig({
    required this.color,
    this.dotRadius = 1,
    this.duration = const Duration(milliseconds: 500),
  });

  const VhsOverlayConfig.standard()
      : color = const VhsColor.standard(),
        dotRadius = 1,
        duration = const Duration(milliseconds: 500);

  final VhsColor color;
  final Duration duration;
  final double dotRadius;
}

class VhsOverlay extends StatefulWidget {
  const VhsOverlay({
    required this.config,
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
      duration: widget.config.duration,
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
    return AnimatedBuilder(
      animation: _noiseAnimation,
      builder: (context, child) {
        return Container(
          color: widget.config.color.filter?.color,
          child: CustomPaint(
            painter: _VhsPainter(
              noiseValue: _noiseAnimation.value,
              dotRadius: widget.config.dotRadius,
              color: widget.config.color,
            ),
          ),
        );
      },
    );
  }
}

class _VhsPainter extends CustomPainter {
  const _VhsPainter({
    required this.noiseValue,
    required this.dotRadius,
    required this.color,
  });

  final double noiseValue;
  final double dotRadius;
  final VhsColor color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Add scanlines
    for (double y = 0; y < size.height; y += 4) {
      paint.color = color.scanline.color;
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }

    // Add random noise with random colors
    final random = Random();
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      paint.color = color.dot.color;
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VhsPainter oldDelegate) {
    return oldDelegate.noiseValue != noiseValue ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.color != color;
  }
}

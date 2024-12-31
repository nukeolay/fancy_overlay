import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class RetroPixelOverlay extends StatefulWidget {
  const RetroPixelOverlay({
    this.config = const RetroPixelOverlayConfig(),
    super.key,
  });

  final RetroPixelOverlayConfig config;

  @override
  State<RetroPixelOverlay> createState() => _RetroPixelOverlayState();
}

class _RetroPixelOverlayState extends State<RetroPixelOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _RetroPixelationPainter(
            config: widget.config,
            animationValue: _animation.value,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class _RetroPixelationPainter extends CustomPainter {
  final RetroPixelOverlayConfig config;
  final double animationValue;

  _RetroPixelationPainter({
    required this.config,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final pixelPaint = Paint();

    // Draw translucent pixelation
    for (double x = 0; x < size.width; x += config.pixelSize) {
      for (double y = 0; y < size.height; y += config.pixelSize) {
        // Choose a base color from the palette
        final baseColor =
            config.colorPalette[random.nextInt(config.colorPalette.length)];

        // Apply glitch or subtle distortion
        final isGlitch =
            random.nextDouble() < config.glitchFrequency * animationValue;
        final color = isGlitch
            ? config.colorPalette[random.nextInt(config.colorPalette.length)]
            : baseColor.withOpacity(config.opacity);

        // Set pixel color with adjusted opacity
        pixelPaint.color = color;

        // Draw the pixel block
        canvas.drawRect(
          Rect.fromLTWH(x, y, config.pixelSize, config.pixelSize),
          pixelPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RetroPixelationPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.config != config;
  }
}

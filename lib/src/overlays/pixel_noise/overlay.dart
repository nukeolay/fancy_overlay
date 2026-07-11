import 'dart:math';

import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

/// A widget that renders animated pixel square noise.
class PixelNoiseOverlay extends StatefulWidget {
  /// Creates a [PixelNoiseOverlay] with the provided configuration.
  const PixelNoiseOverlay({
    this.config = const PixelNoiseOverlayConfig(),
    super.key,
  });

  /// The configuration that determines the overlay appearance.
  final PixelNoiseOverlayConfig config;

  @override
  State<PixelNoiseOverlay> createState() => _PixelNoiseOverlayState();
}

class _PixelNoiseOverlayState extends State<PixelNoiseOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.config.validate();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _PixelNoisePainter(
            config: widget.config,
            animationValue: _controller.value,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class _PixelNoisePainter extends CustomPainter {
  const _PixelNoisePainter({
    required this.config,
    required this.animationValue,
  });

  final PixelNoiseOverlayConfig config;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final pixelPaint = Paint();

    for (double x = 0; x < size.width; x += config.pixelSize) {
      for (double y = 0; y < size.height; y += config.pixelSize) {
        final baseColor =
            config.colorPalette[random.nextInt(config.colorPalette.length)];
        final isNoise =
            random.nextDouble() < config.noiseFrequency * animationValue;
        pixelPaint.color = isNoise
            ? config.colorPalette[random.nextInt(config.colorPalette.length)]
            : baseColor.withValues(alpha: config.opacity);

        canvas.drawRect(
          Rect.fromLTWH(x, y, config.pixelSize, config.pixelSize),
          pixelPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelNoisePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.config != config;
  }
}

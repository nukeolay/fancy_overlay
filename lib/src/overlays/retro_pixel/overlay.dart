import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

/// A widget that renders a retro-style pixelated overlay effect.
///
/// The [RetroPixelOverlay] simulates a vintage pixelated screen with optional
/// glitch effects, configurable pixel size, opacity, and color palette. It can be
/// used to add a retro or nostalgic aesthetic to your application.
///
/// Example usage:
/// ```dart
/// RetroPixelOverlay(
///   config: RetroPixelOverlayConfig(
///     pixelSize: 10.0,
///     opacity: 0.1,
///     glitchFrequency: 0.02,
///       colorPalette: [
///         Color(0xFF00FF00),
///         Color(0xFF0000FF),
///         Color(0xFFFF0000),
///         Color(0xFFFFFF00),
///       ],
///     ),
/// );
/// ```
///
/// See [RetroPixelOverlayConfig] for a detailed explanation of configuration options.
class RetroPixelOverlay extends StatefulWidget {
  /// Creates a [RetroPixelOverlay] with the provided configuration.
  ///
  /// The [config] parameter is required and specifies the behavior and appearance
  /// of the overlay.
  const RetroPixelOverlay({
    this.config = const RetroPixelOverlayConfig(),
    super.key,
  });

  /// The configuration that determines the behavior and appearance of the
  /// overlay.
  final RetroPixelOverlayConfig config;

  @override
  State<RetroPixelOverlay> createState() => _RetroPixelOverlayState();
}

class _RetroPixelOverlayState extends State<RetroPixelOverlay>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _RetroPixelationPainter(
            config: widget.config,
            animationValue: _controller.value,
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

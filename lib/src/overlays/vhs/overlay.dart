import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

/// Applies a shader-backed Heavy VHS-on-CRT effect to the rendered backdrop.
class VhsOverlay extends StatefulWidget {
  /// Creates a VHS/CRT overlay with the Heavy preset by default.
  const VhsOverlay({
    this.config = const VhsOverlayConfig(),
    super.key,
  });

  /// Loads and caches the VHS/CRT shader before the overlay is shown.
  static Future<void> precacheShader() async {
    await _VhsShaderProgram.load();
  }

  /// Signal controls used by both the shader and portable fallback.
  final VhsOverlayConfig config;

  @override
  State<VhsOverlay> createState() => _VhsOverlayState();
}

class _VhsOverlayState extends State<VhsOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    unawaited(_loadShader());
  }

  @override
  void didUpdateWidget(covariant VhsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.config.validate();
  }

  @override
  void dispose() {
    _shader?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadShader() async {
    final program = await _VhsShaderProgram.load();
    if (!mounted || program == null) return;

    _shader?.dispose();
    _shader = program.fragmentShader();
    setState(() {});
  }

  void _updateUniforms(double time, double devicePixelRatio) {
    final shader = _shader;
    if (shader == null) return;

    final config = widget.config;
    shader
      ..setFloat(2, time)
      ..setFloat(3, config.scanlineIntensity)
      ..setFloat(4, config.noiseIntensity)
      ..setFloat(5, config.chromaAberration)
      ..setFloat(6, config.trackingIntensity)
      ..setFloat(7, config.distortionIntensity)
      ..setFloat(8, config.curvature)
      ..setFloat(9, config.vignetteIntensity)
      ..setFloat(10, config.flickerIntensity)
      ..setFloat(11, devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    widget.config.validate();
    final mediaQuery = MediaQuery.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final time = _controller.value * 10;
        final shader = _shader;
        if (!ui.ImageFilter.isShaderFilterSupported || shader == null) {
          return CustomPaint(
            painter: _VhsFallbackPainter(
              config: widget.config,
              time: time,
            ),
            size: mediaQuery.size,
          );
        }

        _updateUniforms(time, mediaQuery.devicePixelRatio);
        return BackdropFilter(
          filter: ui.ImageFilter.shader(shader),
          child: CustomPaint(
            painter: const _VhsCoveragePainter(),
            size: mediaQuery.size,
          ),
        );
      },
    );
  }
}

class _VhsShaderProgram {
  static ui.FragmentProgram? _program;
  static Future<ui.FragmentProgram?>? _loading;

  static Future<ui.FragmentProgram?> load() {
    if (!ui.ImageFilter.isShaderFilterSupported) {
      return Future.value();
    }
    final program = _program;
    if (program != null) return Future.value(program);

    _loading ??= ui.FragmentProgram.fromAsset(
      'packages/fancy_overlay/shaders/vhs_crt.frag',
    ).then((program) {
      _program = program;
      return program;
    }).whenComplete(() {
      _loading = null;
    });
    return _loading!;
  }
}

class _VhsFallbackPainter extends CustomPainter {
  const _VhsFallbackPainter({
    required this.config,
    required this.time,
  });

  final VhsOverlayConfig config;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final scanlinePaint = Paint()
      ..color = Colors.black.withValues(
        alpha: config.scanlineIntensity * 0.42,
      );
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), scanlinePaint);
    }

    final frame = (time * 30).floor();
    final random = Random(frame);
    final noiseCount = min(
      1200,
      (size.width * size.height / 1800 * config.noiseIntensity).round(),
    );
    final noisePaint = Paint();
    for (var index = 0; index < noiseCount; index++) {
      noisePaint.color = Colors.white.withValues(
        alpha: random.nextDouble() * config.noiseIntensity * 0.35,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          1 + random.nextDouble() * 2,
          1 + random.nextDouble() * 2,
        ),
        noisePaint,
      );
    }

    final trackingY = (time * 0.11 % 1) * size.height;
    final trackingPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: config.trackingIntensity * 0.18,
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawRect(
      Rect.fromLTWH(0, trackingY - 12, size.width, 24),
      trackingPaint,
    );

    final flicker =
        (sin(time * 47) * 0.5 + 0.5) * config.flickerIntensity * 0.1;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black.withValues(alpha: flicker),
    );

    final rect = Offset.zero & size;
    final edgeFalloff = size.shortestSide * 0.24;
    final innerRect = rect.deflate(edgeFalloff * 0.6);
    if (config.vignetteIntensity > 0 && !innerRect.isEmpty) {
      final vignettePath = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rect.inflate(edgeFalloff))
        ..addRRect(
          RRect.fromRectAndRadius(
            innerRect,
            Radius.circular(size.shortestSide * 0.12),
          ),
        );
      final vignette = Paint()
        ..color = Colors.black.withValues(
          alpha: config.vignetteIntensity * 0.82,
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, edgeFalloff / 2);
      canvas
        ..save()
        ..clipRect(rect)
        ..drawPath(vignettePath, vignette)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant _VhsFallbackPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.config != config;
  }
}

class _VhsCoveragePainter extends CustomPainter {
  const _VhsCoveragePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color.fromARGB(1, 0, 0, 0),
    );
  }

  @override
  bool shouldRepaint(covariant _VhsCoveragePainter oldDelegate) => false;
}

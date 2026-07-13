import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

/// Applies an animated liquid treatment to the rendered backdrop.
class LiquidDistortionOverlay extends StatefulWidget {
  /// Creates a liquid distortion overlay with the balanced configuration.
  const LiquidDistortionOverlay({
    this.config = const LiquidDistortionOverlayConfig(),
    super.key,
  });

  /// Loads and caches the liquid distortion shader before it is needed.
  static Future<void> precacheShader() async {
    await _LiquidDistortionShaderProgram.load();
  }

  /// Controls the distortion animation and appearance.
  final LiquidDistortionOverlayConfig config;

  @override
  State<LiquidDistortionOverlay> createState() =>
      _LiquidDistortionOverlayState();
}

class _LiquidDistortionOverlayState extends State<LiquidDistortionOverlay>
    with SingleTickerProviderStateMixin {
  static const _baseCycle = Duration(seconds: 6);

  /// Caps active cycles so every validated positive speed has a finite period.
  static const _maximumCycle = Duration(days: 365);

  late final AnimationController _controller;
  ui.FragmentShader? _shader;
  bool? _animationsDisabled;

  @override
  void initState() {
    super.initState();
    widget.config.validate();
    _controller = AnimationController(
      vsync: this,
      duration: _durationFor(widget.config.speed),
      animationBehavior: AnimationBehavior.preserve,
    );
    unawaited(_loadShaderForOverlay());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animationsDisabled = MediaQuery.of(context).disableAnimations;
    if (_animationsDisabled == animationsDisabled) return;

    _animationsDisabled = animationsDisabled;
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant LiquidDistortionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.config.validate();
    if (oldWidget.config.speed != widget.config.speed) {
      _syncAnimation(updateDuration: true);
    }
  }

  @override
  void dispose() {
    _shader?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadShader() async {
    final program = await _LiquidDistortionShaderProgram.load();
    if (!mounted || program == null) return;

    _shader?.dispose();
    _shader = program.fragmentShader();
    setState(() {});
  }

  Future<void> _loadShaderForOverlay() async {
    try {
      await _loadShader();
    } catch (exception, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stackTrace,
          library: 'fancy_overlay',
          context: ErrorDescription(
            'while loading the LiquidDistortionOverlay shader',
          ),
        ),
      );
    }
  }

  void _syncAnimation({bool updateDuration = false}) {
    final phase = _controller.value;
    _controller.stop(canceled: false);

    final speed = widget.config.speed;
    if (updateDuration && speed > 0) {
      _controller.duration = _durationFor(speed);
    }
    _controller.value = phase;

    if (speed > 0 && _animationsDisabled == false) {
      _controller.repeat();
    }
  }

  static Duration _durationFor(double speed) {
    if (speed == 0) return _baseCycle;

    final cycleMicroseconds = _baseCycle.inMicroseconds / speed;
    if (!cycleMicroseconds.isFinite ||
        cycleMicroseconds >= _maximumCycle.inMicroseconds) {
      return _maximumCycle;
    }
    return Duration(
      microseconds: cycleMicroseconds.round(),
    );
  }

  void _updateShaderUniforms({
    required double phase,
    required double devicePixelRatio,
  }) {
    final shader = _shader;
    if (shader == null) return;

    final config = widget.config;
    shader
      ..setFloat(2, phase)
      ..setFloat(3, config.distortionStrength)
      ..setFloat(4, config.waveScale)
      ..setFloat(5, config.direction)
      ..setFloat(6, config.chromaticAberration)
      ..setFloat(7, devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    widget.config.validate();
    final mediaQuery = MediaQuery.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final phase = _controller.value * 2 * pi;
        final shader = _shader;
        if (!ui.ImageFilter.isShaderFilterSupported || shader == null) {
          return CustomPaint(
            key: const ValueKey('liquid-distortion-fallback'),
            painter: _LiquidDistortionFallbackPainter(
              intensity: widget.config.distortionStrength,
              phase: phase,
            ),
            size: mediaQuery.size,
          );
        }

        _updateShaderUniforms(
          phase: phase,
          devicePixelRatio: mediaQuery.devicePixelRatio,
        );
        return BackdropFilter(
          filter: ui.ImageFilter.shader(shader),
          child: CustomPaint(
            key: const ValueKey('liquid-distortion-shader'),
            painter: const _LiquidDistortionCoveragePainter(),
            size: mediaQuery.size,
          ),
        );
      },
    );
  }
}

class _LiquidDistortionShaderProgram {
  static ui.FragmentProgram? _program;
  static Future<ui.FragmentProgram?>? _loading;

  static Future<ui.FragmentProgram?> load() {
    if (!ui.ImageFilter.isShaderFilterSupported) {
      return Future.value(null);
    }

    final program = _program;
    if (program != null) return Future.value(program);

    _loading ??= ui.FragmentProgram.fromAsset(
      'packages/fancy_overlay/shaders/liquid_distortion.frag',
    ).then((program) {
      _program = program;
      return program;
    }).whenComplete(() {
      _loading = null;
    });
    return _loading!;
  }
}

class _LiquidDistortionFallbackPainter extends CustomPainter {
  const _LiquidDistortionFallbackPainter({
    required this.intensity,
    required this.phase,
  });

  final double intensity;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = const Color(0xFF4FC3C8).withValues(
          alpha: intensity * 0.045,
        ),
    );

    _drawCaustic(
      canvas,
      size,
      verticalCenter: 0.20,
      phaseOffset: 0,
      bend: 0.10,
    );
    _drawCaustic(
      canvas,
      size,
      verticalCenter: 0.51,
      phaseOffset: 2 * pi / 3,
      bend: -0.08,
    );
    _drawCaustic(
      canvas,
      size,
      verticalCenter: 0.80,
      phaseOffset: 4 * pi / 3,
      bend: 0.07,
    );
  }

  void _drawCaustic(
    Canvas canvas,
    Size size, {
    required double verticalCenter,
    required double phaseOffset,
    required double bend,
  }) {
    final wave = sin(phase + phaseOffset);
    final crossWave = sin(phase * 2 + phaseOffset);
    final path = Path()
      ..moveTo(-size.width * 0.15, size.height * (verticalCenter + wave * 0.04))
      ..cubicTo(
        size.width * 0.18,
        size.height * (verticalCenter + bend + crossWave * 0.025),
        size.width * 0.48,
        size.height * (verticalCenter - bend - wave * 0.035),
        size.width * 0.72,
        size.height * (verticalCenter + bend * 0.5),
      )
      ..cubicTo(
        size.width * 0.90,
        size.height * (verticalCenter - bend + crossWave * 0.02),
        size.width * 1.04,
        size.height * (verticalCenter + bend),
        size.width * 1.18,
        size.height * (verticalCenter - wave * 0.03),
      );
    final alpha = intensity * 0.14;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.10
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height * 0.12),
        <Color>[
          Colors.white.withValues(alpha: alpha * 0.15),
          const Color(0xFFB7F5F2).withValues(alpha: alpha),
          const Color(0xFF80DEEA).withValues(alpha: alpha * 0.65),
          Colors.white.withValues(alpha: alpha * 0.10),
        ],
        const <double>[0, 0.32, 0.72, 1],
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidDistortionFallbackPainter oldDelegate) {
    return oldDelegate.intensity != intensity || oldDelegate.phase != phase;
  }
}

class _LiquidDistortionCoveragePainter extends CustomPainter {
  const _LiquidDistortionCoveragePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color.fromARGB(1, 0, 0, 0),
    );
  }

  @override
  bool shouldRepaint(covariant _LiquidDistortionCoveragePainter oldDelegate) {
    return false;
  }
}

import 'dart:ui' as ui;

import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

/// A widget that pixelates already rendered content behind it.
class PixelizeOverlay extends StatefulWidget {
  /// Creates a [PixelizeOverlay] with the provided configuration.
  const PixelizeOverlay({
    this.config = const PixelizeOverlayConfig(),
    super.key,
  });

  /// Loads and caches the pixelation shader before the overlay is shown.
  static Future<void> precacheShader() async {
    await _PixelizeShaderProgram.load();
  }

  /// The configuration that determines the pixelation strength.
  final PixelizeOverlayConfig config;

  @override
  State<PixelizeOverlay> createState() => _PixelizeOverlayState();
}

class _PixelizeOverlayState extends State<PixelizeOverlay> {
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  @override
  void didUpdateWidget(covariant PixelizeOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.pixelSize != widget.config.pixelSize) {
      _updateShaderUniforms();
    }
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  Future<void> _loadShader() async {
    final program = await _PixelizeShaderProgram.load();
    if (!mounted) {
      return;
    }
    if (program == null) {
      return;
    }

    _shader?.dispose();
    _shader = program.fragmentShader();
    _updateShaderUniforms();
    setState(() {});
  }

  void _updateShaderUniforms() {
    final shader = _shader;
    if (shader == null) {
      return;
    }

    shader.setFloat(2, widget.config.pixelSize.clamp(1.0, double.infinity));
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (!ui.ImageFilter.isShaderFilterSupported || shader == null) {
      return const SizedBox.expand();
    }

    return BackdropFilter(
      filter: ui.ImageFilter.shader(shader),
      child: CustomPaint(
        painter: _PixelizeCoveragePainter(),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

class _PixelizeShaderProgram {
  static ui.FragmentProgram? _program;
  static Future<ui.FragmentProgram?>? _loading;

  static Future<ui.FragmentProgram?> load() {
    if (!ui.ImageFilter.isShaderFilterSupported) {
      return Future.value();
    }

    final program = _program;
    if (program != null) {
      return Future.value(program);
    }

    _loading ??= ui.FragmentProgram.fromAsset(
      'packages/fancy_overlay/shaders/pixelize.frag',
    ).then((program) {
      _program = program;
      return program;
    }).whenComplete(() {
      _loading = null;
    });
    return _loading!;
  }
}

class _PixelizeCoveragePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(1, 0, 0, 0)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _PixelizeCoveragePainter oldDelegate) {
    return false;
  }
}

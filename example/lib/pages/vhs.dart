import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:example/widgets/fancy_color_slider.dart';

class VhsPage extends StatefulWidget {
  const VhsPage({super.key});

  @override
  State<VhsPage> createState() => _VhsPageState();
}

class _VhsPageState extends State<VhsPage> {
  VhsOverlayConfig? _config;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _config = const VhsOverlayConfig();
        context.showFancyOverlay(
          const VhsOverlay(
            config: VhsOverlayConfig(),
          ),
        );
        setState(() {});
      },
    );
  }

  void _updatedConfig(VhsOverlayConfig? config) {
    if (config == null) return;
    context.showFancyOverlay(
      VhsOverlay(config: config),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VHS Overlay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeFancyOverlay<VhsOverlay>();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_config != null) ...[
              Text('Dot size (${_config!.dotSize.toStringAsFixed(2)})'),
              Slider(
                value: _config!.dotSize,
                min: 0,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(dotSize: value);
                  _updatedConfig(_config);
                },
              ),
              Text('Dots number (${_config!.dotsNumber})'),
              Slider(
                value: _config!.dotsNumber.toDouble(),
                min: 0,
                max: 1000,
                onChanged: (value) {
                  _config = _config?.copyWith(dotsNumber: value.toInt());
                  _updatedConfig(_config);
                },
              ),
              FancyColorSlider(
                label: 'Dot color',
                color: _config!.color.dot,
                onColorUpdate: (color) {
                  final updatedColor = _config!.color.copyWith(dot: color);
                  _config = _config?.copyWith(color: updatedColor);
                  _updatedConfig(_config);
                },
              ),
              FancyColorSlider(
                label: 'Scanlin color',
                color: _config!.color.scanline,
                onColorUpdate: (color) {
                  final updatedColor = _config!.color.copyWith(scanline: color);
                  _config = _config?.copyWith(color: updatedColor);
                  _updatedConfig(_config);
                },
              ),
              const Text('Animate Scanlines'),
              Switch(
                value: _config!.animateScanlines,
                onChanged: (value) {
                  _config = _config?.copyWith(animateScanlines: value);
                  _updatedConfig(_config);
                },
              )
            ],
          ],
        ),
      ),
    );
  }
}

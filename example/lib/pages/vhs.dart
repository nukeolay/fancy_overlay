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
          VhsOverlay(config: _config!),
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
        title: const Text('VhsOverlay'),
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
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            if (_config != null) ...[
              Center(
                child: Text(
                  'Dot size (${_config!.dotSize.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.dotSize,
                min: 0,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(dotSize: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Dots number (${_config!.dotsNumber})',
                ),
              ),
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
                color: _config!.dotColor,
                onColorUpdate: (color) {
                  _config = _config?.copyWith(dotColor: color);
                  _updatedConfig(_config);
                },
              ),
              FancyColorSlider(
                label: 'Scanline color',
                color: _config!.scanlineColor,
                onColorUpdate: (color) {
                  _config = _config?.copyWith(scanlineColor: color);
                  _updatedConfig(_config);
                },
              ),
              const Center(
                child: Text(
                  'Animate Scanlines',
                ),
              ),
              Switch(
                value: _config!.animateScanlines,
                onChanged: (value) {
                  _config = _config?.copyWith(animateScanlines: value);
                  _updatedConfig(_config);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

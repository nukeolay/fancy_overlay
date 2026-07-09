import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

class PixelNoisePage extends StatefulWidget {
  const PixelNoisePage({super.key});

  @override
  State<PixelNoisePage> createState() => _PixelNoisePageState();
}

class _PixelNoisePageState extends State<PixelNoisePage> {
  PixelNoiseOverlayConfig? _config;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _config = const PixelNoiseOverlayConfig();
        context.showFancyOverlay(
          PixelNoiseOverlay(config: _config!),
        );
        setState(() {});
      },
    );
  }

  void _updatedConfig(PixelNoiseOverlayConfig? config) {
    if (config == null) return;
    context.showFancyOverlay(
      PixelNoiseOverlay(config: config),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PixelNoiseOverlay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeFancyOverlay<PixelNoiseOverlay>();
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
                  'Pixel size (${_config!.pixelSize.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.pixelSize,
                min: 1,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(pixelSize: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Opacity (${_config!.opacity.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.opacity,
                min: 0,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(opacity: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Noise Frequency '
                  '(${_config!.noiseFrequency.toStringAsFixed(3)})',
                ),
              ),
              Slider(
                value: _config!.noiseFrequency,
                min: 0,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(noiseFrequency: value);
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

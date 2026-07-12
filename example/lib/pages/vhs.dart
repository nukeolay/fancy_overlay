import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

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
        _updatedConfig(const VhsOverlayConfig());
      },
    );
  }

  void _updatedConfig(VhsOverlayConfig config) {
    _config = config;
    context.showFancyOverlay(VhsOverlay(config: config));
    setState(() {});
  }

  Widget _slider({
    required String label,
    required double value,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Text('$label (${value.toStringAsFixed(2)})'),
        Slider(
          value: value,
          min: 0,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => _updatedConfig(const VhsOverlayConfig.mild()),
                child: const Text('Mild'),
              ),
              OutlinedButton(
                onPressed: () =>
                    _updatedConfig(const VhsOverlayConfig.balanced()),
                child: const Text('Balanced'),
              ),
              OutlinedButton(
                onPressed: () => _updatedConfig(const VhsOverlayConfig.heavy()),
                child: const Text('Heavy'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (config != null) ...[
            _slider(
              label: 'Scanline intensity',
              value: config.scanlineIntensity,
              max: 1,
              onChanged: (value) => _updatedConfig(
                config.copyWith(scanlineIntensity: value),
              ),
            ),
            _slider(
              label: 'Noise intensity',
              value: config.noiseIntensity,
              max: 1,
              onChanged: (value) => _updatedConfig(
                config.copyWith(noiseIntensity: value),
              ),
            ),
            _slider(
              label: 'Chroma aberration',
              value: config.chromaAberration,
              max: 8,
              onChanged: (value) => _updatedConfig(
                config.copyWith(chromaAberration: value),
              ),
            ),
            _slider(
              label: 'Tracking intensity',
              value: config.trackingIntensity,
              max: 1,
              onChanged: (value) => _updatedConfig(
                config.copyWith(trackingIntensity: value),
              ),
            ),
            _slider(
              label: 'Distortion intensity',
              value: config.distortionIntensity,
              max: 1,
              onChanged: (value) => _updatedConfig(
                config.copyWith(distortionIntensity: value),
              ),
            ),
            _slider(
              label: 'Curvature',
              value: config.curvature,
              max: 1,
              onChanged: (value) => _updatedConfig(
                config.copyWith(curvature: value),
              ),
            ),
            _slider(
              label: 'Vignette intensity',
              value: config.vignetteIntensity,
              max: 1,
              onChanged: (value) => _updatedConfig(
                config.copyWith(vignetteIntensity: value),
              ),
            ),
            _slider(
              label: 'Flicker intensity',
              value: config.flickerIntensity,
              max: 1,
              onChanged: (value) => _updatedConfig(
                config.copyWith(flickerIntensity: value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

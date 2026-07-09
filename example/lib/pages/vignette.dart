import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class VignettePage extends StatefulWidget {
  const VignettePage({super.key});

  @override
  State<VignettePage> createState() => _VignettePageState();
}

class _VignettePageState extends State<VignettePage> {
  VignetteOverlayConfig? _config;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _config = const VignetteOverlayConfig();
        context.showFancyOverlay(
          VignetteOverlay(config: _config!),
        );
        setState(() {});
      },
    );
  }

  void _updatedConfig(VignetteOverlayConfig? config) {
    if (config == null) return;
    context.showFancyOverlay(
      VignetteOverlay(config: config),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VignetteOverlay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeFancyOverlay<VignetteOverlay>();
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
                  'Intensity (${_config!.intensity.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.intensity,
                min: 0,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(intensity: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Sepia Strength '
                  '(${_config!.sepiaStrength.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.sepiaStrength,
                min: 0,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(sepiaStrength: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Radius '
                  '(${_config!.radius.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.radius,
                min: 1,
                max: 10,
                onChanged: (value) {
                  _config = _config?.copyWith(radius: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Edge Falloff '
                  '(${_config!.edgeFalloff.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.edgeFalloff,
                min: 1,
                max: 10,
                onChanged: (value) {
                  _config = _config?.copyWith(edgeFalloff: value);
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

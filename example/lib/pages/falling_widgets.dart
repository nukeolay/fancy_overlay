import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class FallingWidgetsPage extends StatefulWidget {
  const FallingWidgetsPage({super.key});

  @override
  State<FallingWidgetsPage> createState() => _FallingWidgetsPageState();
}

class _FallingWidgetsPageState extends State<FallingWidgetsPage> {
  FallingWidgetsOverlayConfig? _config;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _config = const FallingWidgetsOverlayConfig(
          children: [
            Text('❅', style: TextStyle(color: Colors.white)),
            Text('✻', style: TextStyle(color: Colors.white)),
            Text('✼', style: TextStyle(color: Colors.white)),
            Text('❆', style: TextStyle(color: Colors.white)),
          ],
        );
        context.showFancyOverlay(
          FallingWidgetsOverlay(config: _config!),
        );
        setState(() {});
      },
    );
  }

  void _updatedConfig(FallingWidgetsOverlayConfig? config) {
    if (config == null) return;
    context.showFancyOverlay(
      FallingWidgetsOverlay(config: config),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FallingWidgetsOverlay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeFancyOverlay<FallingWidgetsOverlay>();
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
                  'Number of Widgets (${_config!.numberOfWidgets})',
                ),
              ),
              Slider(
                value: _config!.numberOfWidgets.toDouble(),
                min: 1,
                max: 1000,
                onChanged: (value) {
                  _config = _config?.copyWith(numberOfWidgets: value.toInt());
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Min Speed (${_config!.minSpeed.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.minSpeed.toDouble(),
                min: 0,
                max: 20,
                onChanged: (value) {
                  _config = _config?.copyWith(minSpeed: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Max Speed (${_config!.maxSpeed.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.maxSpeed.toDouble(),
                min: 0,
                max: 20,
                onChanged: (value) {
                  _config = _config?.copyWith(maxSpeed: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Min Size (${_config!.minSize.toStringAsFixed(2)})',
                ),
              ),
              Center(
                child: Slider(
                  value: _config!.minSize.toDouble(),
                  min: 0,
                  max: 10,
                  onChanged: (value) {
                    _config = _config?.copyWith(minSize: value);
                    _updatedConfig(_config);
                  },
                ),
              ),
              Center(
                child: Text(
                  'Max Size (${_config!.maxSize.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.maxSize.toDouble(),
                min: 0,
                max: 10,
                onChanged: (value) {
                  _config = _config?.copyWith(maxSize: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Drift (${_config!.drift.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.drift.toDouble(),
                min: 0,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(drift: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Rotation Speed (${_config!.rotationSpeed.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.rotationSpeed.toDouble(),
                min: 0,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(rotationSpeed: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Horizontal Offset (${_config!.horizontalOffset.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.horizontalOffset.toDouble(),
                min: -1,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(horizontalOffset: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Opacity (${_config!.opacity.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.opacity.toDouble(),
                min: 0,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(opacity: value);
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

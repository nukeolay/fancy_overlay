import 'package:flutter/cupertino.dart';
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
            Icon(
              CupertinoIcons.snow,
              color: Colors.white,
            ),
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
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade800,
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
                  'Min Y Speed (${_config!.minYSpeed.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.minYSpeed.toDouble(),
                min: 0,
                max: 20,
                onChanged: (value) {
                  _config = _config?.copyWith(minYSpeed: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Max Y Speed (${_config!.maxYSpeed.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.maxYSpeed.toDouble(),
                min: 0,
                max: 20,
                onChanged: (value) {
                  _config = _config?.copyWith(maxYSpeed: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Min X Speed (${_config!.minXSpeed.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.minXSpeed.toDouble(),
                min: -10,
                max: 10,
                onChanged: (value) {
                  _config = _config?.copyWith(minXSpeed: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Max X Speed (${_config!.maxXSpeed.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.maxXSpeed.toDouble(),
                min: -10,
                max: 10,
                onChanged: (value) {
                  _config = _config?.copyWith(maxXSpeed: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Min Scale (${_config!.minScale.toStringAsFixed(2)})',
                ),
              ),
              Center(
                child: Slider(
                  value: _config!.minScale.toDouble(),
                  min: 0,
                  max: 10,
                  onChanged: (value) {
                    _config = _config?.copyWith(minScale: value);
                    _updatedConfig(_config);
                  },
                ),
              ),
              Center(
                child: Text(
                  'Max Scale (${_config!.maxScale.toStringAsFixed(2)})',
                ),
              ),
              Slider(
                value: _config!.maxScale.toDouble(),
                min: 0,
                max: 10,
                onChanged: (value) {
                  _config = _config?.copyWith(maxScale: value);
                  _updatedConfig(_config);
                },
              ),
              Center(
                child: Text(
                  'Rotation Speed '
                  '(${_config!.rotationSpeed.toStringAsFixed(2)})',
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
                  'Horizontal Offset '
                  '(${_config!.horizontalOffset.toStringAsFixed(2)})',
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
              Center(
                child: Text(
                  'Widget Appear Duration '
                  '(${_config!.appearDuration.inMilliseconds} ms)',
                ),
              ),
              Slider(
                value: _config!.appearDuration.inMilliseconds.toDouble(),
                min: 0,
                max: 5000,
                onChanged: (value) {
                  _config = _config?.copyWith(
                    appearDuration: Duration(milliseconds: value.toInt()),
                  );
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

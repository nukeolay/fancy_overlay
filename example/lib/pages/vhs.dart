import 'package:example/widgets/fancy_color_slider.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

class VhsPage extends StatefulWidget {
  const VhsPage({required this.controller, super.key});
  final FancyOverlayController controller;

  @override
  State<VhsPage> createState() => _VhsPageState();
}

class _VhsPageState extends State<VhsPage> {
  VhsOverlayConfig? _config;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final overlay = FancyOverlay.of<VhsOverlayEntry>(context);
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _config = overlay?.config;
        if (_config != null) return;
        widget.controller.setOverlay(
          const VhsOverlayEntry(
            config: VhsOverlayConfig.standard(),
          ),
        );
      });
      _isInit = false;
    }
    _config = overlay?.config;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController;
    return Scaffold(
      appBar: AppBar(
        title: const Text('VHS Overlay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_config != null) ...[
              Text('Dot radius (${_config!.dotRadius.toStringAsFixed(2)})'),
              Slider(
                value: _config!.dotRadius,
                min: 0,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(dotRadius: value);
                  if (_config == null) return;
                  widget.controller.setOverlay(
                    VhsOverlayEntry(config: _config!),
                  );
                },
              ),
              Text('Dots number (${_config!.dotsNumber})'),
              Slider(
                value: _config!.dotsNumber.toDouble(),
                min: 0,
                max: 1000,
                onChanged: (value) {
                  _config = _config?.copyWith(dotsNumber: value.toInt());
                  if (_config == null) return;
                  widget.controller.setOverlay(
                    VhsOverlayEntry(config: _config!),
                  );
                },
              ),
              FancyColorSlider(
                label: 'Dot color',
                color: _config!.color.dot,
                onColorUpdate: (color) {
                  final updatedColor = _config!.color.copyWith(dot: color);
                  _config = _config?.copyWith(color: updatedColor);
                  if (_config == null) return;
                  widget.controller.setOverlay(
                    VhsOverlayEntry(config: _config!),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

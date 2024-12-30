import 'package:example/widgets/fancy_color_slider.dart';
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
        _config = const VhsOverlayConfig.standard();
        context.showFancyOverlay(
          const VhsOverlay(
            config: VhsOverlayConfig.standard(),
          ),
        );
        setState(() {});
      },
    );
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
              Text('Dot radius (${_config!.dotRadius.toStringAsFixed(2)})'),
              Slider(
                value: _config!.dotRadius,
                min: 0,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(dotRadius: value);
                  if (_config == null) return;
                  context.showFancyOverlay(
                    VhsOverlay(config: _config!),
                  );
                  setState(() {});
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
                  context.showFancyOverlay(
                    VhsOverlay(config: _config!),
                  );
                  setState(() {});
                },
              ),
              FancyColorSlider(
                label: 'Dot color',
                color: _config!.color.dot,
                onColorUpdate: (color) {
                  final updatedColor = _config!.color.copyWith(dot: color);
                  _config = _config?.copyWith(color: updatedColor);
                  if (_config == null) return;
                  context.showFancyOverlay(
                    VhsOverlay(config: _config!),
                  );
                  setState(() {});
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

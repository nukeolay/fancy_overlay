import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class RetroPixelPage extends StatefulWidget {
  const RetroPixelPage({super.key});

  @override
  State<RetroPixelPage> createState() => _RetroPixelPageState();
}

class _RetroPixelPageState extends State<RetroPixelPage> {
  RetroPixelOverlayConfig? _config;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _config = const RetroPixelOverlayConfig();
        context.showFancyOverlay(
          const RetroPixelOverlay(
            config: RetroPixelOverlayConfig(),
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
        title: const Text('Retro Pixel Overlay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeFancyOverlay<RetroPixelOverlay>();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_config != null) ...[
              Text('Pixel size (${_config!.pixelSize.toStringAsFixed(2)})'),
              Slider(
                value: _config!.pixelSize,
                min: 1,
                max: 100,
                onChanged: (value) {
                  _config = _config?.copyWith(pixelSize: value);
                  if (_config == null) return;
                  context.showFancyOverlay(
                    RetroPixelOverlay(config: _config!),
                  );
                  setState(() {});
                },
              ),
              Text('Opacity (${_config!.opacity.toStringAsFixed(2)})'),
              Slider(
                value: _config!.opacity,
                min: 0,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(opacity: value);
                  if (_config == null) return;
                  context.showFancyOverlay(
                    RetroPixelOverlay(config: _config!),
                  );
                  setState(() {});
                },
              ),
              Text(
                'Glitch Frequency '
                '(${_config!.glitchFrequency.toStringAsFixed(3)})',
              ),
              Slider(
                value: _config!.glitchFrequency,
                min: 0,
                max: 1,
                onChanged: (value) {
                  _config = _config?.copyWith(glitchFrequency: value);
                  if (_config == null) return;
                  context.showFancyOverlay(
                    RetroPixelOverlay(config: _config!),
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

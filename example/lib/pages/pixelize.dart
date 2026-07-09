import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

class PixelizePage extends StatefulWidget {
  const PixelizePage({super.key});

  @override
  State<PixelizePage> createState() => _PixelizePageState();
}

class _PixelizePageState extends State<PixelizePage> {
  PixelizeOverlayConfig _config = const PixelizeOverlayConfig();
  Future<void>? _shaderPrecache;

  @override
  void initState() {
    super.initState();
    _shaderPrecache = PixelizeOverlay.precacheShader();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.showFancyOverlay(PixelizeOverlay(config: _config));
    });
  }

  void _updateConfig(PixelizeOverlayConfig config) {
    context.showFancyOverlay(PixelizeOverlay(config: config));
    setState(() {
      _config = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PixelizeOverlay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeFancyOverlay<PixelizeOverlay>();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: FlutterLogo(size: 160),
          ),
          const SizedBox(height: 24),
          FutureBuilder<void>(
            future: _shaderPrecache,
            builder: (context, snapshot) {
              final isReady = snapshot.connectionState == ConnectionState.done;
              return Text(
                isReady
                    ? 'Shader precache is complete'
                    : 'Shader precache is running',
                textAlign: TextAlign.center,
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Pixel size (${_config.pixelSize.toStringAsFixed(2)})',
            textAlign: TextAlign.center,
          ),
          Slider(
            value: _config.pixelSize,
            min: 1,
            max: 100,
            onChanged: (value) {
              _updateConfig(_config.copyWith(pixelSize: value));
            },
          ),
        ],
      ),
    );
  }
}

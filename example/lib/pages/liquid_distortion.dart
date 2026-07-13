import 'dart:math' as math;

import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

class LiquidDistortionPage extends StatefulWidget {
  const LiquidDistortionPage({super.key});

  @override
  State<LiquidDistortionPage> createState() => _LiquidDistortionPageState();
}

class _LiquidDistortionPageState extends State<LiquidDistortionPage> {
  LiquidDistortionOverlayConfig _config =
      const LiquidDistortionOverlayConfig.balanced();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _show(_config);
      }
    });
  }

  void _show(LiquidDistortionOverlayConfig config) {
    context.showFancyOverlay(LiquidDistortionOverlay(config: config));
    setState(() {
      _config = config;
    });
  }

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    final formattedValue = value.toStringAsFixed(2);
    return MergeSemantics(
      child: Column(
        children: [
          Text('$label ($formattedValue)'),
          Slider(
            value: value,
            min: min,
            max: max,
            label: formattedValue,
            semanticFormatterCallback: (semanticValue) =>
                semanticValue.toStringAsFixed(2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiquidDistortionOverlay'),
        actions: [
          IconButton(
            tooltip: 'Remove Liquid Distortion overlay',
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeFancyOverlay<LiquidDistortionOverlay>();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () =>
                    _show(const LiquidDistortionOverlayConfig.mild()),
                child: const Text('Mild'),
              ),
              OutlinedButton(
                onPressed: () =>
                    _show(const LiquidDistortionOverlayConfig.balanced()),
                child: const Text('Balanced'),
              ),
              OutlinedButton(
                onPressed: () =>
                    _show(const LiquidDistortionOverlayConfig.heavy()),
                child: const Text('Heavy'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _slider(
            label: 'Distortion strength',
            value: config.distortionStrength,
            min: 0,
            max: 1,
            onChanged: (value) => _show(
              config.copyWith(distortionStrength: value),
            ),
          ),
          _slider(
            label: 'Wave scale',
            value: config.waveScale,
            min: 40,
            max: 320,
            onChanged: (value) => _show(config.copyWith(waveScale: value)),
          ),
          _slider(
            label: 'Speed',
            value: config.speed,
            min: 0,
            max: 1,
            onChanged: (value) => _show(config.copyWith(speed: value)),
          ),
          _slider(
            label: 'Direction',
            value: config.direction,
            min: -math.pi,
            max: math.pi,
            onChanged: (value) => _show(config.copyWith(direction: value)),
          ),
          _slider(
            label: 'Chromatic aberration',
            value: config.chromaticAberration,
            min: 0,
            max: 6,
            onChanged: (value) => _show(
              config.copyWith(chromaticAberration: value),
            ),
          ),
        ],
      ),
    );
  }
}

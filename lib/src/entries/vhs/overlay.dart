import 'package:flutter/widgets.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class VhsOverlay extends FancyOverlay<VhsOverlayConfig> {
  const VhsOverlay({
    required this.config,
  });

  @override
  final VhsOverlayConfig config;

  @override
  Widget get widget => VhsOverlayWidget(config: config);
}

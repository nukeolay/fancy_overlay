import 'package:flutter/widgets.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class VhsOverlayEntry extends FancyOverlayEntry<VhsOverlayConfig> {
  const VhsOverlayEntry({
    required this.config,
  });

  @override
  final VhsOverlayConfig config;

  @override
  Widget get widget => VhsOverlayWidget(config: config);
}

import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:fancy_overlay/src/overlays/falling_widgets/falling_widgets.dart';

class FallingWidgetsOverlay extends StatelessWidget {
  const FallingWidgetsOverlay({
    required this.config,
    super.key,
  });

  final FallingWidgetsOverlayConfig config;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.none,
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: FadeTransition(
        opacity: AlwaysStoppedAnimation(config.opacity),
        child: FallingWidgets(config: config),
      ),
    );
  }
}

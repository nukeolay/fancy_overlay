import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:fancy_overlay/src/overlays/falling_widgets/falling_widgets.dart';

/// A widget that displays an animated overlay of falling widgets on the screen.
///
/// The [FallingWidgetsOverlay] provides a visually appealing effect where
/// specified widgets fall across the screen. It supports customization 
/// through the [FallingWidgetsOverlayConfig] class.
///
/// This widget is useful for creating dynamic visual effects, such as falling
/// snowflakes, stars, or any custom widgets you provide.
///
/// To use this widget, ensure that you provide a valid [FallingWidgetsOverlayConfig]
/// instance with the desired properties.
class FallingWidgetsOverlay extends StatelessWidget {
  /// Creates a [FallingWidgetsOverlay] with the provided configuration.
  ///
  /// The [config] parameter is required and specifies the behavior and appearance
  /// of the falling widgets.
  const FallingWidgetsOverlay({
    required this.config,
    super.key,
  });

  /// The configuration that determines the behavior and appearance of the
  /// falling widgets overlay.
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

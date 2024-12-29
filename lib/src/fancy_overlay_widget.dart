import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class FancyOverlay extends StatefulWidget {
  const FancyOverlay({
    required this.child,
    this.controller,
    super.key,
  });
  final Widget child;
  final FancyOverlayController? controller;

  @override
  State<FancyOverlay> createState() => _FancyOverlayState();
}

class _FancyOverlayState extends State<FancyOverlay>
    with TickerProviderStateMixin {
  OverlayEntry? _overlay;
  FancyOverlayController? _backupController;

  FancyOverlayController get _effectiveFancyOverlayController =>
      widget.controller ?? (_backupController ??= FancyOverlayController());

  @override
  void initState() {
    super.initState();
    final builder = _effectiveFancyOverlayController.builder;
    if (builder == null) return;
    _overlay = OverlayEntry(
      opaque: false,
      builder: (context) => IgnorePointer(
        child: builder(context),
      ),
    );
  }

  @override
  void dispose() {
    _backupController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FancyOverlayControllerProvider(
      controller: _effectiveFancyOverlayController,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            opaque: true,
            maintainState: true,
            builder: (context) => widget.child,
          ),
          if (_overlay != null) _overlay!,
        ],
      ),
    );
  }
}

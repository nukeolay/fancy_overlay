import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class FancyOverlay extends StatefulWidget {
  const FancyOverlay({
    required this.child,
    this.initialOverlay,
    this.controller,
    super.key,
  });
  final Widget child;
  final FancyOverlayEntry? initialOverlay;
  final FancyOverlayController? controller;

  static FancyOverlayEntry? of<T extends FancyOverlayEntry>(
    BuildContext context,
  ) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedFancyOverlay>();
    assert(inherited != null, 'No FancyOverlay found in BuildContext');
    return inherited?.overlay is T ? inherited?.overlay as T : null;
  }

  static FancyOverlayEntry? maybeOf<T extends FancyOverlayEntry>(
    BuildContext context,
  ) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedFancyOverlay>();
    return inherited?.overlay is T ? inherited?.overlay as T : null;
  }

  @override
  State<FancyOverlay> createState() => FancyOverlayState();
}

class FancyOverlayState extends State<FancyOverlay>
    with TickerProviderStateMixin {
  FancyOverlayEntry? _overlay;
  FancyOverlayController? _backupController;

  FancyOverlayController get _effectiveFancyOverlayController =>
      widget.controller ?? (_backupController ??= FancyOverlayController());

  @override
  void initState() {
    super.initState();
    _effectiveFancyOverlayController.setOverlay(widget.initialOverlay);
    _effectiveFancyOverlayController.addListener(() {
      setState(() {
        _overlay = _effectiveFancyOverlayController.overlay;
      });
    });
  }

  @override
  void dispose() {
    _backupController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedFancyOverlay(
      overlay: _overlay,
      child: Stack(
        children: [
          widget.child,
          if (_overlay != null) IgnorePointer(child: _overlay!.widget),
        ],
      ),
    );
  }
}

class _InheritedFancyOverlay extends InheritedWidget {
  const _InheritedFancyOverlay({
    required this.overlay,
    required super.child,
  });

  final FancyOverlayEntry? overlay;

  @override
  bool updateShouldNotify(_InheritedFancyOverlay old) => overlay != old.overlay;
}

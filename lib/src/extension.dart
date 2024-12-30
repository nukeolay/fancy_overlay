import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

extension FancyOverlayExtension on BuildContext {
  static final Map<Type, OverlayEntry> _overlays = {};

  void showFancyOverlay(FancyOverlay overlay) {
    _removeEntryByType(overlay.runtimeType);
    final overlayEntry = OverlayEntry(
      builder: (context) => IgnorePointer(
        child: overlay.widget,
      ),
    );
    _overlays[overlay.runtimeType] = overlayEntry;
    Overlay.of(this).insert(overlayEntry);
  }

  getOverlayConfig<T extends FancyOverlay>() => _overlays[T]?.builder;

  void removeFancyOverlay<T extends FancyOverlay>() {
    _removeEntryByType(T);
  }

  void _removeEntryByType(Type type) {
    final overlayEntries = _overlays.entries
        .where((entry) => entry.key == type)
        .map((entry) => entry.value);
    for (var overlayEntry in overlayEntries) {
      overlayEntry.remove();
    }
    _overlays.removeWhere((key, value) => key == type);
  }
}

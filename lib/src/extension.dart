import 'package:flutter/material.dart';

extension FancyOverlayExtension on BuildContext {
  static final Map<Type, OverlayEntry> _overlays = {};

  void showFancyOverlay(Widget overlay) {
    _removeEntryByType(overlay.runtimeType);
    final overlayEntry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: overlay,
      ),
    );
    _overlays[overlay.runtimeType] = overlayEntry;
    Overlay.of(this).insert(overlayEntry);
  }

  void removeFancyOverlay<T extends Widget>() {
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

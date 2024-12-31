import 'package:flutter/material.dart';

extension FancyOverlayExtension on BuildContext {
  static final Map<Type, OverlayEntry> _overlays = {};

  void showFancyOverlay(
    Widget overlay, {
    bool ignorePointer = true,
  }) {
    _removeEntryByType(overlay.runtimeType);
    final overlayEntry = OverlayEntry(
      builder: (_) => ignorePointer ? IgnorePointer(child: overlay) : overlay,
    );
    _overlays[overlay.runtimeType] = overlayEntry;
    Overlay.of(this).insert(overlayEntry);
  }

  void removeFancyOverlay<T extends Widget>() {
    _removeEntryByType(T);
  }

  void removeAllFancyOverlays() {
    for (var overlayEntry in _overlays.values) {
      overlayEntry.remove();
    }
    _overlays.clear();
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

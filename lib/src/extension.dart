import 'package:flutter/widgets.dart';

/// Convenience methods for managing [OverlayEntry] instances in an [Overlay].
///
/// Entries are scoped to the nearest [Overlay] found from this context. Each
/// overlay keeps at most one active entry for a widget runtime type; showing
/// the same type again replaces that entry in the same overlay only.
extension FancyOverlayExtension on BuildContext {
  static final _overlaysByState = Expando<Map<Type, OverlayEntry>>(
    'fancyOverlayEntries',
  );

  /// Inserts [overlay] into the nearest [Overlay].
  ///
  /// If this overlay already contains an entry with the same runtime type, the
  /// existing entry is removed before [overlay] is inserted. By default,
  /// [overlay] ignores pointer events; set [ignorePointer] to false to let it
  /// receive them.
  void showFancyOverlay(
    Widget overlay, {
    bool ignorePointer = true,
  }) {
    final overlayState = Overlay.of(this);
    final overlays = _overlaysFor(overlayState);
    _removeEntryByType(overlays, overlay.runtimeType);
    final overlayEntry = OverlayEntry(
      builder: (_) => ignorePointer ? IgnorePointer(child: overlay) : overlay,
    );
    overlays[overlay.runtimeType] = overlayEntry;
    overlayState.insert(overlayEntry);
  }

  /// Removes the entry of type [T] from the nearest [Overlay], if present.
  void removeFancyOverlay<T extends Widget>() {
    final overlayState = Overlay.of(this);
    final overlays = _overlaysByState[overlayState];
    if (overlays == null) {
      return;
    }

    _removeEntryByType(overlays, T);
  }

  /// Removes all entries inserted through this extension into the nearest
  /// [Overlay].
  void removeAllFancyOverlays() {
    final overlayState = Overlay.of(this);
    final overlays = _overlaysByState[overlayState];
    if (overlays == null) {
      return;
    }

    for (final overlayEntry in overlays.values) {
      overlayEntry.remove();
    }
    overlays.clear();
  }

  Map<Type, OverlayEntry> _overlaysFor(OverlayState overlayState) {
    return _overlaysByState[overlayState] ??= <Type, OverlayEntry>{};
  }

  void _removeEntryByType(
    Map<Type, OverlayEntry> overlays,
    Type type,
  ) {
    overlays.remove(type)?.remove();
  }
}

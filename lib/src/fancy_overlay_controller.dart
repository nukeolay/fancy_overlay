import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

class FancyOverlayController extends ChangeNotifier {
  FancyOverlayController();

  FancyOverlayEntry? _overlay;
  FancyOverlayEntry? get overlay => _overlay;

  void setOverlay(FancyOverlayEntry? entry) {
    _overlay = entry;
    notifyListeners();
  }
}

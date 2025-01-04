import 'dart:ui';

import 'package:fancy_overlay/fancy_overlay.dart';

class VhsOverlayConfig {
  const VhsOverlayConfig({
    this.scanlineColor = const FancyColor(
      Color.fromRGBO(150, 150, 150, 0.2),
    ),
    this.dotColor = const FancyRandomColor(),
    this.dotSize = 2,
    this.dotsNumber = 300,
    this.animateScanlines = false,
  });

  final FancyColor scanlineColor;
  final FancyColor dotColor;
  final double dotSize;
  final int dotsNumber;
  final bool animateScanlines;

  VhsOverlayConfig copyWith({
    FancyColor? scanlineColor,
    FancyColor? dotColor,
    double? dotSize,
    int? dotsNumber,
    bool? animateScanlines,
  }) {
    return VhsOverlayConfig(
      scanlineColor: scanlineColor ?? this.scanlineColor,
      dotColor: dotColor ?? this.dotColor,
      dotSize: dotSize ?? this.dotSize,
      dotsNumber: dotsNumber ?? this.dotsNumber,
      animateScanlines: animateScanlines ?? this.animateScanlines,
    );
  }
}

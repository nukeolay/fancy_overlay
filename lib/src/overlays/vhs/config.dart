import 'dart:ui';

import 'package:fancy_overlay/fancy_overlay.dart';

class VhsColor {
  const VhsColor({
    this.scanline = const FancyColor(
      Color.fromRGBO(150, 150, 150, 0.2),
    ),
    this.dot = const FancyRandomColor(),
  });

  const VhsColor.random()
      : scanline = const FancyRandomColor(),
        dot = const FancyRandomColor();

  final FancyColor scanline;
  final FancyColor dot;

  VhsColor copyWith({
    FancyColor? scanline,
    FancyColor? dot,
  }) {
    return VhsColor(
      scanline: scanline ?? this.scanline,
      dot: dot ?? this.dot,
    );
  }
}

class VhsOverlayConfig {
  const VhsOverlayConfig({
    this.color = const VhsColor(),
    this.dotSize = 2,
    this.dotsNumber = 300,
    this.animateScanlines = false,
  });

  final VhsColor color;
  final double dotSize;
  final int dotsNumber;
  final bool animateScanlines;

  VhsOverlayConfig copyWith({
    VhsColor? color,
    double? dotSize,
    int? dotsNumber,
    bool? animateScanlines,
  }) {
    return VhsOverlayConfig(
      color: color ?? this.color,
      dotSize: dotSize ?? this.dotSize,
      dotsNumber: dotsNumber ?? this.dotsNumber,
      animateScanlines: animateScanlines ?? this.animateScanlines,
    );
  }
}

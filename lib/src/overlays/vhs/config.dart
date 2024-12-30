import 'dart:ui';

import 'package:fancy_overlay/fancy_overlay.dart';

class VhsColor {
  const VhsColor({
    required this.scanline,
    required this.dot,
    required this.filter,
  });

  const VhsColor.standard()
      : scanline = const FancyColor(Color.fromRGBO(0, 0, 0, 0.2)),
        dot = const FancyRandomColor(),
        filter = null;

  const VhsColor.random()
      : scanline = const FancyRandomColor(),
        dot = const FancyRandomColor(),
        filter = const FancyRandomColor();

  final FancyColor scanline;
  final FancyColor dot;
  final FancyColor? filter;

  VhsColor copyWith({
    FancyColor? scanline,
    FancyColor? dot,
    FancyColor? filter,
  }) {
    return VhsColor(
      scanline: scanline ?? this.scanline,
      dot: dot ?? this.dot,
      filter: filter ?? this.filter,
    );
  }
}

class VhsOverlayConfig {
  const VhsOverlayConfig({
    required this.color,
    required this.dotRadius,
    required this.dotsNumber,
  });

  const VhsOverlayConfig.standard()
      : color = const VhsColor.standard(),
        dotRadius = 1,
        dotsNumber = 100;

  final VhsColor color;
  final double dotRadius;
  final int dotsNumber;

  VhsOverlayConfig copyWith({
    VhsColor? color,
    double? dotRadius,
    int? dotsNumber,
  }) {
    return VhsOverlayConfig(
      color: color ?? this.color,
      dotRadius: dotRadius ?? this.dotRadius,
      dotsNumber: dotsNumber ?? this.dotsNumber,
    );
  }
}

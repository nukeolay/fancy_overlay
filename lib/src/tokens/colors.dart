import 'dart:math';
import 'package:flutter/material.dart';

class FancyColor {
  const FancyColor(this.color);

  final Color color;
}

class FancyRandomColor implements FancyColor {
  const FancyRandomColor([this.r, this.g, this.b, this.intensity]);

  final int? r;
  final int? g;
  final int? b;
  final double? intensity;

  @override
  Color get color {
    return Color.fromRGBO(
      r ?? Random().nextInt(256),
      g ?? Random().nextInt(256),
      b ?? Random().nextInt(256),
      intensity ?? Random().nextDouble(),
    );
  }
}
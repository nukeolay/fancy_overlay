import 'dart:math';
import 'package:flutter/material.dart';

final _random = Random();

class FancyColor {
  const FancyColor(this.color);

  final Color color;
}

class FancyRandomColor implements FancyColor {
  const FancyRandomColor([this.r, this.g, this.b, this.opacity]);

  final int? r;
  final int? g;
  final int? b;
  final double? opacity;

  @override
  Color get color {
    return Color.fromRGBO(
      r ?? _random.nextInt(256),
      g ?? _random.nextInt(256),
      b ?? _random.nextInt(256),
      opacity ?? _random.nextDouble(),
    );
  }
}

import 'package:flutter/material.dart';

abstract class FancyOverlay<T> {
  const FancyOverlay();
  T get config;
  Widget get widget;
}

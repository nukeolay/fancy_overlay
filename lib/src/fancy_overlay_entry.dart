import 'package:flutter/material.dart';

abstract class FancyOverlayEntry<T> {
  const FancyOverlayEntry();
  T get config;
  Widget get widget;
}

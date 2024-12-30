import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

class FancyColorSlider extends StatelessWidget {
  const FancyColorSlider({
    required this.label,
    required this.color,
    required this.onColorUpdate,
    super.key,
  });
  final String label;
  final FancyColor color;
  final Function(FancyColor color) onColorUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        Slider(
          value: color.color.red.toDouble(),
          thumbColor: Colors.red,
          min: 0,
          max: 256,
          onChanged: (value) {
            if (value == 256) {
              onColorUpdate(const FancyRandomColor());
              return;
            }
            final updatedColor = Color.fromRGBO(
              value.toInt(),
              color.color.green,
              color.color.blue,
              color.color.opacity,
            );
            onColorUpdate(FancyColor(updatedColor));
          },
        ),
        Slider(
          value: color.color.green.toDouble(),
          thumbColor: Colors.green,
          min: 0,
          max: 256,
          onChanged: (value) {
            if (value == 256) {
              onColorUpdate(const FancyRandomColor());
              return;
            }
            final updatedColor = Color.fromRGBO(
              color.color.red,
              value.toInt(),
              color.color.blue,
              color.color.opacity,
            );
            onColorUpdate(FancyColor(updatedColor));
          },
        ),
        Slider(
          value: color.color.blue.toDouble(),
          thumbColor: Colors.blue,
          min: 0,
          max: 256,
          onChanged: (value) {
            if (value == 256) {
              onColorUpdate(const FancyRandomColor());
              return;
            }
            final updatedColor = Color.fromRGBO(
              color.color.red,
              color.color.green,
              value.toInt(),
              color.color.opacity,
            );
            onColorUpdate(FancyColor(updatedColor));
          },
        ),
      ],
    );
  }
}

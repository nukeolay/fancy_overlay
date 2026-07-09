import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

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
          value: _colorChannelValue(color.color.r).toDouble(),
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
              _colorChannelValue(color.color.g),
              _colorChannelValue(color.color.b),
              color.color.a,
            );
            onColorUpdate(FancyColor(updatedColor));
          },
        ),
        Slider(
          value: _colorChannelValue(color.color.g).toDouble(),
          thumbColor: Colors.green,
          min: 0,
          max: 256,
          onChanged: (value) {
            if (value == 256) {
              onColorUpdate(const FancyRandomColor());
              return;
            }
            final updatedColor = Color.fromRGBO(
              _colorChannelValue(color.color.r),
              value.toInt(),
              _colorChannelValue(color.color.b),
              color.color.a,
            );
            onColorUpdate(FancyColor(updatedColor));
          },
        ),
        Slider(
          value: _colorChannelValue(color.color.b).toDouble(),
          thumbColor: Colors.blue,
          min: 0,
          max: 256,
          onChanged: (value) {
            if (value == 256) {
              onColorUpdate(const FancyRandomColor());
              return;
            }
            final updatedColor = Color.fromRGBO(
              _colorChannelValue(color.color.r),
              _colorChannelValue(color.color.g),
              value.toInt(),
              color.color.a,
            );
            onColorUpdate(FancyColor(updatedColor));
          },
        ),
      ],
    );
  }
}

int _colorChannelValue(double channel) {
  return (channel * 255).round().clamp(0, 255).toInt();
}

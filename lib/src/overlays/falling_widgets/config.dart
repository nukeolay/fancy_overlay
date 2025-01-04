import 'dart:math';

import 'package:fancy_overlay/src/utils/random_double.dart';
import 'package:flutter/widgets.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

/// Configuration class for the [FallingWidgetsOverlay] effect.
/// Provides detailed customization options for animating falling widgets.
///
/// This configuration allows you to control the behavior, speed, appearance,
/// and animation of widgets that fall across the screen.
///
/// Example usage:
/// ```dart
/// FallingWidgetsOverlayConfig(
///   children: [
///     Icon(
///       CupertinoIcons.snow,
///       color: Colors.white,
///     ),
///   ],
///   numberOfWidgets: 100,
///   positionStrategy = const FallingWidgetRandomPositionStrategy()
///   minYSpeed: 0.5,
///   maxYSpeed: 1.5,
///   minXSpeed: -0.2,
///   maxXSpeed: 0.2,
///   minScale: 0.5,
///   maxScale: 2.0,
///   rotationSpeed: 0.3,
///   appearDuration: const Duration(seconds: 3),
///   opacity: 0.75,
/// );
/// ```
class FallingWidgetsOverlayConfig {
  /// Creates a configuration for the [FallingWidgetsOverlay].
  ///
  /// [children] is a required list of widgets to use as the falling items.
  ///
  /// Optional parameters allow you to customize animation properties, such as
  /// speed, scaling, opacity, and appearance duration.
  const FallingWidgetsOverlayConfig({
    required this.children,
    this.numberOfWidgets = 200,
    this.positionStrategy = const FallingWidgetRandomPositionStrategy(),
    this.minYSpeed = 0.5,
    this.maxYSpeed = 1.0,
    this.minXSpeed = 0,
    this.maxXSpeed = 0,
    this.minScale = 0.25,
    this.maxScale = 1.5,
    this.rotationSpeed = 0.5,
    this.appearDuration = const Duration(milliseconds: 2000),
    this.opacity = 0.5,
  });

  /// The list of widgets that will be animated as falling objects.
  /// Each widget will be rendered randomly across the screen.
  final List<Widget> children;

  /// The number of widgets to display on the screen simultaneously.
  /// Defaults to `200`.
  final int numberOfWidgets;

  /// The initial position of the new widget.
  /// Defaults to [FallingWidgetRandomPositionStrategy].
  final FallingWidgetPositionStrategy positionStrategy;

  /// The minimum vertical falling speed of the widgets.
  /// Defaults to `0.5`.
  final double minYSpeed;

  /// The maximum vertical falling speed of the widgets.
  /// Defaults to `1.0`.
  final double maxYSpeed;

  /// The minimum horizontal movement speed of the widgets.
  /// This allows widgets to drift left or right. Defaults to `0` (no movement).
  final double minXSpeed;

  /// The maximum horizontal movement speed of the widgets.
  /// This allows widgets to drift left or right. Defaults to `0` (no movement).
  final double maxXSpeed;

  /// The minimum scale factor for resizing widgets.
  /// Widgets will randomly scale between [minScale] and [maxScale].
  /// Defaults to `0.25`.
  final double minScale;

  /// The maximum scale factor for resizing widgets.
  /// Widgets will randomly scale between [minScale] and [maxScale].
  /// Defaults to `1.5`.
  final double maxScale;

  /// The rotation speed of the widgets, controlling how fast they spin.
  /// Defaults to `0.5`.
  final double rotationSpeed;

  /// The duration for newly appearing widgets to fade into view.
  /// Defaults to `2` seconds.
  final Duration appearDuration;

  /// The global opacity of the widgets, controlling their transparency.
  /// Values must be between `0.0` (completely transparent) and `1.0` (fully opaque).
  /// Defaults to `0.5`.
  final double opacity;

  /// Returns a new configuration with updated values.
  ///
  /// This method allows you to copy an existing configuration and override specific
  /// values while keeping the others unchanged.
  FallingWidgetsOverlayConfig copyWith({
    List<Widget>? children,
    int? numberOfWidgets,
    FallingWidgetPositionStrategy? positionStrategy,
    double? minYSpeed,
    double? maxYSpeed,
    double? minXSpeed,
    double? maxXSpeed,
    double? minScale,
    double? maxScale,
    double? rotationSpeed,
    Duration? appearDuration,
    double? opacity,
  }) {
    return FallingWidgetsOverlayConfig(
      children: children ?? this.children,
      numberOfWidgets: numberOfWidgets ?? this.numberOfWidgets,
      positionStrategy: positionStrategy ?? this.positionStrategy,
      minYSpeed: minYSpeed ?? this.minYSpeed,
      maxYSpeed: maxYSpeed ?? this.maxYSpeed,
      minXSpeed: minXSpeed ?? this.minXSpeed,
      maxXSpeed: maxXSpeed ?? this.maxXSpeed,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      appearDuration: appearDuration ?? this.appearDuration,
      opacity: opacity ?? this.opacity,
    );
  }
}

/// An abstract base class that defines the initial position of a falling widget.
///
/// This class is used to calculate the starting (x, y) coordinates of a widget
/// relative to the screen size. It allows customization of how and where widgets
/// appear on the screen.
///
/// Implementations of this class can define different strategies for initializing
/// widget positions. For example:
/// - Random positions across the screen.
/// - Starting at the top of the screen.
///
/// See the following implementations for specific behavior:
/// - [FallingWidgetRandomPositionStrategy]
/// - [FallingWidgetToPositionStrategy]
sealed class FallingWidgetPositionStrategy {
  /// Creates a base instance of the initial position class.
  const FallingWidgetPositionStrategy();

  /// Calculates the initial horizontal position (x-coordinate) of a widget.
  ///
  /// [screenSize] provides the dimensions of the screen where the widget will
  /// be displayed.
  double x(Size screenSize);

  /// Calculates the initial vertical position (y-coordinate) of a widget.
  ///
  /// [screenSize] provides the dimensions of the screen where the widget will
  /// be displayed.
  double y(Size screenSize);
}

/// A strategy for initializing widget positions at random locations on the screen.
///
/// Widgets will appear at a random (x, y) coordinate within the screen bounds.
class FallingWidgetRandomPositionStrategy
    extends FallingWidgetPositionStrategy {
  /// Creates an instance of [FallingWidgetRandomPositionStrategy].
  const FallingWidgetRandomPositionStrategy();

  /// Returns a random horizontal position (x-coordinate) within the screen width.
  @override
  double x(Size screenSize) => Random().randomDouble(0, screenSize.width);

  /// Returns a random vertical position (y-coordinate) within the screen height.
  @override
  double y(Size screenSize) => Random().randomDouble(0, screenSize.height);
}

/// A strategy for initializing widget positions at the top of the screen.
///
/// Widgets will appear at a random horizontal position (x-coordinate) but always
/// start at the top of the screen (y = 0).
class FallingWidgetTopPositionStrategy extends FallingWidgetPositionStrategy {
  /// Creates an instance of [FallingWidgetTopPositionStrategy].
  const FallingWidgetTopPositionStrategy();

  /// Returns a random horizontal position (x-coordinate) within the screen width.
  @override
  double x(Size screenSize) => Random().randomDouble(0, screenSize.width);

  /// Returns a vertical position (y-coordinate) fixed at the top of the screen (y = 0).
  @override
  double y(Size screenSize) => 0;
}

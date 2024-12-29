import 'package:flutter/material.dart';

class FancyOverlayController extends ChangeNotifier {
  FancyOverlayController({
    this.builder,
  });

  Widget Function(BuildContext context)? builder;

  static FancyOverlayController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
      controller != null,
      'No FancyOverlayController found in BuildContext',
    );
    return controller!;
  }

  static FancyOverlayController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FancyOverlayControllerProvider>()
        ?.controller;
  }

  void setBuilder(Widget Function(BuildContext context) builder) {
    this.builder = builder;
    notifyListeners();
  }
}

class FancyOverlayControllerProvider extends InheritedWidget {
  const FancyOverlayControllerProvider({
    required this.controller,
    required super.child,
    super.key,
  });

  final FancyOverlayController controller;

  @override
  bool updateShouldNotify(covariant FancyOverlayControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}

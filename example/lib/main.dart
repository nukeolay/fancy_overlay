import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:example/pages/home.dart';
import 'package:example/pages/vhs.dart';

void main() {
  runApp(const FancyOverlayExample());
}

class FancyOverlayExample extends StatelessWidget {
  const FancyOverlayExample({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final controller = FancyOverlayController();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.blueGrey,
        useMaterial3: true,
      ),
      builder: (context, child) => FancyOverlay(
        controller: controller,
        child: child!,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/vhs':
            return MaterialPageRoute(
              builder: (_) => VhsPage(controller: controller),
            );
          default:
            return MaterialPageRoute(builder: (_) => const HomePage());
        }
      },
      home: const HomePage(),
    );
  }
}

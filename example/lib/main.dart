import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:example/pages/home.dart';
import 'package:example/pages/vhs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.blueGrey,
        useMaterial3: true,
      ),
      builder: (context, child) => FancyOverlay(
        controller: FancyOverlayController(
          builder: (_) => const VhsOverlay(
            config: VhsOverlayConfig.standard(),
          ),
        ),
        child: child!,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/vhs':
            return MaterialPageRoute(builder: (_) => const VhsPage());
          default:
            return MaterialPageRoute(builder: (_) => const HomePage());
        }
      },
      home: const HomePage(),
    );
  }
}

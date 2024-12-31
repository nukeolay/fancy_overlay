import 'dart:async';

import 'package:example/pages/falling_widgets.dart';
import 'package:flutter/material.dart';
import 'package:example/pages/home.dart';
import 'package:example/pages/retro_pixel.dart';
import 'package:example/pages/vhs.dart';
import 'package:flutter/services.dart';

void main() {
  unawaited(
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
  );
  runApp(const FancyOverlayExample());
}

class FancyOverlayExample extends StatelessWidget {
  const FancyOverlayExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fancy Overlay Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.blueGrey.shade300,
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/vhs':
            return MaterialPageRoute(
              builder: (_) => const VhsPage(),
            );
          case '/retro_pixel':
            return MaterialPageRoute(
              builder: (_) => const RetroPixelPage(),
            );
          case '/falling_widgets':
            return MaterialPageRoute(
              builder: (_) => const FallingWidgetsPage(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const HomePage(),
            );
        }
      },
      home: const HomePage(),
    );
  }
}

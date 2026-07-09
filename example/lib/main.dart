import 'dart:async';

import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:example/pages/home.dart';
import 'package:example/pages/vhs.dart';
import 'package:example/pages/pixel_noise.dart';
import 'package:example/pages/pixelize.dart';
import 'package:example/pages/falling_widgets.dart';
import 'package:example/pages/vignette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Preload the shader so the first PixelizeOverlay activation does less work.
  unawaited(PixelizeOverlay.precacheShader());

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
          case '/pixel_noise':
            return MaterialPageRoute(
              builder: (_) => const PixelNoisePage(),
            );
          case '/pixelize':
            return MaterialPageRoute(
              builder: (_) => const PixelizePage(),
            );
          case '/falling_widgets':
            return MaterialPageRoute(
              builder: (_) => const FallingWidgetsPage(),
            );
          case '/vignette':
            return MaterialPageRoute(
              builder: (_) => const VignettePage(),
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

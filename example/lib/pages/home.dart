import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fancy Overlay Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: () {
              context.removeAllFancyOverlays();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/vhs');
              },
              child: const Text(
                'VHS Overlay',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/retro_pixel');
              },
              child: const Text(
                'RetroPixel Overlay',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Snack'),
                  ),
                );
              },
              child: const Text('Snack'),
            ),
          ],
        ),
      ),
    );
  }
}

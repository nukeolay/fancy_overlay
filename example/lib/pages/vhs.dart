import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:flutter/material.dart';

class VhsPage extends StatefulWidget {
  const VhsPage({super.key});

  @override
  State<VhsPage> createState() => _VhsPageState();
}

class _VhsPageState extends State<VhsPage> {
  late final FancyOverlayController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = FancyOverlayController.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VHS Overlay'),
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
          ],
        ),
      ),
    );
  }
}

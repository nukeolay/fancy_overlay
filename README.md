# fancy_overlay

Flutter package that provides a collection of stunning, customizable overlays to enhance your app's visual appeal. With a convenient API for adding overlays, it includes effects like VHS glitch, pixel noise, real backdrop pixelation, falling widgets, vignette, and more. Designed for flexibility, the package allows for unique configurations and supports easy expansion with new overlays in the future.

## Features

* FallingWidgetsOverlay()
  - Highly customizable snowfall animation or any other falling widgets.
  - Control properties like vertical and horizaontal speed, scale, rotation, opacity, animation duration.
  - Perfect for adding a festive snowfall effect or any themed animation.

    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/falling_snow.gif" alt="Falling Snow" width="200"/>&nbsp;
    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/falling_stars.gif" alt="Falling Stars" width="200"/>&nbsp;

* VhsOverlay()
  - Add a retro VHS effect to your app with customizable glitch intensity, scanlines, and color distortion for a nostalgic experience.
  
    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/vhs.gif" alt="VHS" width="200"/>&nbsp;

* PixelNoiseOverlay()
  - Draw animated square pixel noise over your app with adjustable pixel sizes, color schemes, opacity, and noise frequency.
  
    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/pixel_noise.gif" alt="Pixel Noise" width="200"/>&nbsp;

* PixelizeOverlay()
  - Pixelate the already rendered backdrop behind the overlay with a configurable `pixelSize`.
  - Uses a shader-backed backdrop filter when the current renderer supports shader image filters.
  - Call `PixelizeOverlay.precacheShader()` before first use to reduce the first activation hitch.

```dart
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(PixelizeOverlay.precacheShader());
  runApp(const MyApp());
}
```

* VignetteOverlay()
  - Add a soft perimeter vignette with configurable intensity, sepia tone, corner radius, and edge falloff.
  - Use `radius` to control the inner corner rounding and `edgeFalloff` to control how far the vignette extends from the screen edges.

    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/vignette.png" alt="Vignette" width="200"/>&nbsp;

* Convenient API for Overlay Management
  - Easily add, remove, and manage overlays with `showFancyOverlay` and `removeFancyOverlay` *BuildContext* extensions.
  - Support for multiple simultaneous overlays without conflicts.

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  fancy_overlay: ^0.0.1
```

In your library add the following import:

```dart
import 'package:fancy_overlay/fancy_overlay.dart';
```

## BuildContext extension methods

* call `context.showFancyOverlay` to show overlay, like this:
 ```dart
      context.showFancyOverlay(
        FallingWidgetsOverlay(
          config: FallingWidgetsOverlayConfig(
            children: [
              Icon(
                CupertinoIcons.snow,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
```

* call `context.removeFancyOverlay<T>()` to remove specific overlay, like this:
 ```dart
      context.removeFancyOverlay<FallingWidgetsOverlay>();
```

* call `context.removeAllFancyOverlays()` to remove all overlays that was shown with `context.showFancyOverlay`:
 ```dart
      context.removeAllFancyOverlays();
```

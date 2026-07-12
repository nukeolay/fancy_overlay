# fancy_overlay

Flutter package that provides a collection of stunning, customizable overlays to enhance your app's visual appeal. With a convenient API for adding overlays, it includes effects like VHS glitch, pixel noise, real backdrop pixelation, falling widgets, vignette, and more. Designed for flexibility, the package allows for unique configurations and supports easy expansion with new overlays in the future.

## Features

* FallingWidgetsOverlay()
  - Highly customizable snowfall animation or any other falling widgets.
  - Control properties like vertical and horizontal speed, scale, rotation, opacity, animation duration.
  - Perfect for adding a festive snowfall effect or any themed animation.

    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/falling_snow.gif" alt="Falling Snow" width="200"/>&nbsp;
    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/falling_stars.gif" alt="Falling Stars" width="200"/>&nbsp;

* VhsOverlay()
  - Applies a Heavy VHS-on-CRT backdrop effect with curvature, RGB separation, tracking distortion, procedural noise, scanlines, flicker, and vignette.
  - Choose `VhsOverlayConfig.mild()`, `.balanced()`, or `.heavy()`, then use `copyWith` to tune individual signal controls.
  - Uses one shader image-filter pass when supported and automatically falls back to a portable painter approximation on other renderers.
  - Call `VhsOverlay.precacheShader()` before first use to reduce activation latency.
  - Compatibility: True curvature, backdrop distortion, and RGB separation require `ImageFilter.isShaderFilterSupported`. On other renderers, `VhsOverlay` keeps its visual character with a portable fallback that draws animated scanlines, noise, tracking, flicker, and vignette. In the same situation, `VhsOverlay.precacheShader()` completes without loading a shader program.
  
    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/vhs.gif" alt="VHS" width="200"/>&nbsp;

* PixelNoiseOverlay()
  - Draw animated square pixel noise over your app with adjustable pixel sizes, color schemes, opacity, and noise frequency.
  
    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/pixel_noise.gif" alt="Pixel Noise" width="200"/>&nbsp;

* PixelizeOverlay()
  - Pixelate the already rendered backdrop behind the overlay with a configurable `pixelSize`.
  - Uses a shader-backed backdrop filter when the current renderer supports shader image filters.
  - Call `PixelizeOverlay.precacheShader()` before first use to reduce the first activation hitch.
  - Compatibility: `PixelizeOverlay` uses `ImageFilter.shader`, which requires the Impeller rendering backend. Support is determined at runtime through `ImageFilter.isShaderFilterSupported`, so it depends on the active renderer rather than the operating system alone. When shader image filters are not supported, `PixelizeOverlay` falls back to a transparent full-size overlay: the backdrop remains unchanged and no `UnsupportedError` is thrown. In the same situation, `PixelizeOverlay.precacheShader()` completes without loading a shader program. See Flutter's [Impeller documentation](https://docs.flutter.dev/perf/impeller) for current platform availability and enablement instructions.

    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/pixelize.gif" alt="Pixelize" width="200"/>&nbsp;

* VignetteOverlay()
  - Add a soft perimeter vignette with configurable intensity, sepia tone, corner radius, and edge falloff.
  - Use `radius` to control the inner corner rounding and `edgeFalloff` to control how far the vignette extends from the screen edges.

    <img src="https://raw.githubusercontent.com/nukeolay/fancy_overlay/main/example/vignette.png" alt="Vignette" width="200"/>&nbsp;

* Convenient API for Overlay Management
  - Easily add, remove, and manage overlays with `showFancyOverlay` and `removeFancyOverlay` *BuildContext* extensions.
  - Support for multiple simultaneous overlays without conflicts.
  - Each `Overlay` keeps one active instance of a runtime type; showing that type again replaces only its instance in the nearest `Overlay`.

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

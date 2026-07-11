## 0.1.0

* Initial release with customizable Flutter overlay effects:
  * `FallingWidgetsOverlay`
  * `VhsOverlay`
  * `PixelNoiseOverlay`
  * `PixelizeOverlay`
  * `VignetteOverlay`
* Added `BuildContext` extension methods for showing and removing overlays.
* Added release-safe validation for overlay configurations.
* Made `FallingWidgetPositionStrategy` extensible by package users.
* Added `PixelizeOverlay` shader precaching and unsupported-renderer fallback.

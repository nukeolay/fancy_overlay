# fancy_overlay example

Interactive gallery for every overlay shipped by `fancy_overlay`.

Open effect pages sequentially to compose multiple persistent overlays. Remove
one effect from its page AppBar or clear the complete composition from the home
page.

The full `PixelizeOverlay`, `VhsOverlay`, and `LiquidDistortionOverlay` shader
paths require an Impeller-backed renderer with shader image-filter support.
Unsupported renderers use each effect's documented fallback. Liquid Distortion
keeps animated caustic highlights and a subtle tint, but cannot refract the
backdrop without shader image filters.

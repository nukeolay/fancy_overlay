# fancy_overlay example

Interactive gallery for every overlay shipped by `fancy_overlay`.

Open effect pages sequentially to compose multiple persistent overlays. Remove
one effect from its page AppBar or clear the complete composition from the home
page.

The full `PixelizeOverlay` and `VhsOverlay` shader paths require an
Impeller-backed renderer with shader image-filter support. Unsupported renderers
use each effect's documented fallback.

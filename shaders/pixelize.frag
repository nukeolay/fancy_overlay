#include <flutter/runtime_effect.glsl>

uniform vec2 u_size;
uniform float u_pixel_size;
uniform sampler2D u_texture_input;

out vec4 frag_color;

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  float safePixelSize = max(u_pixel_size, 1.0);
  vec2 sampleCoord =
      (floor(fragCoord / safePixelSize) + vec2(0.5)) * safePixelSize;
  vec2 uv = clamp(sampleCoord / u_size, vec2(0.0), vec2(1.0));

#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif

  frag_color = texture(u_texture_input, uv);
}

#include <flutter/runtime_effect.glsl>

uniform vec2 u_size;
uniform float u_time;
uniform float u_scanline_intensity;
uniform float u_noise_intensity;
uniform float u_chroma_aberration;
uniform float u_tracking_intensity;
uniform float u_distortion_intensity;
uniform float u_curvature;
uniform float u_vignette_intensity;
uniform float u_flicker_intensity;
uniform float u_device_pixel_ratio;
uniform sampler2D u_texture_input;

out vec4 frag_color;

float hash21(vec2 value) {
  value = fract(value * vec2(123.34, 456.21));
  value += dot(value, value + 45.32);
  return fract(value.x * value.y);
}

vec2 textureUv(vec2 uv) {
#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif
  return clamp(uv, vec2(0.0), vec2(1.0));
}

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec2 uv = fragCoord / u_size;
  vec2 centered = uv * 2.0 - 1.0;
  float radiusSquared = dot(centered, centered);

  vec2 curved = centered * (1.0 + u_curvature * 0.18 * radiusSquared);
  vec2 sampleUv = curved * 0.5 + 0.5;

  float signalWave = sin(sampleUv.y * 90.0 + u_time * 5.0);
  sampleUv.x += signalWave * 0.0035 * u_distortion_intensity;

  float trackingCenter = fract(u_time * 0.11);
  float trackingDistance = abs(sampleUv.y - trackingCenter);
  float trackingBand = exp(-pow(trackingDistance / 0.028, 2.0));
  float trackingWave = sin(sampleUv.y * 620.0 + u_time * 38.0);
  sampleUv.x += trackingWave * trackingBand * 0.028 * u_tracking_intensity;

  float chromaPixels = u_chroma_aberration * u_device_pixel_ratio;
  vec2 chromaOffset = vec2(
    chromaPixels / max(u_size.x, 1.0) * (0.6 + trackingBand),
    0.0
  );

  vec4 centerSample = texture(u_texture_input, textureUv(sampleUv));
  vec4 redSample = texture(
    u_texture_input,
    textureUv(sampleUv + chromaOffset)
  );
  vec4 blueSample = texture(
    u_texture_input,
    textureUv(sampleUv - chromaOffset)
  );
  vec3 color = vec3(redSample.r, centerSample.g, blueSample.b);

  float logicalY = fragCoord.y / max(u_device_pixel_ratio, 1.0);
  float scanline = 0.5 + 0.5 * sin(logicalY * 1.57079632679);
  color *= 1.0 - scanline * u_scanline_intensity * 0.42;

  float logicalX = fragCoord.x / max(u_device_pixel_ratio, 1.0);
  float phosphor = mod(floor(logicalX), 3.0);
  vec3 phosphorMask = phosphor < 1.0
      ? vec3(1.0, 0.94, 0.94)
      : (phosphor < 2.0
          ? vec3(0.94, 1.0, 0.94)
          : vec3(0.94, 0.94, 1.0));
  color *= mix(vec3(1.0), phosphorMask, 0.45);

  vec2 noiseCell = floor(fragCoord / max(u_device_pixel_ratio, 1.0) * 0.5);
  float noiseFrame = floor(u_time * 30.0);
  float noise = hash21(noiseCell + vec2(noiseFrame, noiseFrame * 0.37));
  color += (noise - 0.5) * u_noise_intensity * 0.38;

  float flicker = sin(u_time * 47.0) * 0.5 + 0.5;
  color *= 1.0 - flicker * u_flicker_intensity * 0.12;

  vec2 vignetteAxes = abs(centered);
  vec2 vignettePowers = pow(vignetteAxes, vec2(6.0));
  float vignetteShape = pow(
    vignettePowers.x + vignettePowers.y,
    1.0 / 6.0
  );
  float vignette = smoothstep(0.55, 1.05, vignetteShape);
  color *= 1.0 - vignette * u_vignette_intensity * 0.82;

  float outside = step(1.0, max(abs(curved.x), abs(curved.y)));
  color = mix(color, vec3(0.0), outside);

  frag_color = vec4(clamp(color, 0.0, 1.0), centerSample.a);
}

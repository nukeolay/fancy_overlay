#include <flutter/runtime_effect.glsl>

uniform vec2 u_size;
uniform float u_phase;
uniform float u_distortion_strength;
uniform float u_wave_scale;
uniform float u_direction;
uniform float u_chromatic_aberration;
uniform float u_device_pixel_ratio;
uniform sampler2D u_texture_input;

out vec4 frag_color;

float hash21(vec2 value) {
  return fract(
    sin(dot(value, vec2(127.1, 311.7))) * 43758.5453123
  );
}

float valueNoise(vec2 position) {
  vec2 cell = floor(position);
  vec2 local = fract(position);
  vec2 smoothLocal = local * local * (3.0 - 2.0 * local);

  float bottomLeft = hash21(cell);
  float bottomRight = hash21(cell + vec2(1.0, 0.0));
  float topLeft = hash21(cell + vec2(0.0, 1.0));
  float topRight = hash21(cell + vec2(1.0, 1.0));

  float bottom = mix(bottomLeft, bottomRight, smoothLocal.x);
  float top = mix(topLeft, topRight, smoothLocal.x);
  return mix(bottom, top, smoothLocal.y);
}

vec2 waveGradient(vec2 position, float phase) {
  vec2 directionA = vec2(1.0, 0.0);
  vec2 directionB = vec2(0.5547002, 0.8320503);
  vec2 directionC = vec2(-0.7808688, 0.6246950);
  vec2 directionD = vec2(-0.2425356, -0.9701425);

  float angleA = dot(position, directionA) * 1.00 + phase;
  float angleB = dot(position, directionB) * 1.47 + phase * 2.0;
  float angleC = dot(position, directionC) * 2.13 + phase * 3.0;
  float angleD = dot(position, directionD) * 2.71 + phase * 4.0;

  return
      directionA * (0.36 * 1.00 * cos(angleA)) +
      directionB * (0.28 * 1.47 * cos(angleB)) +
      directionC * (0.22 * 2.13 * cos(angleC)) +
      directionD * (0.14 * 2.71 * cos(angleD));
}

float waveCompression(vec2 position, float phase) {
  vec2 directionA = vec2(1.0, 0.0);
  vec2 directionB = vec2(0.5547002, 0.8320503);
  vec2 directionC = vec2(-0.7808688, 0.6246950);
  vec2 directionD = vec2(-0.2425356, -0.9701425);

  float angleA = dot(position, directionA) * 1.00 + phase;
  float angleB = dot(position, directionB) * 1.47 + phase * 2.0;
  float angleC = dot(position, directionC) * 2.13 + phase * 3.0;
  float angleD = dot(position, directionD) * 2.71 + phase * 4.0;

  return
      0.36 * 1.00 * 1.00 * sin(angleA) +
      0.28 * 1.47 * 1.47 * sin(angleB) +
      0.22 * 2.13 * 2.13 * sin(angleC) +
      0.14 * 2.71 * 2.71 * sin(angleD);
}

vec2 textureUv(vec2 uv) {
  uv = clamp(uv, vec2(0.0), vec2(1.0));
#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif
  return uv;
}

void main() {
  float dpr = max(u_device_pixel_ratio, 1.0);
  vec2 physicalPosition = FlutterFragCoord().xy;
  vec2 logicalPosition = physicalPosition / dpr;
  vec2 logicalSize = max(u_size / dpr, vec2(1.0));
  vec2 baseUv = logicalPosition / logicalSize;

  float safeWaveScale = max(u_wave_scale, 1.0);
  vec2 wavePosition = logicalPosition / safeWaveScale;
  vec2 phaseOrbit = vec2(cos(u_phase), sin(u_phase));
  vec2 directionVector = vec2(cos(u_direction), sin(u_direction));
  vec2 noisePosition =
      wavePosition * 0.72 +
      phaseOrbit * 0.58 +
      directionVector * (sin(u_phase) * 0.32);
  vec2 noiseWarp = vec2(
    valueNoise(noisePosition),
    valueNoise(noisePosition + vec2(17.13, 9.71))
  ) - vec2(0.5);
  vec2 warpedPosition = wavePosition + noiseWarp * 0.68;

  vec2 gradient = waveGradient(warpedPosition, u_phase);
  float gradientLength = length(gradient);
  vec2 boundedGradient = gradient / (1.0 + gradientLength);
  vec2 displacementLogical =
      boundedGradient * (24.0 * u_distortion_strength);
  vec2 displacedUv = baseUv + displacementLogical / logicalSize;

  vec2 normal = gradient / max(gradientLength, 0.0001);
  vec2 chromaOffset =
      normal * u_chromatic_aberration / logicalSize;
  vec4 centerSample = texture(u_texture_input, textureUv(displacedUv));
  vec4 redSample = texture(
    u_texture_input,
    textureUv(displacedUv + chromaOffset)
  );
  vec4 blueSample = texture(
    u_texture_input,
    textureUv(displacedUv - chromaOffset)
  );
  vec3 color = vec3(redSample.r, centerSample.g, blueSample.b);

  float compression = max(
    waveCompression(warpedPosition, u_phase),
    0.0
  );
  float caustic = 1.0 + 0.045 * u_distortion_strength *
      smoothstep(0.18, 1.35, compression);
  color *= caustic;

  frag_color = vec4(clamp(color, 0.0, 1.0), centerSample.a);
}

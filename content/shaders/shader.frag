extern number distortion = 0.1;
extern number aberration = 2.0;
vec4 effect(vec4 color, Image tx, vec2 tc, vec2 pc)
{
  // curvature
  vec2 cc = tc - 0.5f;
  float dist = dot(cc, cc)*distortion;
  tc = (tc + cc * (1.0f + dist) * dist);

  // fake chromatic aberration
  float sx = aberration/love_ScreenSize.x;
  float sy = aberration/love_ScreenSize.y;
  vec4 r = Texel(tx, vec2(tc.x + sx, tc.y - sy));
  vec4 g = Texel(tx, vec2(tc.x, tc.y + sy));
  vec4 b = Texel(tx, vec2(tc.x - sx, tc.y - sy));
  number a = (r.a + g.a + b.a)/3.0;

  return vec4(r.r, g.g, b.b, a);
}
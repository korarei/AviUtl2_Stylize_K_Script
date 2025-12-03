Texture2D src : register(t0);
SamplerState smp : register(s0);
cbuffer params : register(b0) {
    column_major float2x2 rm;
    float2 center;
    float2 output;
    float2 scale;
    float2 mirror;
    float2 phase_dir;
    float phase;
    float aspect;
};

static const float eps = 1.0e-4;

struct PS_Input {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD;
};

float4 wrap(float2 pos) {
    const float2 idx = floor(pos);
    const float2 odd = frac(idx * 0.5) * 2.0;
    const float2 uv = pos - idx;

    return src.Sample(smp, lerp(uv, 1.0 - uv, mirror * odd));
}

float4 motion_tile(PS_Input input) : SV_Target {
    float2 pos = mad(input.uv, output, -center);
    pos.y *= aspect;
    pos = mul(rm, pos) * rcp(max(scale, eps));
    pos.y *= rcp(aspect);
    pos += 0.5;

    const float2 odd = frac(floor(pos) * 0.5) * 2.0;
    pos -= phase * odd.yx * phase_dir;

    return wrap(pos);
}

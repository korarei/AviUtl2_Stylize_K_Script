Texture2D src : register(t0);
SamplerState src_smp : register(s0);
cbuffer params : register(b0) {
    float2 tex_size;
    float2 center;
    float2 output_gain;
    float2 tile_gain;
    float2 mirror;
    float phase;
    float h_shift;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 tiler(float2 pos) {
    int2 idx = int2(floor(pos));
    float2 parity = float2(idx & 1);
    float2 uv = pos - idx;
    float2 coord = lerp(uv, 1.0 - uv, mirror * parity);

    float2 e = 0.5 * rcp(tex_size);
    return src.Sample(src_smp, clamp(coord, e, 1.0 - e));
}

float4 motion_tile(PS_INPUT input) : SV_Target {
    float2 pos = input.uv * output_gain;
    pos -= 0.5 * output_gain + center;
    pos /= max(tile_gain, 1.0e-5);
    pos += 0.5;

    float2 parity = float2(int2(floor(pos)) & 1);
    float2 shift_dir = parity.yx * float2(h_shift, 1.0 - h_shift);
    pos -= shift_dir * phase;

    return tiler(pos);
}

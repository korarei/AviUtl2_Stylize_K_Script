Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);
cbuffer constant0 : register(b0) {
    float2 map_size;
    float map_slice;
    float map_scale;
    float map_shift;
    float map_edges;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 map_viewer(PS_INPUT input) : SV_Target {
    float2 map_uv = edit_map(input.uv.x, map_slice, map_scale, map_shift, map_edges);
    float2 e = 0.5 * rcp(map_size);
    return texture0.Sample(sampler0, clamp(map_uv, e, 1.0 - e));
}

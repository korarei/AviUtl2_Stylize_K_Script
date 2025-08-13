Texture2D texture0 : register(t0);
Texture2D map : register(t1);
SamplerState map_smp : register(s1);
cbuffer constant0 : register(b0) {
    float2 map_size;
    float map_slice;
    float map_scale;
    float map_shift;
    float map_edges;
    float inv_luma;
    float luma_mode;
    float color_space;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 gradient_map(PS_INPUT input) : SV_Target {
    float4 tex = texture0.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);

    float4 lin_col = to_linear(col, color_space);
    float luma = saturate(calc_luma(lin_col.rgb, luma_mode));
    luma = lerp(luma, 1.0 - luma, inv_luma);
    float2 map_uv = edit_map(luma, map_slice, map_scale, map_shift, map_edges);

    float2 e = 0.5 * rcp(map_size);
    float4 out_col = map.Sample(map_smp, clamp(map_uv, e, 1.0 - e));
    return float4(out_col.rgb * tex.a, tex.a);
}

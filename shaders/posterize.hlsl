Texture2D texture0 : register(t0);
cbuffer constant0 : register(b0) {
    float multi_channel_mode;
    float3 levels;
    float level;
    float use_value;
    float color_space;
    float mix;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 quantize_col(float4 col) {
    const float adj = 255.0 * rcp(256.0);
    if (bool(multi_channel_mode)) {
        return float4(floor(col.rgb * levels * adj) * rcp(levels - 1.0), col.a);
    } else if (bool(use_value)) {
        float3 rgb = saturate(col.rgb);
        float3 hsv = rgb2hsv(rgb);
        hsv.z = saturate(floor(hsv.z * level * adj) * rcp(level - 1.0));
        return float4(hsv2rgb(hsv), col.a);
    } else {
        return float4(floor(col.rgb * level * adj) * rcp(level - 1.0), col.a);
    }
}

float4 posterize(PS_INPUT input) : SV_Target {
    float4 tex = texture0.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);

    float4 lin_col = to_linear(col, color_space);
    float4 q_col = quantize_col(lin_col);
    float4 out_col = to_gamma(q_col, color_space);
    float4 out_tex = premul_col(out_col);

    return lerp(tex, out_tex, mix);
}

Texture2D src : register(t0);
cbuffer params : register(b0) {
    float level;
    float channel;
    float col_space;
    float mix;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 quantize_col(float4 col) {
    const float adj = 255.0 * rcp(256.0);

    uint mode = uint(channel);
    float flag = float(mode % 2);
    switch (mode / 2) {
        case 0: {
            float4 q = floor(col * level * adj) * rcp(max(level - 1.0, 1.0));
            return lerp(float4(q.rgb, col.a), q, flag);
        }
        case 1: {
            float3 rgb = saturate(col.rgb);
            float4 hsva = float4(rgb2hsv(rgb), col.a);
            hsva.zw = saturate(floor(hsva.zw * level * adj) * rcp(max(level - 1.0, 1.0)));
            float4 q = float4(hsv2rgb(hsva.xyz), hsva.a);
            return lerp(float4(q.rgb, col.a), q, flag);
        }
        default:
            return col;
    }
}

float4 posterize(PS_INPUT input) : SV_Target {
    float4 tex = src.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);

    float4 lin_col = to_linear(col, col_space);
    float4 q_col = quantize_col(lin_col);
    float4 out_col = to_gamma(q_col, col_space);
    float4 out_tex = premul_col(out_col);

    return lerp(tex, out_tex, mix);
}

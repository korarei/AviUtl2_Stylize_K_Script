Texture2D src : register(t0);
cbuffer params : register(b0) {
    float4 levels;
    float disable_a;
    float col_space;
    float mix;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 posterize_rgba(PS_INPUT input) : SV_Target {
    const float adj = 255.0 * rcp(256.0);

    float4 tex = src.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);

    float4 lin_col = to_linear(col, col_space);
    float4 q_col = floor(lin_col * levels * adj) * rcp(max(levels - 1.0, 1.0));
    q_col.a = lerp(q_col.a, lin_col.a, disable_a);
    float4 out_col = to_gamma(q_col, col_space);
    float4 out_tex = premul_col(out_col);

    return lerp(tex, out_tex, mix);
}

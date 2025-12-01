Texture2D src : register(t0);
cbuffer params : register(b0) {
    float4 threshold;
    float4 inv;
    float disable_a;
    float col_space;
    float mix;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 thresholding_rgba(PS_INPUT input) : SV_Target {
    float4 tex = src.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);

    float4 lin_col = to_linear(col, col_space);
    float4 val = lerp(lin_col, saturate(1.0 - lin_col), inv);
    float4 b_col = step(threshold, val);
    b_col.a = lerp(b_col.a, lin_col.a, disable_a);
    float4 out_col = to_gamma(b_col, col_space);
    float4 out_tex = premul_col(out_col);

    return lerp(tex, out_tex, mix);
}

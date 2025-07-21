Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);
cbuffer constant0 : register(b0) {
    float4 threshold;
    float4 inv;
    float disable_a;
    float color_space;
    float mix;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 thresholding_rgba(PS_INPUT input) : SV_Target {
    float4 tex = texture0.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);

    float4 lin_col = to_linear(col, color_space);
    float4 val = lerp(lin_col, saturate(1.0 - lin_col), inv);
    float4 b_col = step(threshold, val);
    b_col.a = lerp(b_col.a, lin_col.a, disable_a);
    float4 out_col = to_gamma(b_col, color_space);
    float4 out_tex = premul_col(out_col);

    return lerp(tex, out_tex, mix);
}

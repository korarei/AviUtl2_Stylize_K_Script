Texture2D texture0 : register(t0);
cbuffer constant0 : register(b0) {
    float gain;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 unpremult(PS_INPUT input) : SV_Target {
    float4 tex = texture0.Load(int3(input.pos.xy, 0));
    float alpha = max(max(tex.r, tex.g), tex.b);
    return float4(tex.rgb * saturate(gain), saturate(alpha * gain));
}

Texture2D src : register(t0);
cbuffer params : register(b0) {
    float2 blocks;
    float2 res;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 mosaic_point(PS_INPUT input) : SV_Target {
    float2 block_size = res * rcp(blocks);
    int2 block_idx = int2(input.pos.xy * rcp(block_size));
    int2 pos = int2((block_idx + 0.5) * block_size);
    return src.Load(int3(clamp(pos, 0, int2(res) - 1), 0));
}

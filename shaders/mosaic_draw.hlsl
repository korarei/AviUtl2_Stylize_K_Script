Texture2D map : register(t0);
cbuffer params : register(b0) {
    float2 blocks;
    float2 res;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 mosaic_draw(PS_INPUT input) : SV_Target {
    int2 block_idx = int2(input.pos.xy * blocks * rcp(res));
    return map.Load(int3(block_idx, 0));
}

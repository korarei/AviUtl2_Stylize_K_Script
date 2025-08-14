Texture2D mosaic : register(t0);
Texture2D glyph_map : register(t1);
cbuffer params : register(b0) {
    float2 blocks;
    float2 res;
    float2 map_size;
    float2 luma_range;
    float glyph_len;
    float luma_gain;
    float luma_mode;
    float inv_luma;
    float glyph_type;
    float glyph_col;
    float col_space;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float get_glyph_shape(uint2 pos, uint glyph_idx, float block_w) {
    uint map_idx = glyph_idx % 3;
    uint2 st = uint2(uint(block_w * (glyph_idx / 3)), 0);
    uint2 map_pos = min(st + pos, uint2(map_size) - 1);
    float4 glyphs = glyph_map.Load(int3(map_pos, 0));
    return glyphs[map_idx];
}

float4 ascii(PS_INPUT input) : SV_Target {
    const float adj = 255.0 * rcp(256.0);

    float4 tex = mosaic.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);
    float4 lin_col = to_linear(col, col_space);
    float luma = saturate(calc_luma(lin_col.rgb, luma_mode) * luma_gain);
    luma = lerp(luma, 1.0 - luma, inv_luma);

    float2 block_size = res * rcp(blocks);
    uint2 block_idx = uint2(input.pos.xy * rcp(block_size));
    uint2 pos = input.pos.xy - uint2(block_idx * block_size);
    uint glyph_idx = uint(luma * glyph_len * adj);
    float shape = get_glyph_shape(pos, glyph_idx, block_size.x);

    float flag = step(2.0, glyph_type);
    float4 glyph = lerp(decode_col(glyph_col, shape), float4(col.rgb, shape), flag);
    float mask = step(luma_range.x, luma) * step(luma, luma_range.y);
    return lerp(float4(0.0, 0.0, 0.0, 0.0), premul_col(glyph), mask);
}

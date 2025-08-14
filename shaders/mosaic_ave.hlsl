RWTexture2D<half4> tex_out : register(u0);
Texture2D tex_in : register(t0);
cbuffer params : register(b0) {
    float2 blocks;
    float2 res;
    float total_groups;
    float total_blocks;
};

struct CS_INPUT {
    uint3 gid : SV_GroupID;
    uint3 gtid : SV_GroupThreadID;
    uint gidx : SV_GroupIndex;
};

groupshared float4 col_buf[64];
groupshared uint cnt_buf[64];

[numthreads(8, 8, 1)]
void mosaic_ave(CS_INPUT input) {
    for (uint i = input.gid.x; i < uint(total_blocks); i += uint(total_groups)) {
        uint map_w = uint(blocks.x);
        uint2 block_idx = uint2(i % map_w, i / map_w);
        float2 block_size = res * rcp(blocks);
        uint2 st = uint2(block_idx * block_size);
        uint2 ed = min(uint2((block_idx + 1) * block_size), uint2(res));

        float4 l_col = float4(0.0, 0.0, 0.0, 0.0);
        uint l_cnt = 0;
        for (uint y = st.y + input.gtid.y; y < ed.y; y += 8) {
            for (uint x = st.x + input.gtid.x; x < ed.x; x += 8) {
                l_col += tex_in[uint2(x, y)];
                l_cnt++;
            }
        }
        col_buf[input.gidx] = l_col;
        cnt_buf[input.gidx] = l_cnt;

        GroupMemoryBarrierWithGroupSync();
        for (uint s = 32; s > 0; s >>= 1) {
            if (input.gidx < s) {
                col_buf[input.gidx] += col_buf[input.gidx + s];
                cnt_buf[input.gidx] += cnt_buf[input.gidx + s];
            }
            GroupMemoryBarrierWithGroupSync();
        }

        if (input.gidx == 0) {
            float4 col = col_buf[0];
            uint cnt = cnt_buf[0];
            tex_out[block_idx] = col * rcp(max(cnt, 1));
        }
    }
}

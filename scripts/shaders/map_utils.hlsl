float2 edit_map(float luma, float slice, float scale, float shift, float edges) {
    float map_u = (luma - shift) * rcp(max(scale, EPSILON));

    switch (int(edges)) {
        case 0:
            map_u = saturate(map_u);
            break;
        case 1:
        case 2:
            int idx = int(floor(map_u));
            float parity = float(idx & 1);
            float u = map_u - idx;
            map_u = lerp(u, 1.0 - u, step(2.0, edges) * parity);
            break;
    }

    return float2(map_u, slice);
}

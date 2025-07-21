inline float mod(float x, float y) {
    return x - y * floor(x / y);
}

float2 edit_map(float luma, float slice, float scale, float shift, float edges) {
    float map_u = (luma - shift) / max(scale, EPSILON);

    switch (int(edges)) {
        case 0:
            map_u = saturate(map_u);
            break;
        case 1:
        case 2:
            float idx = floor(map_u);
            float parity = mod(idx, 2.0);
            float u = map_u - idx;
            map_u = lerp(u, 1.0 - u, step(2.0, edges) * parity);
            break;
    }
    
    return float2(map_u, slice);
}

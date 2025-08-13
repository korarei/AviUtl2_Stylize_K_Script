Texture2D texture0 : register(t0);
cbuffer constant0 : register(b0) {
    float threshold;
    float channel;
    float inv;
    float light_col;
    float light_a;
    float dark_col;
    float dark_a;
    float color_space;
    float mix;
};

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

float4 luminance_thresholding(float4 col) {
    float val = calc_luma(col.rgb, channel);
    val = lerp(val, saturate(1.0 - val), inv);
    float mask = step(threshold, val);
    float4 dark = decode_col(dark_col, dark_a * col.a);
    float4 light = decode_col(light_col, light_a * col.a);
    return lerp(dark, light, mask);
}

float4 hsv_thresholding(float4 col) {
    float3 rgb = saturate(col.rgb);
    float3 hsv = rgb2hsv(rgb);
    float val = 0.0;
    switch (int(channel)) {
        case 3: // Value
            val = hsv.z;
            break;
        case 4: // Saturation
            val = hsv.y;
            break;
        case 5: // Hue
            val = hsv.x;
            break;
    }

    val = lerp(val, saturate(1.0 - val), inv);
    float mask = step(threshold, val);
    float4 dark = decode_col(dark_col, dark_a * col.a);
    float4 light = decode_col(light_col, light_a * col.a);
    return lerp(dark, light, mask);
}

float4 alpha_thresholding(float4 col) {
    float val = lerp(col.a, saturate(1.0 - col.a), inv);
    float mask = step(threshold, val);
    return lerp(float4(0.0, 0.0, 0.0, 0.0), float4(col.rgb, 1.0), mask);
}

float4 thresholding(PS_INPUT input) : SV_Target {
    float4 tex = texture0.Load(int3(input.pos.xy, 0));
    float4 col = unpremul_col(tex);

    float4 lin_col = to_linear(col, color_space);
    float4 b_col = lin_col;

    switch (int(channel)) {
        case 0: // Luminance BT.601
        case 1: // Luminance BT.709
        case 2: // Luminance BT.2020
            b_col = luminance_thresholding(lin_col);
            break;
        case 3: // Value
        case 4: // Saturation
        case 5: // Hue
            b_col = hsv_thresholding(lin_col);
            break;
        case 6: // Alpha
            b_col = alpha_thresholding(lin_col);
            break;
    }

    float4 out_col = to_gamma(b_col, color_space);
    float4 out_tex = premul_col(out_col);

    return lerp(tex, out_tex, mix);
}

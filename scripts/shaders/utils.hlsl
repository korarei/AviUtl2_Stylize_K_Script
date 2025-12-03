float EPSILON = 1.0e-5;

inline bool is_zero(float val) {
    return abs(val) < EPSILON;
}

inline bool are_equal(float a, float b) {
    return abs(a - b) < EPSILON;
}

inline float4 unpremul_col(float4 col) {
    if (is_zero(col.a)) discard;
    return float4(saturate(col.rgb * rcp(col.a)), col.a);
}

inline float4 premul_col(float4 col) {
    return float4(col.rgb * col.a, col.a);
}

float4 decode_col(float code, float a) {
    uint col = (uint)code;
    float3 rgb = float3(
        (col >> 16) & 0xFF,
        (col >> 8) & 0xFF,
        col & 0xFF
    ) * rcp(255.0);
    return float4(rgb, a);
}

float calc_luma(float3 col, int mode) {
    float3 luma_weights = float3(0.2126, 0.7152, 0.0722); // Default to BT.709
    switch (mode) {
        case 0: // Luminance BT.601
            luma_weights = float3(0.299, 0.587, 0.114);
            break;
        case 2: // Luminance BT.2020
            luma_weights = float3(0.2627, 0.6780, 0.0593);
            break;
    }
    return dot(col, luma_weights);
}

float3 rgb2hsv(float3 rgb) {
    float4 k = float4(0.0, -rcp(3.0), 2.0 * rcp(3.0), -1.0);
    float4 p = lerp(float4(rgb.bg, k.wz), float4(rgb.gb, k.xy), step(rgb.b, rgb.g));
    float4 q = lerp(float4(p.xyw, rgb.r), float4(rgb.r, p.yzx), step(p.x, rgb.r));
    
    float d = q.x - min(q.w, q.y);
    return float3(abs(q.z + (q.w - q.y) * rcp(6.0 * d + EPSILON)), d * rcp(q.x + EPSILON), q.x);
}

float3 hsv2rgb(float3 hsv) {
    float4 k = float4(1.0, 2.0 * rcp(3.0), rcp(3.0), 3.0);
    float3 p = abs(frac(hsv.xxx + k.xyz) * 6.0 - k.www);
    return hsv.z * lerp(k.xxx, clamp(p - k.xxx, 0.0, 1.0), hsv.y);
}

float4 to_linear(float4 col, int mode) {
    switch (mode) {
        case 0:
            return col;
        case 1:
            float3 t = step(col.rgb, 0.04045);
            float3 low = col.rgb * rcp(12.92);
            float3 high = pow(abs((col.rgb + 0.055) * rcp(1.055)), 2.4);
            return float4(lerp(high, low, t), col.a);
        default:
            return col;
    }
}

float4 to_gamma(float4 col, int mode) {
    switch (mode) {
        case 0:
            return saturate(col);
        case 1:
            float3 t = step(col.rgb, 0.0031308);
            float3 low = 12.92 * col.rgb;
            float3 high = 1.055 * pow(abs(col.rgb), rcp(2.4)) - 0.055;
            return saturate(float4(lerp(high, low, t), col.a));
        default:
            return saturate(col);
    }
}

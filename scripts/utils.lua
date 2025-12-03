local function copy_geo(dst, src)
    for k in ("ox, oy, oz, cx, cy, cz, rx, ry, rz, zoom, aspect, alpha"):gmatch("%a+") do
        dst[k] = src[k]
    end
end
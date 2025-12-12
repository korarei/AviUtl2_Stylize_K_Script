local function copy_geo(dst, src)
    for k in ("cx, cy, cz, ox, oy, oz, rx, ry, rz, sx, sy, sz, alpha"):gmatch("%a+") do
        dst[k] = src[k]
    end
end
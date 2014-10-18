include("util.jl")

reload("noise.jl")
using Noise

noisefn = (x, y) -> perlin(get_gradient, x, y)

minr, maxr = 0, 0

render_by_pixels("perl", 0,0, 5,5, 100) do x,y
    r = noisefn(x, y)
    global minr, maxr
    minr = min(r, minr)
    maxr = max(r, maxr)
    r = r + 1/2
    RGB(r,r,r)
end

println("range ", minr, "   ", maxr)

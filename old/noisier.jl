include("util.jl")

reload("noise.jl")
using Noise

tan = RGB(0xe4/255, 0xce/255, 0x86/255)
green = RGB(0x70/255, 0xaf/255, 0x00/255)
brown = RGB(0x7e/255, 0x63/255, 0x1f/255)

function thisnoise(x, y)
    simplex(get_gradient, x, y)
end

render_by_pixels("noisier", 0, 0, 8, 8, 70) do x,y
    r = noise_sum(thisnoise, 4, 1.15, 2., x, y) 
    r = if r > 0 1 else 0 end
    RGB(r,r,r)
end


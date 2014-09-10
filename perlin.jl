include("util.jl")

reload("noise.jl")
using Noise

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

tan = RGB(0xe4/255, 0xce/255, 0x86/255)
green = RGB(0x70/255, 0xaf/255, 0x00/255)
brown = RGB(0x7e/255, 0x63/255, 0x1f/255)

noisefn = (x, y) -> perlin(get_gradient, x, y)

render_by_pixels("perl", 0,0, 5,5, 200) do x,y
    ## pattern 1
    #n = octaves(noisefn, 5, 1., x, y)
    #r = real_to_01(n)   # go from (-1,1) to (0,1)
    ## pattern 2
    #m = octaves(noisefn, 4, 2.0, x, y)
    #m = real_to_01(m)
    #if m > .65
    #    brown
    #elseif r > .53
    #    green
    #else
    #    tan
    #end
    r = noisefn(x, y)
    RGB(r,r,r)
end


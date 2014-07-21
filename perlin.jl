include("util.jl")

reload("noise.jl")
using Noise

img = makeImage(0, 0, 13, 11, 50)

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

tan = RGB(0xe4/255, 0xce/255, 0x86/255)
green = RGB(0x70/255, 0xaf/255, 0x00/255)
brown = RGB(0x7e/255, 0x63/255, 0x1f/255)

noisefn = (g, s, x, y) -> real_to_01(simplex(g, s, x, y))

each_pixel(img) do x,y
    # pattern 1
    n = noisefn(get_gradient, 1, x, y)*8/15
    n += noisefn(get_gradient, .5, x, y)*4/15
    n += noisefn(get_gradient, 0.25, x, y)*2/15
    n += noisefn(get_gradient, 0.125, x, y)*1/15
    r = n # (n+1)/2   # go from (-1,1) to (0,1)
    # pattern 2
    m = noisefn(get_gradient, .7, x, y)*2/3
    m += noisefn(get_gradient, .3, x, y)*1/3
    if m > .62
        brown
    elseif r > .53
        green
    else
        tan
    end
    #RGB(r,r,r)
end

green = RGB(0, 1, 0)
red = RGB(1, 0, 0)

imwrite(img.data, "perl.png")
    

    
    


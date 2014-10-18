include("util.jl")

reload("noise.jl")
using Noise

img = makeImage(0, 0, 5,5, 80)

tan = RGB(0xe4/255, 0xce/255, 0x86/255)
green = RGB(0x70/255, 0xaf/255, 0x00/255)
darkgreen = RGB(0x71/255, 0x9d/255, 0x24/255)
water = RGB(.35,.35,1)

each_pixel(img) do x,y
    turb = octaves((x,y)->simplex(get_gradient, x, y), 4, x, y)
    r = (sin(sqrt(x*x + y*y) +4*turb)+1)/2
    #RGB(r,r,r)
    if r > .5
        green
    elseif r > .3
        tan
    else
        water
    end
end

imwrite(img.data, "turb.png")


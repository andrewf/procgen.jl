include("util.jl")

reload("noise.jl")
using Noise

img = makeImage(0, 0, 20, 20, 20)

tan = RGB(0xe4/255, 0xce/255, 0x86/255)
green = RGB(0x70/255, 0xaf/255, 0x00/255)
darkgreen = RGB(0x71/255, 0x9d/255, 0x24/255)
water = RGB(.35,.35,1)

each_pixel(img) do x,y
    r = valuenoise(default_get_value, x/2,y/2)*8/15
    r += valuenoise(default_get_value, x, y)*4/15
    r += valuenoise(default_get_value, 2x, 2y)*2/15
    r += valuenoise(default_get_value, 4x, 4y)*1/15
    if r > .8
        darkgreen
    elseif r > .6
        green
    elseif r > .5
        tan
    else
        water
    end
end

imwrite(img.data, "land.png")

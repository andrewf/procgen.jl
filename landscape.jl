include("util.jl")

reload("noise.jl")
using Noise

img = makeImage(0, 0, 13, 13, 50)

tan = RGB(0xe4/255, 0xce/255, 0x86/255)

each_pixel(img) do x,y
    r = valuenoise(default_get_value, x/2,y/2)*8/15
    r += valuenoise(default_get_value, x, y)*4/15
    r += valuenoise(default_get_value, 2x, 2y)*2/15
    r += valuenoise(default_get_value, 4x, 4y)*1/15
    if r > .5
        tan
    else
        RGB(.35,.35,1)
    end
end

imwrite(img.data, "land.png")

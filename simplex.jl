include("util.jl")

reload("noise.jl")
using Noise

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

img = makeImage(0, 0, 5, 5, 160)

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1.0)

function rplus_to_01(x)
    1/(x+1)
end

function thisnoise(x, y)
    simplex(get_gradient, x, y)
end

each_pixel(img) do x,y
    n = abs(octaves((x,y)->perlin(get_gradient, x, y), 4, 2.0, x, y))
    m = real_to_01(simplex(get_gradient, x/1, y/1))
    r = m*(1-n)
    #r = if m*(1-n) > .5 1 else 0 end
    RGB(r,r,r)
end

imwrite(img.data, "simplex.png")


include("util.jl")

reload("noise.jl")
using Noise

img = makeImage(0, 0, 2, 2, 300)

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1.0)

function thisnoise(x, y)
    simplex(get_gradient, x, y)
end

each_pixel(img) do x,y
    nx = 2*octaves((x,y)->abs(2*perlin(get_gradient, x, y)), 4, 1.0, x, y)
    ny = 2*octaves((x,y)->abs(2*perlin(get_gradient, x, y)), 4, 1.0, -x, -y)
    m = simplex(get_gradient, x+nx, y+ny) |> real_to_01
    r = m #.3*m+ .7*(1-n)
    #r = if r > .5 1 else 0 end
    RGB(r,r,r)
end

imwrite(img.data, "simplex.png")


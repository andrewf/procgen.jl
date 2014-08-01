include("util.jl")

reload("noise.jl")
using Noise

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1.0)

function thisnoise(x, y)
    simplex(get_gradient, x, y)
end

render_by_pixels("simplex", 0, 0, 2, 2, 300) do x,y
    nx = 2*octaves((x,y)->abs(2*perlin(get_gradient, x, y)), 4, 1.0, x, y)
    ny = 2*octaves((x,y)->abs(2*perlin(get_gradient, x, y)), 4, 1.0, -x, -y)
    m = simplex(get_gradient, x+1.5nx, y+1.5ny) |> real_to_01
    r = m #.3*m+ .7*(1-n)
    #r = if r > .5 1 else 0 end
    RGB(r,r,r)
end


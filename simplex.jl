include("util.jl")

require("noise.jl")
using Noise

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

img = makeImage(0, 0, 5, 5, 100)

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1.0)

minVal = 0
maxVal = 0

function rplus_to_01(x)
    1/(x+1)
end

each_pixel(img) do x,y
    n = simplex(get_gradient, 1, x, y)
    n += simplex(get_gradient, .5, x, y)/2
    n += simplex(get_gradient, .25, x, y)/4
    n += simplex(get_gradient, .125, x, y)/8
    #n = abs(n)
    global minVal, maxVal
    minVal = min(minVal, n)
    maxVal = max(maxVal, n)
    r = real_to_01(n)
    RGB(r,r,1)
end

imwrite(img.data, "simplex.png")

println("range of [", minVal, ", ", maxVal, "]")
    


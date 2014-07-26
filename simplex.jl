include("util.jl")

reload("noise.jl")
using Noise

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

img = makeImage(0, 0, 5, 5, 80)

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1.0)

minVal = 0
maxVal = 0

function rplus_to_01(x)
    1/(x+1)
end

function thisnoise(x, y)
    simplex(get_gradient, x, y)
end

each_pixel(img) do x,y
    n = octaves(thisnoise, 4, 1.0, x, y)
    #n = abs(n)
    global minVal, maxVal
    minVal = min(minVal, n)
    maxVal = max(maxVal, n)
    r = real_to_01(n)
    RGB(r,r,r)
end

imwrite(img.data, "simplex.png")

println("range of [", minVal, ", ", maxVal, "]")
    


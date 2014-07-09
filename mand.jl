using Images
using Color

w = 1000
h = 1000

realw = 2.0
realh = 2.0

cx = w/2
cy = h/2

data = Array(RGB, h, w)
fill!(data, RGB(1,1,1))

# the array is a field covering [-2,2]x[-2,2] on the cartesian plane
# for every point therein we map it to the correct complex number
# before iterating it
println("generating")
for y in 1:h
    for x in 1:w
        c = (-2 + 4*x/w) + (-2 + 4*y/h)*im
        z = 0 + 0im
        iter = 0
        while abs(z) < 2.0 && iter < 200
            z = z^3 + c
            iter += 1
        end
        if iter == 200
            data[y,x] = RGB(0,0,0)
        else
            # greyscale depending on number of iterations it took to get out
            v = 1.0 - float(iter)/200.0
            data[y,x] = RGB(v,v,v)
        end
    end
end

println("writing img")
imwrite(data, "fractal.png")

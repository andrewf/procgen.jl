using Images
using Color

w = 1000
h = 1000

top = (-2, -2)  # that is, the least point on the image
dims = (4, 4)
res = 250 # px/u

data = Array(RGB, dims[2]*res, dims[1]*res)
fill!(data, RGB(1,1,1))

function u2px(pt)
    ux, uy = pt
    int(round(ux - top[1]))*res, int(round(uy - top[2]))
end

function px2u(pt)
    px, py = pt
    float(px)/res + top[1], float(py)/res + top[2]
end

function each_pixel(fn, img)
    for y in 1:(dims[2]*res)
        for x in 1:(dims[1]*res)
            u = px2u((x,y))
            img[y,x] = fn(u[1], u[2])
        end
    end
end

println("generating")
each_pixel(data) do x,y
    c = x + y*im
    z = 0 + 0im
    iter = 0
    while abs(z) < 2.0 && iter < 200
        z = z^2 + c
        iter += 1
    end
    if iter == 200
        v = 0
    else
        # greyscale depending on number of iterations it took to get out
        v = 1.0 - float(iter)/200.0
    end
    return RGB(v,v,v)
end


println("writing img")
imwrite(data, "fractal.png")

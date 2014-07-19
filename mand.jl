using Images
using Color

r = x -> int(round(x))

top = (-2.2,-2)  # that is, the least point on the image
dims = (4,4)
res = 200 # px/u

data = Array(RGB, r(dims[2]*res), r(dims[1]*res))
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

ITERATIONS = 200
RADIUS = 5.0

function escape_time(data, initfn, iterfn)
    each_pixel(data) do x,y
        c = x + y*im
        z = initfn(c)
        iter = 0
        while abs(z) < RADIUS && iter < ITERATIONS
            z = iterfn(z, c)
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
end

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

println("generating")
#each_pixel(data) do x,y
#    c = x + y*im
#    z = c^5 - 2c^4 + 3c^2 + 1
#    # derive color from z
#    d = z - c # distance traveled
#    return convert(RGB, HSV(240.0, real_to_01(real(z)), real_to_01(imag(z))))
#end

escape_time(
    data,
    # init pos -> init value
    c->c,
    # iterated function (curr, px) -> new
    (z,c)->z^2 + c
)


println("writing img")
imwrite(data, "fractal.png")

using Images
using Color
using Util
using Draw

img = makeImage(
        # position
        -2.2, -2,
        # dimensions
        4, 4,
        # resolution
        200  # px/u
      )

ITERATIONS = 200
RADIUS = 5.0

function escape_time(img, initfn, iterfn)
    each_pixel(img) do x,y
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

escape_time(
    img,
    # init pos -> init value
    c->c,
    # iterated function (curr, px) -> new
    (z,c)->z^2 + c
)

println("writing img")
writeout(img, "fractal.png")


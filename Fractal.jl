# module for doing escape-time fractals

module Fractal

export escape_time

using Draw

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



end  # module

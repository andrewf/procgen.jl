include("util.jl")

img = makeImage(0, 0, 10, 10, 50)

gridsize = (13, 11)

function dp(a::(Float64, Float64), b::(Float64, Float64))
    a[1]*b[1] + a[2]*b[2]
end

# short for unit point
function up(f)
    angle = f*2*pi/12  # twelfths of the circle
    (cos(angle), sin(angle))
end

#grads = [up(4), up(11), up(3), up(8), up(7), up(2), up(1), up(5), up(10), up(0), up(6), up(9)]
grads = (Float64, Float64)[]
for i in 1:17
    th = rand()*2*pi
    push!(grads, (cos(th), sin(th)))
end

function interp(x::Float64)
    x*x*x*(6*x*x - 15*x + 10)
end

assert(interp(0.0) == 0.0)
assert(interp(1.0) == 1.0)

function get_gradient(x::Int, y::Int)
    # mod them by the size to make them loop
    # xor them to "hash" them
    # mod by size of grad array
    x = x % (gridsize[1] + 1)
    y = y % (gridsize[2] + 1)
    r = (x $ y) ^ 13
    grads[ r % length(grads) + 1 ]
end

function noise(gridspace, x::Float64, y::Float64)
    # divrem does the right thing for finding fractional part
    xgrid, xrem = divrem(x, gridspace)  # lower grid coord, and fraction across the square
    ygrid, yrem = divrem(y, gridspace)
    xfrac, yfrac = xrem/gridspace, yrem/gridspace
    xgrid = r(xgrid)
    ygrid = r(ygrid)
    # height, I guess, as dictated by each gradient
    n_00 = dp(get_gradient(xgrid, ygrid), (xfrac, yfrac) )
    n_10 = dp(get_gradient(xgrid+1, ygrid), (xfrac-1, yfrac) )
    n_01 = dp(get_gradient(xgrid, ygrid+1), (xfrac, yfrac-1) )
    n_11 = dp(get_gradient(xgrid+1, ygrid+1), (xfrac-1, yfrac-1) )
    # now interp along each edge
    n_x0 = n_00*(1-interp(xfrac)) + n_10*interp(xfrac)  # top edge
    n_x1 = n_01*(1-interp(xfrac)) + n_11*interp(xfrac)  # bottom edge
    n_final = n_x0*(1-interp(yfrac)) + n_x1*interp(yfrac)
    n_final
end

img = makeImage(0, 0, 10, 10, 50)

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

each_pixel(img) do x,y
    n = noise(1, x, y)
    n += noise(.5, x, y)/2
    n += noise(0.25, x, y)/4
    r = real_to_01(n)
    #r = (n+1)/2
    if r > .55
        RGB(0,0,0)
    else
        RGB(1,1,1)
    end
    #RGB(r,r,r)
end

green = RGB(0, 1, 0)
red = RGB(1, 0, 0)

#for y in 1:gridsize[2]
#    for x in 1:gridsize[1]
#        start = (float(x*gridspace), float(y*gridspace))
#        finish = start + get_gradient(x, y)
#        start = u2px(img, start)
#        finish = u2px(img, finish)
#        naive_line(img, green, start[1],start[2], finish[1],finish[2])
#        # four points at the grid point
#        z, w = start
#        plot(img, (z, w), red)
#        plot(img, (z+1, w), red)
#        plot(img, (z, w+1), red)
#        plot(img, (z+1, w+1), red)
#    end
#end
        

imwrite(img.data, "perl.png")
    

    
    


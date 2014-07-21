module Noise

export perlin, simplex, get_gradient

gridsize = (13, 11)
grads = Array(Vector{Float64}, gridsize[2], gridsize[1])

function r(x)
    int(round(x))
end

for y in 1:gridsize[2]
    for x in 1:gridsize[1]
        theta = rand()*2*pi
        grads[y, x] = [cos(theta), sin(theta)]
    end
end

function get_gradient(x::Int, y::Int)
    # mod them by the size to make them loop
    # xor them to "hash" them
    # mod by size of grad array
    x = mod(x, gridsize[1])
    y = mod(y, gridsize[2])
    grads[y + 1, x + 1]
end

function dp(a::Array{Float64, 1}, b::Array{Float64, 1})
    a[1]*b[1] + a[2]*b[2]
end


# nice interpolation function
function interp(x::Float64)
    x*x*x*(6*x*x - 15*x + 10)
end

assert(interp(0.0) == 0.0)
assert(interp(1.0) == 1.0)

function perlin(gradient::Function, gridspace::Number, x::Float64, y::Float64)
    # divrem does the right thing for finding fractional part
    xgrid, xrem = divrem(x, gridspace)  # lower grid coord, and fraction across the square
    ygrid, yrem = divrem(y, gridspace)
    xfrac, yfrac = xrem/gridspace, yrem/gridspace
    xgrid = r(xgrid)
    ygrid = r(ygrid)
    # height, I guess, as dictated by each gradient
    n_00 = dp(gradient(xgrid, ygrid), [xfrac, yfrac] )
    n_10 = dp(gradient(xgrid+1, ygrid), [xfrac-1, yfrac] )
    n_01 = dp(gradient(xgrid, ygrid+1), [xfrac, yfrac-1] )
    n_11 = dp(gradient(xgrid+1, ygrid+1), [xfrac-1, yfrac-1] )
    # now interp along each edge
    n_x0 = n_00*(1-interp(xfrac)) + n_10*interp(xfrac)  # top edge
    n_x1 = n_01*(1-interp(xfrac)) + n_11*interp(xfrac)  # bottom edge
    # interp between top and bottom edges
    n_final = n_x0*(1-interp(yfrac)) + n_x1*interp(yfrac)
    # and actually that's it
    # as long as all the vectors are unit vectors, this is true
    assert(-1 <= n_final <= 1)
    n_final
end

# rows are images of (1,0) and (0,1) under transform
# from gradient space to real space
# transpose to make them into columns
# inv to get matrix for reverse transformation
to_square_space, to_real_space = let l = sqrt(2)/sqrt(3), theta = pi/12
    T = [(l*cos(-theta)) (l*sin(-theta)) ; (l*cos(pi/2+theta)) (l*sin(pi/2+theta))]
    #println("orig ", T)
    to_real_space = transpose(T)
    #println("trans ", to_real_space)
    to_square_space = inv(to_real_space)
    #println("inv'd ", to_square_space)
    to_square_space, to_real_space
end

function simplex(gradient::Function, sidelen::Number, x::Float64, y::Float64)
    # to figure out which corners to combine, we need to project everything
    # into space where simplices are squished into manageable squares
    P = [x; y]
    P = P*(1/sidelen)
    # from here, we can assume distance between squares in square space is 1
    P_squares = to_square_space*P  # side = 1
    # the grid square in which P resides
    cell_origin = map( c->int(floor(c)) , P_squares)   # side still = 1, want floor as int
    into = P - cell_origin   # distance of P into square
    opposite_corner = cell_origin + [1,1]
    middle_corner = if into[1] < into[2]
        cell_origin + [0, 1]  # y > x, upper half, upper corner
    else
        cell_origin + [1, 0]
    end
    # now, get them all back into real space by mul'ing them by inv matrix
    # and scaling them by sidelen
    corners = (cell_origin, middle_corner, opposite_corner)
    corners = map(corners) do corner
        sidelen*(to_real_space*corner), gradient(corner[1], corner[2])
    end
    # corners :: [(point, gradient)]
    # find contributions
    corners = map(corners) do tup
        #corner, grad = tup
        corner = tup[1]
        grad = tup[2]
        dist = ([x;y] - corner)/sidelen
        height = dp(dist, grad)
        # now attenuate it, somehow
        # I don't know how this works. It looks like the 0.7
        # figure is flexible (In fact Perlin says 0.6), but
        # you have to mess with the final scaling factor to compensate
        t = 0.7 - (dist[1]*dist[1] + dist[2]*dist[2])
        if t >= 0
            t = 8*t*t*t*t
            t*height
        else
            0
        end
    end
    2*sum(corners)
end




end

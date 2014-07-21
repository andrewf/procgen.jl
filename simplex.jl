include("util.jl")

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

gridsize = (13, 11)
grads = Array(Vector{Float64}, gridsize[2], gridsize[1])

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

img = makeImage(0, 0, 10, 10, 50)

# size of each simplex (triangle)
sidelen = 1.5

# rows are images of (1,0) and (0,1) under transform
# from gradient space to real space
# transpose to make them into columns
# inv to get matrix for reverse transformation

to_square_space, to_real_space = let l = sqrt(2)/sqrt(3), theta = pi/12
    T = [(l*cos(-theta)) (l*sin(-theta)) ; (l*cos(pi/2+theta)) (l*sin(pi/2+theta))]
    println("orig ", T)
    to_real_space = transpose(T)
    println("trans ", to_real_space)
    to_square_space = inv(to_real_space)
    println("inv'd ", to_square_space)
    to_square_space, to_real_space
end

function dp(a::Array{Float64, 1}, b::Array{Float64, 1})
    a[1]*b[1] + a[2]*b[2]
end

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1.0)


function noise(gradient::Function, sidelen::Number, x::Float64, y::Float64)
    # to figure out which corners to combine, we need to project everything
    # into space where simplices are squished into manageable squares
    #println("noise for ", x, " ", y)
    P = [x; y]
    P = P*(1/sidelen)
    # from here, we can assume distance between squares in square space is 1
    P_squares = to_square_space*P  # side = 1
    # the grid square in which P resides
    cell_origin = map( c->int(floor(c)) , P_squares)   # side still = 1, want floor as int
    into = P - cell_origin   # distance of P into square
    opposite_corner = cell_origin + [1,1]
    middle_corner = if into[1] < into[2]
        cell_origin + [0, 1]  # y> x, upper half, upper corner
    else
        cell_origin + [1, 0]
    end
    # now, get them all back into real space by mul'ing them by inv matrix
    # and scaling them by sidelen
    corners = (cell_origin, middle_corner, opposite_corner)
    corners = map(corners) do corner
        #println("  corner", corner)
        sidelen*(to_real_space*corner), gradient(corner[1], corner[2])
    end
    #println("  reached ")#, corners)
    # corners :: [(point, gradient)]
    # find contributions
    corners = map(corners) do tup
        #corner, grad = tup
        #println("  tup ", tup)
        corner = tup[1]
        grad = tup[2]
        dist = ([x;y] - corner)/sidelen
        height = dp(dist, grad)
        # now attenuate it, somehow
        t = 0.7 - (dist[1]*dist[1] + dist[2]*dist[2])
        #println("t ", t, " height ", height)
        if t >= 0
            t = 8*t*t*t*t
            t*height
        else
            0
        end
    end
    #println("  noise is ", sum(corners))
    2*sum(corners)
end

minVal = 0
maxVal = 0

each_pixel(img) do x,y
    n = noise(get_gradient, 1, x, y)
    global minVal, maxVal
    minVal = min(minVal, n)
    maxVal = max(maxVal, n)
    r = real_to_01(n)
    RGB(r,r,r)
end


#for p in ( [1;0], [0;1], [-1;0], [0;-1] )
#    t = to_square_space*p
#    println(p, " -> ", t)
#    or = u2px(img, (0.0, 0.0))  # real origin
#    p = (float(p[1]), float(p[2]))
#    t = (float(t[1]), float(t[2]))
#    p = u2px(img, p)
#    t = u2px(img, t)
#    dot(img, (or[1], or[2]), blue)
#    naive_line(img, red, or[1], or[2], p[1], p[2])
#    dot(img, (p[1], p[2]), blue)
#    naive_line(img, green, or[1], or[2], t[1], t[2])
#    dot(img, (t[1], t[2]), blue)
#end

imwrite(img.data, "simplex.png")

println("range of [", minVal, ", ", maxVal, "]")
    


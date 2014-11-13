module Util

export r, rplus_to_01, real_to_01,
       Vec, Polygon, area, each_edge, subsurf,
       Affine, apply, affmat, rot2, scale, compose, translate,
       random_dispatcher

r(x) = int(round(x))

rplus_to_01(x) = 1 - exp(-x)

# we scale atan to get derivative at 0 = 1
real_to_01(x) = (atan(pi*x) + pi/2)/pi

# Affine transformations and helper functions
type Affine
    linear::Array{Float64, 2} # a 2x2 matrix
    trans::Array{Float64, 1} # 2x1 matrix
end

function apply(f::Affine, x::Array{Float64, 1})
    f.linear*x + f.trans
end

function compose(f::Affine, g::Affine)
    Affine(f.linear*g.linear, f.linear*g.trans + f.trans)
end

function rot2(theta)
    [cos(theta) -sin(theta);
     sin(theta)  cos(theta)]
end

function scale(s::Float64)
    [s 0; 0 s]
end

function translate(v::Array{Float64,1})
    Affine([1 0; 0 1], v)
end

function affmat(v::Array{Float64, 2})
    Affine(v, [0;0])
end


# handy types

typealias Vec Vector{Float64}
typealias Polygon Array{Float64, 2}

function area(p::Polygon)
    # shoelace algorithm
    total = 0.0
    n = size(p)[2]
    for i in range(1,n)
        prev = if i == 1 n else i-1 end
        next = if i == n 1 else i+1 end
        total += p[1, i]*(p[2, next] - p[2, prev])
    end
    0.5*abs(total)
end

function each_edge(pairfn, p::Polygon)
    l = size(p)[2] # the width of the matrix
    for i in range(1, l)
        iprev = if i == 1 l else i - 1 end
        pair = p[:,i]
        prev = p[:,iprev]
        pairfn(prev, pair)
    end
end

# cut off each corner by for each edge, returning two points in the middle,
# each some fraction of the total length from the end
function subsurf(poly)
    l = size(poly)[2]
    new_points :: Array{Float64, 2} = Array(Float64, 2, l*2)
    i = 1
    each_edge(poly) do p1, p2
        d = p2 - p1
        r = 1.0/4.0
        r2 = 1 - r
        # stick new points in the output array
        new_points[:,2*i-1] = p1 + r*d
        new_points[:,2*i] = p1 + r2*d
        i+=1
    end
    return new_points
end

function random_dispatcher(fs::Vector{(Float64, Function)})
    # create list of partial sums of probabilities
    partial_total_probs = Float64[]
    total_p = 0.0
    for i in 1:length(fs)
        total_p += first(fs[i])
        push!(partial_total_probs, total_p)
    end

    function(x...)
        r = rand()*total_p
        #println("random ", r)
        ind = 1
        for j in 1:length(fs)
            ind = j
            if r < partial_total_probs[j]
                break
            end
        end
        #println("  calling ", ind)
        fs[ind][2](x...)
    end
end

end  # module Util





include("util.jl")

img = makeImage(-3,0, 6,10, 100)

halfer = [1/2 0; 0 1/2]

sierpinski = [
    (x -> halfer*x),
    (x -> halfer*x + [1/2; 0]),
    (x -> halfer*x + [1/4; sqrt(3)/4])
]

barnsley = [
    x -> [0 0; 0 .16]*x,
    x -> [.85 .04; -.04 .85]*x + [0; 1.6],
    x -> [-.15 .28; .26 .24]*x + [0; .44],
    x -> [0.2 -.26; .23 .22]*x + [0; 1.6]
]

function choose_probs(fns)
    map(fns) do f
        # choose weight based on area of image of unit square under f
        a = tuple(f([0;0])...)
        b = tuple(f([1;0])...)
        c = tuple(f([1;1])...)
        d = tuple(f([0;1])...)
        p = Polygon([a,b,c,d])
        (max(area(p), .03), f)
    end
end

function render_ifs(img, fns)
    probs = map(first, fns)
    partial_total_probs = Float64[]
    total_p = 0
    for i in range(1, length(probs))
        total_p += probs[i]
        push!(partial_total_probs, total_p)
    end

    x = [0; 0]
    n = length(fns)

    for i in range(1,1000000)
        z = rand()*total_p
        ind = 1
        for j in range(1, n)
            ind = j
            if z < partial_total_probs[j]
                break
            end
        end
        t = fns[ind][2]
        x = t(x)
        if i > 100  # this is supposedly important
            # plot the point
            plot(img, tuple(x...), RGB(0,.8,0))
        end
    end
end

render_ifs(img, choose_probs(barnsley))

imwrite(img.data, "ifs.png")


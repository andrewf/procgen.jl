include("util.jl")

img = makeImage(-3,0, 6,10, 100)

halfer = [1/2 0; 0 1/2]

sierpinski = [
    (2, x -> halfer*x),
    (1, x -> halfer*x + [1/2; 0]),
    (3, x -> halfer*x + [1/4; sqrt(3)/4])
]

barnsley = [
    (0.03, x -> [0 0; 0 .16]*x),
    (0.73, x -> [.85 .04; -.04 .85]*x + [0; 1.6]),
    (0.13, x -> [-.15 .28; .26 .24]*x + [0; .44]),
    (0.11, x -> [0.2 -.26; .23 .22]*x + [0; 1.6])
]


barnsley_raw = [
    x -> [0 0; 0 .16]*x,
    x -> [.85 .04; -.04 .85]*x + [0; 1.6],
    x -> [-.15 .28; .26 .24]*x + [0; .44],
    x -> [0.2 -.26; .23 .22]*x + [0; 1.6]
]

barnsley_auto = map(barnsley_raw) do f
    # choose weight based on area of image of unit square under f
    a = tuple(f([0;0])...)
    b = tuple(f([5;0])...)
    c = tuple(f([5;5])...)
    d = tuple(f([0;5])...)
    p = Polygon([a,b,c,d])
    println("points ", p.points)
    println("area ", area(p))
    (max(area(p), .05), f)
end

trans = barnsley_auto
probs = map(first, trans)

partial_total_probs = Float64[]
total_p = 0
for i in range(1, length(probs))
    total_p += probs[i]
    push!(partial_total_probs, total_p)
    println("curr ", probs[i], "     tot ", partial_total_probs[i])
end


x = [0; 0]
n = length(trans)

for i in range(1,1000000)
    z = rand()*total_p
    ind = 1
    for j in range(1, n)
        ind = j
        if z < partial_total_probs[j]
            break
        end
    end
    t = trans[ind][2]
    x = t(x)
    if i > 100  # this is supposedly important
        # plot the point
        plot(img, tuple(x...), RGB(0,.8,0))
    end
end

imwrite(img.data, "ifs.png")


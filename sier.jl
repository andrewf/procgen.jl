include("util.jl")

img = makeImage(0, 0, 1, 1, 1200)

halfer = [1/2 0; 0 1/2]

trans = [
    x -> halfer*x,
    x -> halfer*x + [1/2; 0],
    x -> halfer*x + [1/4; sqrt(3)/4]
]

x = [0; 0]

for i in range(1,100000)
    z = rand()
    ind = int(floor(3*z)) + 1
    t = trans[ind]
    x = t(x)
    if i > 100  # this is supposedly important
        # plot the point
        plot(img, tuple(x...), RGB(0,0,0))
    end
end

imwrite(img.data, "ifs.png")


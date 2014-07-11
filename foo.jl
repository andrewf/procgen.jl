include("util.jl")

# let's just call these centimeters for now
w = 10
h = 10

# map "real" units to pixels
res = 100 #px/cm


seed = Array((Float64, Float64), h, w)
for y in 1:h
    for x in 1:h
        seed[y,x] = (rand(), rand())
    end
end
data = Array(RGB, h*res, w*res)
fill!(data, RGB(1,1,1))

poly = Polygon([(100.0, 400.0), (500.0,200.0),(550.0, 600.0), (700.0,650.0), (700.0, 700.0), (150.0, 750.0)])
poly2 = subsurf(poly)
poly3 = subsurf(poly2)
poly4 = subsurf(poly3)

draw(data, RGB(1,0,0), poly)
draw(data, RGB(0,1,0), poly4)

println("writing img")
imwrite(data, "eckphbth.png")

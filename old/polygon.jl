include("util.jl")

# let's just call these centimeters for now
w = 10
h = 10

# map "real" units to pixels
res = 100 #px/cm

img = makeImage(0, 0, 10, 10, 100)

poly = transpose([1.0 4; 5 2; 5.5 6; 7 6.5; 7 7; 1.5 7.5])

println("orig ", poly)
poly2 = subsurf(poly)
poly3 = subsurf(poly2)
poly4 = subsurf(poly3)

draw(img, RGB(1,0,0), poly)
draw(img, RGB(0,1,0), poly2)
draw(img, RGB(0,0,1), poly4)

println("writing img")
imwrite(img.data, "eckphbth.png")

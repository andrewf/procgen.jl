include("util.jl")

# let's just call these centimeters for now
w = 10
h = 10

# map "real" units to pixels
res = 100 #px/cm

img = makeImage(0, 0, 10, 10, 100)

poly = Polygon([(1.000, 4.000), (5.000, 2.000), (5.500, 6.000),
                (7.000, 6.500), (7.000, 7.000), (1.500, 7.500)])
poly2 = subsurf(poly)
poly3 = subsurf(poly2)
poly4 = subsurf(poly3)

draw(img, RGB(1,0,0), poly)
draw(img, RGB(0,1,0), poly4)

println("writing img")
imwrite(img.data, "eckphbth.png")

using Images
using Color


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

function naive_line(img, color, x1, y1, x2, y2)
    xdiff = abs(x1 - x2)
    ydiff = abs(y1 - y2)
    start = (x1, y1)
    finish = (x2, y2)
    if xdiff == 0
        # line is perfectly vertical
        starty = int(round(min(y1, y2)))
        finishy = int(round(max(y1, y2)))
        for y in starty:finishy
            img[y, int(x1)] = color
        end
    elseif xdiff >= ydiff
        # line is closer to horizontal
        if x2 < x1
            (start, finish) = (finish, start)
        end
        starty = float(start[2])
        finishy = float(finish[2])
        slope = (finishy - starty)/float(xdiff)
        for x in int(round(start[1])):int(round(finish[1]))
            xdist = x - start[1]
            y = round( start[2] + xdist*slope )
            y = int(y)
            img[y,x] = color
        end
    else
        # line is more vertical
        if y2 < y1
            (start, finish) = (finish, start)
        end
        slope = (finish[1] - start[1])/(finish[2] - start[2])
        for y in int(round(start[2])):int(round(finish[2]))
            ydist = y - start[2]
            x = round( start[1] + slope*ydist )
            x = int(x)
            img[y,x] = color
        end
    end
end

function each_pair(pairfn, points)
    prev = points[length(points)] # start with last element
    for p in points
        pairfn(prev, p)
        prev = p
    end
end

function line_loop(img, color, points)
    each_pair((p1, p2)->( naive_line(img, color, p1[1],p1[2], p2[1],p2[2]) ), points)
end

# cut off each corner by for each edge, returning two points in the middle,
# each some fraction of the total length from the end
function subsurf_loop(points)
    new_points = Array((Float64, Float64), 0)
    each_pair(
        (p1, p2) -> begin
            d = (p2[1]-p1[1], p2[2]-p1[2])
            r = 1.0/4.0
            r2 = 1 - r
            push!(new_points, (p1[1] + r*d[1], p1[2] + r*d[2]))
            push!(new_points, (p1[1] + r2*d[1], p1[2] + r2*d[2]))
        end,
        points
    )
    return new_points
end

data = Array(RGB, h*res, w*res)
fill!(data, RGB(1,1,1))

#for y in 1:h*res
#    for x in 1:w*res
#        data[y,x] = RGB(rand(),rand(),rand())
#    end
#end

poly = [(100.0, 400.0), (500.0,200.0),(550.0, 600.0), (700.0,650.0), (700.0, 700.0), (150.0, 750.0)]
poly2 = subsurf_loop(poly)
poly3 = subsurf_loop(poly2)
poly4 = subsurf_loop(poly3)

line_loop(data, RGB(1,0,0), poly)
line_loop(data, RGB(0,1,0), poly4)

println("writing img")
imwrite(data, "eckphbth.png")

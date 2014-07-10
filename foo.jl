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
    if x1 < x2
        start = (x1, y1)
        finish = (x2, y2)
    else
        start = (x2, y2)
        finish = (x1, y1)
    end
    startx = start[1]
    finishx = finish[1]
    xdiff = finishx - startx
    if xdiff == 0
        starty = min(y1, y2)
        finishy = max(y1, y2)
        for y in starty:finishy
            img[y, x1] = color
        end
    else
        starty = float(start[2])
        finishy = float(finish[2])
        slope = (finishy - starty)/float(xdiff)
        for x in startx:finishx
            xdist = x - startx
            y = round( starty + xdist*slope )
            img[y,x] = color
        end
    end
end

function line_loop(img, color, points)
    prev = points[length(points)] # start with last element
    for (x, y) in points
        xprev, yprev = prev
        naive_line(img, color, xprev,yprev, x,y)
        prev = (x,y)
    end
end

    

data = Array(RGB, h*res, w*res)
fill!(data, RGB(1,1,1))

#for y in 1:h*res
#    for x in 1:w*res
#        data[y,x] = RGB(rand(),rand(),rand())
#    end
#end

naive_line(data, RGB(0,0,0), 1,1, 900,400)
naive_line(data, RGB(1,0,0), 700, 10, 700, 700)

line_loop(data, RGB(0,0,0), [(10,30),(30,10),(50,30),(30,50)])

println("writing img")
imwrite(data, "eckphbth.png")

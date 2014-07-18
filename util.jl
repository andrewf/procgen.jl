using Images
using Color

r = x -> int(round(x))

type Polygon
    points :: Array{(Float64, Float64),1}
end

type CoordImage
    data :: Array{RGB, 2}
    top :: (Float64, Float64)
    dims :: (Float64, Float64)
    res :: Float64
end

function u2px(img::CoordImage, pt::(Float64, Float64))
    x, y = pt
    x, y = (x - img.top[1], y - img.top[2])
    (r(x*img.res), r(y*img.res))
end

function px2u(img::CoordImage, pt::(Int64, Int64))
    x, y = float(pt[1])/img.res, float(pt[2])/img.res
    (x + img.top[1], y + img.top[2])
end

function plot(img::CoordImage, pt::(Int64, Int64), color)
    ysize = size(img.data, 1)
    xsize = size(img.data, 2)
    if !((1 <= pt[1] <= xsize) && (1 <= pt[2] <= ysize))
        # out of range
        return
    end
    img.data[y,x] = color
end

function plot(img::CoordImage, pt::(Float64, Float64), color)
    pt = u2px(pt)
    plot(img, pt, color)
end

function makeImage(top, left, w, h, res)
    pxw, pxh = r(w*res), r(h*res)
    data = Array(RGB, pxh, pxw)
    fill!(data, RGB(1,1,1))
    Foo(data, (top, left), (w, h), res)
end

function each_edge(pairfn, p::Polygon)
    prev = p.points[length(p.points)] # start with last element
    for pair in p.points
        pairfn(prev, pair)
        prev = pair
    end
end

function naive_line(img, color, x1::Int64, y1::Int64, x2::Int64, y2::Int64)
    xdiff = abs(x1 - x2)
    ydiff = abs(y1 - y2)
    start = (x1, y1)
    finish = (x2, y2)
    if xdiff == 0
        # line is perfectly vertical
        starty = min(y1, y2)
        finishy = max(y1, y2)
        for y in starty:finishy
            plot(img, (x, y), color)
        end
    elseif xdiff >= ydiff
        # line is closer to horizontal
        if x2 < x1
            (start, finish) = (finish, start)
        end
        starty = start[2]
        finishy = finish[2]
        slope = (finishy - starty)/xdiff
        for x in start[1]:finish[1]
            xdist = x - start[1]
            y = r( start[2] + xdist*slope )
            plot(img, (x, y), color)
        end
    else
        # line is more vertical
        if y2 < y1
            (start, finish) = (finish, start)
        end
        slope = (finish[1] - start[1])/(finish[2] - start[2])
        for y in start[2]:finish[2]
            ydist = y - start[2]
            x = r( start[1] + slope*ydist )
            plot(img, (x, y), color)
            img[y,x] = color
        end
    end
end

function draw(img, color, poly::Polygon)
    each_edge((p1, p2)-> naive_line(img, color, p1[1],p1[2], p2[1],p2[2]), poly)
end

# cut off each corner by for each edge, returning two points in the middle,
# each some fraction of the total length from the end
function subsurf(poly)
    new_points = Array((Float64, Float64), 0)
    each_edge(
        (p1, p2) -> begin
            d = (p2[1]-p1[1], p2[2]-p1[2])
            r = 1.0/4.0
            r2 = 1 - r
            push!(new_points, (p1[1] + r*d[1], p1[2] + r*d[2]))
            push!(new_points, (p1[1] + r2*d[1], p1[2] + r2*d[2]))
        end,
        poly
    )
    return Polygon(new_points)
end


# create an image, and a function that maps float coordinates to
# int coordinates based on a rect.
function image_and_coords(top::(Float64, Float64),
                          dims::(Float64, Float64),
                          res::Int64) # px/1.0
    x,y = top
    w,h = dims
    img = Array(RGB, int(round(h))*res, int(round(w))*res)
    mapper = (pos::(Float64, Float64)) -> begin
        inx, iny = pos
        outx = int(round(inx - x))*res
        outy = int(round(iny - y))*res
        (outx, outy)
    end
    (img, mapper)
end

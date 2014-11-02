using Images
using Color

r(x) = int(round(x))

rplus_to_01(x) = 1 - exp(-x)

# we scale atan to get derivative at 0 = 1
real_to_01(x) = (atan(pi*x) + pi/2)/pi

typealias Vec Vector{Float64}
typealias Polygon Array{Float64, 2}

function area(p::Polygon)
    # shoelace algorithm
    total = 0.0
    n = length(p.points)
    for i in range(1,n)
        prev = if i == 1 n else i-1 end
        next = if i == n 1 else i+1 end
        total += p.points[i][1]*(p.points[next][2] - p.points[prev][2])
    end
    0.5*abs(total)
end

type CoordImage
    data :: Array{RGB, 2}
    top :: (Float64, Float64)
    dims :: (Float64, Float64)
    res :: Float64
end

function u2px(img::CoordImage, pt::Vec)
    x, y = pt
    x, y = (x - img.top[1], y - img.top[2])
    [r(x*img.res); r(y*img.res)]
end

function px2u(img::CoordImage, pt::Vector{Int64})
    x, y = float(pt[1])/img.res, float(pt[2])/img.res
    [x + img.top[1]; y + img.top[2]]
end

function plot(img::CoordImage, pt::Vector{Int64}, color)
    ysize = size(img.data, 1)
    xsize = size(img.data, 2)
    if !((1 <= pt[1] <= xsize) && (1 <= pt[2] <= ysize))
        # out of range
        return
    end
    img.data[pt[2],pt[1]] = color
end

function plot(img::CoordImage, pt::Vec, color)
    pt = u2px(img, pt)
    plot(img, pt, color)
end

function dot(img::CoordImage, pt::Vec, color)
    x, y = pt
    plot(img, pt, color)
    plot(img, [x+1,y], color)
    plot(img, [x,y+1], color)
    plot(img, [x+1,y+1], color)
end

function each_pixel(fn, img::CoordImage)
    for y in 1:size(img.data, 1)
        for x in 1:size(img.data, 2)
            u = px2u(img, [x;y])
            img.data[y,x] = fn(u[1], u[2])
        end
    end
end

function makeImage(top, left, w, h, res)
    pxw, pxh = r(w*res), r(h*res)
    data = Array(RGB, pxh, pxw)
    fill!(data, RGB(1,1,1))
    CoordImage(data, (top, left), (w, h), res)
end

function render_by_pixels(fn, name, top, left, w, h, res)
    img = makeImage(top, left, w, h, res)
    each_pixel(fn, img)
    imwrite(img.data, "$name.png")
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

function naive_line(img::CoordImage, color, p1::Vector{Int64}, p2::Vector{Int64})
    x1 = p1[1]
    y1 = p1[2]
    x2 = p2[1]
    y2 = p2[2]
    xdiff = abs(x1 - x2)
    ydiff = abs(y1 - y2)
    start = (x1, y1)
    finish = (x2, y2)
    if xdiff == 0
        # line is perfectly vertical
        starty = min(y1, y2)
        finishy = max(y1, y2)
        for y in starty:finishy
            plot(img, [x1, y], color)
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
            plot(img, [x, y], color)
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
            plot(img, [x, y], color)
        end
    end
end

function draw(img, color, poly::Polygon)
    each_edge(poly) do p1,p2
        p1 = u2px(img, p1)
        p2 = u2px(img, p2)
        naive_line(img, color, p1, p2)
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


module Draw

using Images
using Color
using Util

export CoordImage, makeImage, writeout, u2px, px2u, plot, dot, each_pixel, render_by_pixels, line, naive_line, draw, RGB

type CoordImage
    data :: Array{RGB{Float64}, 2}
    top :: (Float64, Float64)
    dims :: (Float64, Float64)
    res :: Float64
end

function writeout(img::CoordImage, fname)
    imwrite(img.data, fname)
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
    writeout(img, "$name.png")
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

function line(img::CoordImage, color, p1::Vec, p2::Vec)
    naive_line(img, color, u2px(img, p1), u2px(img, p2))
end

function draw(img, color, poly::Polygon)
    each_edge(poly) do p1,p2
        p1 = u2px(img, p1)
        p2 = u2px(img, p2)
        naive_line(img, color, p1, p2)
    end
end




end   # module Draw

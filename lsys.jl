include("turtle.jl")

function ugly(t::Turtle, depth::Int)
    draw(t, img, [0;1.])
    if depth < 10
        # left branch
        push(t)
        move(t, Affine(scale(.6)*rot2(-pi/4), [0;0]))
        lsys(t, depth+1)
        pop(t)
        # right branch
        push(t)
        move(t, Affine(scale(.7)*rot2(pi/8), [0;0]))
        lsys(t, depth+1)
        pop(t)
    end
    pop(t)
end

ang = 25*pi/180

# meh
function planty(t::Turtle, depth::Int)
    fwd = [0;.3]
    push(t)
    move(t, Affine(scale(1.), [0;0]))
    draw(t,fwd)
    if depth < 5
        draw(t,fwd)
        move(t, Affine(rot2(-ang),[0;0]))
        push(t)
        push(t)
        planty(t, depth+1)
        pop(t)
        move(t, Affine(rot2(ang),[0;0]))
        planty(t, depth+1)
        pop(t)
        move(t, Affine(rot2(ang),[0;0]))
        draw(t,fwd)
        push(t)
        move(t, Affine(rot2(ang),[0;0]))
        draw(t,fwd)
        planty(t, depth+1)
        pop(t)
        move(t, Affine(rot2(-ang),[0;0]))
        planty(t, depth+1)
    end
    pop(t)
end

img = makeImage(-2, -2, 4, 6, 100)
t = makeTurtle(img)

planty(t, 1)

p = Polygon([(-.5,.5),(.5,.5),(.5,-.5),(-.5,-.5)])
draw(img, RGB(1,0,0), p)

imwrite(img.data, "turtle.png")


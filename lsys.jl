using TurtleGraphics
import Color.RGB
import Images.imwrite
using Util

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

function planty_grammar(original)
    ret :: Vector{Char} = []
    for c in original
        if c == 'F'
            push!(ret, 'F')
            push!(ret, 'F')
        elseif c == 'X'
            push!(ret, 'F')
            push!(ret, '-')
            push!(ret, '[')
            push!(ret, '[')
            push!(ret, 'X')
            push!(ret, ']')
            push!(ret, '+')
            push!(ret, 'X')
            push!(ret, ']')
            push!(ret, '+')
            push!(ret, 'F')
            push!(ret, '[')
            push!(ret, '+')
            push!(ret, 'F')
            push!(ret, 'X')
            push!(ret, ']')
            push!(ret, '-')
            push!(ret, 'X')
        else
            push!(ret, c)
        end
    end
    ret
end

img = makeImage(-2, -11, 16, 12, 50)
t = makeTurtle(img)

#planty(t, 1)

s = ['X']
s = planty_grammar(s)
s = planty_grammar(s)
s = planty_grammar(s)
s = planty_grammar(s)
s = planty_grammar(s)
s = planty_grammar(s)
s = planty_grammar(s)

fwd = [0; -.04]

move(t, translate([-1.; 1.]))
move(t, Affine(rot2(+ang),[0;0]))

for c in s
    if c == 'F'
        TurtleGraphics.draw(t, fwd)
    elseif c == '+'
        move(t, Affine(rot2(+ang),[0;0]))
    elseif c == '-'
        move(t, Affine(rot2(-ang),[0;0]))
    elseif c == '['
        push(t)
    elseif c == ']'
        pop(t)
    end
end


#p = Polygon([(-.5,.5),(.5,.5),(.5,-.5),(-.5,-.5)])
p = transpose([-.5 .5; .5 .5; .5 -.5; -.5 -.5])
draw(img, RGB(1,0,0), p)

imwrite(img.data, "turtle.png")


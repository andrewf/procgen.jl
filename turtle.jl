include("util.jl")

img = makeImage(-2, -2, 4, 5, 100)

type Aff
    linear::Array{Float64, 2} # a 2x2 matrix
    trans::Array{Float64, 1} # 2x1 matrix
end

function apply(f::Aff, x::Array{Float64, 1})
    f.linear*x + f.trans
end

function compose(f::Aff, g::Aff)
    Aff(f.linear*g.linear, f.linear*g.trans + f.trans)
end

# the location of the turtle is apply(last(stack), [0;1])
type Turtle
    stack :: Array{Aff}
end

function push(t::Turtle)
    # we actually want to push a copy of the top
    # so we can mutate it.
    push!(t.stack, last(t.stack))
end

function pop(t::Turtle)
    pop!(t.stack)
end

# move the transform cursor through f
function move(t::Turtle, f::Aff)
    l = length(t.stack)
    t.stack[l] = compose(t.stack[l], f)
end

function draw(t::Turtle, img, f::Aff)
    p1 = apply(last(t.stack), [0.;1.])
    p1 = u2px(img, (p1[1], p1[2]))
    move(t, f)
    p2 = apply(last(t.stack), [0.;1.])
    p2 = u2px(img, (p2[1], p2[2]))
    println("draw from ", p1, " to ", p2)
    naive_line(img, RGB(0,0,0),
                p1[1], p1[2],
                p2[1], p2[2])
end

function rot2(theta)
    [cos(theta) -sin(theta);
     sin(theta)  cos(theta)]
end

t = Turtle([Aff([1 0;0 1],[0;0])])
draw(t, img, Aff([1 0; 0 1],[0.;1.]))
push(t)                              
draw(t, img, Aff(rot2(pi/4),[1.;0.]))
#draw(t, img, Aff([1 0; 0 1],[0.;1.]))
#draw(t, img, Aff([1 0; 0 1],[0.;1.]))

println("turtle ", t)

#naive_line(img, RGB(0,1,0), 1,-100, 0,100)
#naive_line(img, RGB(0,1,0), -100,1, 100,0)

p = Polygon([(-.5,.5),(.5,.5),(.5,-.5),(-.5,-.5)])
draw(img, RGB(1,0,0), p)

imwrite(img.data, "turtle.png")

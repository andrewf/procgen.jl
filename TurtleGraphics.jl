module TurtleGraphics
using Draw
using Util

export Turtle, makeTurtle, push, pop, move, draw
# turtle graphics
# the location of the turtle is apply(last(stack), [0;1])
type Turtle
    stack :: Array{Affine}
    img :: CoordImage
end

function makeTurtle(img:: CoordImage)
    Turtle([Affine([1.0 0; 0 1.], [0; 0])], img)
end

function push(t::Turtle)
    # we actually want to push a copy of the top
    # so we can mutate it.
    push!(t.stack, last(t.stack))
end

function pop(t::Turtle)
    pop!(t.stack)
end

function curr_f(t::Turtle)
    last(t.stack)
end

# move the transform cursor through f
function move(t::Turtle, f::Affine)
    l = length(t.stack)
    t.stack[l] = compose(curr_f(t), f)
end

function draw(t::Turtle, v::Array{Float64, 1})
    # v is a vector in the coord space defined by current transform
    z = [0.; 0.]
    # first point is f(0), second is f(v)
    p1 = apply(curr_f(t), z)
    p2 = apply(curr_f(t), v)
    p1 = u2px(t.img, p1)
    p2 = u2px(t.img, p2)
    move(t, translate(v))
    naive_line(t.img, RGB(0,0,0), p1, p2)
end

end  # module Turtle

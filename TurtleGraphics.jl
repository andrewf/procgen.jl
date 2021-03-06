module TurtleGraphics
using Draw
using Util

export Turtle, makeTurtle, push, pop, move, draw, draw_fn

# turtle graphics
type Turtle
    stack :: Array{Affine}
    img :: CoordImage
end

function makeTurtle(img:: CoordImage)
    Turtle([Affine([1.0 0; 0 1.], [0; 0])], img)
end

function curr_f(t::Turtle)
    last(t.stack)
end

function push(t::Turtle)
    # we actually want to push a copy of the top
    # so we can mutate it.
    push!(t.stack, last(t.stack))
    t
end

function pop(t::Turtle)
    pop!(t.stack)
    t
end

# move the transform cursor through f
function move(t::Turtle, f::Affine)
    l = length(t.stack)
    t.stack[l] = compose(curr_f(t), f)
    t
end

# first arg is a function that takes an image and the current transform
# and returns the offset (in the current transformed coord system)
# that the cursor should be moved through when
# the function returns.
function draw_fn(f::Function, t::Turtle)
    transform = curr_f(t)
    offset = f(transform, t.img)
    move(t, translate(offset))
    t
end

# draw a line and move the cursor through v, in the current
# coordinate system
function draw(t::Turtle, v::Array{Float64, 1})
    draw_fn(t) do f::Affine, img
        p1 = Util.apply(f, [0.;0.])
        p2 = Util.apply(f, v)
        line(img, RGB(0,0,0), p1, p2)
        v
    end
end

end  # module Turtle

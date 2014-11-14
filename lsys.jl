using Draw
using TurtleGraphics
using Util

ang = 25*pi/180

# basic set of constants standing in for the characters
# of a normal lsystem
module G
    F = 1
    X = 2
    push = 3
    pop = 4
    right = 5
    left = 6
    N = 6
end

function makeLProcessor(mod::Module, bindings::Vector{(Int64, Function)}, default::Function)
    ret = fill(default, mod.N)
    # so if bindings contains numbers outside [1,mod.N], this will crash
    for (i, f) in bindings
        if i<= mod.N
            ret[i] = f
        else
            panic("invalid symbol index")
        end
    end
    ret
end

TurtleRenderer = makeLProcessor(G, [
    (G.F, (sym, t::Turtle) -> TurtleGraphics.draw(t, [0.; 1.])),
#    'X' => (sym, t::Turtle) -> draw_fn(t) do f, img
#                                # draw an X
#                                p1 = Util.apply(f, [-.5; -.5])
#                                p2 = Util.apply(f, [.5; .5])
#                                q1 = Util.apply(f, [-.5; .5])
#                                q2 = Util.apply(f, [.5; -.5])
#                                line(img, RGB(1, 0, 1), p1, p2)
#                                line(img, RGB(1, 0, 1), q1, q2)
#                                [0.0; 0.]
#                          end,
    (G.right, (sym, t::Turtle) -> move(t, affmat(rot2(ang)))),
    (G.left, (sym, t::Turtle) -> move(t, affmat(rot2(-ang)))),
    (G.push, (sym, t::Turtle) -> push(t)),
    (G.pop, (sym, t::Turtle) -> pop(t))
], (sym, t)->t)

#longstr = ['F', '-', '[', '[', 'X', ']', '+', 'X', ']',
#            '+', 'F', '[', '+', 'F', 'X', ']', '-', 'X']
longstr = [G.F, G.left, G.push, G.push, G.X, G.pop, G.right, G.X, G.pop,
            G.right, G.F, G.push, G.right, G.F, G.X, G.pop, G.left, G.X]

PlantyGrammar = makeLProcessor(G, [
    (G.F,     (sym,s) -> vcat(s, G.F, G.F)),
    (G.X,     (sym,s) -> vcat(s, longstr)),
], (sym, state) -> vcat(state, sym))

# take a series of characters and process it according
# to one of the above grammar/processing module thingies
function runLModule(mod, data::Vector{Int64}, state)
    for sym in data
        if sym > G.N || sym < 1
        end
        state = mod[sym](sym, state)
    end
    state
end

# use the passed grammar to iterate some number of times,
# then render the result in the passed turtle
function renderLSystem(mod, init_state, iterations::Int, turtle)
    s = init_state
    for i in 1:iterations
        s = runLModule(mod, s, Int64[])
    end
    runLModule(TurtleRenderer, s, turtle)
end

############################
# actually render something
############################

img = makeImage(-2, -11, 16, 12, 50)
t = makeTurtle(img)

currgrammar = PlantyGrammar
#currgrammar = [
#    "startState" => ['F', '-', 'F', '-', 'F', '-', 'F', '-'],
#    'F' => s -> vcat(s, ['F', '+', 'F', '-', 'F', 'F', '-', 'F', '-', 'F', '+', '+']),
#    '+' => s -> vcat(s, '+'),
#    '-' => s -> vcat(s, '-'),
#    '[' => s -> vcat(s, '['),
#    ']' => s -> vcat(s, ']')
#]

move(t, translate([2., 1.]))
move(t, affmat(scale(-0.05)))
move(t, Affine(rot2(+ang),[0;0]))
renderLSystem(currgrammar, [G.X], 7, t)

p = transpose([-.5 .5; .5 .5; .5 -.5; -.5 -.5])
Draw.draw(img, RGB(1,0,0), p)

writeout(img, "turtle.png")


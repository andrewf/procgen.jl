using Draw
using TurtleGraphics
using Util

ang = pi/2 # 25*pi/180

TurtleRenderer = [
    'F' => t::Turtle -> TurtleGraphics.draw(t, [0.; 1.]),
#    'X' => t::Turtle -> draw_fn(t) do f, img
#                                # draw an X
#                                p1 = Util.apply(f, [-.5; -.5])
#                                p2 = Util.apply(f, [.5; .5])
#                                q1 = Util.apply(f, [-.5; .5])
#                                q2 = Util.apply(f, [.5; -.5])
#                                line(img, RGB(1, 0, 1), p1, p2)
#                                line(img, RGB(1, 0, 1), q1, q2)
#                                [0.0; 0.]
#                          end,
    '+' => t::Turtle -> move(t, affmat(rot2(ang))),
    '-' => t::Turtle -> move(t, affmat(rot2(-ang))),
    '[' => t::Turtle -> push(t),
    ']' => t::Turtle -> pop(t)
]

longstr = ['F', '-', '[', '[', 'X', ']', '+', 'X', ']',
            '+', 'F', '[', '+', 'F', 'X', ']', '-', 'X']

PlantyGrammar = [
    "startState" => ['X'],
    'F' => s -> vcat(s, 'F', 'F'),
    'X' => s -> vcat(s, longstr),
    '+' => s -> vcat(s, '+'),
    '-' => s -> vcat(s, '-'),
    '[' => s -> vcat(s, '['),
    ']' => s -> vcat(s, ']')
]

# take a series of characters and process it according
# to one of the above grammar/processing module thingies
function runLModule(mod, data::Vector{Char}, state)
    for c in data
        state = get(mod, c, (s)->(s))(state)
    end
    state
end

# use the passed grammar to iterate some number of times,
# then render the result in the passed turtle
function renderLSystem(mod, iterations::Int, turtle)
    s = get(mod, "startState", Char[])
    for i in 1:iterations
        s = runLModule(mod, s, Char[])
    end
    runLModule(TurtleRenderer, s, turtle)
end

############################
# actually render something
############################

img = makeImage(-2, -11, 16, 12, 50)
t = makeTurtle(img)

#currgrammar = PlantyGrammar
currgrammar = [
    "startState" => ['F', '-', 'F', '-', 'F', '-', 'F', '-'],
    'F' => s -> vcat(s, ['F', '+', 'F', 'F', '-', 'F', 'F', '-', 'F', '-',
                            'F', '+', 'F', '+', 'F']),
    '+' => s -> vcat(s, '+'),
    '-' => s -> vcat(s, '-'),
    '[' => s -> vcat(s, '['),
    ']' => s -> vcat(s, ']')
]

move(t, translate([4., -2.]))
move(t, affmat(scale(-0.025)))
move(t, Affine(rot2(+ang),[0;0]))
renderLSystem(currgrammar, 5, t)

p = transpose([-.5 .5; .5 .5; .5 -.5; -.5 -.5])
Draw.draw(img, RGB(1,0,0), p)

writeout(img, "turtle.png")


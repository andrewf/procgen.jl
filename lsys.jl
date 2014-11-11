using Draw
using TurtleGraphics
using Util

ang = 25*pi/180

TurtleRenderer = [
    'F' => (t::Turtle) -> TurtleGraphics.draw(t, [0.; 1.]),
    'X' => (t::Turtle) -> draw_fn(t) do f, img
                                # draw an X
                                p1 = Util.apply(f, [-.5; -.5])
                                p2 = Util.apply(f, [.5; .5])
                                q1 = Util.apply(f, [-.5; .5])
                                q2 = Util.apply(f, [.5; -.5])
                                line(img, RGB(1, 0, 1), p1, p2)
                                line(img, RGB(1, 0, 1), q1, q2)
                                [0.0; 0.]
                          end,
    '+' => (t::Turtle) -> move(t, affmat(rot2(ang))),
    '-' => (t::Turtle) -> move(t, affmat(rot2(-ang))),
    '[' => (t::Turtle) -> push(t),
    ']' => (t::Turtle) -> pop(t)
]

longstr = ['F', '-', '[', '[', 'X', ']', '+', 'X', ']',
            '+', 'F', '[', '+', 'F', 'X', ']', '-', 'X']

PlantyGrammar = [
    'F' => (s) -> vcat(s, 'F', 'F'),
    'X' => (s) -> vcat(s, longstr)::Vector{Char},
    '+' => (s) -> vcat(s, '+')::Vector{Char},
    '-' => (s) -> vcat(s, '-')::Vector{Char},
    '[' => (s) -> vcat(s, '[')::Vector{Char},
    ']' => (s) -> vcat(s, ']')::Vector{Char}
]

# take a series of characters and process it according
# to one of the above grammar/processing module thingies
function runLModule(mod, data::Vector{Char}, state)
    for c in data
        state = get(mod, c, (s)->(s))(state)
    end
    state
end

s = ['X'] 

s = runLModule(PlantyGrammar, s, Array(Char,0))
first = s
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
#s = runLModule(PlantyGrammar, s, Array(Char,0))

img = makeImage(-2, -11, 16, 12, 50)
t = makeTurtle(img)

println(first)

push(t)
    move(t, translate([4., 0.]))
    move(t, affmat(scale(-1.1)))
    move(t, Affine(rot2(+ang),[0;0]))
    runLModule(TurtleRenderer, first, t)
pop(t)

move(t, translate([-1.; .5]))
move(t, Affine(rot2(+ang),[0;0]))
move(t, affmat(scale(-.2)))

runLModule(TurtleRenderer, s, t)

p = transpose([-.5 .5; .5 .5; .5 -.5; -.5 -.5])
draw(img, RGB(1,0,0), p)

writeout(img, "turtle.png")


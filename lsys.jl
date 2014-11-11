using Draw
using TurtleGraphics
using Util

ang = 25*pi/180

TurtleRenderer = [
    'F' => (t::Turtle) -> TurtleGraphics.draw(t, [0.; 1.]),
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
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))
s = runLModule(PlantyGrammar, s, Array(Char,0))

img = makeImage(-2, -11, 16, 12, 50)
t = makeTurtle(img)

move(t, translate([-1.; .5]))
move(t, Affine(rot2(+ang),[0;0]))
move(t, affmat(scale(-.02)))

runLModule(TurtleRenderer, s, t)

p = transpose([-.5 .5; .5 .5; .5 -.5; -.5 -.5])
draw(img, RGB(1,0,0), p)

writeout(img, "turtle.png")


using Draw
using TurtleGraphics
using Util

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

function TurtleRenderer(t::Turtle, angle)
    makeLProcessor(G, [
        (G.F, (sym) -> TurtleGraphics.draw(t, [0.; 1.])),
        (G.right, (sym) -> move(t, affmat(rot2(angle)))),
        (G.left, (sym) -> move(t, affmat(rot2(-angle)))),
        (G.push, (sym) -> push(t)),
        (G.pop, (sym) -> pop(t))
    ], (sym)->Nothing)
end

longstr = [G.F, G.left, G.push, G.push, G.X, G.pop, G.right, G.X, G.pop,
            G.right, G.F, G.push, G.right, G.F, G.X, G.pop, G.left, G.X]

function PlantyGrammar(prev)
    makeLProcessor(G, [
        (G.F,     (sym) -> begin prev[G.F](G.F); prev[G.F](G.F) end),
        (G.X,     (sym) -> begin
                               for s in longstr
                                   prev[s](s)
                               end
                           end),
    ], (sym) -> prev[sym](sym))
end

############################
# actually render something
############################

img = makeImage(-5, -17, 13, 18, 50)
t = makeTurtle(img)

move(t, affmat(scale(-0.05)))

#renderLSystem(currgrammar, [G.X], 7, t)
lsys = PlantyGrammar(TurtleRenderer(t, 25*pi/180))
lsys = lsys |> PlantyGrammar
lsys = lsys |> PlantyGrammar
lsys = lsys |> PlantyGrammar
lsys = lsys |> PlantyGrammar
lsys = lsys |> PlantyGrammar
lsys = lsys |> PlantyGrammar
lsys[G.X](G.X)

p = transpose([-.5 .5; .5 .5; .5 -.5; -.5 -.5])
Draw.draw(img, RGB(1,0,0), p)

writeout(img, "plant.png")


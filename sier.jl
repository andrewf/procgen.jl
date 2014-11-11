using Util
using Draw
using Ifs

img = makeImage(-1,-1, 3,3, 400)

halfer = scale(.5)

sierpinski = [
    (x -> halfer*x),
    (x -> halfer*x + [1/2; 0]),
    (x -> halfer*x + [1/4; sqrt(3)/4])
]

barnsley = [
    x -> [0 0; 0 .16]*x,
    x -> [.85 .04; -.04 .85]*x + [0; 1.6],
    x -> [-.15 .28; .26 .24]*x + [0; .44],
    x -> [0.2 -.26; .23 .22]*x + [0; 1.6]
]

heighway = [
    x -> 1/sqrt(2)*rot2(pi/4)*x,
    x -> 1/sqrt(2)*rot2(3pi/4)*x + [1; 0]
]

render_ifs(img, RGB(0, .0, .0), choose_probs(heighway))

writeout(img, "ifs.png")


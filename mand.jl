using Draw
using Fractal

img = makeImage(
        # position
        -2.2, -2,
        # dimensions
        4, 4,
        # resolution
        200  # px/u
      )

println("generating")

escape_time(
    img,
    # init pos -> init value
    c->c,
    # iterated function (curr, px) -> new
    (z,c)->z^2 + c
)

println("writing img")
writeout(img, "fractal.png")


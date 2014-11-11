=Procgen.jl=

This is just where I stash my weird experiments in procedural 2d graphics.
I'm using Julia as my implementation language because Julia is pretty cool.
Util has a couple handy types and functions.

Draw.jl contains your basic
image handling stuff, designed to let you do graphics in real numbers and
convert it to pixel coordinates at the last second. In Noise.jl, there are
implementations of functions resembling Perlin Noise, simplex noise, and
ordinary value noise. They're actually pretty close, but for simplex noise
I had to tweak some of the magic numbers from Perlin's paper, and the gradient
generation is completely separate from the interpolation.

TurtleGraphics.jl does about what it says in the filename, except that
instead of just fwd/back and turning, you can move the cursor through
arbitrary affine transformations.

The other files do various things like render IFSs, L-Systems, noise functions, etc.

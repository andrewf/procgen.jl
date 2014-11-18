module Ifs

using Util
using Draw

export choose_probs, render_ifs

# given a list of functions, return
# a list of tuples of the areas of the unit square under the function
# and the function itself. since our probabilities don't have to
# sum to 1, this serves as a list of functions and their probabilities
# assuming the only purpose of the probability is to ensure even coverage
function choose_probs(fns)
    map(fns) do f
        # choose weight based on area of image of unit square under f
        a = f([0;0])
        b = f([1;0])
        c = f([1;1])
        d = f([0;1])
        p = cat(2, a, b, c, d)
        (max(area(p), .03), f)  # we don't want area to be 0
    end
end

# given an image, a color and a [(prob, fn)], render
# the specified IFS
function render_ifs(img, color, fns::Vector{(Float64, Function)})
    x = [0; 0]
    ts = random_dispatcher(fns)
    for i in range(1,1000000)
        x = ts(x)
        if i > 100  # this is supposedly important
            # plot the point
            plot(img, x, color)
        end
    end
end

end  # module Ifs

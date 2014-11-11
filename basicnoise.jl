using Util
using Draw
using Noise

function thisnoise(x, y)
    simplex(default_grads.get, x, y)
end

render_by_pixels("basicnoise", 0, 0, 5, 5, 100) do x,y
    v = noise_sum(  # main pattern
        thisnoise,
        4,    # num layers
        1.5,  # amplitude divisor
        2.3,   # freq multiplier
        x, y)
    v = real_to_01(v)
    RGB(v,v,v)
end


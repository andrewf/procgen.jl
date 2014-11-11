using Util
using Draw
using Noise

tan = RGB(0xe4/255, 0xce/255, 0x86/255)
green = RGB(0x70/255, 0xaf/255, 0x00/255)
brown = RGB(0x7e/255, 0x63/255, 0x1f/255)

function thisnoise(x, y)
    simplex(default_grads.get, x, y)
end

render_by_pixels("simplex", 0, 0, 1.5, 1.5, 100) do x,y
    v = noise_sum(  # main pattern
        thisnoise,
        4,    # num layers
        1.01,  # amplitude divisor
        2.0,   # freq multiplier
        x, y)
    #s = octaves(thisnoise, 2, x+1.5, y+1.5)  # edge width
    s = 0 # max(s, 0) * 0.3
    # v is still in reals, not [0,1]
    if -s < v && v < s 
        r = .5
        brown
    elseif v < 0
        r = 0
        green
    else
        r = 1
        tan
    end
    #RGB(r,r,r)
end


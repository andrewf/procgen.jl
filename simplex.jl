using Util
using Draw
using Noise

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1.0)

tan = RGB(0xe4/255, 0xce/255, 0x86/255)
green = RGB(0x70/255, 0xaf/255, 0x00/255)
brown = RGB(0x7e/255, 0x63/255, 0x1f/255)

function thisnoise(x, y)
    simplex(get_gradient, x, y)
end

render_by_pixels("simplex", 0, 0, 4, 4, 100) do x,y
    v = noise_sum(thisnoise, 4, 1.7, 2.5, x, y)  # main pattern
    s = octaves(thisnoise, 2, x+1.5, y+1.5)  # edge width
    s = max(s, 0) * 0.3
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


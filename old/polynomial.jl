using Images
using Color

img = makeImage(
        # position
        -2.2, -2,
        # dimensions
        4, 4,
        # resolution
        200  # px/u
      )

function real_to_01(x)
    (atan(x) + pi/2)/pi
end

println("generating")

each_pixel(img) do x,y
    c = x + y*im
    z = c^5 - 2c^4 + 3c^2 + 1
    # derive color from z
    d = z - c # distance traveled
    return convert(RGB, HSV(240.0, real_to_01(real(z)), real_to_01(imag(z))))
end


println("writing img")
imwrite(img.data, "poly.png")

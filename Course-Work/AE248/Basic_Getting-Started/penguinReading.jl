using Plots
using FileIO
using ImageIO
using Statistics
using Images
println("\033c")

img = load("./penguins.png")
flattened_img = vec(img)
# println(flattened_img[2].r)
flattened_img_channel = [val.r for val in flattened_img]
# println(img[1])
println(size(img))
display(img[200:size(img)[1], 100:size(img)[2]])
# histogram(flattened_img_channel)


# println(img)


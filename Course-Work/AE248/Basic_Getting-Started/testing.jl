using Plots
using Statistics
print("\033c")
divs = 100000
x = LinRange(0, 2π, divs)
sinx = sin.(x)
x_percentiles = [quantile(sinx, i/100) for i in 0:100] 

plot(
plot([0:100],x_percentiles),

histogram(sinx, bins=200)
)




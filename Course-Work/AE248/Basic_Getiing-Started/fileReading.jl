using Plots
using Statistics
print("\033c")

xVals = []
yVals = []

open("./data.txt") do f
    for line in readlines(f)
        vals = [parse(Float64, val) for val in split(line)]
        push!(xVals, vals[2])
        push!(yVals, vals[1])
    end
end

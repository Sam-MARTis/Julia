using Observables
using GLMakie

print("\033c")

g = -0.3;

positions = Observable(zeros(Float32, 100, 2)) 
velocities = Observable(-0.2 .+ 0.2 .* rand(Float32, 100, 2))
function updateValues(list1, list2, dt::Float64)
    list1[:, 1] .+= list2[:, 1] * dt;  
    list1[:, 2] .+= list2[:, 2] * dt;
    list2[:, 2] .+= g*dt;


    notify(positions) 
end

# Initialize the plot with lines for the positions
fig, ac, l = scatter(positions, linewidth = 2)

# Loop to update the positions over time
record(fig, "./observablePlotting.gif", 1:100) do i
    updateValues(positions[], velocities[], 0.1)
end
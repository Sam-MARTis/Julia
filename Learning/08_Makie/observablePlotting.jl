using Observables
using GLMakie
positions = Observable(zeros(Float32, 100, 2))
velocities = Observable(zeros(Float32, 100, 2))

function updateValues(list1, list2, dt::Float32)
    list1[:, 1] .+= list2[:, 1]*dt;
    list1[:, 2] .+= list2[:, 2]*dt;
    list1[] = list1[];
    list2[] = list2[];
end


plotThis = on(positions) do value
    println("Update arrived");
    lines(value[1, :], value[2,:]; linewidth = 2);
    # FigureAxisPlot()

end

# updateValues(positions[], velocities[], 0.1)
positions[] = positions[];
println("Done")
lines(positions[1, :], positions[2,:]; linewidth = 2);
# seconds = 0:0.1:2
# measurements = [8.2, 8.4, 6.3, 9.5, 9.1, 10.5, 8.6, 8.2, 10.5, 8.5, 7.2,
#         8.8, 9.7, 10.8, 12.5, 11.6, 12.1, 12.1, 15.1, 14.7, 13.1]

# lines(seconds, measurements; linewidth = 2)
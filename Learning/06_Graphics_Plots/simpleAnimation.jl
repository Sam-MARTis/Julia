print("\033c")

# using Plots


a = 1:0.1:10
b = sin.(a)
c = zeros(length(a))



using Plots
using Printf
anim = @animate for i in 1:10
    plot()
    for j in eachindex(a)


        scatter!(a, sin.(a+c))
        c.+= 0.001
        println(j)
    end
    # scatter!(a, )
    # title!(Printf.format("Time: %d", i))
    xlabel!("x")
    ylabel!("y")
end
# plot()
# scatter!(a, b)

# N = 1  # Number of particles
# T = 100  # Number of time steps
# positions = rand(N, 3, T)  # Replace with your actual data

# # Set up the animation
# anim = @animate for t in 1:T
#     plot()
#     for i in 1:N
#         # scatter!(positions[i, 1, 1:t], positions[i, 2, 1:t], positions[i, 3, 1:t], label=false)
#         scatter!(b)
#     end
#     title!(Printf.format("Time: %d", t))
#     xlabel!("x")
#     ylabel!("y")
#     zlabel!("z")
# end

# # Save the animation as a GIF
gif(anim, "n_body_simulation.gif", fps=15)
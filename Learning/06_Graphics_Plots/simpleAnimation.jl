print("\033c")

# using Plots


a = 1:0.1:10
b = sin.(a)
c = zeros(length(a))



using Plots
using Printf


anim = @animate for i in 1:10
    plot()
    # plot!(Plots.Legend = false)
    plot!(legend= false)
    

        scatter!(a, sin.(a+c))

    c.+= 0.005
    # scatter!(a, )
    # title!(Printf.format("Time: %d", i))
    xlabel!("x")
    ylabel!("y")
end





gif(anim, "./Learning/06_Graphics_Plots/n_body_simulation.gif", fps=15)
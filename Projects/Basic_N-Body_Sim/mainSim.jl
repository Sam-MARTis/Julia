print("\033c")
using LinearAlgebra
using Plots
using Animations
gr()
PARTICLES = 400
G = 10000
maxForce = 8
dt = 0.1

mainList = zeros(PARTICLES, 4, 2)
mainList[:, 4, 1] .= 1
mainList[:, 4, 2] .= 1

# mainList[:, 1, 1] .= rand(1:300)
# mainList[:, 1, 2] .= rand(1:300)

mainList[:, 1, :] = rand(1:300, PARTICLES, 2)

function maxVec(v, maxVal)
    v .= ((v.<maxVal).*v) .+ ((v.>=maxVal).*maxVal)
end


function updateForceAtParticle(list, i, gVal, maxForce)
    for j ∈ 1:length(list[:, 1, 1])
        if i == j
            continue
        else
            r = list[j, 1, :] - list[i, 1, :]
            F = r*gVal*list[i, 4, 1]*list[j, 4, 1]/(norm(r)^3)
            F = F*(norm(F)<maxForce) + F*(norm(F)>=maxForce)*maxForce/norm(F)
            list[i, 3, :] += F
        end
    end
end


function updateValues(list, dt)
    # one is position, 2 velocity, 3 force, 4,1 is mass, 4,2 is radius
    list[:, 1, :] .+= list[:, 2, :]*dt/2
    list[:, 2, :] .+= (list[:, 3, :]*dt ./ list[:, 4, 1])
    list[:, 1, :] .+= list[:, 2, :]*dt/2
    list[:, 3, :] .= 0
end

# println(mainList[:, 1, :])

# updateForceAtParticle(mainList, 1, G)
# updateForceAtParticle(mainList, 2, G)
# updateValues(mainList, dt)
anim = @animate for i in 1:50
    plot()
    plot!(legend= false)
    

    scatter!(mainList[:, 1, 1], mainList[:, 1, 2], xlims = (0, 300), ylims = (0, 300))
    for j ∈ 1:PARTICLES
        updateForceAtParticle(mainList, j, G, maxForce)
    end
    updateValues(mainList, dt)
    xlabel!("x")
    ylabel!("y")
end


display(anim)
# animate(anim)
gif(anim, "./Projects/Basic_N-Body_Sim/n_body_simulation.gif", fps=15)
# for i ∈ 1:200
#     for j ∈ 1:PARTICLES
#         updateForceAtParticle(mainList, j, G)
#     end
#     updateValues(mainList, dt)
# end

# println(mainList[:, 1, :])
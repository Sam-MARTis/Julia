print("\033c")
using LinearAlgebra
using Plots
using Animations
using CUDA
gr()
PARTICLES = 40
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

function gpu_updateForceAtParticles(mainList, G, maxForce)
    index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
    stride = gridDim().x*blockDim().x

    for i ∈ index:stride:length(mainList[:, 1, 1])
        for j ∈ 1:length(mainList[:, 1, 1])
            if i == j
                continue
            else
                r = mainList[j, 1, :] - mainList[i, 1, :]
                F = r*G*mainList[i, 4, 1]*mainList[j, 4, 1]/(norm(r)^3)
                F = F*(norm(F)<maxForce) + F*(norm(F)>=maxForce)*maxForce/norm(F)
                mainList[i, 3, :] += F
            end
        end
    end

end


mainList_d = CuArray(mainList)
anim = @animate for i in 1:50
    plot()
    plot!(legend= false)
    global mainList, mainList_d
    # mainList = Array(mainList_d)
    

    scatter!(mainList[:, 1, 1],mainList[:, 1, 2], xlims = (0, 300), ylims = (0, 300))
    # for j ∈ 1:PARTICLES
    #     updateForceAtParticle(mainList_d, j, G, maxForce)
    # end
    @cuda threads=256 blocks=ceil(Int, PARTICLES/256) gpu_updateForceAtParticles(mainList_d, G, maxForce)
    mainList = Array(mainList_d)
    updateValues(mainList, dt)
    mainList_d = CuArray(mainList)
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
print("\033c")
using LinearAlgebra
using Plots
using Animations
using CUDA
# gr()
PARTICLES = 1000

G = 100
maxForce = 150
dt = 0.1
min_range, max_range = 50, 850

mainList = zeros(Float32, PARTICLES, 4, 2)
mainList[:, 4, 1] .= 1
mainList[:, 4, 2] .= 1
# mainList[:, 1, 1] .= rand(1:300)
# mainList[:, 1, 2] .= rand(1:300)

mainList[:, 1, :] = rand(min_range:max_range, PARTICLES, 2)

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

function gpu_updateParticles(mainList, G:: Int32, maxForceSquared:: Float32, dt:: Float32)
    # inVal = 3
    

    index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
    # indx = 3
    # index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
    stride = gridDim().x*blockDim().x

    for i ∈ index:stride:size(mainList, 1)
        for j in axes(mainList, 1)
            if i == j
                continue
            else
                # r =  mainList[j, 1, :] -mainList[i, 1, :]
                dx = mainList[j, 1, 1] - mainList[i, 1, 1]
                dy = mainList[j, 1, 2] - mainList[i, 1, 2]
                normRSquared = dx*dx + dy*dy
                if normRSquared == 0
                    continue
                else

                Fx = dx*G*mainList[i, 4, 1]*mainList[j, 4, 1]/(normRSquared^(3/2))
                Fy = dy*G*mainList[i, 4, 1]*mainList[j, 4, 1]/(normRSquared^(3/2))
                normFSquared = Fx*Fx + Fy*Fy
                Fx = Fx*(normFSquared<maxForceSquared) + (normFSquared>=maxForceSquared)*((maxForceSquared/normFSquared)^0.5)*Fx
                Fy = Fy*(normFSquared<maxForceSquared) + (normFSquared>=maxForceSquared)*((maxForceSquared/normFSquared)^0.5)*Fy
                mainList[i, 3, 1] += Fx
                mainList[i, 3, 2] += Fy
                end
                # normRSquared = (r[1]^2 + r[2]^2)
                # normRSquared = (r[1]*r[1] + r[2]*r[2])
    #             F = r*G*mainList[i, 4, 1]*mainList[j, 4, 1]/(normRSquared^(3/2))
    #             normFSquared = F[1]^2 + F[2]^2 
    #             F = F*(normFSquared<maxForceSquared) +(normFSquared>=maxForceSquared)*((maxForceSquared/normFSquared)^0.5)*F
    #             mainList[i, 3, :] .+= F
            end
        end
    end
    for i ∈ index:stride:size(mainList, 1)
        for k in axes(mainList, 3)
            mainList[i, 1, k] += mainList[i, 2, k] * dt / 2
        end
        for k in axes(mainList, 3)
            mainList[i, 2, k] += (mainList[i, 3, k]*dt / mainList[i, 4, 1])
        end
        for k in axes(mainList, 3)
            mainList[i, 1, k] += mainList[i, 2, k]*dt/2
        end
        # mainList[i, 2, :] .+= (mainList[i, 3, :]*dt ./ mainList[i, 4, 1])
        # mainList[i, 1, :] .+= mainList[i, 2, :]*dt/2
        mainList[i, 3, :] .= 0
    end

    return nothing

end

# println(mainList)
mainList_d = CuArray(mainList)
# @cuda threads=256 blocks=5 gpu_updateParticles(mainList_d, Int32(G), Float32(maxForce), Float32(dt))
# println(Array(mainList_d))
anim = @animate for i in 1:800
    plot()
    plot!(legend= false)
    global mainList_d
    local listMine = Array(mainList_d)

    # mainList = Array(mainList_d)


    scatter!(listMine[:, 1, 1],listMine[:, 1, 2], xlims = (min_range-200, max_range+200), ylims = (min_range-200, max_range+200), markersize = 1, color = :blue)

    @cuda threads=256 blocks=ceil(Int, PARTICLES/256) gpu_updateParticles(mainList_d, Int32(G), Float32(maxForce), Float32(dt))

    mainList = Array(mainList_d)
    # updateValues(mainList, dt)
    # mainList_d = CuArray(mainList)
    xlabel!("x")
    ylabel!("y")
end


# display(anim)
# animate(anim)
gif(anim, "./Projects/Basic_N-Body_Sim/n-body-simulation_$(PARTICLES)-particles_$(dt)-dt_$(G)-G.gif")
# for i ∈ 1:200
#     for j ∈ 1:PARTICLES
#         updateForceAtParticle(mainList, j, G)
#     end
#     updateValues(mainList, dt)
# end

# println(mainList[:, 1, :])
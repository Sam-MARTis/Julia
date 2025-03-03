print("\033c")

using CUDA
using Plots
function proceed!(State, Bet_Result, size, iterCount)
    index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
    stride = gridDim().x*blockDim().x
    # i = index
    # while(i<=size)
    for i ∈ index:stride:size
        #1 is balance
        #2 is bet amount.
        #3 is iteration survives
        #4 is 'isAlive?'
        @inbounds State[i, 1] += State[i, 2]*(2*Bet_Result[i] - 1)
        @inbounds State[i, 4] *= (State[i, 1]>0)
        @inbounds State[i, 2] = (2*State[i, 2]*(1-Bet_Result[i]) + 1*(Bet_Result[i]))*State[i, 4]
        @inbounds State[i, 3] += 1*State[i, 4]
        @inbounds State[i, 5] -= 1


        # i += stride

    end
    return nothing
end 

# function demo_func!(state, randval)
#     index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
#     stride = gridDim().x*blockDim().x
#     for i ∈ index:stride:length(state)/4
#         state[index] += 1
#     end
#     return nothing
    
# end

# const iterations = 1000
people =  51200000
initialBalance = 100
iterationsCount = 1000
viewValues = iterationsCount - 50
function main_func()
    state = ones(people, 5)
    state[:, 1] .= initialBalance
    state_d = CuArray(state)
    random_d = CUDA.rand(Bool, people)

    blockCount = cld(length(state), 512)
    for _ ∈ 1:iterationsCount
        # @cuda threads=512 blocks=blockCount proceed!(state_d, random_d, people, iterationsCount)
        @cuda threads=512 blocks=blockCount proceed!(state_d, random_d, people, iterationsCount)
        random_d = CUDA.rand(Bool, people)

    end




    # @cuda threads=256 blocks=blockCount proceed!(state_d, random_d, people, iterationsCount)
    # @cuda threads=256 blocks=blockCount proceed!(state_d, random_d, people, iterationsCount)
    

    # @cuda threads=256 blocks=blockCount demo_func!(state_d, random_d)

    # println(Array(state_d))
    state_h = Array(state_d)
    count_val = zeros(viewValues)
    for i ∈ 1:people
        if(Int32(state_h[i, 3]-1) <viewValues)
        
            count_val[Int32(state_h[i, 3]-1)] += 1
        # println(state_h[i, 3])
        end

        

    end
    return count_val
    plot(count_val)
    println("Done")
end


@time begin
    array_final = main_func()
end

println("GPU Done")
plot(array_final)




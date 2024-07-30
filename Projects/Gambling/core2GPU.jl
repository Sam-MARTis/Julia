print("\033c")

using CUDA
function proceed!(State, Bet_Result, size)
    index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
    stride = gridDim().x * blockDim().x
    for i ∈ index:stride:size
        #1 is balance
        #2 is bet amount.
        #3 is iteration survives
        #4 is 'isAlive?'
        State[i][1] += State[i][2]*(2*Bet_Result[i] - 1)
        State[i][4] = (State[1][1]>0)
        State[i][2] = (2*State[i][2]*Bet_Result[i] + 1*(1-Bet_Result[i]))*State[i][4]
        State[i][3] += 1*State[4]
    end
end 

function demo_func!(state, randval)
    index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
    stride = gridDim().x*blockDim().x
    for i ∈ index:stride:length(state)/4
        state[index] += 1
    end
    return nothing
    
end

# const iterations = 1000
const people = 200000
const initialBalance = 1000
function main_func()
    state = ones(people, 4)
    state[:, 1] .= initialBalance
    state_d = CuArray(state)
    random_d = CUDA.rand(Bool, people)

    # # @cuda threads=people blocks=1 proceed!(state_d, random_d, people)
    blockCount = cld(length(state), 256)
    @cuda threads=256 blocks=blockCount demo_func!(state_d, random_d)
    # println(Array(state_d))
end



main_func()




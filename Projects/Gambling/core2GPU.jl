print("\033c")

using CUDA
function proceed(State, Bet_Result, size)
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

const iterations:: Int32 = 1000
const people:: Int32 = 100
const initialBalance:: Int32 = 1000
function main()
    state = CUDA.fill(initialBalance, people)
    for j∈ 1:iterations
        for k ∈ 1:people

        end
    end
end



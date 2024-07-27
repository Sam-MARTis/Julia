using CUDA
using Plots

print("\033c")

const startBettingWith = 1
const startingBalance = 10000
const playersCount = 1000000
const iterationCount = 500000

function bet!(balance, amount)
    balance .= balance .- amount
    win = CUDA.rand(length(balance)) .> 0.5
    balance[win] .= balance[win] .+ 2 .* amount[win]
    return win
end

people = CUDA.zeros(Int, iterationCount)
initial_betamt = CUDA.fill(startBettingWith, playersCount)
initial_balance = CUDA.fill(startingBalance, playersCount)

betamt = similar(initial_betamt)
balance = similar(initial_balance)

for j in 1:playersCount
    CUDA.copyto!(betamt, initial_betamt)
    CUDA.copyto!(balance, initial_balance)

    for i in 1:iterationCount
        win = bet!(balance, betamt)
        betamt .= ifelse(win, 1, betamt .* 2)

        bankrupt = balance .< 0
        if any(bankrupt)
            CUDA.atomic_add!(people, i, sum(bankrupt))
            break
        end
    end

    if mod(j, 10000) == 1
        println(j)
    end
end

people_cpu = Array(people)
plot(people_cpu)
using Plots
print("\033c")

startBettingWith = 1
startingBalance = 100
playersCount = 100000
iterationCount = 950



betamt = 1;

function bet(amount)
    global balance
    balance = balance - amount
    if (rand() > 0.5)
        balance += 2 * amount
        return true
    else
        return false
    end
end

balance = startingBalance

people = [0 for i ∈ 1:iterationCount];

@time begin


    for j ∈ 1:playersCount
        global people
        global balance

        local betamt = startBettingWith
        balance = startingBalance
        local s = 1
        n=300

        for i ∈ 1:iterationCount
            for k∈ 1:n
                for l ∈ 1:n
                    if (s==1)
                        s=2
                    else
                        s=1
                    end
                end
            end

            if (bet(betamt) == false)
                betamt *= 2
            else
                betamt = 1
            end

            # betamt = bet(betamt) ? 1 : betamt*2
            if (balance < 0)
                global people[i] += 1
                break
            end


        end

        # if (mod(j, 10000) == 1)
        #     # println(j)
        # end


    end
    
end
println("CPU done")
plot(people, xlabel="Iterations", ylabel="Number of Bankruptcies", title="Martingale Strategy Simulation")


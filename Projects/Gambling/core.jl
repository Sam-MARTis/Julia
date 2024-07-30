using Plots
print("\033c")

const startBettingWith = 1
const startingBalance = 100
const playersCount = 10000
const iterationCount = 50000



betamt = 1

function bet(amount)
    global balance
    balance = balance -amount
    if(rand()>0.5)
        balance += 2*amount;
        return true;
    else
        return false
    end
end

balance = startingBalance

people = [0 for i ∈ 1:iterationCount]
for j ∈ 1:playersCount
    global people
    global balance

    local betamt = startBettingWith
    balance = startingBalance

    for i ∈ 1:iterationCount

        if(bet(betamt) == false)
            betamt *= 2
        else
            betamt = 1
        end

        # betamt = bet(betamt) ? 1 : betamt*2
        if(balance<0)
            global people[i] += 1
            break
        end

        
    end

    if(mod(j, 10000)==1)
        println(j)
    end


end


plot(people)
    
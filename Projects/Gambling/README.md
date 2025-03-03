This whole thing started when I tried to convince my friend that doubling your bet amount when losing is not a 'guaranteed-profit' strategy.

Not being convinced by the expected value of the process, we settled on a different strategy

As any normal, grass-touching human would do, we decided that the best course of action would be to simulate this strategy (which I later learnt was called the Martingale's strategy)
We both wrote our code. I wrote it in Julia because I was learning it at the time and it seemed like it would be anice change of syntax.

The graphs we got were...surprising.

Yes, the strategy was not a surefire victory, but people were loosing quite slowly, with some of them surviving for tens of thousands of matches despite starting with only 100 times their initial bet amount.

But more importantly, if you plotted the number of players who died at a particular game vs the number of games, you got a very...strange pattern.
The number of people who died reduced as more iterations passed(which made sense because there were lesser people still playing to lose), but at some intervals, the number of people dying seemed to almost halve. 
And even more freakily, the size of these intervals kept doubling!
![image](https://github.com/user-attachments/assets/01cf8f4a-d6e9-43f7-9114-5dada4d8d111)

We realised we needed more poeple. So that's what we did! We got better results, but we hit a computational barrier. We could simulate only about 1 million players over 1000 iterations. And that took a LONG time. Around 40 minutes we waited as I watched my laptop burn up from afar.

From the graph we obtained, we were sure there was a pattern, but our CPUs couldn't take more.

Luckily, I was trying out stuff in webGL and CUDA. I was looking into the whole GPU computing field. That was why I started learning Julia in the first place.

Julia has an ace up its sleeve: It can run natively on the GPU, no other-language kernel needed.

So I spent the next day figuring out how GPU computing works and how to use CUDA with Julia.

What took the CPU 40 minutes, Julia would do in an order of magnitude less.

Here's an example of a stark difference- Simulating 100k people over 1k games


CPU: 21.99 seconds

GPU: 0.260070 seconds

![image](https://github.com/user-attachments/assets/85aab710-e863-450e-b4f7-55b125f9ba72)
![image](https://github.com/user-attachments/assets/1165e274-75be-4d49-bbf8-6f2480df72a3)





The end result? I managed to simulate 51.2 billion players over 50k games 

![image](https://github.com/user-attachments/assets/635ab7fe-e911-44e0-af79-a942a30f082f)


![image](https://github.com/user-attachments/assets/ed63c094-a8a4-4578-8a72-76f445aa0cc8)

![image](https://github.com/user-attachments/assets/cdace02f-530b-4e4d-b224-c38823918422)





The code lies in the following GPU kernel- 
```Julia
function proceed!(State, Bet_Result, size, iterCount)
    index = ((blockIdx().x -1)*blockDim().x) + threadIdx().x
    stride = gridDim().x*blockDim().x
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

    end
    return nothing
end 

```

I then call the function in the main code using the CPU:
```Julia
blockCount = cld(length(state), 512)
    for _ ∈ 1:iterationsCount
        @cuda threads=512 blocks=blockCount proceed!(state_d, random_d, people, iterationsCount)
        random_d = CUDA.rand(Bool, people)
    end
```

Works on the principle of same process different data. Now it was simple to just change the values to simulate other gambling strategies as well :)

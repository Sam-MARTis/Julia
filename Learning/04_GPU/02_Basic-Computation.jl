N = 2^20
x = fill(1.0f0, N) #float32
y = fill(2.0f0, N)

y .+= x

# The above are performed on cpu


using Test
@test all(y .== 3.0f0)





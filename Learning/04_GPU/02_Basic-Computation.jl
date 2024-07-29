print("\033c")
N = 2^20
x = fill(1.0f0, N) #float32
y = fill(2.0f0, N)

# y .+= x




using Test
# @test all(y .== 3.0f0)



function sequential_add!(y, x)
    for i ∈ eachindex(y, x)
        @inbounds y[i] += x[i]
    end
    return nothing
end
# The above are performed on cpu


fill!(y, 2)
sequential_add!(y, x)

@test all(y .== 3.0f0)



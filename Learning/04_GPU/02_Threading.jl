# We will be doing mutithreading in this script

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

function parallel_add!(y, x)
	Threads.@threads for i ∈ eachindex(y, x)
		@inbounds y[i] += x[i]
	end
	return nothing
end



fill!(y, 2)
sequential_add!(y, x)
@test all(y .== 3.0f0)
parallel_add!(y, x)
@test all(y .== 4.0f0)


using BenchmarkTools
@btime sequential_add!($y, $x)
# @test all(y .== 4.0f0)

@btime parallel_add!($y, $x)
# @test all(y .== 4.0f0)


using Printf
using Statistics
a1 = zeros(Int32, 2, 2)

a2 = Array{Int128}(undef, 5)

a3 = Float64[]

a4 = [1, 2, 3]

println(a4[end])

println(2 in a4)

println(findfirst(isequal(2), a4))
f(a) = (a>=2) ? true : false
println(findall(f, a4))
println(count(f, a4))

println(size(a4))
println(sum(a4))

splice!(a4, 3:2, [8,9]) #n:n-1 for not removing elements. 
println(a4)
println(maximum(a4))
println(2a4)
println(a4*2)

a5 = [1, 3.14, "hello"]

a6 = [sin, cos, tan]
for n in a6
    println(n(0))
end

a7 = [1 2 3; 4 5 6]
for n = 1:2, m = 1:3
    @printf("%d", a7[n,m])
end

println(a7[:, 2])

a9 = collect(2:2:10)
for n in a9 println(n) end

a10 = [n^2 + m for n in 1:5, m in 1:6]
println(a10)


push!(a9, 36)
println(a9)


a11 = rand(0:9, 5, 8)
println(a11)


using Printf
using Statistics

t1 = ((1,2), (1, 4))
println(t1[1])


tw = (name = ("Samanth", 100), age = (93, 200))
println(tw[1])
println(tw.age)





#Dictionaries

d1 = Dict("pi"=>3.14, "e"=>2.718)
println(d1["pi"])

d1["golden"] = 1.618
delete!(d1, "pi")
haskey(d1, "pi")
println(in(d1, "pi"=>3.14))

println(keys(d1))
println(values(d1))


for kv in d1
    println(kv)
end

for(key, value) in d1
    println(value)
end
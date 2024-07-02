
v1::Float64 = 22/7

v9::Int128 = 14
# v2::Float64 = 2.3
println(v1)

c1 = Char(120)
println(c1)

println(UInt8(trunc(3.1415)))

println(parse(Int8, "1"))
# print(s1)
s1::String = "New string here mwwhaha stuff here\n"
println(length(s1))
println(s1[1])
println(s1[2:4])
s2 = string("Testing", " this rn")
println(s2)
println("String "*"Concatenation")

println("Minutes in a day: $(24*60)")

s3 = """this
is 
a
multi-line
string
"""

println("Zirst">"Second")
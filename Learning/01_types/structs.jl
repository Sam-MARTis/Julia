struct Customer
    name::String
    balance:: Float32
    id:: Int32
end

bob = Customer("Bob Smith", 10.50, 123)
println(bob.name)

mutable struct Person
    name::String
    balance:: Number
    id:: Int32
end

p1 = Person("Sam", 1223, 42)
println(p1)

p1.id = 60
println(p1)




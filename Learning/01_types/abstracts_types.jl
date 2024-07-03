


abstract type Animal

end

struct Dog <: Animal
    name::String
    bark::String
end

struct Cat <:Animal
    name::String
    bark::String 
end

bowser = Dog("Bowser", "Ruff")
muffin = Cat("Muffin", "Meow")



function makeSound(animal::Animal)
    println(animal.bark)

end

makeSound(bowser)
makeSound(muffin)
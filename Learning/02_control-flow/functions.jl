


f(a) = a^3
println(f(3))


function isOdd(number = 42)
    if number%2 == 0
        println(:Even)
    else
        println(:Odd)
    end
end

isOdd(4)

v1 = 4

function changev1()
    v1=10
end

function changev1_2()
    global v1 = 10
end

changev1()
println(v1)
changev1_2()
println(v1)


function getSum(args...)
    sum = 0
    for a in args
        sum+=a
    end
    return sum
end


println(getSum(1,2,3,9))



#Retruning functions

function makePowerOf(x)
    return function(a) return a^x end
end 

pow3 = makePowerOf(3)
println(pow3(4))



# Function overloading 

function getSumOverload(num1::Number, num2::Number)
    return num1 + num2
end

function getSumOverload(num1::String, num2::Number)
    return parse(Float32, num1) + num2
end

println(getSumOverload(3, 4))
println(getSumOverload("2", 3))

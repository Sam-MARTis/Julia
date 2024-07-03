print("Enter a number ")
num1 = chomp(readline())
print("Enter second number ")
num2 = chomp(readline())
try
    val = parse(Int32, num1)/parse(Int32, num2)
    if val==Inf
        error("Cant divide by zero")
    else
        println(val)
    end
catch e
    println(e)
end


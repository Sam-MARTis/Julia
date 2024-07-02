using Printf

number = 42

if number>30
    println("Old")
elseif number<18
    println("Too young")
else 
    println("Too middle")
end

@printf("true || false = %s\n", true || false ? "true" : "false")
@printf("!true = %s\n", !true)
macro repeatTimes(n, expression)
    quote
        for i=1:$(esc(n))
            $(esc(expression))
        end
    end
    
end


@repeatTimes(3, println(100))


macro doWhile(exp)
    @assert exp.head == :while 
#I do not understand this yet. I'll figure it out
        esc(quote
            $(exp.args[2])
            $exp
        end)
end


z = 0


@doWhile while z<10 
    global z +=1
    println(z)
end
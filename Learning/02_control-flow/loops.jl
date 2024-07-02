i = 1
while i<20
    if (i%2)==0
        println(i)
    end
    global i+=1
    if i>= 10
        break
    end
end


for i=1:5
    println(i)
end

for i in [1,4,5,6,8]
    println(i)
end

for i = 1: 5, j = 2:2:10
    println((i, j))
end
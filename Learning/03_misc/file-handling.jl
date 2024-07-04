open("testing1.txt", "w") do file
    write(file, "Here be dragon\nCreatures of wonder")
end

open("testing1.txt", "r") do file
    data = read(file, String)
    println(data)
end

open("testing1.txt", "w") do file
    write(file, "Here were dragons\nNo more")
end




open("testing1.txt", "r") do file
    for line in eachline(file)
        println(line)
    end
end
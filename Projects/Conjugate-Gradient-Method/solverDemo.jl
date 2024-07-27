print("\033c")

using LinearAlgebra
A = [3 2; 2 6];
b = [2.0; -8]
x = [0.0; 0.0]

function fprime(x, mat, finalVec) 
    return mat*x - finalVec
end

for _=1:50
    global x
    r = -fprime(x, A, b)
    # println(r)
    alpha = (dot(r , r)/dot(r, (A*r)))

    x = x + (alpha*r)
end

println(x)



print("\033c")

using LinearAlgebra
A = [3 2; 2 6];
b = [2.0; -8]
x = [0.0; 0.0]

function fprime(x, mat, finalVec) 
    return mat*x - finalVec
end

for i ∈ 1:50
    global x
    r = -fprime(x, A, b)
    alpha = (dot(r , r)/dot(r, (A*r)))
    x = x + (alpha*r)
end

print("Soution obtained is: ")
println(x)
print("Actual solution is: ")
println(A\b)



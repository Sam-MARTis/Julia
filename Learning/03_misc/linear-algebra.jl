using LinearAlgebra
print("\033c")
dot([1, 2, 3], [4, 5, 6]);

[1,2,3] ⋅ [4,5,6];

# Matrix multiplication
A = [1 2; 3 4];
B = [5.0 6; 7 8];
C = A * B;
# println(C)
println(A*[1, 2])
print(A\[5, 11])
print("\033c")
using LinearAlgebra

A = 1.1
L = 1
E = 0.01
I = 0.9




K = [     12/(L^3) 6/(L^2) -12/(L^3) 6/(L^2);
	6/(L^2) 4/L -6/(L^2) 2/L;
	 -12/(L^3) -6/(L^2) 12/(L^3) -6/(L^2);
	  6/(L^2) 2/L -6/(L^2) 4/L
]
println(K)
b = []
x = []

function fprime(x, mat, finalVec)
	return mat * x - finalVec
end

for i ∈ 1:50000
	global x
	r = -fprime(x, K, b)
	# println(r)
	alpha = (dot(r, r) / dot(r, (K * r)))

	x = x + (alpha * r)
end

# println(x)
# println(K*x)
println(det(K))
# println(inv(K)*b)



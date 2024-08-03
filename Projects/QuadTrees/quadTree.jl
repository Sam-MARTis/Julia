print("\033c")


module custom_types
struct Body
    x::Float32
    y::Float32
    mass::Float32
    vx::Float32
    vy::Float32
    forceX::Float32
    forceY::Float32

    # Inner constructor with default values
    function Body(x::Float32 = 0.0f0, y::Float32 = 0.0f0, mass::Float32 = 1.0f0, vx::Float32 = 0.0f0, vy::Float32 = 0.0f0, forceX::Float32 = 0.0f0, forceY::Float32 = 0.0f0)
        new(Float32(x), Float32(y), Float32(mass), Float32(vx), Float32(vy), Float32(forceX), Float32(forceY))
    end
end
end

# function 
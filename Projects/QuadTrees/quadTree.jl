print("\033c")

using StaticArrays




module Helpers
export inRange
    Base.@pure function inRange(x::Float32, y::Float32, rx1::Float32, ry1::Float32, width::Float32, height::Float32)
        return ((x >= rx1) && x <= (rx1 + width)) && ((y >= ry1) && (y <= ry1 + height))
    end

    Base.@pure function doesIntersect(x1, y1, w1, h1, x2, y2, w2, h2)
        return (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2)
    end
end

module custom_types
using StaticArrays
using ..Helpers
export *

export Body, QuadTree, inRange, addPoint, subdivide
export *
mutable struct Body
	x::Float32
	y::Float32
	mass::Float32
	vx::Float32
	vy::Float32
	force::SVector{2, Float32}


	# Inner constructor with default values
	function Body(
		x::Float32 = 0.0f0,
		y::Float32 = 0.0f0,
		mass::Float32 = 1.0f0, 
        vx::Float32 = 0.0f0, 
        vy::Float32 = 0.0f0, 
        force::SVector{2, Float32} = SVector{2, Float32}(0.0f0, 0.0f0)
        )
		new(Float32(x), Float32(y), Float32(mass), Float32(vx), Float32(vy), force)
	end
end

mutable struct QuadTree
	x::Float32
	y::Float32
	width::Float32
	height::Float32
	count::Int32
	bodies::Vector{Body}
	maxBodies::Int32
	massContained::Float32
	com::SVector{2, Float32}
	isDivided::Bool
	subTrees::Union{Vector{QuadTree}, Nothing}
	# northWest::Union{QuadTree, Nothing}
	# northEast::Union{QuadTree, Nothing}
	# southWest::Union{QuadTree, Nothing}
	# southEast::Union{QuadTree, Nothing}

	# Inner constructor with default values
	function QuadTree(
		x::Float32 = 0.0f0,
		y::Float32 = 0.0f0,
		width::Float32 = 0.0f0,
		height::Float32 = 0.0f0,
		count::Int32 = Int32(0),
		bodies::Vector{Body} = Vector{Body}(),
		maxBodies::Int32 = Int32(4),
		massContained::Float32 = 0.0f0,
		com::SVector{2, Float32} = SVector{2, Float32}(0.0f0, 0.0f0),
		isDivided::Bool = false,
		subTrees::Union{Vector{QuadTree}, Nothing} = nothing)


		new(Float32(x), Float32(y), Float32(width), Float32(height), Int32(count), bodies, maxBodies, massContained, com, isDivided, subTrees)
	end


    function QuadTree(
        x::Float32 = 0.0f0,
        y::Float32 = 0.0f0,
        width::Float32 = 0.0f0,
        height::Float32 = 0.0f0,
    )
        new(Float32(x), Float32(y), Float32(width), Float32(height), Int32(0), Vector{Body}(), Int32(4), 0.0f0, SVector{2, Float32}(0.0f0, 0.0f0), false, nothing)
    end
end


function subdivide(tree::QuadTree)
	treeNW::QuadTree = QuadTree(tree.x, tree.y, tree.width / 2, tree.height / 2)
	treeNE::QuadTree = QuadTree(tree.x + tree.width / 2, tree.y, tree.width / 2, tree.height / 2)
	treeSW::QuadTree = QuadTree(tree.x, tree.y + tree.height / 2, tree.width / 2, tree.height / 2)
	treeSE::QuadTree = QuadTree(tree.x + tree.width / 2, tree.y + tree.height / 2, tree.width / 2, tree.height / 2)

	tree.subTrees = Vector{QuadTree}([treeNW, treeNE, treeSW, treeSE])
	tree.isDivided = true
end

function addPoint(tree::QuadTree, body::Body)
    if !inRange(body.x, body.y, tree.x, tree.y, tree.width, tree.height)
        return nothing
    end

    if tree.count < tree.maxBodies
        push!(tree.bodies, body)
        tree.count += 1
        tree.com = (tree.massContained * tree.com + body.mass * SVector(body.x, body.y)) / (tree.massContained + body.mass)
        tree.massContained += body.mass
    else
        if !tree.isDivided
            subdivide(tree)
            for subTree in tree.subTrees
                addPoint(subTree, body)
            for bodyOld in tree.bodies
                    # if inRange(bodyOld.x, bodyOld.y, subTree.x, subTree.y, subTree.width, subTree.height)
                        addPoint(subTree, bodyOld)
                    #     break
                    # end
                end
            end
            # empty!(tree.bodies)
            # tree.count = 0
        else
        for subTree in tree.subTrees
            # if inRange(body.x, body.y, subTree.x, subTree.y, subTree.width, subTree.height)
                addPoint(subTree, body)
            #     break
            # end
        end
    end
    end

    return nothing
end






end



using ..custom_types
b1 = Body(1.0f0, 1.0f0, 1.0f0, 0.0f0, 0.0f0)
b2 = Body(2.0f0, 2.0f0, 1.0f0, 0.0f0, 0.0f0)
b3 = Body(3.0f0, 3.0f0, 1.0f0, 0.0f0, 0.0f0)
b4 = Body(4.0f0, 4.0f0, 1.0f0, 0.0f0, 0.0f0)
b5 = Body(4.1f0, 4.0f0, 1.0f0, 0.0f0, 0.0f0)
b6 = Body(6.0f0, 6.0f0, 1.0f0, 0.0f0, 0.0f0)
b7 = Body(2.0f0, 6.1f0, 1.0f0, 0.0f0, 0.0f0)
myTree::QuadTree = QuadTree(0.0f0, 0.0f0, 10.0f0, 10.0f0)
addPoint(myTree, b1)
addPoint(myTree, b2)
addPoint(myTree, b3)
println(myTree.isDivided)
addPoint(myTree, b4)
println(myTree.isDivided)

# subdivide(myTree)


addPoint(myTree, b5)
println(myTree.isDivided)
addPoint(myTree, b6)
addPoint(myTree, b7)
println(myTree.count)
println(myTree.subTrees[1].count)
println(myTree.subTrees[2].count)
println(myTree.subTrees[3].count)

println(myTree.subTrees[4].count)


# function 
# exit()

using Javis

vid1 = Video(500, 500)
function ground(args...)
    background("black")
    sethue("white")
    
end

function object(p=Point(0, 0), color="black")
    sethue(color)
    circle(p, 25, :fill)
    return p
end


myvideo = Video(500, 500)
Javis.Background(1:70, ground)
red_ball = Object(1:70, (args...) -> object(O, "red"), Point(100, 0))
# blue_ball = Object(1:70, (args...) -> object(O, "blue"), Point(200, 80))

act!(red_ball, Action(anim_rotate_around(2π, O)))

render(
    myvideo;
    pathname="./Learning/05_Graphics_Javis/circle.gif"
)
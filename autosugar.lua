function back()
    turtle.turnLeft()
    turtle.turnLeft()
    while not turtle.detect() do
        turtle.forward()
    end
    turtle.turnLeft()
    turtle.turnLeft()
end

function step()
    turtle.dig()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
end

while true do
    turtle.refuel()

    turtle.turnRight()

    while not turtle.detect() do
        os.sleep(1)
    end

    turtle.dig()
    turtle.turnLeft()
    turtle.forward()

    if turtle.detect() then
        back()
    end
end
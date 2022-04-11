function back()
    turtle.left()
    turtle.left()
    while not turtle.detect() do
        turtle.forward()
    end
    turtle.left()
    turtle.left()
end

function step()
    turtle.dig()
    turtle.left()
    turtle.forward()
    turtle.right()
end

while true:
    turtle.refuel()

    turtle.right()

    while not turtle.detect() do
        os.sleep(1)
    end

    turtle.dig()
    turtle.left()
    turtle.forward()

    if turtle.detect() then
        back()
    end
end
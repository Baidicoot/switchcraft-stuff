local laser = peripheral.find "plethora:laser"

local function main()
    while true do
        if turtle.detect() then
            laser.fire(90, 0, 5)
        end
        local ok, reason = turtle.forward()
        if ok then
            break
        elseif reason == "Out of fuel" then
            print("Refuel")
            turtle.refuel()
            sleep(1)
        end
        laser.fire(0, 270, 5)
        laser.fire(0, 270, 5)
    end
end

main()
local laser = peripheral.find "plethora:laser"

local dir = tonumber(args[1])

local function main()
    while true do
        if turtle.detect() then
            laser.fire(dir*90, 0, 5)
        end
        local ok, reason = turtle.forward()
        if not ok and reason == "Out of fuel" then
            print("Refuel")
            turtle.refuel()
        end
        laser.fire(0, 270, 5)
        laser.fire(0, 270, 5)
    end
    os.sleep(0)
end

main()
local modules = peripheral.wrap "back"

local canvas = modules.canvas()

local w, h = canvas.getSize()

local LASE_KEY = keys.x
local FLY_KEY = keys.v
local FALL_KEY = keys.leftShift
local GLIDE_KEY = keys.r
local JETPACK_KEY = keys.c

-- entity overlay

local entityList

function initEntityList()
    if entityList then pcall(entityList.remove) end
    entityList = canvas.addGroup({w-70, 10})
end

function scanEntities(state)
    while true do
        local entities = modules.sense()

        local entityQuantities = {}
        for _,e in pairs(entities) do
            if entityQuantities[e.name] == nil then
                entityQuantities[e.name] = 0
            end
            entityQuantities[e.name] = entityQuantities[e.name] + 1
        end

        print(entityQuantities)

        local status, _ = pcall(entityList.clear)
        if not status then initEntityList() end

        local i = 0
        for n,q in pairs(entityQuantities) do
            entityList.addText({0, i*7}, n .. " " .. tostring(q))
        end

        os.sleep(0)
    end
end

-- drill

function drillRoutine(state)
    while true do
        local meta = modules.getMetaByName(state.PLAYER)

        if meta then
            if state.pressedKeys[LASE_KEY] then
                modules.fire(meta.yaw, meta.pitch, 5)
            end
        end
        os.sleep(0)
    end
end

-- flight

function flightRoutine(state)
    while true do
        local meta = modules.getMetaByName(state.PLAYER)

        if meta then
            if state.pressedKeys[FLY_KEY] then
                modules.launch(meta.yaw, meta.pitch, 4)
            elseif state.pressedKeys[GLIDE_KEY] then
                modules.launch(meta.yaw, meta.pitch, 0.5)
            elseif state.pressedKeys[JETPACK_KEY] then
                modules.launch(0, 270, 1)
            end
        end
        os.sleep(0)
    end
end

-- fall arrest

function fallArrestRoutine(state)
    while true do
        local meta = modules.getMetaByName(state.PLAYER)

        if meta then
            if not (state.pressedKeys[FLY_KEY] or state.pressedKeys[FALL_KEY]) and meta.motionY <= -0.2 then
                modules.launch(0, 270, 0.3)
            end
        end
        os.sleep(0)
    end
end

-- all

function runUtils(state)
    while true do
        local status, err = pcall(function()
            parallel.waitForAll(
                function() fallArrestRoutine(state) end,
                function() drillRoutine(state) end,
                function() flightRoutine(state) end,
                function() scanEntities(state) end)
        end)
        print(err)
        os.sleep(0)
    end
end
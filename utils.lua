local modules = peripheral.wrap "back"
local PLAYER = "baidicoot"

local LASE_KEY = keys.x
local FLY_KEY = keys.r
local FALL_KEY = keys.f

-- drill

function drillRoutine(state)
    while true do
        local alive, meta = pcall(function() return modules.getMetaByName(PLAYER) end)

        if alive then
            if state.pressedKeys[LASE_KEY] then
                modules.fire(meta.yaw, meta.pitch, 5)
            end
        end
    end
end

-- flight

function flightRoutine(state)
    while true do
        local alive, meta = pcall(function() return modules.getMetaByName(PLAYER) end)

        if alive then
            if state.pressedKeys[FLY_KEY] then
                modules.launch(meta.yaw, meta.pitch, 2)
            end
        end
    end
end

-- fall arrest

function fallArrestRoutine(state)
    while true do
        local alive, meta = pcall(function() return modules.getMetaByName(PLAYER) end)

        if alive then
            if not (state.pressedKeys[FLY_KEY] or state.pressedKeys[FALL_KEY]) and meta.motionY <= -0.2 then
                modules.launch(0, 270, 0.3)
            end
        end
    end
end

-- all

function runUtils(state)
    parallel.waitForAll(
        function() fallArrestRoutine(state) end,
        function() drillRoutine(state) end,
        function() flightRoutine(state) end)
end
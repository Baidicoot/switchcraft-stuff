local modules = peripheral.wrap "back"
local PLAYER = "baidicoot"

local LASE_KEY = keys.x
local FLY_KEY = keys.r
local BOOST_KEY = keys.c
local FALL_KEY = keys.f

-- drill

function drillRoutine(state)
    while true do
        if state.pressedKeys[LASE_KEY] then
            modules.fire(state.meta.yaw, state.meta.pitch, 5)
        end
    end
end

-- flight

function flightRoutine(state)
    while true do
        if state.pressedKeys[FLY_KEY] then
            modules.launch(state.meta.yaw, state.meta.pitch, 4)
        elseif state.pressedKeys[BOOST_KEY] then
            modules.launch(state.meta.yaw, state.meta.pitch, 2)
        end
    end
end

-- fall arrest

function fallArrestRoutine(state)
    while true do
        if not (state.pressedKeys[FLY_KEY] or state.pressedKeys[FALL_KEY]) and state.meta.motionY <= -0.2 then
            modules.launch(0, 270, 0.3)
        end
    end
end

-- all

function runUtils(state)
    parallel.waitForAll(
        function() listenRoutine(state) end,
        function() fallArrestRoutine(state) end,
        function() drillRoutine(state) end,
        function() flightRoutine(state) end)
end
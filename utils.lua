local modules = peripheral.wrap "back"
local PLAYER = "baidicoot"
local pressedKeys = {}

local LASE_KEY = keys.x
local FLY_KEY = keys.r
local FALL_KEY = keys.f

function listenRoutine()
    while true do
        local ev, arg = os.pullEvent()
        if ev == "key" then
            pressedKeys[arg] = true
        elseif ev == "key_up" then
            pressedKeys[arg] = false
        end
    end
end

-- drill

function drillRoutine(power)
    parallel.waitForAny(function()
    while true do
        local meta = modules.getMetaByName(PLAYER)
        
        if pressedKeys[LASE_KEY] then modules.fire(meta.yaw, meta.pitch, power) end
    end end)
end

-- flight

function flightRoutine(power)
    parallel.waitForAny(function()
    while true do
        local meta = modules.getMetaByName(PLAYER)
        
        if pressedKeys[FLY_KEY] then modules.launch(meta.yaw, meta.pitch, power) end
    end end)
end

-- fall arrest

function fallArrestRoutine()
    parallel.waitForAny(function()
    while true do
        local meta = modules.getMetaByName(PLAYER)

        if not (pressedKeys[FLY_KEY] or pressedKeys[FALL_KEY]) and meta.motionY <= -0.2 then
            modules.launch(0, 270, 0.3)
        end
    end end)
end

parallel.waitForAll(listenRoutine, fallArrestRoutine, function() drillRoutine(5) end, function() flightRoutine(4) end)
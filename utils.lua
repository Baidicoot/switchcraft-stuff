local modules = peripheral.wrap "back"
local PLAYER = "baidicoot"
local pressedKeys = {}

local LASE_KEY = keys.x
local FLY_KEY = keys.r
local BOOST_KEY = keys.q
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

function drillRoutine()
    while true do
        local meta = modules.getMetaByName(PLAYER)
        
        if pressedKeys[LASE_KEY] then modules.fire(meta.yaw, meta.pitch, 5) end
    end
end

-- flight

function flightRoutine()
    while true do
        local meta = modules.getMetaByName(PLAYER)
        
        if pressedKeys[FLY_KEY] then modules.launch(meta.yaw, meta.pitch, 4)
        elseif pressedKeys[BOOST_KEY] then modules.launch(meta.yaw, meta.pitch, 2)
    end
end

-- fall arrest

function fallArrestRoutine()
    while true do
        local meta = modules.getMetaByName(PLAYER)

        if not (pressedKeys[FLY_KEY] or pressedKeys[FALL_KEY]) and meta.motionY <= -0.2 then
            modules.launch(0, 270, 0.3)
        end
    end
end

parallel.waitForAll(listenRoutine, fallArrestRoutine, drillRoutine, flightRoutine)
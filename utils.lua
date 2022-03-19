local modules = peripheral.wrap "back"

local pressedKeys = {}

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
    local run = false
    parallel.waitForAny(function()
    while true do
        local meta = modules.getMetaByName "baidicoot"
        
        if run then modules.fire(meta.yaw, meta.pitch, power) end
    end end, function()
        while true do
            local _, c = os.pullEvent "char"
            if c == "x" then run = not run end
        end
    end)
end

-- flight

function flightRoutine(power)
    parallel.waitForAny(function()
    while true do
        local meta = modules.getMetaByName "baidicoot"
        
        if pressedKeys[keys.f] then modules.launch(meta.yaw, meta.pitch, power) end
    end end)
end
parallel.waitForAll(listenRoutine, function() drillRoutine(5) end, function() flightRoutine(4) end)
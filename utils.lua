local modules = peripheral.wrap "back"
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
    local run = false
    parallel.waitForAny(function()
    while true do
        local meta = modules.getMetaByName "baidicoot"
        
        if run then modules.launch(meta.yaw, meta.pitch, power) end
    end end, function()
        while true do
            local _, c = os.pullEvent "char"
            if c == "f" then run = not run end
        end
    end)
end
parallel.waitForAll(function() drillRoutine(5) end, function() flightRoutine(4) end)
local modules = peripheral.wrap "back"
local power = tonumber(... or "") or 5
 
local run = true
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
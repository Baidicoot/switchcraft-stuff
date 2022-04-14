local furnaces = {}
local chests = {}

for _,n in ipairs(peripheral.getNames()) do
    if string.find(n,"^minecraft:furnace") then
        table.insert(furnaces,n)
    elseif string.find(n,"^minecraft:chest") then
        table.insert(chests,n)
    end
end

if #chests < 3 then
    print("not enough chests on network")
    os.exit()
end

local fuel_chest = peripheral.wrap(chests[1])
local item_chest = peripheral.wrap(chests[2])
local out_chest = peripheral.wrap(chests[3])

while true do
    for slot=1,fuel_chest.size() do
        local fuel = fuel_chest.getItemMeta(slot)
        if fuel then
            local perChest = math.ceil(fuel.count / #furnaces)
            for _,furnace in ipairs(furnaces) do
                fuel_chest.pushItems(furnace, slot, perChest, 1)
            end
        end
    end
    for slot=1,item_chest.size() do
        local item = item_chest.getItemMeta(slot)
        if item then
            local perChest = math.ceil(item.count / #furnaces)
            for _,furnace in ipairs(furnaces) do
                item_chest.pushItems(furnace, slot, perChest, 2)
            end
        end
    end
    for _,furnace in ipairs(furnaces) do
        out_chest.pullItems(furnace, 3)
    end
    os.sleep(0)
end
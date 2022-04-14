local furnaces = {}
local item_chest = peripheral.wrap("minecraft:chest_0")
local fuel_chest = peripheral.wrap("minecraft:chest_1")
local out_chest = peripheral.wrap("minecraft:chest_2")

for _,n in ipairs(peripheral.getNames()) do
    if string.find(n,"^minecraft:furnace") then
        table.insert(furnaces,n)
    end
end

while true do
    for slot=1,fuel_chest.size() do
        local fuel = fuel_chest.getItemMeta(i)
        if fuel then
            local perChest = math.ceil(fuel.count / #furnaces)
            for _,furnace in ipairs(furnaces) do
                fuel_chest.pushItems(furnace, slot, perChest, 1)
            end
        end
    end
    for slot=1,item_chest.size() do
        local item = item_chest.getItemMeta(i)
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
    os.sleep(1)
end
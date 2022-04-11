local modules = peripheral.wrap "back"

local w, h = modules.canvas().getSize()

local LASE_KEY = keys.x
local FLY_KEY = keys.v
local FALL_KEY = keys.leftShift
local GLIDE_KEY = keys.r
local JETPACK_KEY = keys.c
local AUTOLASE_KEY = keys.g
local KILL_KEY = keys.k

local AUTOLASE_TARGETS = {"Squid","heav_","gollark"}
local IMPORTANT_BLOCKS =
    { ["minecraft:diamond_ore"] = {0x00c8c8FF, true}
    , ["minecraft:coal_ore"] = {0x101010FF, false}
    , ["minecraft:iron_ore"] = {0x808080FF, false}
    , ["minecraft:gold_ore"] = {0xc8c800FF, false}
    , ["minecraft:lapis_ore"] = {0x0000FFFF, false}
    , ["minecraft:redstone_ore"] = {0xFF0000FF, false}
    , ["minecraft:emerald_ore"] = {0x00FF00FF, true}
    }

-- not at all stolen

function member(e,l)
    for _,v in ipairs(l) do
        if e == v then return true end
    end
    return false
end

function vectorToYawPitch(v)
    local pitch = -math.atan2(v.y, math.sqrt(v.x * v.x + v.z * v.z))
    local yaw = math.atan2(-v.x, v.z)
    return math.deg(yaw), math.deg(pitch)
end

function laseEntity(e)
    local target_location = e.s
	for i = 1, 5 do
		target_location = e.s + e.v * (target_location:length() / 1.5)
	end
	local y, p = vectorToYawPitch(target_location)
	modules.fire(y, p, 5)
end

-- entity overlay

local entityList

function initEntityList()
    if entityList then pcall(entityList.remove) end
    entityList = modules.canvas().addGroup({w-70, 10})
end

initEntityList()

function scanEntities(state)
    while true do
        local entities = modules.sense()

        local entityQuantities = {}
        for _,e in pairs(entities) do
            if entityQuantities[e.displayName] == nil then
                entityQuantities[e.displayName] = 0
            end
            entityQuantities[e.displayName] = entityQuantities[e.displayName] + 1

            e.s = vector.new(e.x, e.y, e.z)
            e.v = vector.new(e.motionX, e.motionY, e.motionZ)

            -- enlase bees targets

            if state.hasLaser then
                if member(e.displayName, AUTOLASE_TARGETS) and state.pressedKeys[AUTOLASE_KEY] then
                    laseEntity(e)
                end

                if state.pressedKeys[KILL_KEY] then
                    laseEntity(e)
                end
            end
        end

        if state.hasOverlayGlasses then
            local status, _ = pcall(entityList.clear)
            if not status then initEntityList() end

            local i = 0
            for n,q in pairs(entityQuantities) do
                entityList.addText({0, i*10}, n .. " " .. tostring(q))
                i = i + 1
            end
        end

        os.sleep(0)
    end
end

-- block scanner

function scanBlocks(state)
    while state.hasBlockScanner and state.hasOverlayGlasses do
        local blocks = modules.scan()

        modules.canvas3d().clear()
        local canvas = modules.canvas3d().create()

        for _, block in pairs(blocks) do
            if IMPORTANT_BLOCKS[block.name] then
                local box = canvas.addBox(block.x, block.y, block.z, 0)
                box.setColor(IMPORTANT_BLOCKS[block.name][1])
                box.setAlpha(255 / (1 + math.sqrt(block.x * block.x + block.y * block.y + block.z * block.z)/2))
                box.setDepthTested(false)

                if IMPORTANT_BLOCKS[block.name][2] then
                    local line = canvas.addLine({0, -0.2, 0}, {block.x, block.y, block.z}, 3, IMPORTANT_BLOCKS[block.name][1])
                    line.setAlpha(128)
                end
            end
        end
        os.sleep(0)
    end
end

-- drill

function drillRoutine(state)
    while state.hasLaser do
        --local meta = state.playerMeta
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
    while state.hasKineticAugment do
        --local meta = state.playerMeta
        local meta = modules.getMetaByName(state.PLAYER)

        if meta then
            if state.pressedKeys[FLY_KEY] then
                modules.launch(meta.yaw, meta.pitch, 4)
            elseif state.pressedKeys[GLIDE_KEY] then
                modules.launch(meta.yaw, meta.pitch, 0.5)
            elseif state.pressedKeys[JETPACK_KEY] then
                modules.launch(0, 270, 1)
            elseif meta.isSneaking then
                modules.launch(meta.yaw, meta.pitch, 4)
            end
        end
        os.sleep(0)
    end
end

-- fall arrest

function fallArrestRoutine(state)
    while state.hasKineticAugment do
        --local meta = state.playerMeta
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
                function() scanEntities(state) end,
                function() scanBlocks(state) end)
        end)
        print(err)
        initEntityList()
        os.sleep(0)
    end
end
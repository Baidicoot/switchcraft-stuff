local modules = peripheral.wrap "back"

local canvas = modules.canvas()

local w, h = canvas.getSize()

local LASE_KEY = keys.x
local FLY_KEY = keys.v
local FALL_KEY = keys.leftShift
local GLIDE_KEY = keys.r
local JETPACK_KEY = keys.c

local BEES_TARGETS = {"Squid", "Heav_"}

-- not at all stolen

function member(e,l)
    for _,v in ipairs(l):
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
    local target_location = entity.s
	for i = 1, 5 do
		target_location = entity.s + entity.v * (target_location:length() / 1.5)
	end
	local y, p = vectorToYawPitch(target_location)
	modules.fire(y, p, 5)
end

-- entity overlay

local entityList

function initEntityList()
    if entityList then pcall(entityList.remove) end
    entityList = canvas.addGroup({w-70, 10})
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

            -- enlase bees targets

            if member(e.displayName, BEES_TARGETS) then
                laseEntity(e)
            end
        end

        local status, _ = pcall(entityList.clear)
        if not status then initEntityList() end

        local i = 0
        for n,q in pairs(entityQuantities) do
            entityList.addText({0, i*7}, n .. " " .. tostring(q))
            i = i + 1
        end

        os.sleep(0)
    end
end

-- drill

function drillRoutine(state)
    while true do
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
    while true do
        local meta = modules.getMetaByName(state.PLAYER)

        if meta then
            if state.pressedKeys[FLY_KEY] then
                modules.launch(meta.yaw, meta.pitch, 4)
            elseif state.pressedKeys[GLIDE_KEY] then
                modules.launch(meta.yaw, meta.pitch, 0.5)
            elseif state.pressedKeys[JETPACK_KEY] then
                modules.launch(0, 270, 1)
            end
        end
        os.sleep(0)
    end
end

-- fall arrest

function fallArrestRoutine(state)
    while true do
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
                function() scanEntities(state) end)
        end)
        print(err)
        os.sleep(0)
    end
end
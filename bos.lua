local modules = peripheral.wrap "back"

modules.canvas().clear()

local utils = require "utils"

local state = {}

state.keyBinds = {}

state.keyBinds.LASE_KEY = keys.x
state.keyBinds.FLY_KEY = keys.v
state.keyBinds.FALL_KEY = keys.leftShift
state.keyBinds.GLIDE_KEY = keys.r
state.keyBinds.JETPACK_KEY = keys.c
state.keyBinds.AUTOLASE_KEY = keys.g
state.keyBinds.KILL_KEY = keys.k

state.IMPORTANT_BLOCKS =
    { ["minecraft:diamond_ore"] = {0x00c8c8FF, true}
    , ["minecraft:coal_ore"] = {0x101010FF, false}
    , ["minecraft:iron_ore"] = {0x808080FF, false}
    , ["minecraft:gold_ore"] = {0xc8c800FF, false}
    , ["minecraft:lapis_ore"] = {0x0000FFFF, false}
    , ["minecraft:redstone_ore"] = {0xFF0000FF, false}
    , ["minecraft:emerald_ore"] = {0x00FF00FF, true}
    }

state.PLAYER = nil
state.pressedKeys = {}
state.playerMeta = nil

state.hasLaser = false
state.hasBlockScanner = false
state.hasKeyboard = false
state.hasKineticAugment = false
state.hasOverlayGlasses = false

function keyListenRoutine()
    while true do
        local ev, arg = os.pullEvent()
        if ev == "key" then
            state.pressedKeys[arg] = true
        elseif ev == "key_up" then
            state.pressedKeys[arg] = false
        end
    end
end

function metaListenRoutine()
    while true do
        local meta = modules.getMetaByName(state.PLAYER)
        if meta then
            state.playerMeta = meta
        else
            state.playerMeta = nil
        end
    end
end

function main(cfg)
    print("Welcome to the Basic BOS Operating System (BBOSOS)")

    state.PLAYER = cfg.name
    if cfg.keyBinds then
        for k,v in pairs(cfg.keyBinds) do
            state.keyBinds[k] = v
        end
    end
    if cfg.autolaseTargets then
        state.AUTOLASE_TARGETS = cfg.autolaseTargets
    end
    if cfg.importantBlocks then
        state.IMPORTANT_BLOCKS = cfg.importantBlocks
    end

    if not modules.hasModule("plethora:sensor") then
        print("ERROR: No entity sensor detected. This module is required for correct operation of BOS.")
    end
    if modules.hasModule("plethora:scanner") then
        state.hasBlockScanner = true
    else
        print("WARNING: No block scanner detected. Block scanning functionality will not operate as advertised.")
        state.hasBlockScanner = false
    end
    if modules.hasModule("plethora:keyboard") then
        state.hasKeyboard = true
    else
        print("WARNING: No keyboard detected. Flight will be rebound to LShift.")
        state.hasKeyboard = false
    end
    if modules.hasModule("plethora:laser") then
        state.hasLaser = true
    else
        print("WARNING: No laser detected. Lasing functionality will not operate as advertised.")
        state.hasLaser = false
    end
    if modules.hasModule("plethora:kinetic") then
        state.hasKineticAugment = true
    else
        print("WARNING: No kinetic augment detected. Flight functionality will not operate as advertised.")
        state.hasKineticAugment = false
    end
    if modules.hasModule("plethora:glasses") then
        state.hasOverlayGlasses = true
    else
        print("WARNING: No overlay glasses detected. HUD functionality will not operate as advertised.")
        state.hasOverlayGlasses = false
    end

    parallel.waitForAll(
        keyListenRoutine,
        --metaListenRoutine,
        function() runUtils(state) end)
end

local bos = {main=main}
return bos
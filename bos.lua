print("Welcome to the Basic BOS Operating System (BBOSOS)")

local modules = peripheral.wrap "back"

modules.canvas().clear()

local utils = require "utils"

local state = {}
state.PLAYER = ""
state.pressedKeys = {}
state.playerMeta = nil

state.hasEntityScanner = false
state.hasBlockScanner = false

function listenRoutine()
    while true do
        local ev, arg = os.pullEvent()
        if ev == "key" then
            state.pressedKeys[arg] = true
        elseif ev == "key_up" then
            state.pressedKeys[arg] = false
        end
        meta, ok = modules.getMetaByName(state.PLAYER)
        if not ok then
            state.playerMeta = nil
        else
            state.playerMeta = meta
        end
    end
end

function main(player)
    state.PLAYER = player

    if modules.sense then
        state.hasEntityScanner = true
    else
        state.hasEntityScanner = false
    end
    if modules.scan then
        state.hasBlockScanner = true
    else
        state.hasBlockScanner = false
    end

    parallel.waitForAll(
        listenRoutine,
        function() runUtils(state) end)
end

local bos = {main=main}
return bos
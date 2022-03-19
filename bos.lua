print("Welcome to the Basic BOS Operating System (BBOSOS)")

local utils = require "utils"

local PLAYER = "baidicoot"

local state = {}
state.pressedKeys = {}
state.meta = {}

function playerMetadata()
    while true do
        local status, meta = pcall(function() modules.getMetaByName(PLAYER) end)
        if status then
            state.meta = meta
        end
    end
end

function listenRoutine()
    while true do
        local ev, arg = os.pullEvent()
        if ev == "key" then
            state.pressedKeys[arg] = true
        elseif ev == "key_up" then
            state.pressedKeys[arg] = false
        end
    end
end

parallel.waitForAll(
    playerMetadata,
    listenRoutine,
    function() runUtils(state) end)
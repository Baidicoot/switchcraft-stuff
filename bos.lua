print("Welcome to the Basic BOS Operating System (BBOSOS)")

local modules = peripheral.wrap "back"

modules.canvas().clear()

local utils = require "utils"

local state = {}
state.PLAYER = "baidicoot"
state.pressedKeys = {}

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
    listenRoutine,
    function() runUtils(state) end)
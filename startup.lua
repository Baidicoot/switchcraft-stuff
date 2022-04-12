local boot = require "boot"

local keyBinds =
    { LASE_KEY=keys.x
    , FLY_KEY=keys.v
    , FALL_KEY=keys.leftShift
    , GLIDE_KEY=keys.r
    , JETPACK_KEY=keys.c
    , AUTOLASE_KEY=keys.g
    , KILL_KEY=keys.k}

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

boot.main({playerName="baidicoot",keyBinds=keyBinds,autolaseTargets=AUTOLASE_TARGETS,importantBlocks=IMPORTANT_BLOCKS})
---@type string, table
local addon, Engine = ...
---@class InvasionTimer: Frame
---@field db InvasionTimerDB
---@field Core InvasionTimerCore
local IT = CreateFrame('Frame')

-- Lua functions
local _G = _G
local format, rawget = format, rawget

-- WoW API / Variables

-- GLOBALS: InvasionTimerDB

local L = {}
setmetatable(L, {
    __index = function(t, s) return rawget(t, s) or s end,
})

Engine[1] = IT
Engine[2] = L
_G[addon] = Engine

function IT:Print(...)
    _G.DEFAULT_CHAT_FRAME:AddMessage("Invasion Timer: " .. format(...))
end

IT:RegisterEvent('PLAYER_LOGIN')
IT:SetScript('OnEvent', function()
    IT:UnregisterEvent('PLAYER_LOGIN')

    if not InvasionTimerDB then
        ---@class InvasionTimerDB
        ---@field dbVersion number
        InvasionTimerDB = {
            dbVersion = 1,
        }
    end

    IT.db = InvasionTimerDB

    IT.Core:Initialize()
end)

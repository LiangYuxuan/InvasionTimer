---@type string, table
local addon, Engine = ...
---@class InvasionTimer: Frame
---@field db InvasionTimerDB
---@field Core InvasionTimerCore
---@field Config InvasionTimerConfig
local IT = CreateFrame('Frame')

-- Lua functions
local _G = _G
local format, ipairs, rawget = format, ipairs, rawget

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
        ---@class InvasionTimerDBSettings
        ---@field displayEntry table<string, boolean>
        ---@field use12HourClock boolean
        ---@field useDDMMFormat boolean

        ---@class InvasionTimerDB
        ---@field dbVersion number
        ---@field settings InvasionTimerDBSettings
        InvasionTimerDB = {
            dbVersion = 1,
            settings = {
                displayEntry = {},
                use12HourClock = false,
                useDDMMFormat = false,
            },
        }
    end

    IT.db = InvasionTimerDB

    local displayEntries = IT.Core:GetAllEntries()
    for _, entry in ipairs(displayEntries) do
        if IT.db.settings.displayEntry[entry.key] == nil then
            IT.db.settings.displayEntry[entry.key] = true
        end
    end

    IT.Core:Initialize()
    IT.Config:Initialize()
end)

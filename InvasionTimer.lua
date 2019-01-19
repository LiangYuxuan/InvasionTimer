local L = LibStub("AceLocale-3.0"):GetLocale("InvasionTimer")
local LDB = LibStub("LibDataBroker-1.1")
local GameTooltip = GameTooltip

-- Invasion code from NDui by siwei
-- https://github.com/siweia/NDui/blob/master/Interface/AddOns/NDui/Modules/Infobar/Time.lua
-- Modified by Rhythm
-- Check Invasion Status
local invIndex = {
    {
        title = L["BfA Invasion"],
        interval = 68400,
        duration = 25200,
        maps = {862, 863, 864, 896, 942, 895},
        timeTable = {4, 1, 6, 2, 5, 3},
        -- baseTime = 1546743600, -- 1/6/2019 11:00
    },
    {
        title = L["Legion Invasion"],
        interval = 66600,
        duration = 21600,
        maps = {630, 641, 650, 634},
        timeTable = {4, 3, 2, 1, 4, 2, 3, 1, 2, 4, 1, 3},
        -- baseTime = 1546844400, -- 1/7/2019 15:00
    }
}

local invTime = {
    CN = {
        1546743600, -- 1/6/2019 11:00
        1546844400, -- 1/7/2019 15:00
    },
}

local region = GetCVar("portal")
if not region or #region ~= 2 then
    local regionID = GetCurrentRegion()
    region = regionID and ({ "US", "KR", "EU", "TW", "CN" })[regionID]
end
if invTime[region] then
    local i, v
    for i, v in pairs(invTime[region]) do
        invIndex[i].baseTime = v
    end
end

local function GetCurrentInvasion(index)
    local inv = invIndex[index]
    local currentTime = time()
    local baseTime = inv.baseTime
    local duration = inv.duration
    local interval = inv.interval
    local elapsed = mod(currentTime - baseTime, interval)
    if elapsed < duration then
        local count = #inv.timeTable
        local round = mod(floor((currentTime - baseTime) / interval) + 1, count)
        if round == 0 then round = count end
        return duration - elapsed, C_Map.GetMapInfo(inv.maps[inv.timeTable[round]]).name
    end
end

local function GetFutureInvasion(index, length)
    if not length then length = 1 end
    local tbl, i = {}
    local inv = invIndex[index]
    local currentTime = time()
    local baseTime = inv.baseTime
    local interval = inv.interval
    local count = #inv.timeTable
    local elapsed = mod(currentTime - baseTime, interval)
    local nextTime = interval - elapsed + currentTime
    local round = mod(floor((nextTime - baseTime) / interval) + 1, count)
    for i = 1, length do
        if round == 0 then round = count end
        table.insert(tbl, {nextTime, C_Map.GetMapInfo(inv.maps[inv.timeTable[round]]).name})
        nextTime = nextTime + interval
        round = mod(round + 1, count)
    end
    return tbl
end

local DataObject = LDB:NewDataObject("Invasion", {
    type = "data source",
    text = L["Invasion"],
    OnEnter = function (frame)
        local parent = frame:GetParent()
        GameTooltip:Hide()
        GameTooltip:SetOwner(parent, parent.anchor, parent.xOff, parent.yOff)
        GameTooltip:ClearLines()

        for index, value in ipairs(invIndex) do
            GameTooltip:AddLine(value.title)
            local timeLeft, zoneName = GetCurrentInvasion(index)
            if timeLeft then
                timeLeft = timeLeft / 60
                GameTooltip:AddDoubleLine(L["Current Invasion"] .. zoneName, format("%dh %.2dm", timeLeft / 60, timeLeft % 60), 1, 1, 1, 0, 1, 0)
            end
            local futureTable, i = GetFutureInvasion(index, 2)
            for i = 1, #futureTable do
                local nextTime, zoneName = unpack(futureTable[i])
                GameTooltip:AddDoubleLine(L["Next Invasion"] .. zoneName, date("%m/%d %H:%M", nextTime), 1, 1, 1, 1, 1, 1)
            end
        end

        GameTooltip:Show()
    end,
    OnLeave = function (frame)
        GameTooltip:Hide()
    end,
})

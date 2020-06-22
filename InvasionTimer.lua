local L = LibStub("AceLocale-3.0"):GetLocale("InvasionTimer")
local LDB = LibStub("LibDataBroker-1.1")
local GameTooltip = GameTooltip

local region = GetCVar("portal")
if not region or #region ~= 2 then
    local regionID = GetCurrentRegion()
    region = regionID and ({ "US", "KR", "EU", "TW", "CN" })[regionID]
end

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
        -- Drustvar Beginning
        baseTime = {
            US = 1548032400, -- 01/20/2019 17:00 UTC-8
            EU = 1548000000, -- 01/20/2019 16:00 UTC+0
            CN = 1546743600, -- 01/06/2019 11:00 UTC+8
        },
    },
    {
        title = L["Legion Invasion"],
        interval = 66600,
        duration = 21600,
        maps = {630, 641, 650, 634},
        -- timeTable = {4, 3, 2, 1, 4, 2, 3, 1, 2, 4, 1, 3},
        -- Stormheim Beginning then Highmountain
        baseTime = {
            US = 1547614800, -- 01/15/2019 21:00 UTC-8
            EU = 1547586000, -- 01/15/2019 21:00 UTC+0
            CN = 1546844400, -- 01/07/2019 15:00 UTC+8
        },
    }
}

-- Fallback
local mapAreaPoiIDs = {
    [630] = 5175,
    [641] = 5210,
    [650] = 5177,
    [634] = 5178,
    [862] = 5973,
    [863] = 5969,
    [864] = 5970,
    [896] = 5964,
    [942] = 5966,
    [895] = 5896,
}

local function GetInvasionInfo(mapID)
    local areaPoiID = mapAreaPoiIDs[mapID]
    local seconds = C_AreaPoiInfo.GetAreaPOISecondsLeft(areaPoiID)
    local mapInfo = C_Map.GetMapInfo(mapID)
    return seconds, mapInfo.name
end

local function CheckInvasion(index)
    for _, mapID in pairs(invIndex[index].maps) do
        local timeLeft, name = GetInvasionInfo(mapID)
        if timeLeft and timeLeft > 0 then
            return timeLeft, name
        end
    end
end

local function GetCurrentInvasion(index)
    local inv = invIndex[index]
    local currentTime = time()
    local baseTime = inv.baseTime[region]
    local duration = inv.duration
    local interval = inv.interval
    local elapsed = mod(currentTime - baseTime, interval)
    if elapsed < duration then
        if inv.timeTable then
            local count = #inv.timeTable
            local round = mod(floor((currentTime - baseTime) / interval) + 1, count)
            if round == 0 then round = count end
            return duration - elapsed, C_Map.GetMapInfo(inv.maps[inv.timeTable[round]]).name
        else
            -- unknown order
            local timeLeft, name = CheckInvasion(index)
            if timeLeft then
                -- found POI on map
                return timeLeft, name
            else
                -- fallback
                return duration - elapsed, UNKNOWN
            end
        end
    end
end

local function GetFutureInvasion(index, length)
    if not length then length = 1 end
    local tbl = {}
    local inv = invIndex[index]
    local currentTime = time()
    local baseTime = inv.baseTime[region]
    local interval = inv.interval
    local elapsed = mod(currentTime - baseTime, interval)
    local nextTime = interval - elapsed + currentTime
    if not inv.timeTable then
        for _ = 1, length do
            tinsert(tbl, {nextTime, ''})
            nextTime = nextTime + interval
        end
    else
        local count = #inv.timeTable
        local round = mod(floor((nextTime - baseTime) / interval) + 1, count)
        for _ = 1, length do
            if round == 0 then round = count end
            tinsert(tbl, {nextTime, C_Map.GetMapInfo(inv.maps[inv.timeTable[round]]).name})
            nextTime = nextTime + interval
            round = mod(round + 1, count)
        end
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
            if value.baseTime[region] then
                -- baseTime provided
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
            else
                local timeLeft, zoneName = CheckInvasion(index)
                if timeLeft then
                    timeLeft = timeLeft / 60
                    GameTooltip:AddDoubleLine(L["Current Invasion"] .. zoneName, format("%dh %.2dm", timeLeft / 60, timeLeft % 60), 1, 1, 1, 0, 1, 0)
                else
                    GameTooltip:AddLine("Missing invasion info on your realm.")
                end
            end
        end

        GameTooltip:Show()
    end,
    OnLeave = function (frame)
        GameTooltip:Hide()
    end,
})

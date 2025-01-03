---@type InvasionTimer, table<string, string>
local IT, L = unpack((select(2, ...)))
---@class InvasionTimerCore: Frame
local Core = CreateFrame('Frame')
IT.Core = Core

local LDB = LibStub('LibDataBroker-1.1')

local region = GetCVar('portal')
if not region or #region ~= 2 then
    local regionID = GetCurrentRegion()
    region = regionID and ({ 'US', 'KR', 'EU', 'TW', 'CN' })[regionID]
end
if region == 'CN' or region == 'TW' or region == 'KR' then
    region = 'CN'
elseif region == 'EU' then
    region = 'EU'
else
    region = 'US'
end

function Core:Initialize()
end

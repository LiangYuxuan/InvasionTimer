---@type InvasionTimer, table<string, string>
local IT, L = unpack((select(2, ...)))
local locale = GetLocale()

if locale == 'zhCN' then
    L["Invasion Timetable"] = "突袭时间"
    L["Invasion Timetable (12 Hour)"] = "突袭时间（12小时）"
    L["Invasion Timetable (DD/MM)"] = "突袭时间（DD/MM）"
    L["Faction Assault"] = "阵营突袭"
    L["Legion Invasion"] = "军团突袭"
    L["Current: "] = "当前: "
    L["Next: "] = "下次: "
elseif locale == 'zhTW' then
    L["Invasion Timetable"] = "突襲時間"
    L["Invasion Timetable (12 Hour)"] = "突襲時間（12小時）"
    L["Invasion Timetable (DD/MM)"] = "突襲時間（DD/MM）"
    L["Faction Assault"] = "陣營突襲"
    L["Legion Invasion"] = "軍團突襲"
    L["Current: "] = "當前: "
    L["Next: "] = "下次: "
elseif locale == 'ruRU' then
    L["Invasion Timetable"] = "Вторжение"
    -- L["Invasion Timetable (12 Hour)"] = "Invasion Timetable (12 Hour)"
    -- L["Invasion Timetable (DD/MM)"] = "Invasion Timetable (DD/MM)"
    L["Faction Assault"] = "Вторжение Фракций"
    L["Legion Invasion"] = "Вторжение Легиона"
    L["Current: "] = "Текущее вторжение: "
    L["Next: "] = "Следующее Вторжение: "
end

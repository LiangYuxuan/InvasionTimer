---@type InvasionTimer, table<string, string>
local IT, L = unpack((select(2, ...)))
local locale = GetLocale()

if locale == 'zhCN' then
    L["Event Timetable"] = "世界活动时间表"
    L["Current"] = "当前"
    L["Next"] = "下次"
    L["Warfront"] = "战争前线"
    L["Faction Assault"] = "阵营突袭"
    L["Legion Invasion"] = "军团突袭"
    L["Use 12-hour clock"] = "使用12小时制"
    L["Use DD/MM format"] = "使用日期/月份格式"
    L["Display"] = "显示"
elseif locale == 'zhTW' then
    -- L["Event Timetable"] = "Event Timetable"
    L["Current"] = "當前"
    L["Next"] = "下次"
    -- L["Warfront"] = "Warfront"
    L["Faction Assault"] = "陣營突襲"
    L["Legion Invasion"] = "軍團突襲"
    -- L["Use 12-hour clock"] = "Use 12-hour clock"
    -- L["Use DD/MM format"] = "Use DD/MM format"
    -- L["Display"] = "Display"
elseif locale == 'ruRU' then
    -- L["Event Timetable"] = "Event Timetable"
    L["Current"] = "Текущее вторжение"
    L["Next"] = "Следующее Вторжение"
    -- L["Warfront"] = "Warfront"
    L["Faction Assault"] = "Вторжение Фракций"
    L["Legion Invasion"] = "Вторжение Легиона"
    -- L["Use 12-hour clock"] = "Use 12-hour clock"
    -- L["Use DD/MM format"] = "Use DD/MM format"
    -- L["Display"] = "Display"
end

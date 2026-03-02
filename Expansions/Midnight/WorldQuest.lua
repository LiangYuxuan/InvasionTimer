---@type InvasionTimer, table<string, string>
local IT, L = unpack((select(2, ...)))
local WQ = IT.WorldQuest

WQ:RegisterEntry({
    type = 'single',
    expansion = 11,
    category = 'quest',
    achievementID = 61219, -- No Time to Paws
    questID = 92085, -- Claw Enforcement
})

WQ:RegisterEntry({
    type = 'single',
    expansion = 11,
    category = 'quest',
    achievementID = 62105, -- Lysikas Would Be Proud
    questID = 93438, -- Special Assignment: Precision Excision
})

WQ:RegisterEntry({
    type = 'criteria',
    expansion = 11,
    category = 'pvp',
    achievementID = 61225, -- Investigating the Rise
    questIDs = {
        {89267}, -- Mysterious Entity
        {87759}, -- Encapsulated Void
        {88679}, -- Encountering the Unexpected
        {91419}, -- Elemental Dominance
        {88992}, -- Envisioned Mastery
        {89377}, -- Undercover Hunt
        {89347}, -- Overcoming the Unknown: Rage-Riddled Drifter
    },
})

WQ:RegisterEntry({
    type = 'criteria',
    expansion = 11,
    category = 'pvp',
    achievementID = 61226, -- Uprising
    questIDs = {
        {89267}, -- Mysterious Entity
        {87759}, -- Encapsulated Void
        {88679}, -- Encountering the Unexpected
        {91419}, -- Elemental Dominance
        {88992}, -- Envisioned Mastery
        {89377}, -- Undercover Hunt
        {89347}, -- Overcoming the Unknown: Rage-Riddled Drifter
    },
})

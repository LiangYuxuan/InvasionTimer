---@type InvasionTimer, table<string, string>
local IT, L = unpack((select(2, ...)))
local WQ = IT.WorldQuest

WQ:RegisterEntry({
    type = 'criteria',
    expansion = 6,
    category = 'quest',
    achievementID = 11427, -- No Shellfish Endeavor
    questIDs = {
        {44943}, -- Now That's Just Clawful!
        {40230}, -- Oh, the Clawdacity!
        {45307}, -- Claws for Alarm!
    },
})

WQ:RegisterEntry({
    type = 'single',
    expansion = 6,
    category = 'quest',
    achievementID = 11607, -- They See Me Rolling
    questID = 46175, -- Rolling Thunder
})

WQ:RegisterEntry({
    type = 'single',
    expansion = 6,
    category = 'quest',
    achievementID = 11681, -- Crate Expectations
    questID = 45559, -- Behind Enemy Portals
})

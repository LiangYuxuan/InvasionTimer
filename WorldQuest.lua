---@type InvasionTimer, table<string, string>
local IT, L = unpack((select(2, ...)))
---@class InvasionTimerWorldQuest: Frame
local WQ = CreateFrame('Frame')
IT.WorldQuest = WQ

-- Lua functions
local format, ipairs, tinsert = format, ipairs, tinsert

-- WoW API / Variables
local C_TaskQuest_GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID
local C_TaskQuest_GetQuestTimeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes
local C_TaskQuest_IsActive = C_TaskQuest.IsActive
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementInfo = GetAchievementInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria

---@alias AchievementCategory 'quest' | 'exploration' | 'reputation'

---@class SingleQuestAchievementEntry
---@field type "single"
---@field expansion number
---@field category AchievementCategory
---@field achievementID number
---@field questID number

---@class QuestCriteriaAchievementEntry
---@field type "criteria"
---@field expansion number
---@field category AchievementCategory
---@field achievementID number
---@field questIDs table<number, number[]>

---@class MultipleQuestAchievementEntry
---@field type "multiple"
---@field expansion number
---@field category AchievementCategory
---@field achievementIDs number[]
---@field questIDs number[]

---@alias WorldQuestEntry SingleQuestAchievementEntry | QuestCriteriaAchievementEntry | MultipleQuestAchievementEntry

---@type WorldQuestEntry[]
local worldQuestEntries = {}

---@param entry WorldQuestEntry
function WQ:RegisterEntry(entry)
    tinsert(worldQuestEntries, entry)
end

function WQ:OnEnter(tooltip)
    tooltip:AddLine(L["World Quests"])

    for _, entry in ipairs(worldQuestEntries) do
        if entry.type == 'single' then
            local _, name, _, completed = GetAchievementInfo(entry.achievementID)
            if not completed then
                if C_TaskQuest_IsActive(entry.questID) then
                    local questID = entry.questID
                    local questTitle = C_TaskQuest_GetQuestInfoByQuestID(questID)
                    local minutesLeft = C_TaskQuest_GetQuestTimeLeftMinutes(questID)

                    tooltip:AddLine(name)

                    tooltip:AddDoubleLine(
                        questTitle,
                        format("%dh %.2dm", minutesLeft / 60, minutesLeft % 60),
                        1, 1, 1, 0, 1, 0
                    )
                end
            end
        elseif entry.type == 'criteria' then
            local _, name, _, completed = GetAchievementInfo(entry.achievementID)
            if not completed then
                local titleReady = false
                local numCriteria = GetAchievementNumCriteria(entry.achievementID)
                for i = 1, numCriteria do
                    local questIDs = entry.questIDs[i]
                    if questIDs then
                        local _, _, criteriaCompleted = GetAchievementCriteriaInfo(entry.achievementID, i)
                        if not criteriaCompleted then
                            for _, questID in ipairs(questIDs) do
                                if C_TaskQuest_IsActive(questID) then
                                    local questTitle = C_TaskQuest_GetQuestInfoByQuestID(questID)
                                    local minutesLeft = C_TaskQuest_GetQuestTimeLeftMinutes(questID)

                                    if not titleReady then
                                        tooltip:AddLine(name)
                                        titleReady = true
                                    end

                                    tooltip:AddDoubleLine(
                                        questTitle,
                                        format("%dh %.2dm", minutesLeft / 60, minutesLeft % 60),
                                        1, 1, 1, 0, 1, 0
                                    )
                                end
                            end
                        end
                    end
                end
            end
        elseif entry.type == 'multiple' then
            local achievementIDs = entry.achievementIDs

            local isAllCompleted = true
            for _, achievementID in ipairs(achievementIDs) do
                local _, _, _, completed = GetAchievementInfo(achievementID)
                if not completed then
                    isAllCompleted = false
                    break
                end
            end

            if not isAllCompleted then
                local titleReady = false
                for _, questID in ipairs(entry.questIDs) do
                    if C_TaskQuest_IsActive(questID) then
                        local questTitle = C_TaskQuest_GetQuestInfoByQuestID(questID)
                        local minutesLeft = C_TaskQuest_GetQuestTimeLeftMinutes(questID)

                        if not titleReady then
                            for _, achievementID in ipairs(achievementIDs) do
                                local _, name, _, completed = GetAchievementInfo(achievementID)
                                if not completed then
                                    tooltip:AddLine(name)
                                    break
                                end
                            end

                            titleReady = true
                        end

                        tooltip:AddDoubleLine(
                            questTitle,
                            format("%dh %.2dm", minutesLeft / 60, minutesLeft % 60),
                            1, 1, 1, 0, 1, 0
                        )
                    end
                end
            end
        end
    end
end

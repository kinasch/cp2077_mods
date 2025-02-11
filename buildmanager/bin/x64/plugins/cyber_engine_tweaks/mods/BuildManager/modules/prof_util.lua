local prof_util = {}

local defaultProfLevelList = {
	{name="StrengthSkill",lvl=1,exp=0},
	{name="ReflexesSkill",lvl=1,exp=0},
	{name="CoolSkill",lvl=1,exp=0},
	{name="IntelligenceSkill",lvl=1,exp=0},
	{name="TechnicalAbilitySkill",lvl=1,exp=0}
}

function prof_util.getDefaultProfLevelList()
    return defaultProfLevelList
end

--- Set a single proficiency / skill level and experience.
---@param playerDevelopmentData PlayerDevelopmentData
---@param profType gamedataProficiencyType
---@param profLevel number
---@param exp number
function prof_util.setProficiency(playerDevelopmentData, profType, profLevel, exp)
    -- Reduce the perk points if prof level was greater than or equal to certain values.
    if playerDevelopmentData:GetProficiencyLevel(profType) >= 15 then
        playerDevelopmentData:AddDevelopmentPoints(-1,gamedataDevelopmentPointType.Primary)
    end
    if playerDevelopmentData:GetProficiencyLevel(profType) >= 35 then
        playerDevelopmentData:AddDevelopmentPoints(-1,gamedataDevelopmentPointType.Primary)
    end

    playerDevelopmentData:SetLevel(profType,1,telemetryLevelGainReason.Ignore)
    if profLevel > 1 then
        playerDevelopmentData:SetLevel(profType,profLevel,telemetryLevelGainReason.Ignore)
    end

    playerDevelopmentData:AddExperience(exp,profType,telemetryLevelGainReason.Ignore)
end

--- Set proficiencies / skills levels and experience from a list of them.
---@param playerDevelopmentData PlayerDevelopmentData
---@param profLevelList { name:string,lvl:number,exp:number }[]
function prof_util.setProficiencies(playerDevelopmentData, profLevelList)
    for key, value in pairs(profLevelList) do
        prof_util.setProficiency(playerDevelopmentData,(gamedataProficiencyType[value.name]),value.lvl,value.exp)
    end
end

--- Returns the a list of tables with with the proficiencies / skills levels and experience from the player.
---@param playerDevelopmentData PlayerDevelopmentData
---@return { name:string,lvl:number,exp:number }[]
function prof_util.getProficiencies(playerDevelopmentData)
    profLevelList = {}
    for key, value in pairs(defaultProfLevelList) do
        local tlvl = playerDevelopmentData:GetProficiencyLevel(gamedataProficiencyType[value.name])
        local texp = playerDevelopmentData:GetProficiencyExperience(gamedataProficiencyType[value.name])

        table.insert(profLevelList,{name=value.name,lvl=tlvl,exp=texp})
    end
    return profLevelList
end

return prof_util
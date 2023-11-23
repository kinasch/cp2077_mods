util = {attributes={},perk={},prof={}}

local defaultProfLevelList = {
	{name="StrengthSkill",lvl=1,exp=0},
	{name="ReflexesSkill",lvl=1,exp=0},
	{name="CoolSkill",lvl=1,exp=0},
	{name="IntelligenceSkill",lvl=1,exp=0},
	{name="TechnicalAbilitySkill",lvl=1,exp=0}
}

-- ##########################################################################
-- Save Functions
-- ##########################################################################
-- Returns attributes, perks, buildLevel and proficiencies.
function util.createNewSave(name, playerDevelopmentData,profLevelList)
    local attributes,perks,buildLevel,profs = nil,nil,nil,nil
    -- Get Attributes and their levels
    attributes = util.attributes.getAttributes(playerDevelopmentData)
    -- Get Perks and their levels
    perks = util.perk.getPerks(playerDevelopmentData)
    -- Get current Player Level to only show builds you can afford.
    buildLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), 'PowerLevel')

    -- Get the profs
    profs = profLevelList

    return attributes,perks,buildLevel,profs
end


-- ##########################################################################
-- Load Functions
-- ##########################################################################
function util.setBuild(playerDevelopmentData, save)
    -- save = {attributes:{},perks:{}}
    util.tabulaRasa(playerDevelopmentData)

    tempPP = util.prof.getPerkPointsFromProfs(save.profs)

    util.attributes.buyAttributes(playerDevelopmentData, save.attributes)

    util.givePerkPoints(playerDevelopmentData, tempPP)
    util.perk.buyPerks(playerDevelopmentData, save.perks)

    util.prof.setProficiencies(playerDevelopmentData, save.profs)
    util.givePerkPoints(playerDevelopmentData, -tempPP)
end



-- ##########################################################################
-- Attribute Functions
-- ##########################################################################
function util.attributes.getAttributes(playerDevelopmentData)
    local attr = {}
    local gameAttr = playerDevelopmentData:GetAttributes()
    local counter = 1

    for l,attribute in ipairs(gameAttr) do
        if attribute.attributeName.value == "Gunslinger" or attribute.attributeName.value == "Espionage" then goto continue end
        attr[counter] = {name=attribute.attributeName.value,level=attribute.value}
        counter = counter + 1
        ::continue::
    end

    return attr
end

function util.attributes.buyAttributes(playerDevelopmentData,attr)
    -- local attr = { {name,level},{name,level},... }
    for l,a in ipairs(attr) do
        for i = 3,a.level-1,1 do
            playerDevelopmentData:BuyAttribute(gamedataStatType[a.name])
        end
    end
end

-- ##########################################################################
-- Perk Functions
-- ##########################################################################

-- Maybe try to get Perks in order?
function util.perk.getPerks(playerDevelopmentData)
    local attributeData = playerDevelopmentData:GetAttributesData()
    local perks = {}
    local counter = 1
    for l,attrData in ipairs(attributeData) do
        for k,perk in ipairs(attrData.unlockedPerks) do
            if perk.currLevel > 0 then
                perks[counter] = {name=perk.type.value,level=perk.currLevel}
                counter = counter + 1
            end
        end
    end
    return perks
end

-- Cannot be done like this
-- Perks now need to be bought in an order.
function util.perk.buyPerks(playerDevelopmentData, perks)
    -- local perks = { {name,level},{name,level},... }
    for l,p in ipairs(perks) do
        for i = 1,p.level,1 do
            playerDevelopmentData:UnlockNewPerk(gamedataNewPerkType[p.name])
            playerDevelopmentData:BuyNewPerk(gamedataNewPerkType[p.name],false)
        end
    end
end


-- ##########################################################################
-- Proficiency Functions
-- ##########################################################################
function util.prof.setProficiency(playerDevelopmentData, profType, profLevel, exp)
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

function util.prof.setProficiencies(playerDevelopmentData, profLevelList)
    for key, value in pairs(profLevelList) do
        util.prof.setProficiency(playerDevelopmentData,(gamedataProficiencyType[value.name]),value.lvl,value.exp)
    end
end

-- Returns the profLevelList with the levels from the player
function util.prof.getProficiencies(playerDevelopmentData)
    profLevelList = {}
    for key, value in pairs(defaultProfLevelList) do
        local tlvl = playerDevelopmentData:GetProficiencyLevel(gamedataProficiencyType[value.name])
        local texp = playerDevelopmentData:GetProficiencyExperience(gamedataProficiencyType[value.name])

        table.insert(profLevelList,{name=value.name,lvl=tlvl,exp=texp})
    end
    return profLevelList
end

-- Returns the profLevelList with the levels from the player
function util.prof.getPerkPointsFromProfs(profLevelList)
    perkPoints = 0
    for key, value in pairs(profLevelList) do
        tempValue = 0
        if value.lvl >= 15 then
            tempValue = 1
        elseif value.lvl >= 35 then
            tempValue = 2
        end
        perkPoints = perkPoints + tempValue
    end
    return perkPoints
end


-- ##########################################################################
-- General Functions
-- ##########################################################################

-- Reset every part of the development data.
-- Currently only attributes and perks
function util.tabulaRasa(playerDevelopmentData)
    playerDevelopmentData:ResetNewPerks()
	playerDevelopmentData:ResetAttributes()
    util.prof.setProficiencies(playerDevelopmentData,defaultProfLevelList)
end

-- Returns the length of a given table.
function util.tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function util.givePerkPoints(playerDevelopmentData,amount)
    playerDevelopmentData:AddDevelopmentPoints(amount,gamedataDevelopmentPointType.Primary)
end

return util
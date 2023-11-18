util = {attributes={},perk={},traits={},prof={}}

local oneProfs = {
	{name="Assault",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="Athletics",level=1,pp={3,7,8,10,11,16,19},xp=0.0},
	{name="Brawling",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="ColdBlood",level=1,pp={4,5,9,10,11,13,17},xp=0.0},
	{name="CombatHacking",level=1,pp={2,4,9,11,14,19},xp=0.0},
	{name="Crafting",level=1,pp={4,6,8,10,14,17},xp=0.0},
	{name="Demolition",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="Engineering",level=1,pp={2,6,8,10,14,17,18},xp=0.0},
	{name="Gunslinger",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="Hacking",level=1,pp={2,6,10,14,16,18},xp=0.0},
	{name="Kenjutsu",level=1,pp={3,8,9,10,14,16,17},xp=0.0},
	{name="Stealth",level=1,pp={3,5,7,10,13,17,18},xp=0.0}
}

-- ##########################################################################
-- Save Functions
-- ##########################################################################
-- Returns attributes, perks, buildLevel and proficiencies.
function util.createNewSave(name, playerDevelopmentData)
    local attributes,perks,buildLevel,profs = nil,nil,nil,nil
    -- Get Attributes and their levels
    attributes = util.attributes.getAttributes(playerDevelopmentData)
    -- Get Perks and their levels
    perks = util.perk.getPerks(playerDevelopmentData)
    -- Get current Player Level to only show builds you can afford.
    buildLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), 'PowerLevel')
    return attributes,perks,buildLevel,profs
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

function util.attributes.setAttributes(playerDevelopmentData,attr,sameLevel)
    -- local attr = {names={},levels={}}
    if sameLevel ~= nil then
        for i = 1,#attr.names,1 do
            playerDevelopmentData:SetAttribute(attr.names[i],sameLevel)
        end
    end
end

function util.attributes.buyAttributes(playerDevelopmentData,attr)
    -- local attr = {names={},levels={}}
    for l,name in ipairs(attr.names) do
        local lvl = (attr.levels[l]-3)
        for i = 1,lvl,1 do
            playerDevelopmentData:BuyAttribute(name)
        end
    end
end

-- ##########################################################################
-- Perk Functions
-- ##########################################################################
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

function util.perk.buyPerks(playerDevelopmentData, perkEnums)
    for i,perk in ipairs(perkEnums) do
        playerDevelopmentData:BuyPerk(perk)
    end
end

-- ##########################################################################
-- Proficiencies
-- ##########################################################################
function util.prof.setProficiencies(playerDevelopmentData,profs)
    for k,attr in pairs(profs) do
        local oldLevel = playerDevelopmentData:GetProficiencyLevel(gamedataProficiencyType[attr.name])
        if attr.level == oldLevel then goto contSetProf end

        playerDevelopmentData:SetLevel(gamedataProficiencyType[attr.name],attr.level,telemetryLevelGainReason.Ignore)

        if attr.xp < 1 or playerDevelopmentData:IsProficiencyMaxLvl(gamedataProficiencyType[attr.name]) then goto afterXP end
        playerDevelopmentData:AddExperience(attr.xp,gamedataProficiencyType[attr.name],telemetryLevelGainReason.Ignore)

        ::afterXP::

        if attr.level > oldLevel then goto contSetProf end
        local count = 0
        for ppK,ppAttr in pairs(attr.pp) do
            if ppAttr > attr.level and ppAttr <= oldLevel then
                count = count - 1
            end
        end
        playerDevelopmentData:AddDevelopmentPoints(count,gamedataDevelopmentPointType.Primary)

        if oldLevel == 20 and attr.level < 20 then
            playerDevelopmentData:LockTraitOfProf(gamedataProficiencyType[attr.name])
        end

        ::contSetProf::
    end

    return true
    --playerDevelopmentData:RefreshProficiencyStats()
end

-- ##########################################################################
-- General Functions
-- ##########################################################################
function util.EnumValuesToString(enums)
    local strings = {}
    for i,enum in ipairs(enums) do
        strings[i] = enum.value
    end
    return strings
end

-- Reset every part of the development data.
-- Currently only attributes and perks
-- TODO: Proficiencies (new)
function util.tabulaRasa(playerDevelopmentData,attr)
    playerDevelopmentData:ResetNewPerks()
	playerDevelopmentData:ResetAttributes()
end

-- Following functions could technically be put into one with a second parameter
-- Thus they are in the general tab
function util.perk.StringToEnumValues(perkStrings)
    local perkEnums = {}
    for i,perk in ipairs(perkStrings) do
        perkEnums[i] = gamedataPerkType[perk]
    end
    return perkEnums
end
function util.attributes.StringToEnumValues(attrStrings)
    local attrEnums = {}
    for i,attr in ipairs(attrStrings) do
        attrEnums[i] = gamedataStatType[attr]
    end
    return attrEnums
end

-- Returns the length of a given table.
function util.tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

return util
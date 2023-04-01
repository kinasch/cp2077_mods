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
-- Attribute Functions
function util.attributes.getAttributes(playerDevelopmentData)
    local attr = {names={},levels={}}
    local gameAttr = playerDevelopmentData:GetAttributes()
    local counter = 1

    for l,attribute in ipairs(gameAttr) do
        if attribute.attributeName.value == "Gunslinger" then goto continue end
        attr.names[counter] = attribute.attributeName
        attr.levels[counter] = attribute.value
        counter = counter + 1
        ::continue::
    end

    return attr
end
function util.attributes.getRemainingAttrPoints(attr)
    local levelSum = 0
    for index, value in ipairs(attr.levels) do
        levelSum = levelSum + value
    end
    return (levelSum - 15)
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
function util.perk.getPerks(playerDevelopmentData)
    local boughtPerks = playerDevelopmentData:GetBoughtPerks()
    local perksByAmountBought = {}
    local counter = 1
    for l,perk in ipairs(boughtPerks) do
        for i = 1,perk.currLevel,1 do
            perksByAmountBought[counter] = perk.type
            counter = counter + 1
        end
    end
    return perksByAmountBought
end

function util.perk.buyPerks(playerDevelopmentData, perkEnums)
    for i,perk in ipairs(perkEnums) do
        playerDevelopmentData:BuyPerk(perk)
    end
end

-- ##########################################################################
-- Trait Functions
function util.traits.getTraits(playerDevelopmentData)
    local boughtTraits = playerDevelopmentData:GetBoughtTraits()
    local traitsByAmountBought = {}
    local counter = 1
    for l,trait in ipairs(boughtTraits) do
        for i = 1,trait.currLevel,1 do
            traitsByAmountBought[counter] = trait.type
            counter = counter + 1
        end
    end
    return traitsByAmountBought
end

function util.traits.buyTraits(playerDevelopmentData, traitEnums)
    for i,trait in ipairs(traitEnums) do
        playerDevelopmentData:IncreaseTraitLevel(trait)
    end
end

-- ##########################################################################
-- Proficiencies

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
function util.EnumValuesToString(enums)
    local strings = {}
    for i,enum in ipairs(enums) do
        strings[i] = enum.value
    end
    return strings
end

function util.tabulaRasa(playerDevelopmentData,attr)
    playerDevelopmentData:RemoveAllPerks(true)
    -- Reset Proficiencies
    util.prof.setProficiencies(playerDevelopmentData,oneProfs)

    -- Reset Attributes
    local points = util.attributes.getRemainingAttrPoints(attr)
    playerDevelopmentData:AddDevelopmentPoints(points,gamedataDevelopmentPointType.Attribute)
    util.attributes.setAttributes(playerDevelopmentData,attr,3)
    playerDevelopmentData:ResetSpentDevPoints(gamedataDevelopmentPointType.Attribute)
end

-- Following functions could technically be put into one with a second parameter
-- Thus they are in the general tab
function util.traits.StringToEnumValues(strings)
    local enums = {}
    for i,s in ipairs(strings) do
        enums[i] = gamedataTraitType[s]
    end
    return enums
end
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

return util
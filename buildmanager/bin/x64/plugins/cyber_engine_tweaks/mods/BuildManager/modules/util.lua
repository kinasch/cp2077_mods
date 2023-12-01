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

--- Returns attributes, perks, buildLevel, proficiencies and usedPoints.
---@param playerDevelopmentData PlayerDevelopmentData
---@param profLevelList table
function util.createNewSave(playerDevelopmentData,profLevelList)
    local attributes,perks,buildLevel,profs = nil,nil,nil,nil
    -- Get Attributes and their levels
    attributes = util.attributes.getAttributes(playerDevelopmentData)
    -- Get Perks and their levels
    perks = util.perk.getPerks(playerDevelopmentData)
    usedPoints = {attributePoints=util.attributes.getUsedAttributePoints(attributes),perkPoints=util.perk.getUsedPerkPoints(perks)}
    -- Get current Player Level to only show builds you can afford.
    buildLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), 'PowerLevel')

    -- Get the profs
    profs = profLevelList

    return attributes,perks,buildLevel,profs,usedPoints
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
-- Import/Export Functions
-- ##########################################################################
local perkLists = {
    body={"Body_Central_Milestone_1","Body_Central_Perk_1_1","Body_Central_Perk_1_2","Body_Central_Perk_1_3","Body_Central_Perk_1_4","Body_Right_Milestone_1","Body_Left_Milestone_2","Body_Left_Perk_2_1","Body_Left_Perk_2_3","Body_Left_Perk_2_4","Body_Right_Milestone_2","Body_Right_Perk_2_1","Body_Right_Perk_2_2","Body_Right_Perk_2_3","Body_Right_Perk_2_4","Body_Left_Milestone_3","Body_Left_Perk_3_1","Body_Left_Perk_3_2","Body_Left_Perk_3_3","Body_Left_Perk_3_4","Body_Inbetween_Left_3","Body_Central_Milestone_3","Body_Central_Perk_3_1","Body_Central_Perk_3_2","Body_Central_Perk_3_4","Body_Inbetween_Right_3","Body_Right_Milestone_3","Body_Right_Perk_3_1","Body_Right_Perk_3_2","Body_Master_Perk_1","Body_Master_Perk_2","Body_Master_Perk_3","Body_Master_Perk_5"},
    reflexes={"Reflexes_Left_Milestone_1","Reflexes_Central_Milestone_1","Reflexes_Central_Perk_1_1","Reflexes_Central_Perk_1_2","Reflexes_Central_Perk_1_3","Reflexes_Central_Perk_1_4","Reflexes_Left_Milestone_2","Reflexes_Left_Perk_2_2","Reflexes_Left_Perk_2_3","Reflexes_Left_Perk_2_4","Reflexes_Central_Milestone_2","Reflexes_Central_Perk_2_1","Reflexes_Central_Perk_2_2","Reflexes_Central_Perk_2_3","Reflexes_Central_Perk_2_4","Reflexes_Inbetween_Right_2","Reflexes_Right_Milestone_2","Reflexes_Right_Perk_2_1","Reflexes_Right_Perk_2_2","Reflexes_Right_Perk_2_3","Reflexes_Left_Milestone_3","Reflexes_Left_Perk_3_1","Reflexes_Left_Perk_3_2","Reflexes_Left_Perk_3_3","Reflexes_Left_Perk_3_4","Reflexes_Inbetween_Left_3","Reflexes_Central_Milestone_3","Reflexes_Central_Perk_3_2","Reflexes_Central_Perk_3_3","Reflexes_Right_Milestone_3","Reflexes_Right_Perk_3_1","Reflexes_Right_Perk_3_3","Reflexes_Right_Perk_3_4","Reflexes_Master_Perk_1","Reflexes_Master_Perk_2","Reflexes_Master_Perk_3","Reflexes_Master_Perk_5"},
    intelligence={"Intelligence_Left_Milestone_1","Intelligence_Left_Perk_1_1","Intelligence_Left_Perk_1_2","Intelligence_Central_Milestone_1","Intelligence_Central_Perk_1_1","Intelligence_Central_Perk_1_2","Intelligence_Central_Perk_1_3","Intelligence_Right_Milestone_1","Intelligence_Left_Milestone_2","Intelligence_Left_Perk_2_1","Intelligence_Left_Perk_2_2","Intelligence_Left_Perk_2_3","Intelligence_Left_Perk_2_4","Intelligence_Inbetween_Left_2","Intelligence_Central_Milestone_2","Intelligence_Central_Perk_2_1","Intelligence_Central_Perk_2_2","Intelligence_Central_Perk_2_3","Intelligence_Central_Perk_2_4","Intelligence_Inbetween_Right_2","Intelligence_Right_Milestone_2","Intelligence_Right_Perk_2_1","Intelligence_Right_Perk_2_2","Intelligence_Left_Milestone_3","Intelligence_Left_Perk_3_1","Intelligence_Left_Perk_3_2","Intelligence_Left_Perk_3_4","Intelligence_Inbetween_Left_3","Intelligence_Central_Milestone_3","Intelligence_Central_Perk_3_1","Intelligence_Central_Perk_3_2","Intelligence_Central_Perk_3_3","Intelligence_Right_Milestone_3","Intelligence_Right_Perk_3_1","Intelligence_Right_Perk_3_2","Intelligence_Master_Perk_1","Intelligence_Master_Perk_3","Intelligence_Master_Perk_4"},
    technicalAbility={"Tech_Left_Milestone_1","Tech_Left_Perk_1_1","Tech_Left_Perk_1_1","Tech_Right_Milestone_1","Tech_Left_Milestone_2","Tech_Left_Perk_2_1","Tech_Left_Perk_2_2","Tech_Left_Perk_2_3","Tech_Left_Perk_2_4","Tech_Central_Milestone_2","Tech_Central_Perk_2_1","Tech_Central_Perk_2_2","Tech_Central_Perk_2_3","Tech_Central_Perk_2_4","Tech_Inbetween_Right_2","Tech_Left_Milestone_3","Tech_Left_Perk_3_01","Tech_Left_Perk_3_2","Tech_Left_Perk_3_3","Tech_Left_Perk_3_4","Tech_Inbetween_Left_3","Tech_Central_Milestone_3","Tech_Central_Perk_3_1","Tech_Central_Perk_3_2","Tech_Central_Perk_3_3","Tech_Central_Perk_3_4","Tech_Right_Milestone_3","Tech_Right_Perk_3_1","Tech_Right_Perk_3_2","Tech_Right_Perk_3_3","Tech_Right_Perk_3_4","Tech_Master_Perk_2","Tech_Master_Perk_3","Tech_Master_Perk_5"},
    cool={"Cool_Left_Milestone_1","Cool_Central_Milestone_1","Cool_Central_Perk_1_1","Cool_Central_Perk_1_2","Cool_Central_Perk_1_4","Cool_Right_Milestone_1","Cool_Right_Perk_1_1","Cool_Right_Perk_1_2","Cool_Left_Milestone_2","Cool_Left_Perk_2_1","Cool_Left_Perk_2_2","Cool_Left_Perk_2_3","Cool_Left_Perk_2_4","Cool_Inbetween_Left_2","Cool_Right_Milestone_2","Cool_Right_Perk_1_1","Cool_Right_Perk_1_2","Cool_Right_Perk_1_3","Cool_Right_Perk_1_4","Cool_Left_Milestone_3","Cool_Left_Perk_3_1","Cool_Left_Perk_3_2","Cool_Left_Perk_3_3","Cool_Left_Perk_3_4","Cool_Inbetween_Left_3","Cool_Central_Milestone_3","Cool_Central_Perk_3_1","Cool_Central_Perk_3_2","Cool_Central_Perk_3_4","Cool_Inbetween_Right_3","Cool_Right_Milestone_3","Cool_Right_Perk_3_1","Cool_Right_Perk_3_2","Cool_Right_Perk_3_4","Cool_Master_Perk_1","Cool_Master_Perk_2","Cool_Master_Perk_4"},
    esp={"Espionage_Left_Milestone_Perk","Espionage_Left_Perk_1_2","Espionage_Central_Milestone_1","Espionage_Central_Perk_1_1","Espionage_Central_Perk_1_2","Espionage_Central_Perk_1_3","Espionage_Central_Perk_1_4","Espionage_Right_Milestone_1","Espionage_Right_Perk_1_1"}
}

--- Sets the build from an official build planner url
---@param url string
function util.setBuildFromURL(playerDevelopmentData,url)
    newSave = {attributes={},perks={},buildLevel=60,profs={}}

    -- Attributes
    aPattern = "?a=[0123456789abcdefghijk]*"
    local aString = string.sub(string.sub(url, string.find(url, aPattern)),4)
    aTable = {}
    ---@diagnostic disable-next-line: discard-returns
    aString:gsub(".",function(c) table.insert(aTable,tonumber(c,21)) end)
    attr = {"Strength","Reflexes","Intelligence","TechnicalAbility","Cool"}
    for index, value in ipairs(aTable) do
        table.insert(newSave.attributes,{name=attr[index],level=value})
    end

    -- Perks
    patterns = {body="&b=%d*",reflexes="&r=%d*",intelligence="&i=%d*",technicalAbility="&t=%d*",cool="&c=%d*",esp="&e=%d*"}

    filteredStringLists = {}
    for key, value in pairs(patterns) do
        local tempSubString = string.sub(string.sub(url, string.find(url, value)),4)
        local tempTable = {}
        tempSubString:gsub(".",function(c) table.insert(tempTable,tonumber(c)) end)
        filteredStringLists[key] = tempTable
    end
    
    for k,v in pairs(filteredStringLists) do
        for i,iv in ipairs(v) do
            if iv > 0 then
                table.insert(newSave.perks,{name=perkLists[k][i],level=iv})
            end
        end
    end

    newSave.profs = {
        {name="StrengthSkill",lvl=60,exp=0},
        {name="ReflexesSkill",lvl=60,exp=0},
        {name="CoolSkill",lvl=60,exp=0},
        {name="IntelligenceSkill",lvl=60,exp=0},
        {name="TechnicalAbilitySkill",lvl=60,exp=0}
    }

    util.setBuild(playerDevelopmentData,newSave)
end

--- Create official build planner URL from current build
---@param playerDevelopmentData PlayerDevelopmentData
function util.getUrlForCurrentBuild(playerDevelopmentData)
    attributesFromSave,perksFromSave = util.createNewSave(playerDevelopmentData,defaultProfLevelList)

    url = ""

    -- https://www.cyberpunk.net/de/build-planner?a=9kkf3&b=&r=&i=&t=&c=&e=
    urlComponents = {a="?a=",b="&b=",r="&r=",i="&i=",t="&t=",c="&c=",e="&e="}

    attrOrder = {"Strength","Reflexes","Intelligence","TechnicalAbility","Cool"}
    -- Horrible Big O, let's hope I will not do this again like 12 lines further down.
    for k,v in pairs(attrOrder) do
        for ak,av in pairs(attributesFromSave) do
            if v == av.name then
                urlComponents.a = urlComponents.a .. util.decimalToBase21(av.level)
            end
        end
    end

    url = url .. "https://www.cyberpunk.net/en/build-planner" .. urlComponents.a

    -- Combine all perkLists into one list.
    perkListsCombined = {}
    for k,v in pairs(perkLists) do
        for kk,vv in pairs(v) do
            table.insert(perkListsCombined,vv)
        end
    end
    -- Inverse Table for combined perkLists to index it.
    perkListsCombinedIndex = {}
    for i,v in ipairs(perkListsCombined) do
        perkListsCombinedIndex[v]=i
    end
    -- Ordering the perk levels by the official build planner order
    -- First: Create a list filled with 0 times the number of perks
    perkOrder = {}
    for i=1,#perkListsCombined do
        perkOrder[i] = 0
    end
    -- Second: Fill this list with the corresponding levels
    for k, v in pairs(perksFromSave) do
        perkOrder[perkListsCombinedIndex[v.name]] = v.level
    end

    -- Use this list to create the url components
    for key, value in pairs(perkLists) do
        for k,v in pairs(value) do
            urlComponents[string.sub(key,0,1)] = urlComponents[string.sub(key,0,1)] .. perkOrder[perkListsCombinedIndex[v]]
        end
    end

    for key, value in pairs(urlComponents) do
        if not (key == "a") then
            url = url .. value
        end
    end

    return url
end

---Turn a decimal decimal number greater 0 to a number base 21
---@param number number
---@return string
function util.decimalToBase21(number)
    number = number % 21
    b21str = ""
    if number < 16 then
        b21str = string.format("%x", number)
    else
        for k, v in pairs({g=16,h=17,i=18,j=19,k=20}) do
            if number == v then
               b21str = k
               break
            end
        end
    end
    return b21str
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

function util.attributes.getUsedAttributePoints(attr)
    local usedAttrPoints = -15
    for k,v in pairs(attr) do
        usedAttrPoints = usedAttrPoints + v.level
    end
    return usedAttrPoints
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

function util.perk.getUsedPerkPoints(perks)
    local usedPerkPoints = 0
    for k,v in pairs(perks) do
        usedPerkPoints = usedPerkPoints + v.level
    end
    return usedPerkPoints
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
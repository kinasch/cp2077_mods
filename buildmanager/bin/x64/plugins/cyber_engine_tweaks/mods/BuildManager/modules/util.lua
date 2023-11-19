util = {attributes={},perk={},traits={}}

-- ##########################################################################
-- Save Functions
-- ##########################################################################
-- Returns attributes, perks, buildLevel and proficiencies.
function util.createNewSave(name, playerDevelopmentData)
    -- TODO: profs value is currently not implemented.
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
-- Save Functions
-- ##########################################################################
function util.setBuild(playerDevelopmentData, save)
    -- save = {attributes:{},perks:{}}
    util.tabulaRasa(playerDevelopmentData)

    util.attributes.buyAttributes(playerDevelopmentData, save.attributes)
    util.perk.buyPerks(playerDevelopmentData, save.perks)
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
-- General Functions
-- ##########################################################################

-- Reset every part of the development data.
-- Currently only attributes and perks
-- TODO: Proficiencies (new)
function util.tabulaRasa(playerDevelopmentData)
    playerDevelopmentData:ResetNewPerks()
	playerDevelopmentData:ResetAttributes()
end

-- Returns the length of a given table.
function util.tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

return util
local perk_util = {}

--- Returns unlocked/bought perks in order (for whatever reason)
---@param playerDevelopmentData PlayerDevelopmentData
---@return table
function perk_util.getPerks(playerDevelopmentData)
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

--- Buys all perks from a list of perks for the player (perks need to be in order)
---@param playerDevelopmentData PlayerDevelopmentData
---@param perks table
function perk_util.buyPerks(playerDevelopmentData, perks)
    -- local perks = { {name,level},{name,level},... }
    for l,p in ipairs(perks) do
        for i = 1,p.level,1 do
            playerDevelopmentData:UnlockNewPerk(gamedataNewPerkType[p.name])
            playerDevelopmentData:BuyNewPerk(gamedataNewPerkType[p.name],false)
        end
    end
end

--- Returns amount of used perk points.
---@param perks table
---@return number
function perk_util.getUsedPerkPoints(perks)
    local usedPerkPoints = 0
    for k,v in pairs(perks) do
        if string.find(v.name, "Espionage") == nil then
            usedPerkPoints = usedPerkPoints + v.level
        end
    end
    return usedPerkPoints
end

return perk_util
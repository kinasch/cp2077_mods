local attributes_util = {}

--- Returns list of tables containing the attributes names and respective levels.
---@param playerDevelopmentData PlayerDevelopmentData
---@return table
function attributes_util.getAttributes(playerDevelopmentData)
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

--- Buy attributes from a list of attributes (usually from a save).
--- @param playerDevelopmentData PlayerDevelopmentData
--- @param attr { name:string, level:number }
function attributes_util.buyAttributes(playerDevelopmentData,attr)
    -- local attr = { {name,level},{name,level},... }
    for l,a in ipairs(attr) do
        for i = 3,a.level-1,1 do
            playerDevelopmentData:BuyAttribute(gamedataStatType[a.name])
        end
    end
end

--- Returns amount of used attribute points from a list of attributes
--- @param attr { name:string, level:number }
--- @return number
function attributes_util.getUsedAttributePoints(attr)
    local usedAttrPoints = -15
    for k,v in pairs(attr) do
        usedAttrPoints = usedAttrPoints + v.level
    end
    return usedAttrPoints
end

return attributes_util
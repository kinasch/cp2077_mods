util = {}

function util.getPerks(playerDevelopmentData)
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

function util.EnumValuesToString(perkEnums)
    local perkStrings = {}
    for i,perk in ipairs(perkEnums) do
        perkStrings[i] = perk.value
    end
    return perkStrings
end

function util.StringToEnumValues(perkStrings)
    local perkEnums = {}
    for i,perk in ipairs(perkStrings) do
        perkEnums[i] = gamedataPerkType[perk]
    end
    return perkEnums
end

return util
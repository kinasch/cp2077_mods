---@class Util
local util = {
    attributes = require("modules/attributes_util"),
    perk = require("modules/perk_util"),
    prof = require("modules/prof_util"),
    equip = require("modules/equip_util"),
    import_export = require("modules/import_export_util")
}

-- ##########################################################################
-- Save Functions
-- ##########################################################################

--- Gathers all needed values to create a new save.
--- Returns attributes, perks, buildLevel, proficiencies (skills), usedPoints and a list of equipment.
---@param playerDevelopmentData PlayerDevelopmentData
---@param profLevelList table
---@return table,table,number,table,table,table
function util.createNewSave(playerDevelopmentData,profLevelList)
    local attributes,perks,buildLevel,profs,equipment = nil,nil,nil,nil,nil
    -- Get Attributes and their levels
    attributes = util.attributes.getAttributes(playerDevelopmentData)
    -- Get Perks and their levels
    perks = util.perk.getPerks(playerDevelopmentData)
    usedPoints = {attributePoints=util.attributes.getUsedAttributePoints(attributes),perkPoints=util.perk.getUsedPerkPoints(perks)}
    -- Get current Player Level to only show builds you can afford.
    buildLevel = Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), 'PowerLevel')

    -- Get the profs
    profs = profLevelList

    -- Always save the equipment as well (just in case)
    equipment = util.equip.getEquippedCyberware()

    return attributes,perks,buildLevel,profs,usedPoints,equipment
end


-- ##########################################################################
-- Load Functions
-- ##########################################################################

--- Takes values from a given save and applies them to the player.
---@param playerDevelopmentData PlayerDevelopmentData
---@param save {attributes: table, perks: table, buildLevel: number, profs: table, usedPoints: number, equipment: table}
---@param loadEquipment bool
---@param loadSkills bool
function util.setBuild(playerDevelopmentData, save, loadEquipment, loadSkills)
    if loadEquipment then
        -- Calling this seperatly from tabulaRasa, to include the loadEquipment check. Might be subject to change...
        util.equip.unequipEverything()
    end
    -- save = {attributes:{},perks:{}}
    util.tabulaRasa(playerDevelopmentData, loadSkills)

    -- Very hacky and weird fixing attempt
    -- Give the player the max amount of perk points theoretically possible.
    -- Needed because the attributes and proficiencies aren't being bought/levelled fast enough internally.
    local tempPP = 80
    if loadSkills then
        util.givePerkPoints(playerDevelopmentData, tempPP)
    end

    util.attributes.buyAttributes(playerDevelopmentData, save.attributes)

    util.perk.buyPerks(playerDevelopmentData, save.perks)

    if loadSkills then
        util.prof.setProficiencies(playerDevelopmentData, save.profs)
        util.givePerkPoints(playerDevelopmentData, -tempPP)
    end

    if loadEquipment then
        util.equip.equipCyberwareFromItemList(save.equipment)
    end
end

-- ##########################################################################
-- General Functions
-- ##########################################################################

--- Reset every part of the development data. (Perks, Attributes and Proficiencies / Skills)
---@param playerDevelopmentData PlayerDevelopmentData
---@param loadSkills bool
function util.tabulaRasa(playerDevelopmentData, loadSkills)
    playerDevelopmentData:ResetNewPerks()
	playerDevelopmentData:ResetAttributes()
    if loadSkills then
        util.prof.setProficiencies(playerDevelopmentData, util.prof.getDefaultProfLevelList())
    end
end

--- Returns the length of a given table.
---@param T table
---@return number
function util.tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function util.givePerkPoints(playerDevelopmentData,amount)
    playerDevelopmentData:AddDevelopmentPoints(amount,gamedataDevelopmentPointType.Primary)
end


return util
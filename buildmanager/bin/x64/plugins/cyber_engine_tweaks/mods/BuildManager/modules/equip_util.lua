local equip_util = {}

--- Returns all equipped Cyberware in an array consisting of tables with ItemID components
---@return {tdb_name:string, rng_seed:number, slotIndex:number, parts:{partTDB:string,partSeed:number,slot:string}, maybe_type:number, unknown:number}[]
function equip_util.getEquippedCyberware()
    local items = {}

    -- This returns an array of SItemInfo
    local equippedCyberware = EquipmentSystem.GetData(GetPlayer()):GetAllEquippedItems()
    for k,v in pairs(equippedCyberware) do
        if v.itemID.id.hash ~= 0 then
            local parts = nil
            local cyberwareParts = EquipmentSystem.GetData(GetPlayer()):GetPartsFromItem(v.itemID)
            if #cyberwareParts > 0 then
                parts = {}
                for partK,partV in pairs(cyberwareParts) do
                    table.insert(parts, {partTDB=partV.partID.id.value, partSeed=partV.partID.rng_seed, slot=partV.slot.value})
                end
            end
            table.insert(items, {
                tdb_name=v.itemID.id.value,
                rng_seed=v.itemID.rng_seed,
                slotIndex=v.slotIndex,
                parts=parts,
                maybe_type=v.itemID.maybe_type,
                unknown=v.itemID.unknown
            })
        end
    end

    return items
end

--- Call the ClearEquipment function (removes Cyberware, Weapons and Clothing (Clothing sets are untouched))
function equip_util.unequipEverything()
    EquipmentSystem.GetData(GetPlayer()):ClearCyberwareWeaponsAndClothes()
end

--- Equip all the cyberware from a list of items. List of items in the style of:
--- - [{tdb_name, rng_seed, slotIndex}, {tdb_name, rng_seed, slotIndex}, ...]
---@param cyberware_items {tdb_name:string, rng_seed:number, slotIndex:number, parts:{partTDB:string,partSeed:number,slot:string}, maybe_type:number, unknown:number}[]
function equip_util.equipCyberwareFromItemList(cyberware_items)
    local items, parts = {}, {}
    for k,v in pairs(cyberware_items) do
        local s_item_info = SItemInfo.new()
        -- v = {tdb_name, rng_seed, slotIndex}
        s_item_info.itemID = ToItemID{
            id=TDBID.Create(v.tdb_name),
            rng_seed=v.rng_seed,
            maybe_type=v.maybe_type,
            unknown=v.unknown
        }
        s_item_info.slotIndex = v.slotIndex
        table.insert(items, s_item_info)
        if v.parts ~= nil then
            for partK, partV in pairs(v.parts) do
                table.insert(parts,{
                    item=s_item_info.itemID,
                    part=ToItemID{id=TDBID.Create(partV.partTDB), rng_seed=partV.partSeed},
                    slot=TDBID.Create(partV.slot)
                })
            end
        end
    end
    -- Maybe temporarily boost the cyberware limit?
    --Game.GetStatsSystem():AddModifier(GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.Humanity, gameStatModifierType.Additive, 100))
    EquipmentSystem.GetData(GetPlayer()):EquipAllItemsFromList(items)
    --Game.GetStatsSystem():AddModifier(GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.Humanity, gameStatModifierType.Additive, -100))

    -- Equip Cyberware Parts (Quickhacks, Mods, etc.)
    for k,v in pairs(parts) do
        Game.GetTransactionSystem():AddPart(GetPlayer(), v.item, v.part, v.slot)
    end
end

return equip_util
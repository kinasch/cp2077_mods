local ratio = 1
local currentEquippedWeaponStatsObjectID = nil;
local equippedWeaponCritChance = 0.0
local playerCritChance = 0.0
local amountOfCritChanceStatDataOnPlayer = 0

registerForEvent("onTweak", function()
    -- Set the maximum crit chance to some arbritary high number, early!
	TweakDB:SetFlat("BaseStats.CritChance.max", 999999)
end)

registerForEvent("onInit", function()
    -- Get equipped weapon (if mod is reloaded during gameplay)
    local player = GetPlayer()
    if player ~= nil then
        local curEquippedWeapon = player.equippedRightHandWeapon
        if curEquippedWeapon ~= nil then
            currentEquippedWeaponStatsObjectID = curEquippedWeapon:GetItemData():GetStatsObjectID()
        end
        playerCritChance = Game.GetStatsSystem():GetStatValue(player:GetEntityID(), gamedataStatType.CritChance)
        for _, detailedStatData in pairs(Game.GetStatsSystem():GetStatDetails(player:GetEntityID())) do
            if detailedStatData.statType == gamedataStatType.CritChance then
                -- This will not work and probably needs redscript ... TODO:
                amountOfCritChanceStatDataOnPlayer = #detailedStatData.modifiers
            end
        end
    end

    -- Observe some method being loaded pretty late into game load (no idea which one to pick here)
    ObserveAfter("healthbarWidgetGameController", "OnInitialize",
    ---@param this healthbarWidgetGameController
    function(this)
        player = GetPlayer()
        if player ~= nil then
            for _, detailedStatData in pairs(Game.GetStatsSystem():GetStatDetails(player:GetEntityID())) do
                if detailedStatData.statType == gamedataStatType.CritChance then
                    amountOfCritChanceStatDataOnPlayer = #detailedStatData.modifiers
                end
            end
        end
    end)


    -- Observe the player for stat changes related to crit chance
    -- Will miss things like bonus crit chance, no idea about the impact of this though
    --[[ Observe("PlayerPuppet", "OnStatChanged",function(this, ownerID, statType, diff, total)
        if statType==gamedataStatType.CritChance then
            if total>=100.0 then
                -- If the diff from the stat change did not push the total above 100, increase CritDamage by the diff, otherwise take total-100
                -- Meaning if the total crit chance was below 100 before, only increase the crit damage by the amount of percent above 100
                local amount = (total-diff)>=100.0 and diff or total-100.0;
                Game.GetStatsSystem():AddModifier(
                    Game.GetPlayer():GetEntityID(),
                    RPGManager.CreateStatModifier(gamedataStatType.CritDamage, gameStatModifierType.Additive, amount*ratio)
                );
            -- Check for the crit chance falling below 100 (bcs of unequipping items, reseting attributes, etc.)
            elseif -diff+total>100 and total<=100.0 then
				Game.GetStatsSystem():AddModifier(
                    Game.GetPlayer():GetEntityID(),
                    -- Example: Crit Chance was 110 before, fell to 90, only 10 crit damage should be subtracted 
                    -- -> -1 * (90 - (-20) - 100) = -10
                    RPGManager.CreateStatModifier(gamedataStatType.CritDamage, gameStatModifierType.Additive, -ratio*(total-diff-100))
                );
			end
            print("Player Crit Chance:", total,"- Player Crit Dmg:", Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType.CritDamage))
        end
    end) ]]

    -- This and the observer above mean, that this mod adds A LOT of modifiers to the player, might decrease performance, idk.
    Observe("PlayerPuppet", "OnItemEquipped", function(this, slot, item)
        if slot==TweakDB:GetRecord("AttachmentSlots.WeaponRight"):GetID() then
            currentEquippedWeaponStatsObjectID = Game.GetTransactionSystem():GetItemData(GetPlayer(), item):GetStatsObjectID()
            equippedWeaponCritChance = Game.GetStatsSystem():GetStatValue(currentEquippedWeaponStatsObjectID, gamedataStatType.CritChance)
            Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, equippedWeaponCritChance))
        end
    end)
    Observe("PlayerPuppet", "OnItemUnequipped", function(this, slot, item)
        if slot==TweakDB:GetRecord("AttachmentSlots.WeaponRight"):GetID() then
            --Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, -equippedWeaponCritChance))
            --Game.GetStatsSystem():RemoveModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, equippedWeaponCritChance))
            for _, detailedStatData in pairs(Game.GetStatsSystem():GetStatDetails(currentEquippedWeaponStatsObjectID)) do
                if detailedStatData.statType == gamedataStatType.CritChance then
                    for _, detailedStat in pairs(detailedStatData.modifiers) do
                        Game.GetStatsSystem():RemoveModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, detailedStat.value))
                    end
                end
            end
            currentEquippedWeaponStatsObjectID = nil
            equippedWeaponCritChance = 0.0
        end
    end)

    -- Observe for stats changing on equipped weapon
    -- Added modifiers
    ObserveAfter("StatsSystem", "AddModifier", function(this, objID, modifierData)
        processWeaponStatChanged(objID, modifierData.statType, "AddModifier", false)
    end)
    ObserveAfter("StatsSystem", "AddModifiers", function(this, objID, modifierData)
        for _, modData in pairs(modifierData) do
            processWeaponStatChanged(objID, modData.statType, "AddModifiers", false)
        end
    end)
    ObserveAfter("StatsSystem", "AddSavedModifier", function(this, objID, modifierData)
        processWeaponStatChanged(objID, modifierData.statType, "AddSavedModifier", false)
    end)
    ObserveAfter("StatsSystem", "ApplyModifierGroup", function(this, objID, groupID)
        -- just pass the right statType, increases comparisons done and is not even remotely efficient, but I do not know how to get from the groupID to its statModifiers
        processWeaponStatChanged(objID, gamedataStatType.CritChance, "ApplyModifierGroup", false)
    end)
    -- ForceModifier here as well? idk - needs testing

    -- Removed Modifiers
    ObserveAfter("StatsSystem", "RemoveModifier", function(this, objID, modifierData)
        processWeaponStatChanged(objID, modifierData.statType, "RemoveModifier", true)
    end)
    ObserveAfter("StatsSystem", "RemoveAllModifiers", function(this, objID, statType, removeSavedModifiers)
        processWeaponStatChanged(objID, statType, "RemoveAllModifiers", true)
    end)
    ObserveAfter("StatsSystem", "RemoveSavedModifiers", function(this, objID, modifierData)
        processWeaponStatChanged(objID, modifierData.statType, "RemoveSavedModifiers", true)
    end)
    ObserveAfter("StatsSystem", "RemoveModifierGroup", function(this, objID, groupID)
        -- just pass the right statType, increases comparisons done and is not even remotely efficient, but I do not know how to get from the groupID to its statModifiers
        processWeaponStatChanged(objID, gamedataStatType.CritChance, "RemoveModifierGroup", true)
    end)
    ObserveAfter("StatsSystem", "RemoveAndUncacheModifier", function(this, objID, modifierData)
        processWeaponStatChanged(objID, modifierData.statType, "RemoveAndUncacheModifier", true)
    end)
    -- UnforceStat here as well? idk - needs testing


    -- Check the crit chance calculation for quickhack and remove weapon crit chance for this
    Observe("DamageSystem", "ProcessCriticalHit",
    ---@param this DamageSystem
    ---@param hitEvent gameHitEvent
    function(this, hitEvent)
        print("player crit chance before crit chance check:",Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritChance))
        if hitEvent.attackData:GetAttackType() == gamedataAttackType.Hack or hitEvent.attackData:HasFlag(hitFlag.QuickHack) then
            for _, detailedStatData in pairs(Game.GetStatsSystem():GetStatDetails(currentEquippedWeaponStatsObjectID)) do
                if detailedStatData.statType == gamedataStatType.CritChance then
                    for detailedWeaponStatIndex, detailedStat in ipairs(detailedStatData.modifiers) do
                        Game.GetStatsSystem():RemoveModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, detailedStat.value))
                    end
                end
            end
            --[[ for _, detailedStatData in pairs(Game.GetStatsSystem():GetStatDetails(GetPlayer():GetEntityID())) do
                if detailedStatData.statType == gamedataStatType.CritChance then
                    print(#detailedStatData.modifiers)
                end
            end ]]
        end
        print("player crit chance during crit chance check:",Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritChance))
    end)
    ObserveAfter("DamageSystem", "ProcessCriticalHit",
    ---@param this DamageSystem
    ---@param hitEvent gameHitEvent
    function(this, hitEvent)
        if hitEvent.attackData:GetAttackType() == gamedataAttackType.Hack or hitEvent.attackData:HasFlag(hitFlag.QuickHack) then
            for _, detailedStatData in pairs(Game.GetStatsSystem():GetStatDetails(currentEquippedWeaponStatsObjectID)) do
                if detailedStatData.statType == gamedataStatType.CritChance then
                    for detailedWeaponStatIndex, detailedStat in ipairs(detailedStatData.modifiers) do
                        Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, detailedStat.value))
                    end
                end
            end
        end
        -- Also add the additional crit chance to player crit chance (to re-calculate crit damage)
        if hitEvent.attackData:GetAdditionalCritChance() > 0.0 then
            Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, hitEvent.attackData:GetAdditionalCritChance()*100.0))
        end
        print("player crit chance after crit chance check:",Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritChance))
    end)

    Observe("DamageSystem", "GetCritDamageModifier",
    ---@param this DamageSystem
    ---@param statSystem StatsSystem
    ---@param attackData AttackData
    function(this, statSystem, attackData)
        print("player crit chance before/during crit DMG CALC:",Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritChance),Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritDamage))
    end)

    -- Remove additional crit chances after crit damage calc is done
    ObserveAfter("DamageSystem", "GetCritDamageModifier",
    ---@param this DamageSystem
    ---@param statSystem StatsSystem
    ---@param attackData AttackData
    function(this, statSystem, attackData)
        if attackData:GetAdditionalCritChance() > 0.0 then
            Game.GetStatsSystem():RemoveModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, attackData:GetAdditionalCritChance()*100.0))
        end
        print("player crit chance after crit DMG CALC:",Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritChance))
    end)


end)

---@param statsObjectID StatsObjectID
---@param statType gamedataStatType
---@param source? string
---@param remove? boolean
function processWeaponStatChanged(statsObjectID, statType, source, remove)
    source = source or "UNKNOWN"
    remove = remove or false
    if currentEquippedWeaponStatsObjectID ~= nil then
        if statType == gamedataStatType.CritChance and statsObjectID.entityHash == currentEquippedWeaponStatsObjectID.entityHash then
            local weaponCritChance = Game.GetStatsSystem():GetStatValue(currentEquippedWeaponStatsObjectID, gamedataStatType.CritChance)
            if weaponCritChance ~= equippedWeaponCritChance then
                --print("Weapon Crit Chance changed, by:", source, "- weaponCritChance vs saved",weaponCritChance, equippedWeaponCritChance)
                if remove then
                    Game.GetStatsSystem():RemoveModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, math.abs(weaponCritChance-equippedWeaponCritChance)))
                else
                    Game.GetStatsSystem():AddModifier(Game.GetPlayer():GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, math.abs(weaponCritChance-equippedWeaponCritChance)))
                end
                equippedWeaponCritChance = weaponCritChance
            end
        end
    end
end

---@param statsObjectID StatsObjectID
---@param statType gamedataStatType
---@param source? string
---@param remove? boolean
function processPlayerStatChanged(statsObjectID, statType, source, remove)
    source = source or "UNKNOWN"
    remove = remove or false
    if statType==gamedataStatType.CritChance and statsObjectID.entityHash == GetPlayer():GetEntityID().hash then
        local total = Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritChance)
        local diff = total - playerCritChance
        if total>=100.0 then
            -- If the diff from the stat change did not push the total above 100, increase CritDamage by the diff, otherwise take total-100
            -- Meaning if the total crit chance was below 100 before, only increase the crit damage by the amount of percent above 100
            local amount = (total-diff)>=100.0 and diff or total-100.0;
            Game.GetStatsSystem():AddModifier(
                Game.GetPlayer():GetEntityID(),
                RPGManager.CreateStatModifier(gamedataStatType.CritDamage, gameStatModifierType.Additive, amount*ratio)
            );
        -- Check for the crit chance falling below 100 (bcs of unequipping items, reseting attributes, etc.)
        elseif -diff+total>100 and total<=100.0 then
            Game.GetStatsSystem():AddModifier(
                Game.GetPlayer():GetEntityID(),
                -- Example: Crit Chance was 110 before, fell to 90, only 10 crit damage should be subtracted 
                -- -> -1 * (90 - (-20) - 100) = -10
                RPGManager.CreateStatModifier(gamedataStatType.CritDamage, gameStatModifierType.Additive, -ratio*(total-diff-100))
            );

            for _, detailedStatData in pairs(Game.GetStatsSystem():GetStatDetails(GetPlayer():GetEntityID())) do
                if detailedStatData.statType == gamedataStatType.CritChance then
                    amountOfCritChanceStatDataOnPlayer = #detailedStatData.modifiers
                end
            end

        end
        playerCritChance = total
        print("Player Crit Chance:", total,"- Player Crit Dmg:", Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType.CritDamage))
    end
end
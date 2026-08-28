registerForEvent("onTweak", function()
    -- Set the maximum crit chance to some arbritary high number, early!
	TweakDB:SetFlat("BaseStats.CritChance.max", 999999)
end)

registerForEvent("onInit", function()
    ObserveAfter("StatsDetailViewController", "Setup",
    ---@param this StatsDetailViewController
    ---@param stat StatViewData
    function(this, stat)
        --[[ if stat.statName == gamedataStatType.CritChance then
            local statsDetailCritChance = math.min(stat.valueF, 100.00)
            inkTextRef:SetText(this.m_StatValueRef, FloatToStringPrec(statsDetailCritChance, 2) + "%");
        end ]]
        if stat.type == gamedataStatType.CritChance then
            local weaponCritChance = 0
            if GetPlayer().equippedRightHandWeapon ~= nil then
                weaponCritChance = Game.GetStatsSystem():GetStatValue(GetPlayer().equippedRightHandWeapon:GetEntityID(), gamedataStatType.CritChance)
            end
            local statsDetailCritChance = stat.valueF + weaponCritChance
            --print(this.StatValueRef, Dump(this.StatValueRef,true))
            ---@diagnostic disable-next-line: missing-parameter
            this.StatValueRef:SetText(FloatToStringPrec(statsDetailCritChance, 2) .. "%")
        end
        if stat.type == gamedataStatType.CritDamage then
            local playerCritChance = Game.GetStatsSystem():GetStatValue(GetPlayer():GetEntityID(), gamedataStatType.CritChance)
            local weaponCritChance, weaponCritDamage = 0, 0
            if GetPlayer().equippedRightHandWeapon ~= nil then
                weaponCritChance = Game.GetStatsSystem():GetStatValue(GetPlayer().equippedRightHandWeapon:GetEntityID(), gamedataStatType.CritChance)
                weaponCritDamage = Game.GetStatsSystem():GetStatValue(GetPlayer().equippedRightHandWeapon:GetEntityID(), gamedataStatType.CritDamage)
            end
            local statsDetailCritDamage = stat.valueF
            local combinedCritChanceWeaponAndPlayer = playerCritChance + weaponCritChance
            if combinedCritChanceWeaponAndPlayer > 100.0 then
                statsDetailCritDamage = statsDetailCritDamage + (combinedCritChanceWeaponAndPlayer - 100.0)
            end
            statsDetailCritDamage = statsDetailCritDamage + weaponCritDamage
            --print(this.StatValueRef, Dump(this.StatValueRef,true))
            ---@diagnostic disable-next-line: missing-parameter
            this.StatValueRef:SetText(FloatToStringPrec(statsDetailCritDamage, 2) .. "%")
        end
    end)
end)
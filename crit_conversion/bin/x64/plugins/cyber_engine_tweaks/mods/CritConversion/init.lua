local ratio = 1

registerForEvent("onTweak", function()
    -- Set the maximum crit chance to some arbritary high number, early!
	TweakDB:SetFlat("BaseStats.CritChance.max", 5000)
end)

registerForEvent("onInit", function()
    -- Observe the player for stat changes related to crit chance
    -- Will miss things like bonus crit chance, no idea about the impact of this though
    Observe("PlayerPuppet", "OnStatChanged",function(this, ownerID, statType, diff, total)
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
        end
    end)
end)
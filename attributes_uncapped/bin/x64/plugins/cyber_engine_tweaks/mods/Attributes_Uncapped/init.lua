-- Init
registerForEvent("onInit", function()
	local loaded = false

	local old_value = {
		Reflexes=0,
		Intelligence=0,
		TechnicalAbility=0,
		Strength=0,
		Cool=0
	}

	-- Raise max value of every attribute.
	for key, value in pairs(old_value) do
		TweakDB:SetFlat("BaseStats."..key..".max",PlayerDevelopmentSystem.GetAttributesUncappedCap())
	end

	-- Set up the stat modifiers for attribute levels beyond 20.
	local stat_modifier = {
		Reflexes=function(amount)
			return RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, amount * 0.5)
		end,
		Intelligence=function(amount, old_amount)
			-- Check the current level / old value of the attribute before level up
			-- Used the calculate whether the user should get more RAM after levelling up normally, aka amount = 1
			old_amount = old_amount or 0
			if amount < 3 and amount > 0 then
				amount = math.floor((old_amount+amount)/4) > math.floor(old_amount/4) and 1 or 0
			elseif amount > -3 and amount < 0 then
				amount = math.floor((old_amount+amount)/4) < math.floor(old_amount/4) and -1 or 0
			else
				amount = amount < 0 and math.ceil(amount/4) or math.floor(amount/4)
			end

			return RPGManager.CreateStatModifier(gamedataStatType.Memory, gameStatModifierType.Additive, amount * 1)
		end,
		TechnicalAbility=function(amount)
			return RPGManager.CreateStatModifier(gamedataStatType.Armor, gameStatModifierType.Additive, amount * 2)
		end,
		Strength=function(amount)
			return RPGManager.CreateStatModifier(gamedataStatType.Health, gameStatModifierType.Additive, amount * 2)
		end,
		Cool=function(amount)
			return RPGManager.CreateStatModifier(gamedataStatType.CritDamage, gameStatModifierType.Additive, amount * 1.25)
		end
	}

	-- Observe the SetAttribute function of PlayerDevelopmentData, as it is called by BuyAttribute and ModifyAttribute
	-- There's (almost) no change of the attributes without it.
	-- Get the old value(s) before changing / setting / buying attributes to compare them later on.
	Observe("PlayerDevelopmentData", "SetAttribute",function(this, type, amount)
		--if not loaded then return end
		type = type.value
		old_value[type] = PlayerDevelopmentSystem.GetData(GetPlayer()):GetAttributeValue(type)
	end)

	-- Check the new amount for actions beyond the normal 
	ObserveAfter("PlayerDevelopmentData", "SetAttribute",function(this, type, amount)
		if not loaded then return end
		type = type.value
		-- Check for resetting or other, more unusual, attribute modifications
		if amount < old_value[type] then
			local worked, error = pcall(function ()
				if type == "Intelligence" then
					Game.GetStatsSystem():AddModifier(
						GetPlayer():GetEntityID(),
						stat_modifier[type]( - old_value[type] + Max(amount,20), old_value[type] )
					)
				else
					Game.GetStatsSystem():AddModifier(
						GetPlayer():GetEntityID(),
						stat_modifier[type]( - old_value[type] + Max(amount,20) )
					)
				end
				
			end)
			if not worked then
				spdlog.warning("Error, Set Attribute amount<old_value:\n"..tostring(error))
			end
		-- Levels 1 through 20, the game handles the attribute passives itself, beyond that it doesn't, no matter the max.
		-- Tbf, this whole mod would be useless if that was not the case.
		elseif amount > 20 then
			local worked, error = pcall(function ()
				if type == "Intelligence" then
					Game.GetStatsSystem():AddModifier(
						GetPlayer():GetEntityID(),
						stat_modifier[type](Max(0,amount-20)-Max(0,old_value[type]-20), old_value[type])
					)
				else
					Game.GetStatsSystem():AddModifier(
						GetPlayer():GetEntityID(),
						stat_modifier[type](Max(0,amount-20)-Max(0,old_value[type]-20))
					)
				end
			end)
			if not worked then
				spdlog.warning("Error, Set Attribute amount>20:\n"..tostring(error))
			end
		end
	end)

	-- Get attribute levels after loading in to avoid cheesing the mod by reloading all mods and stacking modifiers.
	-- This is hopefully only getting called once.
	ObserveAfter("PlayerDevelopmentSystem", "OnRestored",function(this, saveVersion, gameVersion)
		loaded = true

		for key, value in pairs(old_value) do
			local cur_level = PlayerDevelopmentSystem.GetData(GetPlayer()):GetAttributeValue(gamedataStatType[key])
			if cur_level > 20 then
				Game.GetStatsSystem():AddModifier(
					GetPlayer():GetEntityID(),
					stat_modifier[key](Max(0,cur_level-20))
				)
			end

			-- Could one do `value = ...` here? idk
			old_value[key] = cur_level
		end
	end)
end)
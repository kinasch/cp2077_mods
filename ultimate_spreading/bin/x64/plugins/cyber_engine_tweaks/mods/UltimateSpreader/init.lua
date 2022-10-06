local hackingUtils = require("modules/hackingUtils")
local savedSettings = require("modules/savedSettings")

registerForEvent("onInit", function()
	local loaded = savedSettings.tryToLoadSettings()
	if loaded then
		setValuesAfterLoad()
	end

	local nativeSettings = GetMod("nativeSettings")

	if not nativeSettings then -- Make sure the Native UI Settings mod is installed
		print("Error: NativeSettings not found!")
		return
	end

	nativeSettings.addTab("/ultspreader", "Ultimate Spreader")

	-- Suicide QuickHack
	nativeSettings.addSubcategory("/ultspreader/suicide", "Suicide QuickHack")
	nativeSettings.addRangeInt(
		"/ultspreader/suicide", "Suicide Spread Count", "Number of people the Suicide QuickHack spreads to.",
		1, 25, 1, savedSettings.settings.suicide.count.saved, savedSettings.settings.suicide.count.default,
		function(value)
			savedSettings.settings.suicide.count.saved = value
			hackingUtils.setSpreadCountSuicide(value)
		end
	)
	nativeSettings.addRangeInt(
		"/ultspreader/suicide", "Suicide Spread Distance", "Distance the Suicide QuickHack can spread.",
		-1, 100, 1, savedSettings.settings.suicide.range.saved, savedSettings.settings.suicide.range.default,
		function(value)
			savedSettings.settings.suicide.range.saved = value
			hackingUtils.setSpreadRangeSuicide(value)
		end
	)

	-- System Reset (or Collapse) QuickHack
	nativeSettings.addSubcategory("/ultspreader/systemreset", "System Reset QuickHack")
	nativeSettings.addRangeInt(
		"/ultspreader/systemreset", "System Reset Spread Count", "Number of people the System Reset QuickHack spreads to.",
		1, 25, 1, savedSettings.settings.systemCollapse.count.saved, savedSettings.settings.systemCollapse.count.default,
		function(value)
			savedSettings.settings.systemCollapse.count.saved = value
			hackingUtils.setSpreadCountSystemCollapse(value)
		end
	)
	nativeSettings.addRangeInt(
		"/ultspreader/systemreset", "System Reset Spread Distance", "Distance the System Reset QuickHack can spread.",
		-1, 100, 1, savedSettings.settings.systemCollapse.range.saved, savedSettings.settings.systemCollapse.range.default,
		function(value)
			savedSettings.settings.systemCollapse.range.saved = value
			hackingUtils.setSpreadRangeSystemCollapse(value)
		end
	)

	-- Contagion QuickHack
	nativeSettings.addSubcategory("/ultspreader/contagion", "Contagion QuickHack")
	nativeSettings.addRangeInt(
		"/ultspreader/contagion", "Contagion Spread Distance", "Distance the Contagion QuickHack can spread.",
		-1, 100, 1, savedSettings.settings.contagion.range.saved, savedSettings.settings.contagion.range.default,
		function(value)
			savedSettings.settings.contagion.range.saved = value
			hackingUtils.setSpreadRangeContagion(value)
		end
	)
	nativeSettings.addRangeInt(
		"/ultspreader/contagion", "Contagion Bonus Jumps Count", "Number of jumps the Contagion QuickHack does (Player Stat QuickHackSpread + Slider Value).",
		1, 25, 1, savedSettings.settings.contagion.bonusJumps.saved, savedSettings.settings.contagion.bonusJumps.default,
		function(value)
			savedSettings.settings.contagion.bonusJumps.saved = value
			hackingUtils.setBonusJumpsContagion(value)
		end
	)


	-- Save the settings on leaving the pause menu
	Observe('PauseMenuGameController', 'OnUninitialize', function()
		savedSettings.tryToSaveSettings()
	end)
end)

-- Save the settings on leaving the game
registerForEvent("onShutdown", function()
	savedSettings.tryToSaveSettings()
end)

function setValuesAfterLoad()
	hackingUtils.setSpreadCountSuicide(savedSettings.settings.suicide.count.saved)
	hackingUtils.setSpreadRangeSuicide(savedSettings.settings.suicide.range.saved)
	hackingUtils.setSpreadCountSystemCollapse(savedSettings.settings.systemCollapse.count.saved)
	hackingUtils.setSpreadRangeSystemCollapse(savedSettings.settings.systemCollapse.range.saved)
	hackingUtils.setSpreadRangeContagion(savedSettings.settings.contagion.range.saved)
	hackingUtils.setBonusJumpsContagion(savedSettings.settings.contagion.bonusJumps.saved)
end
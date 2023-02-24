local util = require("modules/util")
local saveSettings = require("modules/saveSettings")
local openMenu = false
local loadbool = false
local playerDevelopmentData
local playerLevel

registerForEvent("onOverlayOpen", function()
	playerDevelopmentData = Game.GetScriptableSystemsContainer():Get("PlayerDevelopmentSystem"):GetDevelopmentData(Game.GetPlayer())
	playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])
	openMenu = true
end)
registerForEvent("onOverlayClose", function()
	playerDevelopmentData = nil
	openMenu = false
	-- saveSettings.tryToSaveSettings()
end)

-- Load the settings upon starting the game
registerForEvent("onInit", function()
	saveSettings.tryToLoadSettings()
end)
-- Save the settings upon leaving the game
registerForEvent("onShutdown", function()
	saveSettings.tryToSaveSettings()
end)

registerForEvent("onDraw",function ()
	if openMenu ~= true then return end

	ImGui.SetNextWindowPos(100, 700, ImGuiCond.FirstUseEver)
	ImGui.SetNextWindowSize(150, 450,ImGuiCond.Appearing)
	ImGui.Begin("BuildManager")

	--ImGui.PushItemWidth(0.4*ImGui.GetWindowWidth())

	ImGui.BeginTabBar('Simple Build Manager')

	-- #####################################################################################################
	-- Save
	if ImGui.BeginTabItem("Save") then
		loadbool = false
		local clicked
		for i = 1,10,1 do
			stringifiedNumber = tostring(i)
			clicked = ImGui.Button(stringifiedNumber,(0.5*ImGui.GetWindowWidth()),30)
			if clicked then
				buttonClick(stringifiedNumber)
			end
		end
		ImGui.EndTabItem()
	end

	-- #####################################################################################################
	-- Load
	if ImGui.BeginTabItem("Load") then
		loadbool = true
		local clicked
		for i = 1,10,1 do
			stringifiedNumber = tostring(i)
			-- Check if a save exists
			if saveSettings.settings[stringifiedNumber] ~= nil then
				-- Check for save level
				if playerLevel >= saveSettings.settings[stringifiedNumber].buildLevel then
					clicked = ImGui.Button(stringifiedNumber,(0.5*ImGui.GetWindowWidth()),30)
					if clicked then
						buttonClick(stringifiedNumber)
					end
				end
			end
		end
		ImGui.EndTabItem()
	end

	-- #####################################################################################################
	-- Misc
	if ImGui.BeginTabItem("Misc") then
		loadbool = false
		local clicked
		clicked = ImGui.Button("Reset everything (free)",(0.5*ImGui.GetWindowWidth()),30)
		if clicked then
			local a = util.attributes.getAttributes(playerDevelopmentData)
			local tempA = util.EnumValuesToString(a.names)
			a.names = tempA
			util.tabulaRasa(playerDevelopmentData,a)
		end
		ImGui.EndTabItem()
	end

	ImGui.EndTabBar()
end)

function buttonClick(number)
	if(loadbool) then
		local tempAttr = util.attributes.getAttributes(playerDevelopmentData)
		util.tabulaRasa(playerDevelopmentData,tempAttr)
		saveSettings.tryToLoadSettings()
		local currAttr = {
			names = util.attributes.StringToEnumValues(saveSettings.settings[number].attributes.names),
			levels = saveSettings.settings[number].attributes.levels
		}
		util.attributes.buyAttributes(
			playerDevelopmentData,
			currAttr
		)
		util.perk.buyPerks(playerDevelopmentData, util.perk.StringToEnumValues(saveSettings.settings[number].perks))
		util.traits.buyTraits(playerDevelopmentData, util.traits.StringToEnumValues(saveSettings.settings[number].traits))
	else
		local p = util.perk.getPerks(playerDevelopmentData)
		local t = util.traits.getTraits(playerDevelopmentData)
		local a = util.attributes.getAttributes(playerDevelopmentData)
		local tempA = util.EnumValuesToString(a.names)
		a.names = tempA
		saveSettings.saveData(
			number,
			a,
			util.EnumValuesToString(p),
			util.EnumValuesToString(t),
			playerLevel
		)
		saveSettings.tryToSaveSettings()
	end
end
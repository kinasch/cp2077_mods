local util = require("modules/util")
local saveSettings = require("modules/saveSettings")
local openMenu = false
local playerDevelopmentData

registerForEvent("onOverlayOpen", function()
	playerDevelopmentData = Game.GetScriptableSystemsContainer():Get("PlayerDevelopmentSystem"):GetDevelopmentData(Game.GetPlayer())
	openMenu = true
end)
registerForEvent("onOverlayClose", function()
	playerDevelopmentData = nil
	openMenu = false
	-- saveSettings.tryToSaveSettings()
end)

-- Save the settings upon leaving the game
registerForEvent("onShutdown", function()
	-- saveSettings.tryToSaveSettings()
end)

registerForEvent("onDraw",function ()
	if openMenu ~= true then return end

	ImGui.SetNextWindowPos(100, 700, ImGuiCond.FirstUseEver)
	ImGui.SetNextWindowSize(200, 200,ImGuiCond.Appearing)
	ImGui.Begin("BuildManager")

	ImGui.PushItemWidth(0.4*ImGui.GetWindowWidth())

	-- #####################################################################################################
	-- Test
	local clicked = ImGui.Button("1",(0.5*ImGui.GetWindowWidth()),30)
	if clicked then
		local p = util.getPerks(playerDevelopmentData)
		saveSettings.settings.one.perks = util.EnumValuesToString(p)
		saveSettings.tryToSaveSettings()
	end

	clicked = ImGui.Button("2",(0.5*ImGui.GetWindowWidth()),30)
	if clicked then
		local p = util.getPerks(playerDevelopmentData)
		saveSettings.settings.two.perks = util.EnumValuesToString(p)
		saveSettings.tryToSaveSettings()
	end
end)
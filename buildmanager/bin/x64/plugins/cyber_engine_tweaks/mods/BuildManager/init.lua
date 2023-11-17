local GameSession = require('GameSession')
local Cron = require('Cron')
local util = require("modules/util")

local openMenu,gameLoaded = false,false
local playerDevelopmentData,playerLevel
local resetConfirmation = false

registerForEvent("onOverlayOpen", function()
	openMenu = true
	print(gameLoaded)
	if not gameLoaded then return end

	playerDevelopmentData = PlayerDevelopmentSystem.GetData(Game.GetPlayer())
	playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	if not gameLoaded then return end

	playerDevelopmentData = nil
end)

-- Load the settings upon starting the game
registerForEvent("onInit", function()
	-- gameLoaded should only be true, if the game is loaded and not paused

	gameLoaded = not Game.GetSystemRequestsHandler():IsPreGame()

	GameSession.OnStart(function()
        gameLoaded = true
    end)
	GameSession.OnResume(function()
        gameLoaded = true
    end)

	GameSession.OnPause(function()
        gameLoaded = false
    end)
    GameSession.OnEnd(function()
        gameLoaded = false
    end)
end)

registerForEvent('onUpdate', function(delta)
    -- This is required for Cron to function
    Cron.Update(delta)
end)

registerForEvent("onDraw",function ()
	if not openMenu or not gameLoaded then return end
	
	-- Create new window for the build manager (randomly chosen values by me)
	ImGui.SetNextWindowPos(100, 700, ImGuiCond.FirstUseEver)
	ImGui.SetNextWindowSize(300, 500,ImGuiCond.Appearing)
	ImGui.Begin("BuildManager")

	-- Create a tab bar to access the different tabs
	ImGui.BeginTabBar('Simple Build Manager')

	-- #####################################################################################################
	-- Reset
	if ImGui.BeginTabItem("Reset") then
		ImGui.Text("Reset attributes, perks and traits.")
		if not ImGui.IsPopupOpen("Reset?") then
			if ImGui.Button("Reset everything",(0.95*ImGui.GetWindowWidth()),30) then
				ImGui.OpenPopup("Reset?")
			end
		else
			ImGui.Text("Unavailable! Close reset popup first!")
		end

		-- ##########
		-- Reset Popup  
		if ImGui.BeginPopupModal("Reset?", true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text("This will reset all attributes and perks.\nProceed?")
			local popupx,popupy = ImGui.CalcTextSize("This will reset all attributes and perks")
			ImGui.Indent(popupx/2-25)
			if ImGui.Button("Yes",50,25) then
				util.tabulaRasa(playerDevelopmentData)
				ImGui.CloseCurrentPopup()
			end
			if ImGui.Button("No",50,25) then ImGui.CloseCurrentPopup() end
			ImGui.EndPopup()
		end

		ImGui.EndTabItem()
	end

	if ImGui.BeginTabItem("Test") then
		ImGui.Text("Placeholder")
		ImGui.EndTabItem()
	end

	ImGui.EndTabBar()
	ImGui.End()
end)
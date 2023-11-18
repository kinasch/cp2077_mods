local GameSession = require('GameSession')
local Cron = require('Cron')
local util = require("modules/util")
local saveSettings = require("modules/saveSettings")

local openMenu,gameLoaded = false,false
local playerDevelopmentData,playerLevel
local resetConfirmation = false

local saveNameText = ""

-- Debug Text in the Test tab
local debugText = ""

registerForEvent("onOverlayOpen", function()
	openMenu = true
	if not gameLoaded then return end

	-- Get playerDevelopmentData and playerLevel everytime the overlay is opened.
	playerDevelopmentData = PlayerDevelopmentSystem.GetData(Game.GetPlayer())
	playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	if not gameLoaded then return end

	-- Garbage collection.
	playerDevelopmentData = nil
	playerLevel = 0
end)

-- Load the settings upon starting the game
registerForEvent("onInit", function()
	-- gameLoaded should only be true, if the game is loaded and not paused.
	-- Maybe allow doing this while in the menus like inventory and such.

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
	-- Save Tab
	if ImGui.BeginTabItem("Save") then
		saveNameText = ImGui.InputText("Save Name (max 64)", saveNameText, 64)
		if ImGui.Button("New Save",(0.95*ImGui.GetWindowWidth()),50) then
			if saveNameText ~= nil and saveNameText ~= "" then
				saveSettings.saveData(saveNameText,util.createNewSave(saveNameText,playerDevelopmentData));
				saveNameText = ""
			end
		end
		ImGui.Separator()
		ImGui.EndTabItem()
	end

	-- #####################################################################################################
	-- Reset
	if ImGui.BeginTabItem("Reset") then
		ImGui.Text("Reset attributes, perks and traits.")
		-- Do not allow resetting while the confirmation popup is open.
		if not ImGui.IsPopupOpen("Reset?") then
			if ImGui.Button("Reset everything",(0.95*ImGui.GetWindowWidth()),30) then
				ImGui.OpenPopup("Reset?")
			end
		else
			ImGui.Text("Unavailable! Close reset popup first!")
		end

		-- Reset Popup
		-- Create a Popup Window in which the user can accept resetting attributes and perks.
		if ImGui.BeginPopupModal("Reset?", true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text("This will reset all attributes and perks.\nProceed?")
			-- Calculate the size of this text, as the window auto resizes
			-- to the greatest Object, which in this case is the text above.
			-- Needed to center the buttons.
			local popupx,popupy = ImGui.CalcTextSize("This will reset all attributes and perks")
			-- Center the buttons.
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

	-- #####################################################################################################
	-- Test Tab
	if ImGui.BeginTabItem("Test") then
		ImGui.TextWrapped(debugText)
		if ImGui.Button("Save settings to file",(0.95*ImGui.GetWindowWidth()),50) then
			debugText = tostring(saveSettings.tryToSaveSettings())
		end
		ImGui.EndTabItem()
	end

	ImGui.EndTabBar()
	ImGui.End()
end)
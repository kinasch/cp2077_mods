local GameSession = require('GameSession')
local util = require("modules/util")
local saveSettings = require("modules/saveSettings")
local reset_tab = require("ui/reset_tab")
local save_tab = require("ui/save_tab")
local load_tab = require("ui/load_tab")
local skill_tab = require("ui/skill_tab")
local import_export_tab = require("ui/import_export_tab")
local options_tab = require("ui/options_tab")

local translation = require("translation")

local openMenu,gameLoaded = false,false
---@type PlayerDevelopmentData, number
local playerDevelopmentData, playerLevel

-- Variables for the options
local options = {
	saveLimit=10,
	saveCharacterLimit=64,
	letProfs=true,
	loadEquipment=false
}

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

	saveSettings.saveOptions(options)
	save_tab.reset_locals()
	load_tab.reset_locals()
end)

-- Load the settings upon starting the game
registerForEvent("onInit", function()
	-- gameLoaded should only be true, if the game is loaded.
	-- Should work while paused (big should)
	gameLoaded = not Game.GetSystemRequestsHandler():IsPreGame()
	GameSession.OnStart(function()
        gameLoaded = true
    end)
    GameSession.OnEnd(function()
        gameLoaded = false
    end)

	if gameLoaded then
		playerDevelopmentData = PlayerDevelopmentSystem.GetData(Game.GetPlayer())
		playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])
	end

	-- Load saves and options
	-- spdlog.info("Loading,Init: "..tostring(saveSettings.tryToLoadSettings()))
	local tempOptions = saveSettings.loadOptions()
	if util.tableLength(tempOptions) == util.tableLength(options) then
		options = tempOptions
	end
end)

registerForEvent("onDraw",function ()
	if not openMenu or not gameLoaded then return end
	
	-- Create new window for the build manager (randomly chosen values by me)
	ImGui.SetNextWindowPos(100, 700, ImGuiCond.FirstUseEver)
	ImGui.SetNextWindowSize(420, 500,ImGuiCond.Appearing)
	ImGui.Begin("BuildManager")

	-- Create a tab bar to access the different tabs
	ImGui.BeginTabBar('Simple Build Manager', ImGuiTabBarFlags.FittingPolicyResizeDown)

	-- #####################################################################################################
	-- Save Tab
	save_tab.create(options, saveSettings, util, playerDevelopmentData, translation)

	-- #####################################################################################################
	-- Load Tab
	load_tab.create(options, saveSettings, util, playerDevelopmentData, playerLevel, translation)

	-- #####################################################################################################
	-- Proficiencies / Skills
	skill_tab.create(options, util, playerDevelopmentData, translation)

	-- #####################################################################################################
	-- Reset Tab
	reset_tab.create(playerDevelopmentData, util, translation)

	-- #####################################################################################################
	-- Import/Export Tab
	import_export_tab.create(util, playerDevelopmentData, translation)

	-- #####################################################################################################
	-- Options Tab
	options_tab.create(options, translation)

	ImGui.EndTabBar()
	ImGui.End()
end)
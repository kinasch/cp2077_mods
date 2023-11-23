local GameSession = require('GameSession')
local util = require("modules/util")
local saveSettings = require("modules/saveSettings")

local openMenu,gameLoaded = false,false
local playerDevelopmentData,playerLevel
local resetConfirmation = false
local profLevelList = {
	{name="StrengthSkill",lvl=1,exp=0},
	{name="ReflexesSkill",lvl=1,exp=0},
	{name="CoolSkill",lvl=1,exp=0},
	{name="IntelligenceSkill",lvl=1,exp=0},
	{name="TechnicalAbilitySkill",lvl=1,exp=0}
}
local saveNameText, deleteNameText, infoSave = "","",{}
local profOpened = true

-- Variables for the options
local options = {saveLimit=10,saveCharacterLimit=64,letProfs=true}

-- Debug Text in the Test tab
local debugText = ""

registerForEvent("onOverlayOpen", function()
	openMenu = true
	if not gameLoaded then return end

	-- Get playerDevelopmentData and playerLevel everytime the overlay is opened.
	playerDevelopmentData = PlayerDevelopmentSystem.GetData(Game.GetPlayer())
	playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])

	profLevelList = util.prof.getProficiencies(playerDevelopmentData,profLevelList)
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	if not gameLoaded then return end

	-- Garbage collection.
	playerDevelopmentData = nil
	playerLevel = 0

	saveSettings.saveOptions(options)
	local saveNameText, deleteNameText, infoSave = "","",{}
end)

-- Load the settings upon starting the game
registerForEvent("onInit", function()
	-- gameLoaded should only be true, if the game is loaded and not paused.
	-- TODO: 
	--[[ 	Maybe allow doing this while in the menus like inventory and such.
			OR bind this menu to a hotkey ?
			OR create a new button in the character screen and open the menu upon pressing it ]]
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
	ImGui.SetNextWindowSize(300, 500,ImGuiCond.Appearing)
	ImGui.Begin("BuildManager")

	-- Create a tab bar to access the different tabs
	ImGui.BeginTabBar('Simple Build Manager')

	-- #####################################################################################################
	-- Save Tab
	if ImGui.BeginTabItem("Save") then
		-- Limit the InputText Size such that the Label can be seen.
		ImGui.SetNextItemWidth(0.9*ImGui.GetWindowWidth()-ImGui.CalcTextSize("Save Name"))
		-- Create a new inputText to let the user name the save.
		saveNameText = ImGui.InputText("Save Name", saveNameText, options.saveCharacterLimit)
		-- Create a new save, when the name is neither null nor empty and the maximum amount of allowed saves is not reached.
		if ImGui.Button("New Save",(0.95*ImGui.GetWindowWidth()),50) then
			if saveNameText ~= nil and saveNameText ~= "" and util.tableLength(saveSettings.settings) < options.saveLimit then
				savePLL = util.prof.getProficiencies(playerDevelopmentData)
				saveSettings.saveData(saveNameText,util.createNewSave(saveNameText,playerDevelopmentData,savePLL))
				saveNameText = ""
			else
				ImGui.OpenPopup("Save Limit reached / No name entered")
			end
		end
		ImGui.Separator()

		-- List all saves
		ImGui.Text("Click on an existing save to overwrite it:")
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			if ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30) then
				savePLL = util.prof.getProficiencies(playerDevelopmentData)
				saveSettings.saveData(k,util.createNewSave(k,playerDevelopmentData,savePLL))
			end

			ImGui.SameLine()
			ImGui.PushID("info"..k)
			if ImGui.SmallButton(IconGlyphs.InformationOutline) then
				infoSave = attr
				ImGui.OpenPopup("Info (Save Tab)")
			end

			-------------------------------
			-- Info Popup (Save Tab)
			if ImGui.BeginPopupModal("Info (Save Tab)", ImGuiWindowFlags.AlwaysAutoResize) then

				ImGui.Text("Build Level: "..infoSave.buildLevel)
				ImGui.Spacing()

				if ImGui.BeginTable("attributes",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthFixed, 150)
					ImGui.TableSetupColumn("Column2", ImGuiTableColumnFlags.None)
					for ik,v in pairs(infoSave.attributes) do
						ImGui.TableNextRow()
						ImGui.TableNextColumn()
						ImGui.Text(v.name)
						ImGui.TableNextColumn()
						ImGui.Text(""..v.level)
					end
					ImGui.EndTable()
				end
				ImGui.Spacing()

				if ImGui.BeginTable("profs",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthFixed, 150)
					ImGui.TableSetupColumn("Column2", ImGuiTableColumnFlags.None)
					for ik,v in pairs(infoSave.profs) do
						ImGui.TableNextRow()
						ImGui.TableNextColumn()
						ImGui.Text(GetLocalizedText(TweakDB:GetRecord("Proficiencies."..v.name):Loc_name_key()))
						ImGui.TableNextColumn()
						ImGui.Text(v.lvl.. " ("..v.exp.."XP)")
					end
					ImGui.EndTable()
				end
				ImGui.Spacing()

				if ImGui.Button("Close",250,30) then
					infoSave = {}
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Info Popup (Save Tab)
			-------------------------------

			ImGui.PopID()

			ImGui.SameLine()
			ImGui.PushID("del"..k)
			if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
				deleteNameText = k
				ImGui.OpenPopup("Delete Save (Save Tab)")
			end

			-------------------------------
			-- Delete Save Popup (Save Tab)
			if ImGui.BeginPopupModal("Delete Save (Save Tab)", true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text("Are you sure you want to delete this save?\n"..deleteNameText)
				if ImGui.Button("Yes",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					saveSettings.deleteSave(deleteNameText)
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button("No",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Delete Save Popup (Save Tab)
			-------------------------------

			ImGui.PopID()
			
		end

		ImGui.EndGroup()

		-- ##########
		-- Save Limit reached / No name entered Popup
		if ImGui.BeginPopupModal("Save Limit reached / No name entered", true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text("No name entered or save limit ("..options.saveLimit..") reached.")
			if ImGui.Button("Understood",ImGui.CalcTextSize("No name entered or save limit ("..options.saveLimit..") reached."),25) then
				ImGui.CloseCurrentPopup() 
			end
			ImGui.EndPopup()
		end

		ImGui.EndTabItem()
	end


	-- #####################################################################################################
	-- Load Tab
	if ImGui.BeginTabItem("Load") then
		-- List all saves
		ImGui.Text("Click on a save to load it:")
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			if ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30) then
				util.setBuild(playerDevelopmentData, saveSettings.settings[k])
			end

			ImGui.SameLine()
			ImGui.PushID("info"..k)
			if ImGui.SmallButton(IconGlyphs.InformationOutline) then
				infoSave = attr
				ImGui.OpenPopup("Info (Load Tab)")
			end

			-------------------------------
			-- Info Popup (Load Tab)
			if ImGui.BeginPopupModal("Info (Load Tab)", ImGuiWindowFlags.AlwaysAutoResize) then

				ImGui.Text("Build Level: "..infoSave.buildLevel)
				ImGui.Spacing()

				if ImGui.BeginTable("attributes",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthFixed, 150)
					ImGui.TableSetupColumn("Column2", ImGuiTableColumnFlags.None)
					for ik,v in pairs(infoSave.attributes) do
						ImGui.TableNextRow()
						ImGui.TableNextColumn()
						ImGui.Text(v.name)
						ImGui.TableNextColumn()
						ImGui.Text(""..v.level)
					end
					ImGui.EndTable()
				end
				ImGui.Spacing()

				if ImGui.BeginTable("profs",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthFixed, 150)
					ImGui.TableSetupColumn("Column2", ImGuiTableColumnFlags.None)
					for ik,v in pairs(infoSave.profs) do
						ImGui.TableNextRow()
						ImGui.TableNextColumn()
						ImGui.Text(GetLocalizedText(TweakDB:GetRecord("Proficiencies."..v.name):Loc_name_key()))
						ImGui.TableNextColumn()
						ImGui.Text(v.lvl.. " ("..v.exp.."XP)")
					end
					ImGui.EndTable()
				end
				ImGui.Spacing()

				if ImGui.Button("Close",250,30) then
					infoSave = {}
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Info Popup (Load Tab)
			-------------------------------

			ImGui.PopID()

			ImGui.SameLine()
			ImGui.PushID("del"..k)
			if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
				deleteNameText = k
				ImGui.OpenPopup("Delete Save (Load Tab)")
			end

			-------------------------------
			-- Delete Save Popup (Load Tab)
			if ImGui.BeginPopupModal("Delete Save (Load Tab)", true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text("Are you sure you want to delete this save?\n"..deleteNameText)
				if ImGui.Button("Yes",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					saveSettings.deleteSave(deleteNameText)
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button("No",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Delete Save Popup (Load Tab)
			-------------------------------

			ImGui.PopID()
		end

		ImGui.EndGroup()

		ImGui.EndTabItem()
	end


	-- #####################################################################################################
	-- Proficiencies / Skills
	if ImGui.BeginTabItem("Skills") then
		if profOpened then
			profLevelList = util.prof.getProficiencies(playerDevelopmentData,profLevelList)
			profOpened = false
		end

		if not options.letProfs then
			ImGui.TextWrapped("Enable manually modifying the Skills in the options.")
		else
			ImGui.TextWrapped("Adjust Proficiencies and set them using the button below:")
			ImGui.SameLine()
			if ImGui.SmallButton(IconGlyphs.Reload) then
				profLevelList = util.prof.getProficiencies(playerDevelopmentData,profLevelList)
			end

			ImGui.BeginGroup()
			for k,v in pairs(profLevelList) do
				ImGui.PushItemWidth(0.55*ImGui.GetWindowWidth())
				v.lvl = ImGui.SliderInt(GetLocalizedText(TweakDB:GetRecord("Proficiencies."..v.name):Loc_name_key()),v.lvl,1,60,"%d")
			end
			ImGui.EndGroup()

			if ImGui.Button("Set Skills",(0.95*ImGui.GetWindowWidth()),30) then
				util.prof.setProficiencies(playerDevelopmentData,profLevelList)
			end
		end

		ImGui.EndTabItem()
	else
		if not profOpened then
			profOpened = true
		end
	end


	-- #####################################################################################################
	-- Reset
	if ImGui.BeginTabItem("Reset") then
		ImGui.Text("Reset attributes, perks and skills.")
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
	-- Options Tab
	if ImGui.BeginTabItem("Options") then
		ImGui.TextWrapped("Maximum amount of saves:")
		options.saveLimit = ImGui.SliderInt("sl", options.saveLimit, 5, 20, "%d")
		ImGui.Separator()
		ImGui.TextWrapped("Save Name Character Limit:")
		options.saveCharacterLimit = ImGui.SliderInt("scl", options.saveCharacterLimit, 16, 256, "%d")
		ImGui.Separator()
		ImGui.TextWrapped("Allow manual modification of the skills?")
		options.letProfs = ImGui.Checkbox("Allow?", options.letProfs)

		ImGui.EndTabItem()
	end


	-- #####################################################################################################
	-- Test Tab
	if ImGui.BeginTabItem("Test") then
		ImGui.TextWrapped(debugText)
		if ImGui.Button("Save settings to file",(0.95*ImGui.GetWindowWidth()),50) then
			spdlog.info("Saving,Test: "..tostring(saveSettings.tryToLoadSettings()))
		end
		ImGui.Separator()
		if ImGui.Button("Debug: Print profs",(0.95*ImGui.GetWindowWidth()),30) then
			for k,v in pairs(profLevelList) do
				print(v.name..":"..v.lvl)
			end
		end

		if ImGui.BeginTable("test",2) then
			for i=0,10,1 do
				ImGui.TableNextRow()
				ImGui.TableNextColumn()
				ImGui.Text("links"..i)
				ImGui.TableNextColumn()
				ImGui.Text("rechts"..i)
			end
			ImGui.EndTable()
		end

		ImGui.EndTabItem()
	end

	ImGui.EndTabBar()
	ImGui.End()
end)
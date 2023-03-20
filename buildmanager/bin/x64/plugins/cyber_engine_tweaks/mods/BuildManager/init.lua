local util = require("modules/util")
local saveSettings = require("modules/saveSettings")
local openMenu = false
local loadbool = false
local playerDevelopmentData
local playerLevel
local enableInfo = {}
local x,y
local inputText = ""
local currKeyForDelete
local deletePopup

registerForEvent("onOverlayOpen", function()
	playerDevelopmentData = Game.GetScriptableSystemsContainer():Get("PlayerDevelopmentSystem"):GetDevelopmentData(Game.GetPlayer())
	playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])
	openMenu = true
	currKeyForDelete = nil
	deletePopup = false
end)
registerForEvent("onOverlayClose", function()
	playerDevelopmentData = nil
	openMenu = false
	enableInfo = {}
	-- saveSettings.tryToSaveSettings()
	currKeyForDelete = nil
	deletePopup = false
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
	ImGui.SetNextWindowSize(300, 450,ImGuiCond.Appearing)
	ImGui.Begin("BuildManager")
	x,y = ImGui.GetWindowPos()

	--ImGui.PushItemWidth(0.4*ImGui.GetWindowWidth())

	ImGui.BeginTabBar('Simple Build Manager')

	-- #####################################################################################################
	-- Save
	if ImGui.BeginTabItem("Save") then
		loadbool = false
		local newSave, selected
		inputText, selected = ImGui.InputText("Save Name", inputText, 64)
		newSave = ImGui.Button("Save",(0.5*ImGui.GetWindowWidth()),30)
		if newSave then
			if inputText ~= nil and inputText ~= "" and tablelength(saveSettings.settings) <= 10 then
				buttonClick(inputText)
				inputText = ""
			end
		end

		local clicked
		ImGui.Text("Click on an existing save to overwrite it:")
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			clicked = ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30)
			if clicked then
				buttonClick(k)
			end

			ImGui.SameLine()
			ImGui.PushID("info"..k)
			if ImGui.SmallButton(IconGlyphs.InformationOutline) then
				addToInfo(k)
			end
			ImGui.PopID()

			ImGui.SameLine()
			ImGui.PushID("del"..k)
			if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
				deletePopup = true
				currKeyForDelete = k
			end
			ImGui.PopID()
		end
		ImGui.EndGroup()
		ImGui.EndTabItem()
	end

	-- #####################################################################################################
	-- Load
	if ImGui.BeginTabItem("Load") then
		loadbool = true
		local clicked
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			if saveSettings.settings[k] ~= nil then
				-- Check for save level
				if playerLevel >= saveSettings.settings[k].buildLevel then
					clicked = ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30)
					if clicked then
						buttonClick(k)
					end

					ImGui.SameLine()
					ImGui.PushID("info"..k)
					if ImGui.SmallButton(IconGlyphs.InformationOutline) then
						addToInfo(k)
					end
					ImGui.PopID()

					ImGui.SameLine()
					ImGui.PushID("del"..k)
					if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
						deletePopup = true
						currKeyForDelete = k
					end
					ImGui.PopID()
				end
			end
		end
		ImGui.EndGroup()
		ImGui.EndTabItem()
	end

	-- #####################################################################################################
	-- Misc
	if ImGui.BeginTabItem("Misc") then
		ImGui.Text("Reset attributes, perks and traits.")
		loadbool = false
		local clicked
		clicked = ImGui.Button("Reset everything (free)",(0.95*ImGui.GetWindowWidth()),30)
		if clicked then
			local a = util.attributes.getAttributes(playerDevelopmentData)
			local tempA = util.EnumValuesToString(a.names)
			a.names = tempA
			util.tabulaRasa(playerDevelopmentData,a)
		end
		ImGui.EndTabItem()
	end

	ImGui.EndTabBar()
	ImGui.End()

	-- ###############################
	-- Child Windows
	for k,attr in pairs(enableInfo) do
		if attr then
			ImGui.SetNextWindowPos(x+300, y,ImGuiCond.Appearing)
			ImGui.SetNextWindowSize(200,200,ImGuiCond.Appearing)
			shouldDraw = ImGui.Begin(k)
			if ImGui.Button("Close") then
				enableInfo[k] = false
			end
			ImGui.Text("Info for save"..k)
			ImGui.TextWrapped(tostring(saveSettings.settings[k]))
			ImGui.End()
		end
	end

	-- ++++++++++++++++++++++++++++++++++++++++++++++
	-- Delete Popup
	if deletePopup then
		ImGui.SetNextWindowPos(x+100, y+100,ImGuiCond.Appearing)
		ImGui.Begin("Delete "..tostring(currKeyForDelete), ImGuiWindowFlags.NoCollapse)
		ImGui.Text("Are you sure?")
		local yes = ImGui.Button("Yes",(0.5*ImGui.GetWindowWidth()),30)
		if yes then
			-- delete(k) currKeyForDelete
		end
		local no = ImGui.Button("No",(0.5*ImGui.GetWindowWidth()),30)
		if no then
			deletePopup = false
		end
		ImGui.End()
	end
end)

function buttonClick(name)
	if(loadbool) then
		local tempAttr = util.attributes.getAttributes(playerDevelopmentData)
		util.tabulaRasa(playerDevelopmentData,tempAttr)
		saveSettings.tryToLoadSettings()
		local currAttr = {
			names = util.attributes.StringToEnumValues(saveSettings.settings[name].attributes.names),
			levels = saveSettings.settings[name].attributes.levels
		}
		util.attributes.buyAttributes(
			playerDevelopmentData,
			currAttr
		)
		util.perk.buyPerks(playerDevelopmentData, util.perk.StringToEnumValues(saveSettings.settings[name].perks))
		util.traits.buyTraits(playerDevelopmentData, util.traits.StringToEnumValues(saveSettings.settings[name].traits))
	else
		local p = util.perk.getPerks(playerDevelopmentData)
		local t = util.traits.getTraits(playerDevelopmentData)
		local a = util.attributes.getAttributes(playerDevelopmentData)
		local tempA = util.EnumValuesToString(a.names)
		a.names = tempA
		saveSettings.saveData(
			name,
			a,
			util.EnumValuesToString(p),
			util.EnumValuesToString(t),
			playerLevel
		)
		saveSettings.tryToSaveSettings()
	end
end

function checkPlayerBalance() end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function addToInfo(name)
	enableInfo[name] = true
end
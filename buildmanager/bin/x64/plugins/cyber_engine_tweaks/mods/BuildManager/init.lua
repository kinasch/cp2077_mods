local util = require("modules/util")
local saveSettings = require("modules/saveSettings")
local GameSession = require('GameSession')

local openMenu,loadbool,gameLoaded = false,false,false
local playerDevelopmentData,playerLevel,x,y,deletePopup,currKeyForDelete
local inputText = ""
local stringInfoBool,infoText,enableInfo = {},{},{}

registerForEvent("onOverlayOpen", function()
	openMenu = true
	if not gameLoaded then return end

	playerDevelopmentData = Game.GetScriptableSystemsContainer():Get("PlayerDevelopmentSystem"):GetDevelopmentData(Game.GetPlayer())
	playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])
	currKeyForDelete = nil
	deletePopup = false
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	if not gameLoaded then return end

	playerDevelopmentData = nil
	enableInfo = {}
	saveSettings.tryToSaveSettings()
	currKeyForDelete = nil
	deletePopup = false
end)

-- Load the settings upon starting the game
registerForEvent("onInit", function()
	gameLoaded = not Game.GetSystemRequestsHandler():IsPreGame()

	GameSession.OnStart(function()
		print("Start")
        gameLoaded = true
    end)

    GameSession.OnEnd(function()
		print("Start")
        gameLoaded = false
    end)
	saveSettings.tryToLoadSettings()
end)
-- Save the settings upon leaving the game
registerForEvent("onShutdown", function()
	saveSettings.tryToSaveSettings()
end)

registerForEvent("onDraw",function ()
	if not openMenu or not gameLoaded then return end
	
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
			if inputText ~= nil and inputText ~= "" and tableLength(saveSettings.settings) <= 10 then
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
				if enableInfo[k] then
					enableInfo[k] = false
					stringInfoBool[k] = false
				else
					enableInfo[k] = true
					stringInfoBool[k] = true
				end
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
						if enableInfo[k] then
							enableInfo[k] = false
							stringInfoBool[k] = false
						else
							enableInfo[k] = true
							stringInfoBool[k] = true
						end
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

	-- #####################################################################################################
	-- Child Windows
	for k,attr in pairs(enableInfo) do
		if attr then
			ImGui.SetNextWindowPos(x+300, y,ImGuiCond.Appearing)
			ImGui.SetNextWindowSize(200,200,ImGuiCond.Appearing)
			shouldDraw = ImGui.Begin(k)
			ImGui.PushID("infoclose"..k)
			if ImGui.Button("Close") then
				enableInfo[k] = false
			end
			ImGui.Text("Info for save: "..k)
			-- This may have the consequence of displaying only the text of the first open window
			if stringInfoBool[k] then
				infoText[k] = stringifySettings(saveSettings.settings[k])
				stringInfoBool[k] = false
			end

			ImGui.PushID("level"..k)
			ImGui.TextWrapped(infoText[k].level)
			ImGui.PopID()

			ImGui.BeginGroup()
			ImGui.PushID("attrrr"..k)
			if ImGui.TreeNode("Attributes") then
				ImGui.PopID()
				ImGui.TextWrapped(infoText[k].attr)
			end
			ImGui.EndGroup()

			ImGui.BeginGroup()
			ImGui.PushID("perksss"..k)
			if ImGui.TreeNode("Perks") then
				ImGui.PopID()
				ImGui.TextWrapped(infoText[k].perks)
			end
			ImGui.EndGroup()

			ImGui.BeginGroup()
			ImGui.PushID("traitsss"..k)
			if ImGui.TreeNode("Traits") then
				ImGui.PopID()
				ImGui.TextWrapped(infoText[k].traits)
			end
			ImGui.EndGroup()

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
			deleteSave(currKeyForDelete)
			deletePopup = false
		end
		local no = ImGui.Button("No",(0.5*ImGui.GetWindowWidth()),30)
		if no then
			deletePopup = false
			currKeyForDelete = nil
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

function tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function deleteSave(name)
	saveSettings.settings[name] = nil
	saveSettings.tryToSaveSettings()
	currKeyForDelete = nil
end

-- This is not the optimal solution, but enough for now.
function stringifySettings(table)
	local str = {level="",attr="",perks="",traits=""}
	local coll = {}
	str.level = "Level: "..tostring(math.ceil(table.buildLevel))
	local currString = ""
	for k,v in pairs(table.attributes.names) do
		currString = currString .. tostring(v) .. ": " .. tostring(table.attributes.levels[k]) .. "\n"
	end
	str.attr = currString
	currString = ""
	for k,v in pairs(table.perks) do
		local n = tostring(GetLocalizedText(TweakDB:GetRecord("Perks."..v):Loc_name_key()))
		if coll[n]==nil then
			coll[n] = 0
		end
		coll[n] = coll[n] + 1
	end
	for k,v in pairs(coll) do
		currString = currString .. tostring(k) .. ": " .. tostring(v) .. "\n"
	end
	str.perks = currString
	currString = ""
	coll = {}
	for k,v in pairs(table.traits) do
		local n = tostring(GetLocalizedText(TweakDB:GetRecord("Traits."..v):Loc_name_key()))
		if coll[n]==nil then
			coll[n] = 0
		end
		coll[n] = coll[n] + 1
	end
	for k,v in pairs(coll) do
		currString = currString .. tostring(k) .. ": " .. tostring(v) .. "\n"
	end
	str.traits = currString
	return str
end
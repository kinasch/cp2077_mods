local util = require("modules/util")
local saveSettings = require("modules/saveSettings")
local GameSession = require('GameSession')
local Cron = require('Cron')

local openMenu,gameLoaded,letProfs,loadingSave = false,false,false,false
local playerDevelopmentData,playerLevel,x,y,deletePopup,currKeyForDelete
local inputText = ""
local stringInfoBool,infoText,enableInfo = {},{},{}

local profs = {
	{name="Assault",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="Athletics",level=1,pp={3,7,8,10,11,16,19},xp=0.0},
	{name="Brawling",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="ColdBlood",level=1,pp={4,5,9,10,11,13,17},xp=0.0},
	{name="CombatHacking",level=1,pp={2,4,9,11,14,19},xp=0.0},
	{name="Crafting",level=1,pp={4,6,8,10,14,17},xp=0.0},
	{name="Demolition",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="Engineering",level=1,pp={2,6,8,10,14,17,18},xp=0.0},
	{name="Gunslinger",level=1,pp={3,6,9,10,12,15,18},xp=0.0},
	{name="Hacking",level=1,pp={2,6,10,14,16,18},xp=0.0},
	{name="Kenjutsu",level=1,pp={3,8,9,10,14,16,17},xp=0.0},
	{name="Stealth",level=1,pp={3,5,7,10,13,17,18},xp=0.0}
}

registerForEvent("onOverlayOpen", function()
	openMenu = true
	if not gameLoaded then return end

	playerDevelopmentData = Game.GetScriptableSystemsContainer():Get("PlayerDevelopmentSystem"):GetDevelopmentData(Game.GetPlayer())
	playerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType["PowerLevel"])
	currKeyForDelete = nil
	deletePopup = false

	setProfsFromGame()
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	if not gameLoaded then return end

	while loadingSave do end

	playerDevelopmentData = nil
	enableInfo = {}
	currKeyForDelete = nil
	deletePopup = false
end)

-- Load the settings upon starting the game
registerForEvent("onInit", function()
	letProfs = true
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
	saveSettings.tryToLoadSettings()
end)

registerForEvent('onUpdate', function(delta)
    -- This is required for Cron to function
    Cron.Update(delta)
end)

registerForEvent("onDraw",function ()
	if not openMenu or not gameLoaded then return end
	
	ImGui.SetNextWindowPos(100, 700, ImGuiCond.FirstUseEver)
	ImGui.SetNextWindowSize(300, 500,ImGuiCond.Appearing)
	ImGui.Begin("BuildManager")
	x,y = ImGui.GetWindowPos()

	--ImGui.PushItemWidth(0.4*ImGui.GetWindowWidth())

	ImGui.BeginTabBar('Simple Build Manager')

	-- #####################################################################################################
	-- Save
	if ImGui.BeginTabItem("Save") then
		local newSave, selected
		inputText, selected = ImGui.InputText("Save Name", inputText, 64)
		newSave = ImGui.Button("Save",(0.5*ImGui.GetWindowWidth()),30)
		if newSave then
			if inputText ~= nil and inputText ~= "" and tableLength(saveSettings.settings) <= 10 then
				buttonClick(inputText,false)
				inputText = ""
			end
		end

		local clicked
		ImGui.Text("Click on an existing save to overwrite it:")
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			clicked = ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30)
			if clicked then
				buttonClick(k,false)
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
		local clicked
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			if loadingSave then
				ImGui.TextWrapped("Loading, do not close!")
				break
			end

			if saveSettings.settings[k] ~= nil then
				-- Check for save level
				if playerLevel >= saveSettings.settings[k].buildLevel then
					clicked = ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30)
					if clicked then
						buttonClick(k,true)
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
	-- Proficiencies
	if ImGui.BeginTabItem("Proficiency") then
		ImGui.TextWrapped("Adjust Proficiencies and set them using the button below:")

		ImGui.BeginGroup()
		for k,attr in pairs(profs) do
			ImGui.PushItemWidth(0.55*ImGui.GetWindowWidth())
			attr.level = ImGui.SliderInt(
				GetLocalizedText(TweakDB:GetRecord("Proficiencies."..attr.name):Loc_name_key()),
				attr.level,
				1,
				playerDevelopmentData:GetProficiencyMaxLevel(gamedataProficiencyType[attr.name]),
				"%d"
			)
		end
		ImGui.EndGroup()
		if ImGui.Button("Set Proficiencies",(0.95*ImGui.GetWindowWidth()),30) and letProfs then
			letProfs = false
			util.prof.setProficiencies(playerDevelopmentData,profs)

			Cron.After(0.5,function ()
				setProfsFromGame()
				letProfs = true
				print("BuildManager: Proficiencies set.")
			end,{})
		end

		ImGui.EndTabItem()
	end

	-- #####################################################################################################
	-- Misc
	if ImGui.BeginTabItem("Misc") then
		ImGui.Text("Reset attributes, perks and traits.\nWARNING: No confirmation, instant reset!")
		if ImGui.Button("Reset everything (free)",(0.95*ImGui.GetWindowWidth()),30) then
			local a = util.attributes.getAttributes(playerDevelopmentData)
			local tempA = util.EnumValuesToString(a.names)
			a.names = tempA
			util.tabulaRasa(playerDevelopmentData,a)
			setProfsFromGame()
			saveSettings.tryToLoadSettings()
			print("BuildManager: Reset everything.")
		end
		ImGui.EndTabItem()
	end

	ImGui.EndTabBar()
	ImGui.End()

	-- #####################################################################################################
	-- Info Window
	for k,attr in pairs(enableInfo) do
		if attr then
			ImGui.SetNextWindowPos(x+300, y,ImGuiCond.Appearing)
			ImGui.SetNextWindowSize(400,500,ImGuiCond.Appearing)
			shouldDraw = ImGui.Begin(k)
			ImGui.PushID("infoclose"..k)
			if ImGui.Button("Close") then
				enableInfo[k] = false
			end
			ImGui.Text("Info for save: "..k)
			-- This may have the consequence of displaying only the text of the first open window
			if stringInfoBool[k] then
				infoText[k] = getSettings(saveSettings.settings[k])
				stringInfoBool[k] = false
			end

			ImGui.PushID("level"..k)
			ImGui.TextWrapped(infoText[k].level)
			ImGui.PopID()

			local treeN

			ImGui.BeginGroup()
			ImGui.PushID("attrrr"..k)
			if ImGui.TreeNode("Attributes") then
				ImGui.PopID()
				ImGui.TextWrapped(infoText[k].attr)
			end
			ImGui.EndGroup()

			ImGui.BeginGroup()
			ImGui.PushID("profsss"..k)
			if ImGui.TreeNode("Proficiencies") then
				ImGui.PopID()
				for ky, value in pairs(infoText[k].profs) do
					ImGui.TextWrapped(value.str)
					ImGui.SameLine()
					ImGui.ProgressBar(value.xp,0.4*ImGui.GetWindowWidth(),20)
				end
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

function buttonClick(name,loadbool)
	if loadbool then
		loadingSave = true
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

		util.prof.setProficiencies(playerDevelopmentData,saveSettings.settings[name].profs)

		Cron.After(2,function (uname)
			util.perk.buyPerks(playerDevelopmentData, util.perk.StringToEnumValues(saveSettings.settings[uname.arg].perks))
			util.traits.buyTraits(playerDevelopmentData, util.traits.StringToEnumValues(saveSettings.settings[uname.arg].traits))

			print("BuildManager: Loaded.")
			loadingSave = false
		end,name)
	else
		local p = util.perk.getPerks(playerDevelopmentData)
		local t = util.traits.getTraits(playerDevelopmentData)
		setProfsFromGame()
		local a = util.attributes.getAttributes(playerDevelopmentData)
		local tempA = util.EnumValuesToString(a.names)
		a.names = tempA
		saveSettings.saveData(
			name,
			a,
			util.EnumValuesToString(p),
			util.EnumValuesToString(t),
			playerLevel,
			profs
		)
		saveSettings.tryToSaveSettings()
		print("BuildManager: Saved.")
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
function getSettings(table)
	local str = {level="",attr="",perks="",traits="",profs={}}
	local coll = {}
	str.level = "Level: "..tostring(math.ceil(table.buildLevel))
	local currString = ""
	for k,v in pairs(table.attributes.names) do
		currString = currString .. tostring(GetLocalizedText(TweakDB:GetRecord("BaseStats."..v):LocalizedName())) .. ": " .. tostring(table.attributes.levels[k]) .. "\n"
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

	currString = ""
	coll = {}
	for k,v in pairs(table.profs) do
		currString = ""
		currString = currString .. tostring(GetLocalizedText(TweakDB:GetRecord("Proficiencies."..v.name):Loc_name_key()))
		currString = currString .. ": " .. tostring(v.level)
		--[[ if not playerDevelopmentData:IsProficiencyMaxLvl(gamedataProficiencyType[v.name]) then
			currString = currString .. " (" .. tostring(v.xp) .. "/"
			currString = currString .. tostring(v.xp+playerDevelopmentData:GetRemainingExpForLevelUp(gamedataProficiencyType[v.name])) .. ")\n"
		else currString = currString .. " (-)\n" end ]]

		str.profs[v.name] = {}
		str.profs[v.name].str = currString
		if not playerDevelopmentData:IsProficiencyMaxLvl(gamedataProficiencyType[v.name]) then
		str.profs[v.name].xp = v.xp / (v.xp+playerDevelopmentData:GetRemainingExpForLevelUp(gamedataProficiencyType[v.name]))
		else
		str.profs[v.name].xp = 1
		end
		
	end
	return str
end

function setProfsFromGame()
	for k,attr in pairs(profs) do
		attr.level = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType[attr.name])
		attr.xp = playerDevelopmentData:GetProficiencyExperience(gamedataProficiencyType[attr.name])
	end
end
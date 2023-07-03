local savedSettings = require("modules/savedSettings")
local openMenu,rangeActivated = false,false

registerForEvent("onInit", function()
	savedSettings.tryToLoadSettings()

	ObserveBefore('SpreadInitEffector','ActionOn;GameObject',function(self, o)
		for key, value in pairs(savedSettings.settings) do
			if NameToString(self.objectActionRecord:ActionName()) == value.name then
				if value.count.saved ~= value.count.default then self.sCount = value.count.saved end
				if value.range.saved ~= value.range.default then self.ran = value.range.saved end
				if value.bonusJumps.saved ~= value.bonusJumps.default then self.bJumps = value.bonusJumps.saved end
				return
			end
		end
	end)
end)

registerForEvent("onOverlayOpen", function()
	openMenu = true
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	savedSettings.tryToSaveSettings()
end)

-- Save the settings upon leaving the game (this comment is self-explanatory?)
registerForEvent("onShutdown", function()
	savedSettings.tryToSaveSettings()
end)

registerForEvent("onDraw",function ()
	if openMenu ~= true then return end

	ImGui.SetNextWindowPos(100, 100, ImGuiCond.FirstUseEver)
	ImGui.SetNextWindowSize(400, 400,ImGuiCond.Appearing)
	ImGui.Begin("Ultimate Spreader")

	local clicked = ImGui.Button("Reset to default",(0.5*ImGui.GetWindowWidth()),30)
	if clicked then
		resetSavedValuesToDefault()
	end

	ImGui.Spacing()
	rangeActivated = ImGui.Checkbox("Modify Range?",rangeActivated)

	ImGui.Separator()
	ImGui.Spacing()

	ImGui.PushItemWidth(0.4*ImGui.GetWindowWidth())

	for key, value in pairs(savedSettings.settings) do
		ImGui.Spacing()
		-- Why go through the struggle of translating every hack? 
		-- Idk, I started looking into this over 2 hours and forgot that everything else is in english...
		local curLocalName = GetLocalizedText(LocKeyToString(TweakDB:GetRecord("Interactions.".. value.name .."Hack"):Caption()))
		ImGui.Text(curLocalName.." Spread")

		-- Dunno if the id thing is used right here and it looks hella ugly, but it works.
		ImGui.PushID(curLocalName.."Count")
		value.count.saved = ImGui.SliderInt("Count", value.count.saved, -1, 25, "%d")
		ImGui.PopID()
		ImGui.PushID(curLocalName.."BonusJumps")
		value.bonusJumps.saved = ImGui.SliderInt("Bonus Jumps", value.bonusJumps.saved, -1, 25, "%d")
		ImGui.PopID()
		if rangeActivated then
			ImGui.PushID(curLocalName.."Range")
			value.range.saved = ImGui.SliderInt("Range", value.range.saved, -1, 25, "%d")
			ImGui.PopID()
		end
	end
	
end)

function resetSavedValuesToDefault()
	for k,v in pairs(savedSettings.settings) do
		v.count.saved = v.count.default
		v.range.saved = v.range.default
		v.bonusJumps.saved = v.bonusJumps.default
	end
	savedSettings.tryToSaveSettings()
end
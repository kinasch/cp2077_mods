local hackingUtils = require("modules/hackingUtils")
local savedSettings = require("modules/savedSettings")
local openMenu = false

registerForEvent("onInit", function()
	local loaded = savedSettings.tryToLoadSettings()
	if loaded then
		setAllValuesInGame(false)
	end

	ObserveBefore('SpreadInitEffector','ActionOn;GameObject',function(self, o)
		for key, value in pairs(savedSettings.settings) do
			if NameToString(self.objectActionRecord:ActionName()) == value.name then
				self.sCount = value.count.saved
				return
			end
		end
	end)

	ObserveAfter('SpreadInitEffector','ActionOn;GameObject',function(self, o) print(self.sCount) end)
end)

registerForEvent("onOverlayOpen", function()
	openMenu = true
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	savedSettings.tryToSaveSettings()
end)

-- Save the settings upon leaving the game
registerForEvent("onShutdown", function()
	savedSettings.tryToSaveSettings()
end)

registerForEvent("onDraw",function ()
	if openMenu ~= true then return end
	local toggled

	ImGui.SetNextWindowPos(100, 100, ImGuiCond.FirstUseEver)
	ImGui.SetNextWindowSize(400, 400,ImGuiCond.Appearing)
	ImGui.Begin("Ultimate Spreader")

	if ImGui.SmallButton(IconGlyphs.InformationOutline) then
		print(savedSettings.settings.suicide.count.saved)
		print(savedSettings.settings.systemCollapse.count.saved)
	end

	ImGui.PushItemWidth(0.4*ImGui.GetWindowWidth())

	-- #####################################################################################################
	-- Suicide
	ImGui.Text("Suicide Spread")
	savedSettings.settings.suicide.count.saved, toggled = ImGui.SliderInt("Suicide Count", savedSettings.settings.suicide.count.saved, -1, 25, "%d")
	if toggled then
		--hackingUtils.setSpreadCountSuicide(savedSettings.settings.suicide.count.saved)
	end
	savedSettings.settings.suicide.bonusJumps.saved, toggled = ImGui.SliderInt("Suicide Bonus Jumps", savedSettings.settings.suicide.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsSuicide(savedSettings.settings.suicide.bonusJumps.saved)
	end
	savedSettings.settings.suicide.range.saved, toggled = ImGui.SliderInt("Suicide Range", savedSettings.settings.suicide.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeSuicide(savedSettings.settings.suicide.range.saved)
	end

	-- #####################################################################################################
	-- System Reset / System Collapse
	ImGui.Text("System Reset")
	savedSettings.settings.systemCollapse.count.saved, toggled = ImGui.SliderInt("System Reset Count", savedSettings.settings.systemCollapse.count.saved, -1, 25, "%d")
	if toggled then
		--hackingUtils.setSpreadCountSystemCollapse(savedSettings.settings.systemCollapse.count.saved)
	end
	savedSettings.settings.systemCollapse.bonusJumps.saved, toggled = ImGui.SliderInt("System Reset Bonus Jumps", savedSettings.settings.systemCollapse.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsSystemCollapse(savedSettings.settings.systemCollapse.bonusJumps.saved)
	end
	savedSettings.settings.systemCollapse.range.saved, toggled = ImGui.SliderInt("System Reset Range", savedSettings.settings.systemCollapse.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeSystemCollapse(savedSettings.settings.systemCollapse.range.saved)
	end

	-- #####################################################################################################
	-- Contagion
	ImGui.Text("Contagion Spread")
	savedSettings.settings.contagion.count.saved, toggled = ImGui.SliderInt("Contagion Count", savedSettings.settings.contagion.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountContagion(savedSettings.settings.contagion.count.saved)
	end
	savedSettings.settings.contagion.bonusJumps.saved, toggled = ImGui.SliderInt("Contagion Bonus Jumps", savedSettings.settings.contagion.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsContagion(savedSettings.settings.contagion.bonusJumps.saved)
	end
	savedSettings.settings.contagion.range.saved, toggled = ImGui.SliderInt("Contagion Range", savedSettings.settings.contagion.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeContagion(savedSettings.settings.contagion.range.saved)
	end

	-- #####################################################################################################
	-- Overheat
	ImGui.Text("Overheat Spread")
	savedSettings.settings.overheat.count.saved, toggled = ImGui.SliderInt("Overheat Count", savedSettings.settings.overheat.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountOverheat(savedSettings.settings.overheat.count.saved)
	end
	savedSettings.settings.overheat.bonusJumps.saved, toggled = ImGui.SliderInt("Overheat Bonus Jumps", savedSettings.settings.overheat.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsOverheat(savedSettings.settings.overheat.bonusJumps.saved)
	end
	savedSettings.settings.overheat.range.saved, toggled = ImGui.SliderInt("Overheat Range", savedSettings.settings.overheat.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeOverheat(savedSettings.settings.overheat.range.saved)
	end

	-- #####################################################################################################
	-- Blind
	ImGui.Text("Reboot Optics Spread")
	savedSettings.settings.blind.count.saved, toggled = ImGui.SliderInt("Reboot Optics Count", savedSettings.settings.blind.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountBlind(savedSettings.settings.blind.count.saved)
	end
	savedSettings.settings.blind.bonusJumps.saved, toggled = ImGui.SliderInt("Reboot Optics Bonus Jumps", savedSettings.settings.blind.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsBlind(savedSettings.settings.blind.bonusJumps.saved)
	end
	savedSettings.settings.blind.range.saved, toggled = ImGui.SliderInt("Reboot Optics Range", savedSettings.settings.blind.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeBlind(savedSettings.settings.blind.range.saved)
	end

	-- #####################################################################################################
	-- Cyberware Malfunction
	ImGui.Text("Cyberware Malfunction Spread")
	savedSettings.settings.cyberwareMalfunction.count.saved, toggled = ImGui.SliderInt("Cyberware Malfunction Count", savedSettings.settings.cyberwareMalfunction.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountCyberwareMalfunction(savedSettings.settings.cyberwareMalfunction.count.saved)
	end
	savedSettings.settings.cyberwareMalfunction.bonusJumps.saved, toggled = ImGui.SliderInt("Cyberware Malfunction Bonus Jumps", savedSettings.settings.cyberwareMalfunction.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsCyberwareMalfunction(savedSettings.settings.cyberwareMalfunction.bonusJumps.saved)
	end
	savedSettings.settings.cyberwareMalfunction.range.saved, toggled = ImGui.SliderInt("Cyberware Malfunction Range", savedSettings.settings.cyberwareMalfunction.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeCyberwareMalfunction(savedSettings.settings.cyberwareMalfunction.range.saved)
	end

	-- #####################################################################################################
	-- Locomotion Malfunction
	ImGui.Text("Locomotion Malfunction Spread")
	savedSettings.settings.locomotionMalfunction.count.saved, toggled = ImGui.SliderInt("Locomotion Malfunction Count", savedSettings.settings.locomotionMalfunction.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountLocomotionMalfunction(savedSettings.settings.locomotionMalfunction.count.saved)
	end
	savedSettings.settings.locomotionMalfunction.bonusJumps.saved, toggled = ImGui.SliderInt("Locomotion Malfunction Bonus Jumps", savedSettings.settings.locomotionMalfunction.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsLocomotionMalfunction(savedSettings.settings.locomotionMalfunction.bonusJumps.saved)
	end
	savedSettings.settings.locomotionMalfunction.range.saved, toggled = ImGui.SliderInt("Locomotion Malfunction Range", savedSettings.settings.locomotionMalfunction.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeLocomotionMalfunction(savedSettings.settings.locomotionMalfunction.range.saved)
	end

	-- #####################################################################################################
	-- Weapon Malfunction
	ImGui.Text("Weapon Malfunction Spread")
	savedSettings.settings.weaponMalfunction.count.saved, toggled = ImGui.SliderInt("Weapon Malfunction Count", savedSettings.settings.weaponMalfunction.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountWeaponMalfunction(savedSettings.settings.weaponMalfunction.count.saved)
	end
	savedSettings.settings.weaponMalfunction.bonusJumps.saved, toggled = ImGui.SliderInt("Weapon Malfunction Bonus Jumps", savedSettings.settings.weaponMalfunction.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsWeaponMalfunction(savedSettings.settings.weaponMalfunction.bonusJumps.saved)
	end
	savedSettings.settings.weaponMalfunction.range.saved, toggled = ImGui.SliderInt("Weapon Malfunction Range", savedSettings.settings.weaponMalfunction.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeWeaponMalfunction(savedSettings.settings.weaponMalfunction.range.saved)
	end

	-- #####################################################################################################
	-- Grenade
	ImGui.Text("Detonate Grenade Spread")
	savedSettings.settings.grenade.count.saved, toggled = ImGui.SliderInt("Detonate Grenade Count", savedSettings.settings.grenade.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountDetonateGrenade(savedSettings.settings.grenade.count.saved)
	end
	savedSettings.settings.grenade.bonusJumps.saved, toggled = ImGui.SliderInt("Detonate Grenade Bonus Jumps", savedSettings.settings.grenade.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsDetonateGrenade(savedSettings.settings.grenade.bonusJumps.saved)
	end
	savedSettings.settings.grenade.range.saved, toggled = ImGui.SliderInt("Detonate Grenade Range", savedSettings.settings.grenade.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeDetonateGrenade(savedSettings.settings.grenade.range.saved)
	end

	-- #####################################################################################################
	-- Overload/Short Circuit
	ImGui.Text("Short Circuit Spread")
	savedSettings.settings.overload.count.saved, toggled = ImGui.SliderInt("Short Circuit Count", savedSettings.settings.overload.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountOverload(savedSettings.settings.overload.count.saved)
	end
	savedSettings.settings.overload.bonusJumps.saved, toggled = ImGui.SliderInt("Short Circuit Bonus Jumps", savedSettings.settings.overload.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsOverload(savedSettings.settings.overload.bonusJumps.saved)
	end
	savedSettings.settings.overload.range.saved, toggled = ImGui.SliderInt("Short Circuit Range", savedSettings.settings.overload.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeOverload(savedSettings.settings.overload.range.saved)
	end

	-- #####################################################################################################
	-- Brain Melt/Synapse Burnout QuickHack
	ImGui.Text("Synapse Burnout Spread")
	savedSettings.settings.brainMelt.count.saved, toggled = ImGui.SliderInt("Synapse Burnout Count", savedSettings.settings.brainMelt.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountBrainMelt(savedSettings.settings.brainMelt.count.saved)
	end
	savedSettings.settings.brainMelt.bonusJumps.saved, toggled = ImGui.SliderInt("Synapse Burnout Bonus Jumps", savedSettings.settings.brainMelt.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsBrainMelt(savedSettings.settings.brainMelt.bonusJumps.saved)
	end
	savedSettings.settings.brainMelt.range.saved, toggled = ImGui.SliderInt("Synapse Burnout Range", savedSettings.settings.brainMelt.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeBrainMelt(savedSettings.settings.brainMelt.range.saved)
	end

	-- #####################################################################################################
	-- Madness/Cyberpsychosis
	ImGui.Text("Cyberpsychosis Spread")
	savedSettings.settings.madness.count.saved, toggled = ImGui.SliderInt("Cyberpsychosis Count", savedSettings.settings.madness.count.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setSpreadCountCyberpsychosis(savedSettings.settings.madness.count.saved)
	end
	savedSettings.settings.madness.bonusJumps.saved, toggled = ImGui.SliderInt("Cyberpsychosis Bonus Jumps", savedSettings.settings.madness.bonusJumps.saved, -1, 25, "%d")
	if toggled then
		hackingUtils.setBonusJumpsCyberpsychosis(savedSettings.settings.madness.bonusJumps.saved)
	end
	savedSettings.settings.madness.range.saved, toggled = ImGui.SliderInt("Cyberpsychosis Range", savedSettings.settings.madness.range.saved, -1, 200, "%d")
	if toggled then
		hackingUtils.setSpreadRangeCyberpsychosis(savedSettings.settings.madness.range.saved)
	end

	-- #####################################################################################################
	ImGui.Separator()
	ImGui.Spacing()
	-- "Reset to Default" Button
	ImGui.SameLine(0.25*ImGui.GetWindowWidth())
	local clicked = ImGui.Button("Reset to default",(0.5*ImGui.GetWindowWidth()),30)
	if clicked then
		resetSavedValuesToDefault()
	end
end)

function setAllValuesInGame(default)
	local defaultOrSaved = default and "default" or "saved"
	--Suicide
	hackingUtils.setSpreadCountSuicide(savedSettings.settings.suicide.count[defaultOrSaved])
	hackingUtils.setBonusJumpsSuicide(savedSettings.settings.suicide.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadRangeSuicide(savedSettings.settings.suicide.range[defaultOrSaved])
	--SystemReset
	hackingUtils.setSpreadCountSystemCollapse(savedSettings.settings.systemCollapse.count[defaultOrSaved])
	hackingUtils.setBonusJumpsSystemCollapse(savedSettings.settings.systemCollapse.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadRangeSystemCollapse(savedSettings.settings.systemCollapse.range[defaultOrSaved])
	--Contagion
	hackingUtils.setSpreadRangeContagion(savedSettings.settings.contagion.range[defaultOrSaved])
	hackingUtils.setBonusJumpsContagion(savedSettings.settings.contagion.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountContagion(savedSettings.settings.contagion.count[defaultOrSaved])
	--Overheat
	hackingUtils.setSpreadRangeOverheat(savedSettings.settings.overheat.range[defaultOrSaved])
	hackingUtils.setBonusJumpsOverheat(savedSettings.settings.overheat.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountOverheat(savedSettings.settings.overheat.count[defaultOrSaved])
	--Blind/Reboot Optics
	hackingUtils.setSpreadRangeBlind(savedSettings.settings.blind.range[defaultOrSaved])
	hackingUtils.setBonusJumpsBlind(savedSettings.settings.blind.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountBlind(savedSettings.settings.blind.count[defaultOrSaved])
	--CyberwareMalfunction
	hackingUtils.setSpreadRangeCyberwareMalfunction(savedSettings.settings.cyberwareMalfunction.range[defaultOrSaved])
	hackingUtils.setBonusJumpsCyberwareMalfunction(savedSettings.settings.cyberwareMalfunction.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountCyberwareMalfunction(savedSettings.settings.cyberwareMalfunction.count[defaultOrSaved])
	--LocomotionMalfunction
	hackingUtils.setSpreadRangeLocomotionMalfunction(savedSettings.settings.locomotionMalfunction.range[defaultOrSaved])
	hackingUtils.setBonusJumpsLocomotionMalfunction(savedSettings.settings.locomotionMalfunction.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountLocomotionMalfunction(savedSettings.settings.locomotionMalfunction.count[defaultOrSaved])
	--WeaponMalfunction
	hackingUtils.setSpreadRangeWeaponMalfunction(savedSettings.settings.weaponMalfunction.range[defaultOrSaved])
	hackingUtils.setBonusJumpsWeaponMalfunction(savedSettings.settings.weaponMalfunction.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountWeaponMalfunction(savedSettings.settings.weaponMalfunction.count[defaultOrSaved])
	--DetonateGrenade
	hackingUtils.setSpreadRangeDetonateGrenade(savedSettings.settings.grenade.range[defaultOrSaved])
	hackingUtils.setBonusJumpsDetonateGrenade(savedSettings.settings.grenade.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountDetonateGrenade(savedSettings.settings.grenade.count[defaultOrSaved])
	--Overload/Short Circuit
	hackingUtils.setSpreadRangeOverload(savedSettings.settings.overload.range[defaultOrSaved])
	hackingUtils.setBonusJumpsOverload(savedSettings.settings.overload.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountOverload(savedSettings.settings.overload.count[defaultOrSaved])
	--Brain Melt/Synapse Burnout QuickHack
	hackingUtils.setSpreadRangeBrainMelt(savedSettings.settings.brainMelt.range[defaultOrSaved])
	hackingUtils.setBonusJumpsBrainMelt(savedSettings.settings.brainMelt.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountBrainMelt(savedSettings.settings.brainMelt.count[defaultOrSaved])
	--Madness/Cyberpsychosis
	hackingUtils.setSpreadRangeCyberpsychosis(savedSettings.settings.madness.range[defaultOrSaved])
	hackingUtils.setBonusJumpsCyberpsychosis(savedSettings.settings.madness.bonusJumps[defaultOrSaved])
	hackingUtils.setSpreadCountCyberpsychosis(savedSettings.settings.madness.count[defaultOrSaved])
end

function resetSavedValuesToDefault()
	for k,v in pairs(savedSettings.settings) do
		v.count.saved = v.count.default
		v.range.saved = v.range.default
		v.bonusJumps.saved = v.bonusJumps.default
	end
	setAllValuesInGame(true)
	savedSettings.tryToSaveSettings()
end
skill_tab = {}

local profLevelList = {
	{name="StrengthSkill",lvl=1,exp=0},
	{name="ReflexesSkill",lvl=1,exp=0},
	{name="CoolSkill",lvl=1,exp=0},
	{name="IntelligenceSkill",lvl=1,exp=0},
	{name="TechnicalAbilitySkill",lvl=1,exp=0}
}
local profOpened = true

function skill_tab.on_overlay_open(util, playerDevelopmentData)
    profLevelList = util.prof.getProficiencies(playerDevelopmentData,profLevelList)
end

function skill_tab.create(options, util, playerDevelopmentData)
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
end

return skill_tab
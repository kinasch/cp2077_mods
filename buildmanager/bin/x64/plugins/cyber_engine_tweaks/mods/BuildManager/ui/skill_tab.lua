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

--- Creates the skills tab for the UI
--- @param options BMOptions
--- @param util Util
--- @param playerDevelopmentData PlayerDevelopmentData
--- @param translation BuildManagerTranslation
function skill_tab.create(options, util, playerDevelopmentData, translation)
    if ImGui.BeginTabItem(translation.skills.skills_tab_title) then
		if profOpened then
			profLevelList = util.prof.getProficiencies(playerDevelopmentData,profLevelList)
			profOpened = false
		end

		ImGui.PushID("options.letProfs_checkbox")
		options.letProfs = ImGui.Checkbox("", options.letProfs)
		ImGui.PopID()
		ImGui.SameLine()
		ImGui.TextWrapped(translation.skills.allow_manual_modification)
		ImGui.Spacing()
		ImGui.Separator()

		if not options.letProfs then
			ImGui.TextWrapped(translation.skills.warning_disallowed_modification)
		else
			ImGui.TextWrapped(translation.skills.skills_explanation)

			ImGui.BeginGroup()
			for k,v in pairs(profLevelList) do
				ImGui.PushItemWidth(0.55*ImGui.GetWindowWidth())
				v.lvl = ImGui.SliderInt(GetLocalizedText(TweakDB:GetRecord("Proficiencies."..v.name):Loc_name_key()),v.lvl,1,60,"%d")
			end
			ImGui.EndGroup()

			if ImGui.Button(translation.skills.set_skills,(ImGui.GetContentRegionAvail()*0.9),30) then
				util.prof.setProficiencies(playerDevelopmentData,profLevelList)
			end
			ImGui.SameLine()
			if ImGui.SmallButton(IconGlyphs.Reload) then
				profLevelList = util.prof.getProficiencies(playerDevelopmentData,profLevelList)
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
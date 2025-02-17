local options_tab = {}

--- Creates the options tab for the UI
--- @param options BMOptions
--- @param translation BuildManagerTranslation
function options_tab.create(options, translation)
    if ImGui.BeginTabItem(translation.options.options_tab_title) then
		ImGui.TextWrapped(translation.options.max_amount_of_saves_text)
		ImGui.PushID("options.saveLimit_slider")
		options.saveLimit = ImGui.SliderInt("", options.saveLimit, 5, 50, "%d")
		ImGui.PopID()
		if options.saveLimit > 20 then
			ImGui.TextWrapped(translation.options.saves_amount_warning)
		end

		ImGui.Spacing()
		ImGui.Separator()

		ImGui.TextWrapped(translation.options.save_name_character_limit)
		ImGui.PushID("options.saveCharacterLimit_slider")
		options.saveCharacterLimit = ImGui.SliderInt("", options.saveCharacterLimit, 16, 256, "%d")
		ImGui.PopID()

		ImGui.EndTabItem()
	end
end

return options_tab
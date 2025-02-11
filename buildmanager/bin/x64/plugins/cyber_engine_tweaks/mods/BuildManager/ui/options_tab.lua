local options_tab = {}

--- Creates the options tab for the UI
--- @param options { saveLimit: number, saveCharacterLimit: number, letProfs: bool, loadEquipment: bool }
function options_tab.create(options)
    if ImGui.BeginTabItem("Options") then
		ImGui.TextWrapped("Maximum amount of saves:")
		options.saveLimit = ImGui.SliderInt("sl", options.saveLimit, 5, 20, "%d")
		ImGui.Separator()
		ImGui.TextWrapped("Save Name Character Limit:")
		options.saveCharacterLimit = ImGui.SliderInt("scl", options.saveCharacterLimit, 16, 256, "%d")
		ImGui.Separator()
		ImGui.TextWrapped("Allow manual modification of the skills?")
		options.letProfs = ImGui.Checkbox("Allow?", options.letProfs)
		ImGui.Separator()
		ImGui.TextWrapped("Load Equipment on Load/Build Load?")
		options.loadEquipment = ImGui.Checkbox("Load?", options.loadEquipment)

		ImGui.EndTabItem()
	end
end

return options_tab
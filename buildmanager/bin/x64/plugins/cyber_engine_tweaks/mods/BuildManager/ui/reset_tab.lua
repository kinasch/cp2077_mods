reset_tab = {}

local include_equipment = false

--- Creates the reset tab for the UI
--- @param playerDevelopmentData PlayerDevelopmentData
--- @param util Util
--- @param translation BuildManagerTranslation
--- @param options BMOptions
function reset_tab.create(playerDevelopmentData, util, translation, options)
    if ImGui.BeginTabItem(translation.reset.reset_tab_title) then
		ImGui.TextWrapped(translation.reset.reset_explanation)
		ImGui.Spacing()
		-- Do not allow resetting while the confirmation popup is open.
		if not ImGui.IsPopupOpen(translation.reset.reset_tab_title) then
			if ImGui.Button(translation.reset.button_reset,ImGui.GetContentRegionAvail(),40) then
				include_equipment = false
				ImGui.OpenPopup(translation.reset.reset_tab_title)
			end
		else
			ImGui.Text(translation.reset.reset_edge_case)
		end

		-- Reset Popup
		-- Create a Popup Window in which the user can accept resetting attributes and perks.
		if ImGui.BeginPopupModal(translation.reset.reset_tab_title, true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text(translation.reset.reset_popup.info_text)
			ImGui.Text(translation.reset.reset_popup.confirmation_question)
			-- Calculate the size of this text, as the window auto resizes
			-- to the greatest Object, which in this case is the text above.
			-- Needed to center the buttons.
			local popupx = ImGui.GetContentRegionAvail()
			include_equipment = ImGui.Checkbox(translation.reset.reset_popup.include_equipment, include_equipment)
			-- Center the buttons.
			ImGui.Indent(popupx/2-30)
			if ImGui.Button(translation.yes,60,25) then
				if include_equipment then util.equip.unequipEverything() end
				util.tabulaRasa(playerDevelopmentData, options.loadSkills)
				include_equipment = false
				ImGui.CloseCurrentPopup()
			end
			if ImGui.Button(translation.no,60,25) then
				include_equipment = false
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end

		ImGui.EndTabItem()
	end
end

return reset_tab
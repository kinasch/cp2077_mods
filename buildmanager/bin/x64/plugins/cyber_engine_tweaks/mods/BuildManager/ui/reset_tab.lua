reset_tab = {}

local include_equipment = false

--- Creates the reset tab for the UI
--- @param playerDevelopmentData PlayerDevelopmentData
function reset_tab.create(playerDevelopmentData)
    if ImGui.BeginTabItem("Reset") then
		ImGui.TextWrapped("Reset attributes, perks, skills and, optionally, equipment.")
		-- Do not allow resetting while the confirmation popup is open.
		if not ImGui.IsPopupOpen("Reset?") then
			if ImGui.Button("Reset everything",(0.95*ImGui.GetWindowWidth()),30) then
				include_equipment = false
				ImGui.OpenPopup("Reset?")
			end
		else
			ImGui.Text("Unavailable! Close reset popup first!")
		end

		-- Reset Popup
		-- Create a Popup Window in which the user can accept resetting attributes and perks.
		if ImGui.BeginPopupModal("Reset?", true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text("This will reset all attributes and perks.\nProceed?")
			-- Calculate the size of this text, as the window auto resizes
			-- to the greatest Object, which in this case is the text above.
			-- Needed to center the buttons.
			local popupx,popupy = ImGui.CalcTextSize("This will reset all attributes and perks")
			include_equipment = ImGui.Checkbox("Include Equipment?", include_equipment)
			-- Center the buttons.
			ImGui.Indent(popupx/2-25)
			if ImGui.Button("Yes",50,25) then
				util.tabulaRasa(playerDevelopmentData)
				if include_equipment then util.equip.unequipEverything() end
				include_equipment = false
				ImGui.CloseCurrentPopup()
			end
			if ImGui.Button("No",50,25) then
				include_equipment = false
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end

		ImGui.EndTabItem()
	end
end

return reset_tab
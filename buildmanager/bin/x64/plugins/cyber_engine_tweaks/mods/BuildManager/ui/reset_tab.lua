reset_tab = {}

function reset_tab.create(playerDevelopmentData)
    if ImGui.BeginTabItem("Reset") then
		ImGui.Text("Reset attributes, perks and skills.")
		-- Do not allow resetting while the confirmation popup is open.
		if not ImGui.IsPopupOpen("Reset?") then
			if ImGui.Button("Reset everything",(0.95*ImGui.GetWindowWidth()),30) then
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
			-- Center the buttons.
			ImGui.Indent(popupx/2-25)
			if ImGui.Button("Yes",50,25) then
				util.tabulaRasa(playerDevelopmentData)
				ImGui.CloseCurrentPopup()
			end
			if ImGui.Button("No",50,25) then ImGui.CloseCurrentPopup() end
			ImGui.EndPopup()
		end

		ImGui.EndTabItem()
	end
end

return reset_tab
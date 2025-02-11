local import_export_tab = {}

local importURL, exportURL = "",""

--- Creates the import/export tab for the UI
--- @param util Util
--- @param playerDevelopmentData PlayerDevelopmentData
function import_export_tab.create(util, playerDevelopmentData)
    if ImGui.BeginTabItem("Import/Export") then
		ImGui.SetNextItemWidth(0.9*ImGui.GetWindowWidth()-ImGui.CalcTextSize("URL"))
		-- Create a new inputText to let the user name the save.
		importURL = ImGui.InputText("URL", importURL, 300)
		if ImGui.Button("Import and Load",(0.95*ImGui.GetWindowWidth()),30) then
			if importURL ~= nil and importURL ~= "" then
				ImGui.OpenPopup("Import Save Popup (Import Tab)")
			else
				ImGui.OpenPopup("No URL entered")
			end
		end

		-------------------------------
		-- Import Save Popup (Import Tab)
		if ImGui.BeginPopupModal("Import Save Popup (Import Tab)", true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text("Overwrite your current build with the import?")
			if ImGui.Button("Yes",ImGui.CalcTextSize("Overwrite your current build with the import"),25) then
				local newSave = util.import_export.setBuildFromURL(playerDevelopmentData,importURL, false)
				util.setBuild(playerDevelopmentData, newSave, false)
				ImGui.CloseCurrentPopup()
			end
			if ImGui.Button("No",ImGui.CalcTextSize("Overwrite your current build with the import"),25) then
				importURL = ""
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end
		-- Import Save Popup (Import Tab)
		-------------------------------

		-----------------
		-- No URL entered
		if ImGui.BeginPopupModal("No URL entered", true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text("No URL entered.")
			if ImGui.Button("Understood",ImGui.CalcTextSize("No URL entered"),25) then
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end
		-- No URL entered
		-----------------

		-- #####################################################
		-- Export
		ImGui.Spacing()
		ImGui.Separator()
		ImGui.Spacing()
		if ImGui.Button("Current Build To Url",(0.95*ImGui.GetWindowWidth()),30) then
			exportURL = tostring(
				util.import_export.getUrlForCurrentBuild(
					playerDevelopmentData,
					util.createNewSave(playerDevelopmentData, util.prof.getDefaultProfLevelList())
				)
			)
		end
		-- Set Output width to a value, such that the small button is still visible fully.
		ImGui.SetNextItemWidth(0.95*ImGui.GetWindowWidth()-ImGui.CalcTextSize("----------------"))
		ImGui.PushID("exportoutput")
		ImGui.InputText("", exportURL, 300, ImGuiInputTextFlags.ReadOnly)
		ImGui.PopID()
		ImGui.SameLine()
		ImGui.PushID("copyexport")
		if ImGui.SmallButton(IconGlyphs.ContentCopy) then
			ImGui.SetClipboardText(exportURL)
		end
		ImGui.PopID()
		ImGui.SameLine()
		ImGui.PushID("clearexport")
		if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
			exportURL = ""
		end
		ImGui.PopID()
		ImGui.TextWrapped("Might not work correctly if you used 80 or more perk points and/or more than 66 attribute points.")

		ImGui.EndTabItem()
	end
end

return import_export_tab
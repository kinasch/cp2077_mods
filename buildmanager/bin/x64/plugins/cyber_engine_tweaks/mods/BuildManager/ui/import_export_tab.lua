local import_export_tab = {}

local importURL, exportURL = "",""

local used_points_save = {attributePoints=0, perkPoints=0}

--- Creates the import/export tab for the UI
--- @param util Util
--- @param playerDevelopmentData PlayerDevelopmentData
--- @param translation BuildManagerTranslation
--- @param options BMOptions
function import_export_tab.create(util, playerDevelopmentData, translation, options)
    if ImGui.BeginTabItem(translation.import_export.import_export_tab_title) then
		ImGui.SetNextItemWidth(0.9*ImGui.GetContentRegionAvail()-ImGui.CalcTextSize(translation.import_export.url_input))
		-- Create a new inputText to let the user name the save.
		importURL = ImGui.InputText(translation.import_export.url_input, importURL, 300)
		if ImGui.Button(translation.import_export.import_button,ImGui.GetContentRegionAvail(),30) then
			if importURL ~= nil and importURL ~= "" then
				ImGui.OpenPopup(translation.import_export.import_popup_title)
			else
				ImGui.OpenPopup(translation.import_export.no_url_input_popup)
			end
		end

		-------------------------------
		-- Import Save Popup (Import Tab)
		if ImGui.BeginPopupModal(translation.import_export.import_popup_title, true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text(translation.import_export.import_popup_confirmation)
			if ImGui.Button(translation.yes,ImGui.GetContentRegionAvail(),25) then
				local newSave = util.import_export.setBuildFromURL(playerDevelopmentData,importURL,util)
				util.setBuild(playerDevelopmentData, newSave, false, true)
				ImGui.CloseCurrentPopup()
			end
			if ImGui.Button(translation.no,ImGui.GetContentRegionAvail(),25) then
				importURL = ""
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end
		-- Import Save Popup (Import Tab)
		-------------------------------

		-----------------
		-- No URL entered
		ImGui.SetNextWindowSize(350,70)
		if ImGui.BeginPopupModal(translation.import_export.no_url_input_popup, true, ImGuiWindowFlags.NoResize) then
			if ImGui.Button(IconGlyphs.Check,ImGui.GetContentRegionAvail()) then
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
		if ImGui.Button(translation.import_export.export_button,ImGui.GetContentRegionAvail(),30) then
			local _attrs,_perks,_,_,_us,_ = util.createNewSave(playerDevelopmentData, util.prof.getDefaultProfLevelList())
			used_points_save = _us
			exportURL = tostring(
				util.import_export.getUrlForCurrentBuild(
					playerDevelopmentData,
					_attrs,_perks
				)
			)
		end
		-- Set Output width to a value, such that the small button is still visible fully.
		ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail()-ImGui.CalcTextSize("----------------"))
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
			used_points_save = {attributePoints=0, perkPoints=0}
		end
		ImGui.PopID()
		ImGui.Spacing()
		if used_points_save.attributePoints > 66 or used_points_save.perkPoints >= 80 then
			ImGui.TextWrapped(
				IconGlyphs.Alert..
				translation.import_export.export_warning..
				used_points_save.perkPoints..
				","..
				used_points_save.attributePoints
			)
		end

		ImGui.EndTabItem()
	end
end

return import_export_tab
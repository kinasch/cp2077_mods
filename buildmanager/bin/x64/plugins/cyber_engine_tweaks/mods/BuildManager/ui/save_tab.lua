save_tab = {}

local saveNameText, deleteNameText, infoSave = "", "", {}

function save_tab.reset_locals()
    saveNameText, deleteNameText, infoSave = "", "", {}
end

--- Creates the save tab for the UI
--- @param options { saveLimit: number, saveCharacterLimit: number, letProfs: bool, loadEquipment: bool }
--- @param saveSettings SaveSettings
--- @param util Util
--- @param playerDevelopmentData PlayerDevelopmentData
--- @param translation BuildManagerTranslation
function save_tab.create(options, saveSettings, util, playerDevelopmentData, translation)
    if ImGui.BeginTabItem(translation.save.save_tab_title) then
		ImGui.TextWrapped(translation.save.create_new_save)
		-- Limit the InputText Size such that the Label can be seen.
		ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail()-ImGui.CalcTextSize(IconGlyphs.PlusThick.."--------"))
		-- Create a new inputText to let the user name the save.
		ImGui.PushID("newSaveName_input")
		saveNameText = ImGui.InputText("", saveNameText, options.saveCharacterLimit)
		ImGui.PopID()
		ImGui.SameLine()
		-- Create a new save, when the name is neither null nor empty and the maximum amount of allowed saves is not reached.
		if ImGui.Button(IconGlyphs.PlusThick,ImGui.CalcTextSize(IconGlyphs.PlusThick.."-----"), ImGui.GetFontSize()*1.333) then
			if saveNameText ~= nil and saveNameText ~= "" and util.tableLength(saveSettings.settings) < options.saveLimit then
				savePLL = util.prof.getProficiencies(playerDevelopmentData)
				saveSettings.saveData(saveNameText,util.createNewSave(playerDevelopmentData,savePLL))
				saveNameText = ""
			else
				ImGui.OpenPopup(translation.save.save_limit_or_no_name)
			end
		end
		ImGui.Spacing()
		ImGui.Separator()
		ImGui.Spacing()

		-- List all saves
		ImGui.Text(translation.save.existing_save_overwrite)
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			if ImGui.Button(k,(ImGui.GetContentRegionAvail()-ImGui.CalcTextSize(IconGlyphs.DeleteOutline..IconGlyphs.InformationOutline)-32),30) then
				deleteNameText = k
				ImGui.OpenPopup(translation.save.overwrite_save_popup_title)
			end

			-------------------------------
			-- Overwrite Save Popup (Save Tab)
			if ImGui.BeginPopupModal(translation.save.overwrite_save_popup_title, true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text(translation.save.overwrite_save_popup_confirmation)
				ImGui.Text(deleteNameText)
				if ImGui.Button(translation.yes,ImGui.GetContentRegionAvail(),25) then
					savePLL = util.prof.getProficiencies(playerDevelopmentData)
					saveSettings.saveData(deleteNameText,util.createNewSave(playerDevelopmentData,savePLL))
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button(translation.no,ImGui.GetContentRegionAvail(),25) then
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Overwrite Save Popup (Save Tab)
			-------------------------------

			ImGui.SameLine()
			ImGui.PushID("info_save"..k)
			if ImGui.SmallButton(IconGlyphs.InformationOutline) then
				infoSave = attr
				ImGui.OpenPopup(translation.build_info.build_info_title.." \""..k.."\"")
			end

			-------------------------------
			-- Info Popup (Save Tab)
			if ImGui.BeginPopupModal(translation.build_info.build_info_title.." \""..k.."\"", true, ImGuiWindowFlags.AlwaysAutoResize) then

				ImGui.Text(translation.build_info.build_level..infoSave.buildLevel)
				ImGui.Separator()

				if ImGui.BeginTable("attributes",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthStretch, 150)
					ImGui.TableSetupColumn("Column2", ImGuiTableColumnFlags.None)
					for ik,v in pairs(infoSave.attributes) do
						ImGui.TableNextRow()
						ImGui.TableNextColumn()
						ImGui.Text(GetLocalizedText(TweakDB:GetRecord("BaseStats."..v.name):LocalizedName()))
						ImGui.TableNextColumn()
						ImGui.Text(""..v.level)
					end
					-- Spacing Row
					ImGui.TableNextRow()
					ImGui.TableNextColumn()
					ImGui.Text("--------------------------")
					ImGui.TableNextColumn()
					ImGui.Text("")
					
					-- Used Points Rows
					ImGui.TableNextRow()
					ImGui.TableNextColumn()
					ImGui.Text(translation.build_info.used_attribute_points)
					ImGui.TableNextColumn()
					ImGui.Text(""..infoSave.usedPoints.attributePoints)
					ImGui.TableNextRow()
					ImGui.TableNextColumn()
					ImGui.Text(translation.build_info.used_perk_points)
					ImGui.TableNextColumn()
					ImGui.Text(""..infoSave.usedPoints.perkPoints)

					ImGui.EndTable()
				end
				ImGui.Separator()

				if ImGui.BeginTable("profs",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthStretch, 150)
					ImGui.TableSetupColumn("Column2", ImGuiTableColumnFlags.None)
					for ik,v in pairs(infoSave.profs) do
						ImGui.TableNextRow()
						ImGui.TableNextColumn()
						ImGui.Text(GetLocalizedText(TweakDB:GetRecord("Proficiencies."..v.name):Loc_name_key()))
						ImGui.TableNextColumn()
						ImGui.Text(""..v.lvl)
					end
					ImGui.EndTable()
				end

				ImGui.EndPopup()
			end
			-- Info Popup (Save Tab)
			-------------------------------

			ImGui.PopID()

			ImGui.SameLine()
			ImGui.PushID("del_save"..k)
			if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
				deleteNameText = k
				ImGui.OpenPopup(translation.deletion_popup.deletion_popup_title)
			end

			-------------------------------
			-- Delete Save Popup (Save Tab)
			if ImGui.BeginPopupModal(translation.deletion_popup.deletion_popup_title, true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text(translation.deletion_popup.confirmation_question)
				ImGui.Text(deleteNameText)
				if ImGui.Button(translation.yes,ImGui.GetContentRegionAvail(),25) then
					saveSettings.deleteSave(deleteNameText)
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button(translation.no,ImGui.GetContentRegionAvail(),25) then
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Delete Save Popup (Save Tab)
			-------------------------------

			ImGui.PopID()
			
		end

		ImGui.EndGroup()

		---------------------------------------------
		-- Save Limit reached / No name entered Popup
		if ImGui.BeginPopupModal(translation.save.save_limit_or_no_name, true, ImGuiWindowFlags.AlwaysAutoResize) then
			if ImGui.Button(IconGlyphs.Check,ImGui.GetContentRegionAvail(),25) then
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end
		-- Save Limit reached / No name entered Popup
		---------------------------------------------

		ImGui.EndTabItem()
	end
end

return save_tab
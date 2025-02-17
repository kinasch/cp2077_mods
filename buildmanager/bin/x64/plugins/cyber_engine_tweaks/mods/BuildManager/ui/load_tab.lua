local load_tab = {}

local deleteNameText, infoSave = "", {}

function load_tab.reset_locals()
    deleteNameText, infoSave = "", {}
end

--- Creates the load tab for the UI
--- @param options BMOptions
--- @param saveSettings SaveSettings
--- @param util Util
--- @param playerDevelopmentData PlayerDevelopmentData
--- @param playerLevel number
--- @param translation BuildManagerTranslation
function load_tab.create(options, saveSettings, util, playerDevelopmentData, playerLevel, translation)
    if ImGui.BeginTabItem(translation.load.load_tab_title) then

		ImGui.PushID("options.loadEquipment_checkbox")
		options.loadEquipment = ImGui.Checkbox("", options.loadEquipment)
		ImGui.PopID()
		ImGui.SameLine()
		ImGui.TextWrapped(translation.load.load_including_equipment_text)
		ImGui.Spacing()
		ImGui.PushID("options.loadSkills_checkbox")
		options.loadSkills = ImGui.Checkbox("", options.loadSkills)
		ImGui.PopID()
		ImGui.SameLine()
		ImGui.TextWrapped(translation.load.load_including_skills_text)
		ImGui.Spacing()
		ImGui.Separator()

		-- List all saves
		ImGui.Text(translation.load.choose_save_to_load)
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
            local save_loadable = playerLevel >= attr.buildLevel
            if not save_loadable then
                ImGui.BeginDisabled()
            end
			if ImGui.Button(k,((ImGui.GetContentRegionAvail()-ImGui.CalcTextSize(IconGlyphs.DeleteOutline..IconGlyphs.InformationOutline)-32)),30) then
				ImGui.OpenPopup(translation.load.load_popup.load_popup_title.." \""..k.."\"")
			end
			if ImGui.IsItemHovered() then
				ImGui.SetTooltip(k)
			end
            if not save_loadable then
                ImGui.EndDisabled()
            end

			-------------------------------
			-- Load Save Popup
			if ImGui.BeginPopupModal(translation.load.load_popup.load_popup_title.." \""..k.."\"", true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text(translation.load.load_popup.load_popup_confirmation)
				if ImGui.Button(translation.yes,ImGui.GetContentRegionAvail(),25) then
					util.setBuild(playerDevelopmentData, saveSettings.settings[k], options.loadEquipment, options.loadSkills)
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button(translation.no,ImGui.GetContentRegionAvail(),25) then
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Load Save Popup
			-------------------------------

			ImGui.SameLine()
			ImGui.PushID("info_load"..k)
			if ImGui.SmallButton(IconGlyphs.InformationOutline) then
				infoSave = attr
				ImGui.OpenPopup(translation.build_info.build_info_title.." \""..k.."\"")
			end

			-------------------------------
			-- Info Popup (Load Tab)
			if ImGui.BeginPopupModal(translation.build_info.build_info_title.." \""..k.."\"", true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text(translation.build_info.build_info_title.." \""..k.."\":  ")
				ImGui.Separator()
				ImGui.Text(translation.build_info.build_level..infoSave.buildLevel)
				ImGui.Spacing()

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
					ImGui.Text("")
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
			-- Info Popup (Load Tab)
			-------------------------------

			ImGui.PopID()

			ImGui.SameLine()
			ImGui.PushID("del_load"..k)
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

		ImGui.EndTabItem()
	end
end

return load_tab
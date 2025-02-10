local load_tab = {}

local deleteNameText, infoSave = "", {}

function load_tab.reset_locals()
    deleteNameText, infoSave = "", {}
end

function load_tab.create(options, saveSettings, util, playerDevelopmentData, playerLevel)
    if ImGui.BeginTabItem("Load") then
		-- List all saves
		ImGui.Text("Click on a save to load it:")
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
            local save_loadable = playerLevel >= attr.buildLevel
            if not save_loadable then
                ImGui.BeginDisabled()
            end
			if ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30) then
				ImGui.OpenPopup("Load Save \""..k.."\"")
			end
            if not save_loadable then
                ImGui.EndDisabled()
            end

			-------------------------------
			-- Load Save Popup
			if ImGui.BeginPopupModal("Load Save \""..k.."\"", true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text("Load selected save and overwrite current build?")
				if ImGui.Button("Yes",ImGui.CalcTextSize("Load selected save and overwrite current build"),25) then
					util.setBuild(playerDevelopmentData, saveSettings.settings[k], options.loadEquipment)
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button("No",ImGui.CalcTextSize("Load selected save and overwrite current build"),25) then
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Load Save Popup
			-------------------------------

			ImGui.SameLine()
			ImGui.PushID("info"..k)
			if ImGui.SmallButton(IconGlyphs.InformationOutline) then
				infoSave = attr
				ImGui.OpenPopup("Info for \""..k.."\" (Load Tab)")
			end

			-------------------------------
			-- Info Popup (Load Tab)
			if ImGui.BeginPopupModal("Info for \""..k.."\" (Load Tab)", ImGuiWindowFlags.AlwaysAutoResize) then

				ImGui.Text("Build Level: "..infoSave.buildLevel)
				ImGui.Separator()

				if ImGui.BeginTable("attributes",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthFixed, 150)
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
					ImGui.Text("Used Attribute Points:")
					ImGui.TableNextColumn()
					ImGui.Text(""..infoSave.usedPoints.attributePoints)
					ImGui.TableNextRow()
					ImGui.TableNextColumn()
					ImGui.Text("Used Perk Points:")
					ImGui.TableNextColumn()
					ImGui.Text(""..infoSave.usedPoints.perkPoints)

					ImGui.EndTable()
				end
				ImGui.Separator()

				if ImGui.BeginTable("profs",2) then
					ImGui.TableSetupColumn("Column1", ImGuiTableColumnFlags.WidthFixed, 150)
					ImGui.TableSetupColumn("Column2", ImGuiTableColumnFlags.None)
					for ik,v in pairs(infoSave.profs) do
						ImGui.TableNextRow()
						ImGui.TableNextColumn()
						ImGui.Text(GetLocalizedText(TweakDB:GetRecord("Proficiencies."..v.name):Loc_name_key()))
						ImGui.TableNextColumn()
						ImGui.Text(v.lvl.. " ("..v.exp.."XP)")
					end
					ImGui.EndTable()
				end
				ImGui.Spacing()

				if ImGui.Button("Close",250,30) then
					infoSave = {}
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Info Popup (Load Tab)
			-------------------------------

			ImGui.PopID()

			ImGui.SameLine()
			ImGui.PushID("del"..k)
			if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
				deleteNameText = k
				ImGui.OpenPopup("Delete Save (Load Tab)")
			end

			-------------------------------
			-- Delete Save Popup (Load Tab)
			if ImGui.BeginPopupModal("Delete Save (Load Tab)", true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text("Are you sure you want to delete this save?\n"..deleteNameText)
				if ImGui.Button("Yes",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					saveSettings.deleteSave(deleteNameText)
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button("No",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Delete Save Popup (Load Tab)
			-------------------------------

			ImGui.PopID()
		end

		ImGui.EndGroup()

		ImGui.EndTabItem()
	end
end

return load_tab
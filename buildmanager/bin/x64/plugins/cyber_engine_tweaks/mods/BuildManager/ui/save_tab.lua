save_tab = {}

local saveNameText, deleteNameText, infoSave = "", "", {}

function save_tab.reset_locals()
    saveNameText, deleteNameText, infoSave = "", "", {}
end

function save_tab.create(options, saveSettings, util, playerDevelopmentData)
    if ImGui.BeginTabItem("Save") then
		-- Limit the InputText Size such that the Label can be seen.
		ImGui.SetNextItemWidth(0.9*ImGui.GetWindowWidth()-ImGui.CalcTextSize("Save Name"))
		-- Create a new inputText to let the user name the save.
		saveNameText = ImGui.InputText("Save Name", saveNameText, options.saveCharacterLimit)
		-- Create a new save, when the name is neither null nor empty and the maximum amount of allowed saves is not reached.
		if ImGui.Button("New Save",(0.95*ImGui.GetWindowWidth()),50) then
			if saveNameText ~= nil and saveNameText ~= "" and util.tableLength(saveSettings.settings) < options.saveLimit then
				savePLL = util.prof.getProficiencies(playerDevelopmentData)
				saveSettings.saveData(saveNameText,util.createNewSave(playerDevelopmentData,savePLL))
				saveNameText = ""
			else
				ImGui.OpenPopup("Save Limit reached / No name entered")
			end
		end
		ImGui.Separator()

		-- List all saves
		ImGui.Text("Click on an existing save to overwrite it:")
		ImGui.BeginGroup()
		for k,attr in pairs(saveSettings.settings) do
			if ImGui.Button(k,(0.5*ImGui.GetWindowWidth()),30) then
				deleteNameText = k
				ImGui.OpenPopup("Overwrite Save (Save Tab)")
			end

			-------------------------------
			-- Overwrite Save Popup (Save Tab)
			if ImGui.BeginPopupModal("Overwrite Save (Save Tab)", true, ImGuiWindowFlags.AlwaysAutoResize) then
				ImGui.Text("Overwrite save?\n"..deleteNameText)
				if ImGui.Button("Yes",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					savePLL = util.prof.getProficiencies(playerDevelopmentData)
					saveSettings.saveData(deleteNameText,util.createNewSave(playerDevelopmentData,savePLL))
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				if ImGui.Button("No",ImGui.CalcTextSize(string.rep("A", options.saveCharacterLimit)),25) then
					deleteNameText = ""
					ImGui.CloseCurrentPopup()
				end
				ImGui.EndPopup()
			end
			-- Overwrite Save Popup (Save Tab)
			-------------------------------

			ImGui.SameLine()
			ImGui.PushID("info"..k)
			if ImGui.SmallButton(IconGlyphs.InformationOutline) then
				infoSave = attr
				ImGui.OpenPopup("Info for \""..k.."\" (Save Tab)")
			end

			-------------------------------
			-- Info Popup (Save Tab)
			if ImGui.BeginPopupModal("Info for \""..k.."\" (Save Tab)", ImGuiWindowFlags.AlwaysAutoResize) then

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
			-- Info Popup (Save Tab)
			-------------------------------

			ImGui.PopID()

			ImGui.SameLine()
			ImGui.PushID("del"..k)
			if ImGui.SmallButton(IconGlyphs.DeleteOutline) then
				deleteNameText = k
				ImGui.OpenPopup("Delete Save (Save Tab)")
			end

			-------------------------------
			-- Delete Save Popup (Save Tab)
			if ImGui.BeginPopupModal("Delete Save (Save Tab)", true, ImGuiWindowFlags.AlwaysAutoResize) then
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
			-- Delete Save Popup (Save Tab)
			-------------------------------

			ImGui.PopID()
			
		end

		ImGui.EndGroup()

		---------------------------------------------
		-- Save Limit reached / No name entered Popup
		if ImGui.BeginPopupModal("Save Limit reached / No name entered", true, ImGuiWindowFlags.AlwaysAutoResize) then
			ImGui.Text("No name entered or save limit ("..options.saveLimit..") reached.")
			if ImGui.Button("Understood",ImGui.CalcTextSize("No name entered or save limit ("..options.saveLimit..") reached."),25) then
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
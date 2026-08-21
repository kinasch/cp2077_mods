local savedSettings = require("modules/savedSettings")
local openMenu = false

staticSettings = {
    overload = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-EMPOverloadProgram",
        category = "Gameplay-Parts-Programs-Category-DamageHacks",
        flats = { "QuickHack.OverloadBaseHack_inline6" }
    },
    overheat = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-OverheatProgram",
        category = "Gameplay-Parts-Programs-Category-DamageHacks",
        flats = { "QuickHack.BaseOverheatHack_inline3" }
    },
    contagion = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-ContagionProgram",
        category = "Gameplay-Parts-Programs-Category-DamageHacks",
        flats = { "QuickHack.BaseContagionHack_inline3" }
    },
    brainMelt = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-BrainMeltProgram",
        category = "Gameplay-Parts-Programs-Category-DamageHacks",
        flats = { "QuickHack.BrainMeltBaseHack_inline5" }
    },
    blind = {
        locSecondaryKey = "Gameplay-RPG-Items-Names-BlindProgram",
        category = "Gameplay-Parts-Programs-Category-ControlHacks",
        flats = {
            "QuickHack.BlindHack_inline1",
            "QuickHack.BlindLvl1Hack_inline1",
            "QuickHack.BlindLvl2Hack_inline1",
            "QuickHack.BlindLvl3Hack_inline1",
            "QuickHack.BlindLvl4Hack_inline1",
            "QuickHack.BlindLvl4Hack_inline10"
        }
    },
    weaponMalfunction = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-JamWeaponProgram",
        category = "Gameplay-Parts-Programs-Category-ControlHacks",
        flats = {
            "QuickHack.WeaponMalfunctionHack_inline1",
            "QuickHack.WeaponMalfunctionLvl2Hack_inline1",
            "QuickHack.WeaponMalfunctionLvl3Hack_inline1",
            "QuickHack.WeaponMalfunctionLvl4Hack_inline1",
            "QuickHack.WeaponMalfunctionLvl4PlusPlusHack_inline1"
        }
    },
    locomotionMalfunction = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-LocomotionMalfunctionProgram",
        category = "Gameplay-Parts-Programs-Category-ControlHacks",
        flats = {
            "QuickHack.LocomotionMalfunctionHack_inline1",
            "QuickHack.LocomotionMalfunctionLvl2Hack_inline1",
            "QuickHack.LocomotionMalfunctionLvl3Hack_inline1",
            "QuickHack.LocomotionMalfunctionLvl4Hack_inline1"
        }
    },
    cyberwareMalfunction = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-CyberwareMalfunction",
        category = "Gameplay-Parts-Programs-Category-ControlHacks",
        flats = {
            "QuickHack.CyberwareMalfunctionHack_inline1",
            "QuickHack.CyberwareMalfunctionLvl2Hack_inline1",
            "QuickHack.CyberwareMalfunctionLvl3Hack_inline1",
            "QuickHack.CyberwareMalfunctionLvl4Hack_inline1",
            "QuickHack.CyberwareMalfunctionLvl4PlusPlusHack_inline1"
        }
    },
    suicide = {
        locSecondaryKey = "Gameplay-RPG-Items-Names-SuicideProgram",
        category = "Gameplay-Parts-Programs-Category-UltimateHacks",
        flats = { "QuickHack.SuicideHackBase_inline7" }
    },
    madness = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-MadnessProgram",
        category = "Gameplay-Parts-Programs-Category-UltimateHacks",
        flats = { "QuickHack.MadnessHackBase_inline6" }
    },
    grenade = {
        locSecondaryKey = "Gameplay-RPG-Items-Names-GrenadeExplodeProgram",
        category = "Gameplay-Parts-Programs-Category-UltimateHacks",
        flats = { "QuickHack.GrenadeHackBase_inline6" }
    },
    systemCollapse = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-SystemCollapseProgram",
        category = "Gameplay-Parts-Programs-Category-UltimateHacks",
        flats = { "QuickHack.SystemCollapseHackBase_inline8" }
    },
    blackWall = {
        locSecondaryKey = "Gameplay-Parts-Programs-DisplayName-BlackWallProgram",
        category = "Gameplay-Parts-Programs-Category-UltimateHacks",
        flats = { "QuickHack.BaseBlackWallHack_inline6" }
    }
}

registerForEvent("onInit", function()
	savedSettings.tryToLoadSettings()
end)

registerForEvent("onOverlayOpen", function()
	openMenu = true
end)
registerForEvent("onOverlayClose", function()
	openMenu = false
	-- Value application logic here
	savedSettings.tryToSaveSettings()
end)

-- Save the settings upon leaving the game (this comment is self-explanatory?)
registerForEvent("onShutdown", function()
	savedSettings.tryToSaveSettings()
end)

-- Define the quickhack category order
local categoryOrder = {
    "Gameplay-Parts-Programs-Category-DamageHacks",
    "Gameplay-Parts-Programs-Category-ControlHacks",
    "Gameplay-Parts-Programs-Category-UltimateHacks"
}

registerForEvent("onDraw", function ()
    if openMenu ~= true then return end

    ImGui.SetNextWindowPos(100, 100, ImGuiCond.FirstUseEver)
    -- Haha 420 get it, blaze it haha ... :/
    ImGui.SetNextWindowSize(420, 420, ImGuiCond.Appearing)
    ImGui.Begin("Ultimate Spreader")

    local clicked = ImGui.Button("Reset to default", (0.5 * ImGui.GetWindowWidth()), 30)
    if clicked then
        resetSavedValuesToDefault()
        updateIngameValues()
    end

    ImGui.Separator()
    ImGui.Spacing()

    ImGui.TextWrapped("A value of \"-1\" takes the player stat (should be 8 for range and 1 for count by default).")

    ImGui.Separator()
    ImGui.Spacing()

    ImGui.PushItemWidth(0.6 * ImGui.GetWindowWidth())

    for _, categoryKey in ipairs(categoryOrder) do
        local locCategoryName = GetLocalizedText(categoryKey) or categoryKey
        
        if ImGui.CollapsingHeader(locCategoryName) then
            for key, value in pairs(savedSettings.settings) do
                
                -- Pull static data for this specific hack
                local staticData = staticSettings[key]
                
                if staticData and staticData.category == categoryKey then
                    ImGui.Spacing()
                    
                    local curLocalName = GetLocalizedText(staticData.locSecondaryKey) or value.name
                    ImGui.Text(curLocalName .. " Spread")

                    ImGui.PushID(curLocalName .. "Count")
                    value.count.saved = ImGui.SliderInt("Count", value.count.saved, -1, 15, "%d")
                    if ImGui.IsItemDeactivatedAfterEdit() then
                        updateIngameValue(key, "spreadCount", value.count.saved)
                    end
                    ImGui.PopID()

                    ImGui.PushID(curLocalName .. "BonusJumps")
                    value.bonusJumps.saved = ImGui.SliderInt("Bonus Jumps", value.bonusJumps.saved, 0, 10, "%d")
                    if ImGui.IsItemDeactivatedAfterEdit() then
                        updateIngameValue(key, "bonusJumps",value.bonusJumps.saved)
                    end
                    ImGui.PopID()

                    -- Range of -1 could be the spreadCount of the player stats
                    -- Also, if the range is above 50 (or similar), the spread targets NPCs further/furthest away first - no idea, why
                    ImGui.PushID(curLocalName .. "Range")
                    value.range.saved = ImGui.SliderInt("Range", value.range.saved, -1, 100, "%d")
                    if ImGui.IsItemDeactivatedAfterEdit() then
                        updateIngameValue(key, "spreadDistance", value.range.saved)
                    end
                    ImGui.PopID()
                    
                    ImGui.Spacing()
                    ImGui.Separator()
                end
            end
        end
    end
    
    ImGui.PopItemWidth()
    ImGui.End()
end)

function resetSavedValuesToDefault()
	for k,v in pairs(savedSettings.settings) do
		v.count.saved = v.count.default
		v.range.saved = v.range.default
		v.bonusJumps.saved = v.bonusJumps.default
	end
	savedSettings.tryToSaveSettings()
end

function updateIngameValue(staticKey, valueKey, value)
	local staticData = staticSettings[staticKey]

	if staticData and staticData.flats then
		for _, flatPath in ipairs(staticData.flats) do
			TweakDB:SetFlat(flatPath .. "." .. valueKey, value)
		end
	end
end

function updateIngameValues()
    for key, value in pairs(savedSettings.settings) do
        local staticData = staticSettings[key]

        if staticData and staticData.flats then
            for _, flatPath in ipairs(staticData.flats) do
                TweakDB:SetFlat(flatPath .. ".spreadCount", value.count.saved)
                TweakDB:SetFlat(flatPath .. ".spreadDistance", value.range.saved)
                TweakDB:SetFlat(flatPath .. ".bonusJumps", value.bonusJumps.saved)
            end
        end
    end
end
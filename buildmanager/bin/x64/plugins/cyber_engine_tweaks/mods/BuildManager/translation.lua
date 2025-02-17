---@class BuildManagerTranslation
local translation = {
    -- Mod title (Title of the window in the CET overlay)
    build_manager =                             "Build Manager",
    -- Generic Yes or No for popups (Like "Do you want to delete the save" or sum)
    yes =                                       "Yes",
    no =                                        "No",
    -- Every text from the save tab (+respective popups)
    -- For the info popup, see build_info
    -- For the save deletion, see deletion_popup
    save = {
        -- Title of the Save tab
        save_tab_title =                        "Save",
        -- Text above the Save Name Input
        create_new_save =                       "Create new save:",
        -- Text above the list of saves prompting the user to click on any save, to overwrite it
        existing_save_overwrite =               "Click on an existing save to overwrite it:",
        -- Popup Text, warning user that the maximum amount of saves has been reached, or they entered no save name
        save_limit_or_no_name =                 "Save Limit reached / No name entered",
        -- Title of the popup, asking the user if they want to overwrite the save, behind the button they clicked on.
        overwrite_save_popup_title =            "Overwrite save?",
        -- Another confirming question if the user wants to overwrite the save.
        overwrite_save_popup_confirmation =     "Are you sure you want to overwrite this save?",
    },
    -- Every text from the load tab (+respective popups)
    -- For the info popup, see build_info
    -- For the save deletion, see deletion_popup
    load = {
        -- Title of the load tab
        load_tab_title =                        "Load",
        -- Checkbox if loading saves should clear equipment and put on the one from the save.
        load_including_equipment_text =         "Load Equipment on Load?",
        -- Checkbox if loading saves should include the skills from the save.
        load_including_skills_text =            "Include Skills on Load?",
        choose_save_to_load =                   "Click on a save to load it:",
        -- Text for the loading popup (Confirmation if save should be loaded/applied)
        load_popup = {
            -- Title of the load popup
            load_popup_title =                  "Load save",
            -- Confirming question if save should be loaded/applied
            load_popup_confirmation =           "Load selected save and overwrite current build?",
        }
    },
    build_info = {
        -- Text that shows the level of the saved build.
        build_level =                           "Build Level: ",
        used_attribute_points =                 "Used Attribute Points: ",
        used_perk_points =                      "Used Perk Points: ",
        -- Title of the info popup
        build_info_title =                      "Info for",
    },
    deletion_popup = {
        -- Title of the popup to delete a save
        deletion_popup_title =                  "Delete Save?",
        -- Ask again, to make sure (followed by a line break and the save name in a new line)
        confirmation_question =                 "Are you sure you want to delete this save?",
    },
    -- Every text from the skills / proficiencies tab
    -- Skills should be translated to the game language automatically, as the Loc_keys of the skills are used
    skills = {
        -- Title of the Skills tab
        skills_tab_title =                      "Skills",
        -- Text for the checkbox, allowing setting skills levels by the user.
        allow_manual_modification =             "Enable manual modification of the skills?",
        -- If the manual modification of skills is disabled, this warning is shown below.
        warning_disallowed_modification =       "Enable manually modifying the Skills!",
        -- Text explaining the sliders to set the skills
        skills_explanation =                    "Adjust Proficiencies and set them using the button below:",
        -- Button text to apply changes from the sliders.
        set_skills =                            "Set Skills"
    },
    -- Every text from the reset tab
    reset = {
        -- Title of the Reset tab, also used for the confirmation popup
        reset_tab_title =                       "Reset",
        -- Text, explaining what the button below does.
        reset_explanation =                     "Reset attributes, perks, skills and, optionally, unequip equipment.",
        -- Button text to reset everything mentioned in the explanation.
        button_reset =                          "Reset everything",
        -- Fail safe, if the popup is still open, without being confirmed nor denied (extreme edge case)
        reset_edge_case =                       "Unavailable! Close reset popup first!",
        -- Strings from the reset confirmation popup
        reset_popup = {
            -- Info text, explaining what is done upon proceeding.
            info_text =                         "This will reset all attributes, perks and skills.",
            -- Additional question to confirm
            confirmation_question =             "Proceed?",
            -- Checkbox inside the confirmation window, asking if equipment should be unequipped
            include_equipment =                 "Also unequip Equipment?",
            -- Checkbox inside the confirmation window, asking if skills should be reset as well
            include_skills =                    "Also reset skills?"
        }

    },
    -- Every text from the Import/Export tab
    import_export = {
        -- Title of the Import/Export tab
        import_export_tab_title =               "Import/Export",
        -- Label of the URL *input*
        url_input =                             "URL",
        -- Title of popup warning the user, that no URL was entered.
        no_url_input_popup =                    "No URL entered!",
        import_button =                         "Import and Load",
        import_popup_title =                    "Import Save Popup",
        import_popup_confirmation =             "Overwrite your current build with the import?",
        export_button =                         "Current Build To Url",
        export_warning =                        "Might not work correctly if you used 80 or more perk points and/or more than 66 attribute points. Used: "
    },
    -- Every text from the Options tab
    options = {
        -- Title of the Import/Export tab
        options_tab_title =                     "Options",
        -- Label for the slider that sets the maximum amount of saves
        max_amount_of_saves_text =              "Maximum amount of saves:",
        -- Label for the slider that sets the character limit for save names
        save_name_character_limit =             "Save Name Character Limit:",
        -- Warns the user when the maximum amount of allowed saves is set higher than 20.
        saves_amount_warning =                  "A high amount of saves might decrease performance!"
    }
}

return translation
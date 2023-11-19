-- Default values are taken from the respective TweakDB defaults
saveSettings = { settings = {},options = {saveLimit=10,saveCharacterLimit=64} }

function saveSettings.saveData(name,attributes,perks,currLevel,proficiencies)
    saveSettings.settings[name] = {
        -- Order: Attribute,Amount
        attributes = attributes,
        -- Order: Perk1,Perk1,Perk2,Perk3,Perk3,Perk3
        perks = perks,
        buildLevel = currLevel,
        profs = proficiencies
    }

    -- WARNING
    -- File operations are very resource hungry!
    spdlog.info("Saving,sS.saveData: "..tostring(saveSettings.tryToSaveSettings()))
end

function saveSettings.saveOptions(saveLimit,saveCharacterLimit)
    saveSettings.options = {saveLimit=saveLimit,saveCharacterLimit=saveCharacterLimit}
    saveSettings.tryToSaveSettings()
    spdlog.info("Saving,sS.saveOptions: "..tostring(saveSettings.tryToSaveSettings()))
end

function saveSettings.deleteSave(name)
    saveSettings.settings[name] = nil
	spdlog.info("Saving,sS.deleteSave: "..tostring(saveSettings.tryToSaveSettings()))
end

local path = "builds.json"


-- Tries to save the current saves.
-- Returns a boolean value, whether the file operation worked or not.
function saveSettings.tryToSaveSettings()
    local status, err = pcall(fileFunctions.save)
    if status then
        return true
    else
        spdlog.error("Saving: "..tostring(err))
        return false
    end
end

-- Tries to load the settings from the savedSettings.json
-- returns bool: true if a file was found, false if not
-- TODO: Rewrite  <-- lmao
function saveSettings.tryToLoadSettings()
    local status, err = pcall(fileFunctions.load)
    if status then
        return true
    else
        spdlog.error("Loading: "..tostring(err))
        return false
    end
end


-- Util functions for only this file
fileFunctions = {}
function fileFunctions.save()
    local file = io.open(path, "w")
    local content = json.encode({settings=saveSettings.settings,options=saveSettings.options})
    file:write(content)
    file:close()
end

function fileFunctions.load()
    local file = io.open(path, "r")
    local content = file:read("*a")
    local jsonObject = json.decode(content)
    saveSettings.settings,saveSettings.options = jsonObject.settings,jsonObject.options
    file:close()
end


return saveSettings
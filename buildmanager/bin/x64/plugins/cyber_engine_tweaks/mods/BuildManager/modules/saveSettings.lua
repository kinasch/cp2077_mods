-- Default values are taken from the respective TweakDB defaults
saveSettings = {
    settings = {
        one = {
            -- Order: Attribute,Amount
            attributes = nil,
            -- Order: Perk1,Perk1,Perk2,Perk3,Perk3,Perk3
            perks = nil,
            -- Perk without limit thingies
            traits = nil,
            points = {
                perk = 0,
                attribute = 0,
            },
        },
        two = {
            -- Order: Attribute,Amount
            attributes = nil,
            -- Order: Perk1,Perk1,Perk2,Perk3,Perk3,Perk3
            perks = nil,
            -- Perk without limit thingies
            traits = nil,
            points = {
                perk = 0,
                attribute = 0,
            },
        }
    },
}

local path = "builds.json"

-- Tries to load the settings from the savedSettings.json
-- returns bool: true if a file was found, false if not
-- TODO: Rewrite
function saveSettings.tryToLoadSettings()
    local file = io.open(path,"r")
    if(file~=nil) then
        io.close(file)
        fileFunctions.load()
        return true
    else
        print("No saved settings file found.")
        -- fileFunctions.save()
        return false
    end
end

function saveSettings.tryToSaveSettings()
    local file = io.open(path,"r")
    if(file~=nil) then
        io.close(file)
        fileFunctions.save()
    else
        print("No saved settings file found. Creating one ...")
        fileFunctions.save()
    end
end


-- Util functions for only this file
fileFunctions = {}
function fileFunctions.save()
    local file = io.open(path, "w")
    local content = json.encode(saveSettings.settings)
    file:write(content)
    file:close()
end

function fileFunctions.load()
    local file = io.open(path, "r")
    local content = file:read("*a")
    saveSettings.settings = json.decode(content)
    file:close()
end


return saveSettings
-- Default values are taken from the respective TweakDB defaults
savedSettings = {
    settings = {
        suicide = {
            count = {
                default = 1,
                saved = 1
            },
            range = {
                default = -1,
                saved = -1
            }
        },
        systemCollapse = {
            count = {
                default = 1,
                saved = 1
            },
            range = {
                default = -1,
                saved = -1
            }
        },
    }
}

local path = "savedSettings.json"

-- Tries to load the settings from the savedSettings.json
-- returns bool: true if a file was found, false if not
function savedSettings.tryToLoadSettings()
    local file = io.open(path,"r")
    if(file~=nil) then
        io.close(file)
        fileFunctions.load()
        return true
    else
        print("No saved settings file found. Creating one ...")
        fileFunctions.save()
        return false
    end
end

function savedSettings.tryToSaveSettings()
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
    local content = json.encode(savedSettings.settings)
    file:write(content)
    file:close()
end

function fileFunctions.load()
    local file = io.open(path, "r")
    local content = file:read("*a")
    savedSettings.settings = json.decode(content)
    file:close()
end


return savedSettings
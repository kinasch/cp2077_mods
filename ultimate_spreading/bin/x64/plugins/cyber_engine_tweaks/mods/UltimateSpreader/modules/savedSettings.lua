-- Default values are taken from the respective TweakDB defaults
savedSettings = {
    -- TODO: Some defaults are wrong
    settings = {
        overload = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "Overload" },
        overheat = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "Overheat" },
        contagion = { count = { default = -1, saved = -1 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "Contagion" },
        brainMelt = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "BrainMelt" },
        blind = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "Blind" },
        weaponMalfunction = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "WeaponMalfunction" },
        locomotionMalfunction = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "LocomotionMalfunction" },
        cyberwareMalfunction = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "CyberwareMalfunction" },
        suicide = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "Suicide" },
        madness = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "Madness" },
        grenade = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "Grenade" },
        systemCollapse = { count = { default = 0, saved = 0 }, bonusJumps = { default = 0, saved = 0 }, range = { default = -1, saved = -1 }, name = "SystemCollapse" },
        blackWall = { count = { default = -1, saved = -1 }, bonusJumps = { default = 0, saved = 0 }, range = { default = 20, saved = 20 }, name = "BlackWall" }
    }
}

local path = "savedSettings.json"

-- Tries to load the settings from the savedSettings.json
-- returns bool: true if a file was found, false if not
-- MAYBE: Add taking the games values in case someone already played with the values.
function savedSettings.tryToLoadSettings()
    local file = io.open(path,"r")
    if(file~=nil) then
        io.close(file)
        fileFunctions.load()
        return true
    else
        --print("No saved settings file found. Creating one ...")
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
        --print("No saved settings file found. Creating one ...")
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
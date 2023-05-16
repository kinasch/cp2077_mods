-- Default values are taken from the respective TweakDB defaults
savedSettings = {
    settings = {
        suicide = {
            count = {
                default = 1,
                saved = 1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "Suicide"
        },
        systemCollapse = {
            count = {
                default = 1,
                saved = 1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "SystemCollapse"
        },
        contagion = {
            count = {
                default = -1,
                saved = -1
            },
            bonusJumps = {
                default = 1,
                saved = 1
            },
            range = {
                default = -1,
                saved = -1
            },name = "Contagion"
        },
        overheat = {
            count = {
                default = 2,
                saved = 2
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = 6,
                saved = 6
            },name = "Overheat"
        },
        blind = {
            count = {
                default = -1,
                saved = -1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "Blind"
        },
        cyberwareMalfunction = {
            count = {
                default = -1,
                saved = -1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "CyberwareMalfunction"
        },
        locomotionMalfunction = {
            count = {
                default = -1,
                saved = -1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "LocomotionMalfunction"
        },
        weaponMalfunction = {
            count = {
                default = -1,
                saved = -1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "WeaponMalfunction"
        },
        grenade = {
            count = {
                default = -1,
                saved = -1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "Grenade"
        },
        overload = {
            count = {
                default = 2,
                saved = 2
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = 6,
                saved = 6
            },name = "Overload"
        },
        brainMelt = {
            count = {
                default = 2,
                saved = 2
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = 6,
                saved = 6
            },name = "BrainMelt"
        },
        madness = {
            count = {
                default = -1,
                saved = -1
            },
            bonusJumps = {
                default = 0,
                saved = 0
            },
            range = {
                default = -1,
                saved = -1
            },name = "Madness"
        },
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
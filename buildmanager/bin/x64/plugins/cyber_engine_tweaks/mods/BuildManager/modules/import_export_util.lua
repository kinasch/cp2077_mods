local import_export_util = {}

---@type {body:string[],reflexes:string[],intelligence:string[],technicalAbility:string[],cool:string[],esp:string[]}
--- Lists containing all perks in their respective order
local perkLists = {
    body={"Body_Central_Milestone_1","Body_Central_Perk_1_1","Body_Central_Perk_1_2","Body_Central_Perk_1_3","Body_Central_Perk_1_4","Body_Right_Milestone_1","Body_Left_Milestone_2","Body_Left_Perk_2_1","Body_Left_Perk_2_3","Body_Left_Perk_2_4","Body_Right_Milestone_2","Body_Right_Perk_2_1","Body_Right_Perk_2_2","Body_Right_Perk_2_3","Body_Right_Perk_2_4","Body_Left_Milestone_3","Body_Left_Perk_3_1","Body_Left_Perk_3_2","Body_Left_Perk_3_3","Body_Left_Perk_3_4","Body_Inbetween_Left_3","Body_Central_Milestone_3","Body_Central_Perk_3_1","Body_Central_Perk_3_2","Body_Central_Perk_3_4","Body_Inbetween_Right_3","Body_Right_Milestone_3","Body_Right_Perk_3_1","Body_Right_Perk_3_2","Body_Master_Perk_1","Body_Master_Perk_2","Body_Master_Perk_3","Body_Master_Perk_5"},
    reflexes={"Reflexes_Left_Milestone_1","Reflexes_Central_Milestone_1","Reflexes_Central_Perk_1_1","Reflexes_Central_Perk_1_2","Reflexes_Central_Perk_1_3","Reflexes_Central_Perk_1_4","Reflexes_Left_Milestone_2","Reflexes_Left_Perk_2_2","Reflexes_Left_Perk_2_3","Reflexes_Left_Perk_2_4","Reflexes_Central_Milestone_2","Reflexes_Central_Perk_2_1","Reflexes_Central_Perk_2_2","Reflexes_Central_Perk_2_3","Reflexes_Central_Perk_2_4","Reflexes_Inbetween_Right_2","Reflexes_Right_Milestone_2","Reflexes_Right_Perk_2_1","Reflexes_Right_Perk_2_2","Reflexes_Right_Perk_2_3","Reflexes_Left_Milestone_3","Reflexes_Left_Perk_3_1","Reflexes_Left_Perk_3_2","Reflexes_Left_Perk_3_3","Reflexes_Left_Perk_3_4","Reflexes_Inbetween_Left_3","Reflexes_Central_Milestone_3","Reflexes_Central_Perk_3_2","Reflexes_Central_Perk_3_3","Reflexes_Right_Milestone_3","Reflexes_Right_Perk_3_1","Reflexes_Right_Perk_3_3","Reflexes_Right_Perk_3_4","Reflexes_Master_Perk_1","Reflexes_Master_Perk_2","Reflexes_Master_Perk_3","Reflexes_Master_Perk_5"},
    intelligence={"Intelligence_Left_Milestone_1","Intelligence_Left_Perk_1_1","Intelligence_Left_Perk_1_2","Intelligence_Central_Milestone_1","Intelligence_Central_Perk_1_1","Intelligence_Central_Perk_1_2","Intelligence_Central_Perk_1_3","Intelligence_Right_Milestone_1","Intelligence_Left_Milestone_2","Intelligence_Left_Perk_2_1","Intelligence_Left_Perk_2_2","Intelligence_Left_Perk_2_3","Intelligence_Left_Perk_2_4","Intelligence_Inbetween_Left_2","Intelligence_Central_Milestone_2","Intelligence_Central_Perk_2_1","Intelligence_Central_Perk_2_2","Intelligence_Central_Perk_2_3","Intelligence_Central_Perk_2_4","Intelligence_Inbetween_Right_2","Intelligence_Right_Milestone_2","Intelligence_Right_Perk_2_1","Intelligence_Right_Perk_2_2","Intelligence_Left_Milestone_3","Intelligence_Left_Perk_3_1","Intelligence_Left_Perk_3_2","Intelligence_Left_Perk_3_4","Intelligence_Inbetween_Left_3","Intelligence_Central_Milestone_3","Intelligence_Central_Perk_3_1","Intelligence_Central_Perk_3_2","Intelligence_Central_Perk_3_3","Intelligence_Right_Milestone_3","Intelligence_Right_Perk_3_1","Intelligence_Right_Perk_3_2","Intelligence_Master_Perk_1","Intelligence_Master_Perk_3","Intelligence_Master_Perk_4"},
    technicalAbility={"Tech_Left_Milestone_1","Tech_Left_Perk_1_1","Tech_Left_Perk_1_2","Tech_Right_Milestone_1","Tech_Left_Milestone_2","Tech_Left_Perk_2_1","Tech_Left_Perk_2_2","Tech_Left_Perk_2_3","Tech_Left_Perk_2_4","Tech_Central_Milestone_2","Tech_Central_Perk_2_1","Tech_Central_Perk_2_2","Tech_Central_Perk_2_3","Tech_Central_Perk_2_4","Tech_Inbetween_Right_2","Tech_Left_Milestone_3","Tech_Left_Perk_3_01","Tech_Left_Perk_3_2","Tech_Left_Perk_3_3","Tech_Left_Perk_3_4","Tech_Inbetween_Left_3","Tech_Central_Milestone_3","Tech_Central_Perk_3_1","Tech_Central_Perk_3_2","Tech_Central_Perk_3_3","Tech_Central_Perk_3_4","Tech_Right_Milestone_3","Tech_Right_Perk_3_1","Tech_Right_Perk_3_2","Tech_Right_Perk_3_3","Tech_Right_Perk_3_4","Tech_Master_Perk_2","Tech_Master_Perk_3","Tech_Master_Perk_5"},
    cool={"Cool_Left_Milestone_1","Cool_Central_Milestone_1","Cool_Central_Perk_1_1","Cool_Central_Perk_1_2","Cool_Central_Perk_1_4","Cool_Right_Milestone_1","Cool_Right_Perk_1_1","Cool_Right_Perk_1_2","Cool_Left_Milestone_2","Cool_Left_Perk_2_1","Cool_Left_Perk_2_2","Cool_Left_Perk_2_3","Cool_Left_Perk_2_4","Cool_Inbetween_Left_2","Cool_Right_Milestone_2","Cool_Right_Perk_1_1","Cool_Right_Perk_1_2","Cool_Right_Perk_1_3","Cool_Right_Perk_1_4","Cool_Left_Milestone_3","Cool_Left_Perk_3_1","Cool_Left_Perk_3_2","Cool_Left_Perk_3_3","Cool_Left_Perk_3_4","Cool_Inbetween_Left_3","Cool_Central_Milestone_3","Cool_Central_Perk_3_1","Cool_Central_Perk_3_2","Cool_Central_Perk_3_4","Cool_Inbetween_Right_3","Cool_Right_Milestone_3","Cool_Right_Perk_3_1","Cool_Right_Perk_3_2","Cool_Right_Perk_3_4","Cool_Master_Perk_1","Cool_Master_Perk_2","Cool_Master_Perk_4"},
    esp={"Espionage_Left_Milestone_Perk","Espionage_Left_Perk_1_2","Espionage_Central_Milestone_1","Espionage_Central_Perk_1_4","Espionage_Central_Perk_1_2","Espionage_Central_Perk_1_3","Espionage_Central_Perk_1_1","Espionage_Right_Milestone_1","Espionage_Right_Perk_1_1"}
}

--- Creates the save data from an official build planner url and returns it.
---@param playerDevelopmentData PlayerDevelopmentData
---@param url string
---@param util Util
---@return {attributes: table, perks: table, buildLevel: number, profs: table, usedPoints: number, equipment: table}
function import_export_util.setBuildFromURL(playerDevelopmentData,url,util)
    newSave = {attributes={},perks={},buildLevel=60,profs={}}

    -- Attributes
    aPattern = "?a=[0123456789abcdefghijk]*"
    local aString = string.sub(string.sub(url, string.find(url, aPattern)),4)
    aTable = {}
    ---@diagnostic disable-next-line: discard-returns
    aString:gsub(".",function(c) table.insert(aTable,tonumber(c,21)) end)
    attr = {"Strength","Reflexes","Intelligence","TechnicalAbility","Cool"}
    for index, value in ipairs(aTable) do
        table.insert(newSave.attributes,{name=attr[index],level=value})
    end

    -- Perks
    patterns = {body="&b=%d*",reflexes="&r=%d*",intelligence="&i=%d*",technicalAbility="&t=%d*",cool="&c=%d*",esp="&e=%d*"}

    filteredStringLists = {}
    for key, value in pairs(patterns) do
        local tempSubString = string.sub(string.sub(url, string.find(url, value)),4)
        local tempTable = {}
        tempSubString:gsub(".",function(c) table.insert(tempTable,tonumber(c)) end)
        filteredStringLists[key] = tempTable
    end
    
    for k,v in pairs(filteredStringLists) do
        for i,iv in ipairs(v) do
            if iv > 0 then
                table.insert(newSave.perks,{name=perkLists[k][i],level=iv})
            end
        end
    end

    newSave.profs = {
        {name="StrengthSkill",lvl=60,exp=0},
        {name="ReflexesSkill",lvl=60,exp=0},
        {name="CoolSkill",lvl=60,exp=0},
        {name="IntelligenceSkill",lvl=60,exp=0},
        {name="TechnicalAbilitySkill",lvl=60,exp=0}
    }

    return newSave
end

--- Create official build planner URL from current build
---@param playerDevelopmentData PlayerDevelopmentData
function import_export_util.getUrlForCurrentBuild(playerDevelopmentData, current_attributes, current_perks)
    attributesFromSave, perksFromSave = current_attributes, current_perks

    url = ""

    -- https://www.cyberpunk.net/de/build-planner?a=9kkf3&b=&r=&i=&t=&c=&e=
    urlComponents = {a="?a=",b="&b=",r="&r=",i="&i=",t="&t=",c="&c=",e="&e="}

    attrOrder = {"Strength","Reflexes","Intelligence","TechnicalAbility","Cool"}
    -- Horrible Big O, let's hope I will not do this again like 12 lines further down.
    for k,v in pairs(attrOrder) do
        for ak,av in pairs(attributesFromSave) do
            if v == av.name then
                urlComponents.a = urlComponents.a .. import_export_util.decimalToBase21(av.level)
            end
        end
    end

    url = url .. "https://www.cyberpunk.net/en/build-planner" .. urlComponents.a

    -- Combine all perkLists into one list.
    perkListsCombined = {}
    for k,v in pairs(perkLists) do
        for kk,vv in pairs(v) do
            table.insert(perkListsCombined,vv)
        end
    end
    -- Inverse Table for combined perkLists to index it.
    perkListsCombinedIndex = {}
    for i,v in ipairs(perkListsCombined) do
        perkListsCombinedIndex[v]=i
    end
    -- Ordering the perk levels by the official build planner order
    -- First: Create a list filled with 0 times the number of perks
    perkOrder = {}
    for i=0,#perkListsCombined do
        perkOrder[i] = 0
    end
    -- Second: Fill this list with the corresponding levels
    for k, v in pairs(perksFromSave) do
        localLevel = v.level
        if string.find(v.name,"Espionage") and string.find(v.name,"Milestone") then
            localLevel = 3
        end
        perkOrder[perkListsCombinedIndex[v.name]] = localLevel
    end

    -- Use this list to create the url components
    for key, value in pairs(perkLists) do
        for k,v in pairs(value) do
            urlComponents[string.sub(key,0,1)] = urlComponents[string.sub(key,0,1)] .. perkOrder[perkListsCombinedIndex[v]]
        end
    end

    for key, value in pairs(urlComponents) do
        if not (key == "a") then
            url = url .. value
        end
    end

    return url
end

---Converts a decimal number greater 0 to a number base 21
---@param number number
---@return string
function import_export_util.decimalToBase21(number)
    number = number % 21
    b21str = ""
    if number < 16 then
        b21str = string.format("%x", number)
    else
        for k, v in pairs({g=16,h=17,i=18,j=19,k=20}) do
            if number == v then
               b21str = k
               break
            end
        end
    end
    return b21str
end

return import_export_util
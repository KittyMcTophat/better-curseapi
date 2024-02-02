local mod = require("scripts.bettercurseapi");
local json = require("json");

local function loadTable(sourceTable, destinationTable)
    for k, _ in pairs(destinationTable) do
        if sourceTable[k] ~= nil then
            local type_s = type(sourceTable[k]);
            local type_d = type(destinationTable[k]);

            if type_s == "table" and type_d == "table" then
                loadTable(sourceTable[k], destinationTable[k]);
            elseif type_s == type_d then
                destinationTable[k] = sourceTable[k];
            else
                if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Type mismatch in key '" .. k .. "' expected " .. type_d .. " but got " .. type_s .. ". Value was not loaded") end;
            end
        end;
    end
end

local function loadSettings()
    -- Reset settings in case something got broken
    mod:loadDefaultSettings();

    if not mod:HasData() then
        if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": No data to load") end;
        return;
    end;

    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Loading config data") end;

    local jsonString = mod:LoadData();
    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": " .. jsonString) end;

    local loadData
    if (pcall(function()
        loadData = json.decode(jsonString);
    end)) then
        if type(loadData) == "table" then
            loadTable(loadData, mod.settings);
        else
            if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Load failed. Using default config.") end;
        end
    else
        if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Malformed json, load failed.") end;
    end

    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": New config data: " .. json.encode(mod.settings)) end;
end

if not REPENTOGON then
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, loadSettings); -- load config data before a run
else
    -- Fixes the bug where config isn't loaded for first floor curse generation.
    -- As far as I'm aware, there isn't a non-repentogon way to fix this bug.
    local loadedSlot = -1;

    function mod:repentogonLoad(saveslot, isslotselected, rawslot)
        if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": MC_POST_SAVESLOT_LOAD " .. tostring(saveslot) .. " " .. tostring(isslotselected) .. " " .. tostring(rawslot)) end;

        if not isslotselected then return end;
        if rawslot == 0 then return end;
        if saveslot == loadedSlot then return end;

        loadedSlot = saveslot;
        loadSettings();
    end

    mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, mod.repentogonLoad);
end

function mod:saveSettings()
    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Saving config data") end;
    local jsonString = json.encode(mod.settings)
    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": " .. jsonString) end;
    mod:SaveData(jsonString)

    -- Dequeue the save, since it has been saved now
    mod:RemoveCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.saveSettings);
end

function mod:queueSave()
    mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.saveSettings);
end

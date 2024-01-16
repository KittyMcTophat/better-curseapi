local mod = require("scripts.bettercurseapi");

local function descriptionTable(table)
    if not mod.enable_config then
        return {"THIS OPTION IS OVERRIDDEN BY ANOTHER MOD AND CANNOT BE CHANGED"};
    else
        return table;
    end
end

------------------------------------- GENERAL -------------------------------------

mod.MCM_GENERAL_TAB = "General";

ModConfigMenu.AddTitle(mod.MOD_NAME, mod.MCM_GENERAL_TAB, "Version " .. mod.MOD_VERSION);

ModConfigMenu.AddSpace(mod.MOD_NAME, mod.MCM_GENERAL_TAB);

-- mod.settings.force_curse
ModConfigMenu.AddSetting(
    mod.MOD_NAME,
    mod.MCM_GENERAL_TAB,
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return mod.settings.force_curse;
        end,
        Display = function()
            return "Force Curse: " .. (mod.settings.force_curse and "On" or "Off");
        end,
        OnChange = function (b)
            if mod.enable_config then
                mod.settings.force_curse = b;
                mod:queueSave();
            end
        end,
        Info = function ()
            return descriptionTable({"Default value: Off", "If On, every floor will be forced to have a curse."});
        end
    }
);

-- mod.settings.force_curse_bitmask
ModConfigMenu.AddSetting(
    mod.MOD_NAME,
    mod.MCM_GENERAL_TAB,
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return mod.settings.force_curse_bitmask;
        end,
        Minimum = -1,
        Maximum = 2147483647,
        Display = function()
            return "Force Curse Bitmask: " .. (mod.settings.force_curse_bitmask == -1 and "None" or mod.settings.force_curse_bitmask);
        end,
        OnChange = function (n)
            if mod.enable_config then
                mod.settings.force_curse_bitmask = n;
                mod:queueSave();
            end
        end,
        Info = function ()
            return descriptionTable({"Default value: None", "Force a specific curse bitmask on a new floor.","Leave at None if you don't understand"});
        end
    }
);

ModConfigMenu.AddSpace(mod.MOD_NAME, mod.MCM_GENERAL_TAB);

local MAX_CURSES_OPTIONS = 100;
-- mod.settings.max_curses
ModConfigMenu.AddSetting(
    mod.MOD_NAME,
    mod.MCM_GENERAL_TAB,
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return mod.settings.max_curses;
        end,
        Minimum = 0,
        Maximum = MAX_CURSES_OPTIONS,
        Display = function()
            return "Maximum Curses: " .. mod.settings.max_curses;
        end,
        OnChange = function (n)
            if mod.enable_config then
                mod.settings.max_curses = n;
                mod:queueSave();
            end
        end,
        Info = function ()
            return descriptionTable({"Default value: 1", "The maximum number of curses that will be generated on a new floor."});
        end
    }
);

local ADDITIONAL_CURSE_CHANCE_OPTIONS = 20;
-- mod.settings.additional_curse_chance
ModConfigMenu.AddSetting(
    mod.MOD_NAME,
    mod.MCM_GENERAL_TAB,
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return mod.settings.additional_curse_chance * ADDITIONAL_CURSE_CHANCE_OPTIONS;
        end,
        Minimum = 0,
        Maximum = ADDITIONAL_CURSE_CHANCE_OPTIONS,
        Display = function()
            local additional_curse_chance = mod.settings.additional_curse_chance;

            return "Additional Curse Chance: " .. (additional_curse_chance * 100) .. "%";
        end,
        OnChange = function (n)
            if mod.enable_config then
                mod.settings.additional_curse_chance = n / ADDITIONAL_CURSE_CHANCE_OPTIONS;
                mod:queueSave();
            end
        end,
        Info = function ()
            return descriptionTable({"Default value: 0%", "The chance to add an additional curse after each curse added."});
        end
    }
);

----------------------------------- END GENERAL -----------------------------------

------------------------------------- CURSES  -------------------------------------

mod.MCM_CURSES_TAB = "Curses";

local MAX_WEIGHT = 5;
local WEIGHT_STEP = 10;

local function addCurseConfigToMCM(curse, paramsTable)
    ModConfigMenu.AddTitle(mod.MOD_NAME, mod.MCM_CURSES_TAB, curse.name);

    if (paramsTable.text) then
        ModConfigMenu.AddText(mod.MOD_NAME, mod.MCM_CURSES_TAB, paramsTable.text, (paramsTable.textColor and paramsTable.textColor or {0.0, 0.0, 0.0}))
    end

    -- enabled
    ModConfigMenu.AddSetting(
        mod.MOD_NAME,
        mod.MCM_CURSES_TAB,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = paramsTable.enabled_current_setting,
            Display = function()
                return "Enabled: " .. (paramsTable.enabled_current_setting() and "On" or "Off");
            end,
            OnChange = paramsTable.on_change_enabled,
            Info = function ()
                return descriptionTable({"Default value: " .. (paramsTable.default_enabled and "On" or "Off"), "If Off, the curse will not generate."});
            end
        }
    );

    -- weight
    ModConfigMenu.AddSetting(
        mod.MOD_NAME,
        mod.MCM_CURSES_TAB,
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function() return mod:curseWeight(curse) * WEIGHT_STEP end,
            Minimum = 0,
            Maximum = MAX_WEIGHT * WEIGHT_STEP,
            Display = function()
                return "Weight: " .. mod:curseWeight(curse);
            end,
            OnChange = function (n)
                paramsTable.on_weight_change(n / WEIGHT_STEP);
            end,
            Info = function ()
                return descriptionTable({"Default value: " .. paramsTable.default_weight, "The relative frequency of this curse.", "A curse with 2.0 is twice as likely as a curse with 1.0"});
            end
        }
    );

    ModConfigMenu.AddSpace(mod.MOD_NAME, mod.MCM_CURSES_TAB);
end

local function addVanillaCurseConfig(id)
    local paramsTable = {
        enabled_current_setting = function () return mod.settings.default_curses_enabled[id] end;
        on_change_enabled = function (b)
            mod.settings.default_curses_enabled[id] = b;
            mod:queueSave();
        end;
        default_enabled = true;
        on_weight_change = function (n)
            mod.settings.default_curses_weights[id] = n;
            mod:queueSave();
        end;
        default_weight = 1.0;
    }

    if (id == 5 or id == 8) then -- All except Curse of the Cursed and Curse of the Giant are enabled by default
        paramsTable.default_enabled = false;
    end

    if (id == 8) then -- Curse of the Giant
        paramsTable.text = "WARNING: Enabling may cause crashes";
        paramsTable.textColor = { 1.0, 0.0, 0.0 };
    end

    addCurseConfigToMCM(mod.curses[id], paramsTable);
end

for i = 1, 8 do
    addVanillaCurseConfig(i);
end

function mod:addCurseConfig(curse_id, paramsTable)
    local curse = mod:getCurseByID(curse_id);
    addCurseConfigToMCM(curse, paramsTable);
end

----------------------------------- END CURSES ------------------------------------

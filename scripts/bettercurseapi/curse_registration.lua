local mod = require("scripts.bettercurseapi");

-- Placeholder warning if neither curse icon method is present
local function addCurseIcon(curse_id, curse_icon)
    if curse_icon == nil then return end;

    warn("Neither MinimapAPI nor REPENTOGON are present, modded curse icons will not be rendered");
end

if MinimapAPI then
    -- Add the curse's icon using MiniMAPI
    addCurseIcon = function (curse_id, curse_icon)
        if curse_icon == nil then return end;
        
        MinimapAPI:AddMapFlag(
            curse_id,
            function() return mod:curseIsActive(curse_id) end,
            curse_icon[1], -- Fuck you lua, arrays start at 0
            curse_icon[2],
            curse_icon[3]
        )
    end
elseif REPENTOGON then
    -- Add the curse's icon using REPENTOGON
    local repentogon_curse_icon_renderer = require("scripts.bettercurseapi.repentogon.curse_icon_renderer");

    addCurseIcon = function (curse_id, curse_icon)
        if curse_icon == nil then return end;

        repentogon_curse_icon_renderer:addIcon(curse_id, curse_icon);
    end
end

local function addCurseToTable(new_curse_id, new_curse_name, new_curse_weight, new_curse_is_allowed, new_curse_icon)
    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Registering curse \"" .. new_curse_name .. "\" with id " .. new_curse_id) end;

    table.insert(mod.curses, {
        id = new_curse_id;
        name = new_curse_name;
        weight = new_curse_weight;
        is_allowed = new_curse_is_allowed;
    });

    addCurseIcon(new_curse_id, new_curse_icon);
end

-- Only useful for a hypothetical CurseAPI -> Better CurseAPI translator
-- Use BetterCurseAPI:registerCurse instead if you're making a BetterCurseAPI mod
function mod:registerCurseByID(new_curse_id, new_curse_weight, new_curse_is_allowed, new_curse_icon)
    addCurseToTable(new_curse_id, "CURSE_ID_" .. new_curse_id, new_curse_weight, new_curse_is_allowed, new_curse_icon);
end

-- Adds a curse to the pool and returns its id.
-- Returns -1 if the curse was not found.
function mod:registerCurse(new_curse_name, new_curse_weight, new_curse_is_allowed, new_curse_icon)
    local new_curse_id = Isaac.GetCurseIdByName(new_curse_name);

    if new_curse_id ~= -1 then
        addCurseToTable(new_curse_id, new_curse_name, new_curse_weight, new_curse_is_allowed, new_curse_icon);
    else
        if mod.DEBUG then
            print(mod.MOD_NAME_SHORT .. ": Could not find curse \"" .. new_curse_name .. "\"");
            print(mod.MOD_NAME_SHORT .. ": Curse \"" .. new_curse_name .. "\" was not registered");
        end;
    end

    return new_curse_id;
end

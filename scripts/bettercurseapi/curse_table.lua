local mod = require("scripts.bettercurseapi");

mod.curses = {
    {
        id = 1;
        name = "Curse of Darkness";
        weight = function () return mod.settings.default_curses_weights[1] end;
        is_allowed = function() return mod.settings.default_curses_enabled[1] end;
    },
    {
        id = 2;
        name = "Curse of the Labyrinth";
        weight = function () return mod.settings.default_curses_weights[2] end;
        is_allowed = function()
            local level_stage = Game():GetLevel():GetStage();
            return Game():GetLevel():CanStageHaveCurseOfLabyrinth(level_stage) and mod.settings.default_curses_enabled[2];
        end;
    },
    {
        id = 3;
        name = "Curse of the Lost";
        weight = function () return mod.settings.default_curses_weights[3] end;
        is_allowed = function() return mod.settings.default_curses_enabled[3] end;
    },
    {
        id = 4;
        name = "Curse of the Unknown";
        weight = function () return mod.settings.default_curses_weights[4] end;
        is_allowed = function() return mod.settings.default_curses_enabled[4] end;
    },
    {
        id = 5;
        name = "Curse of the Cursed";
        weight = function () return mod.settings.default_curses_weights[5] end;
        is_allowed = function() return mod.settings.default_curses_enabled[5] end;
    },
    {
        id = 6;
        name = "Curse of the Maze";
        weight = function () return mod.settings.default_curses_weights[6] end;
        is_allowed = function() return mod.settings.default_curses_enabled[6] end;
    },
    {
        id = 7;
        name = "Curse of the Blind";
        weight = function () return mod.settings.default_curses_weights[7] end;
        is_allowed = function() return mod.settings.default_curses_enabled[7] end;
    },
    {
        id = 8;
        name = "Curse of the Giant";
        weight = function () return mod.settings.default_curses_weights[8] end;
        is_allowed = function() return mod.settings.default_curses_enabled[8] end;
    },
};


function mod:curseWeight(curse)
    local weight_type = type(curse.weight);
    if weight_type == "function" then
        return curse.weight();
    elseif weight_type == "number" then
        return curse.weight;
    else
        error(mod.MOD_NAME_SHORT .. ": Invalid type for curse.is_allowed: " .. weight_type);
    end
end

function mod:curseIsAllowed(curse)
    local ia_type = type(curse.is_allowed);
    if ia_type == "function" then
        return curse.is_allowed();
    elseif ia_type == "boolean" then
        return curse.is_allowed;
    else
        error(mod.MOD_NAME_SHORT .. ": Invalid type for curse.is_allowed: " .. ia_type);
    end
end

function mod:getCurseByID(curse_id)
    for _, curse in ipairs(mod.curses) do
        if curse.id == curse_id then return curse end;
    end
    return { id = 0; name = 0; weight = 0.0; is_allowed = false; };
end

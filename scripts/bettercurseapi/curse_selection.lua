local mod = require("scripts.bettercurseapi");

local function getValidCurses(current_curses)
    local valid_curses = {};
    for _, curse in ipairs(mod.curses) do
        if mod:curseIsAllowed(curse) and not mod:curseInBitmask(curse.id, current_curses) then
            table.insert(valid_curses, curse);
        end
    end

    if mod.DEBUG then
        local to_print = mod.MOD_NAME_SHORT .. ": Valid Curses:";
        for _, curse in ipairs(valid_curses) do
            to_print = to_print .. " " .. curse.name .. " (" .. curse.id .. ")";
        end
        print(to_print);
    end

    return valid_curses;
end

local function getTotalWeight(curses_table)
    local total_weight = 0.0;
    for _, curse in ipairs(curses_table) do
        total_weight = total_weight + mod:curseWeight(curse);
    end
    return total_weight;
end

local function pickNewCurse(rng, current_curses)
    local valid_curses = getValidCurses(current_curses);

    local selection = rng:RandomFloat() * getTotalWeight(valid_curses);

    for _, curse in ipairs(valid_curses) do
        selection = selection - mod:curseWeight(curse);
        if selection < 0.0 then return curse end;
    end

    return { id = 0; name = "none"; }; -- Should never be reached, but left just in case
end

function mod:pickCurses(rng)
    local new_curses = 0;

    local add_curse = true;
    local num_curses = 0;
    while add_curse do
        local added_curse = pickNewCurse(rng, new_curses);
        if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Adding \"" .. added_curse.name .. "\"") end;
        if added_curse.id == 0 then add_curse = false end;

        if add_curse then
            new_curses = new_curses | mod:curseBit(added_curse.id);
            num_curses = num_curses + 1;

            if num_curses >= mod.settings.max_curses then add_curse = false end;
            if rng:RandomFloat() >= mod.settings.additional_curse_chance then add_curse = false end;
        end
    end

    return new_curses;
end

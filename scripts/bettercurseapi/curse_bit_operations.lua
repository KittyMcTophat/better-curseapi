local mod = require("scripts.bettercurseapi");

function mod:curseBit(curse_id)
    return 1 << (curse_id - 1);
end

function mod:curseInBitmask(curse_id, bitmask)
    local curse_bit = mod:curseBit(curse_id);
    return bitmask & curse_bit ~= 0;
end

local function getCurses()
    return Game():GetLevel():GetCurses();
end

function mod:curseIsActive(curse_id)
    local curses = getCurses();
    return mod:curseInBitmask(curse_id, curses);
end

function mod:addCurse(curse_id, showName)
    Game():GetLevel():AddCurse(mod:curseBit(curse_id), showName);
end

function mod:removeCurse(curse_id)
    Game():GetLevel():RemoveCurses(mod:curseBit(curse_id));
end

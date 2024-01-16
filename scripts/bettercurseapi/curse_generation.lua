local mod = require("scripts.bettercurseapi");

require("scripts.bettercurseapi.curse_selection");

local function curseEval(bitmask)
    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Curse eval started") end;

    local curses = Game():GetLevel():GetCurses();

    if mod.settings.force_curse_bitmask >= 0 then
        if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Replacing old curse bitmask of ".. curses .. " with forced curse bitmask of " .. mod.settings.force_curse_bitmask) end;
        return mod.settings.force_curse_bitmask;
    end;

    if not mod.settings.force_curse then -- Skip checking if there should always be a curse

        if mod.settings.max_curses == 0 then
            if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Max curses = 0, no curses will be applied") end;
            return LevelCurse.CURSE_NONE;
        end -- Curses have been disabled

        if curses == LevelCurse.CURSE_NONE then 
            if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": No curses this floor") end;
            return nil
        end -- No curse for this floor, so no need to see if it'd be replaced

    end

    local SHIFT_INDEX = 35;
    local level_stage = Game():GetLevel():GetStage();
    local stage_seed = Game():GetSeeds():GetStageSeed(level_stage);

    local rng = RNG();
    rng:SetSeed(stage_seed, SHIFT_INDEX);

    local new_curses = mod:pickCurses(rng);

    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": Replacing old curse bitmask of", curses, "with", new_curses) end;
    return new_curses;
end

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, curseEval);

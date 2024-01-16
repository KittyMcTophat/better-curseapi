local mod = require("scripts.bettercurseapi");

mod.default_settings = {
    -- If true, force curses to spawn every floor
    force_curse = false;

    -- If 0 or greater, forces a specific curse bitmask
    -- Just leave it at -1 if you don't understand
    force_curse_bitmask = -1;

    -- The maximum number of curses a floor will start with.
    -- default value = 1
    max_curses = 1;

    -- x/1 chance to add another curse after each curse added.
    -- default value = 0.0
    additional_curse_chance = 0.0;

    default_curses_enabled = {
        true, -- Curse of Darkness
        true, -- Curse of the Labyrinth
        true, -- Curse of the Lost
        true, -- Curse of the Unknown
        false, -- Curse of the Cursed
        true, -- Curse of the Maze
        true, -- Curse of the Blind
        false, -- Curse of the Giant
    };

    default_curses_weights = {
        1.0, -- Curse of Darkness
        1.0, -- Curse of the Labyrinth
        1.0, -- Curse of the Lost
        1.0, -- Curse of the Unknown
        1.0, -- Curse of the Cursed
        1.0, -- Curse of the Maze
        1.0, -- Curse of the Blind
        1.0, -- Curse of the Giant
    };
};

mod.settings = {};

local function deepcopy(table, destination)
    for k, value in pairs(table) do
        if type(value) == "table" then
            destination[k] = {};
            deepcopy(value, destination[k]);
        else
            destination[k] = value;
        end
    end
end

function mod:loadDefaultSettings()
    mod.settings = {};
    deepcopy(mod.default_settings, mod.settings);
end
mod:loadDefaultSettings();

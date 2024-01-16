local mod = require("scripts.bettercurseapi");

-- If set to false, Mod Config Menu can't change settings
-- Always true unless another mod has changed its value
-- If you need to override something, set this to false so the player can't break it
mod.enable_config = true;

require("scripts.bettercurseapi.settings_table");

require("scripts.bettercurseapi.curse_table");

require("scripts.bettercurseapi.curse_bit_operations");

require("scripts.bettercurseapi.curse_registration");

require("scripts.bettercurseapi.curse_generation");

require("scripts.bettercurseapi.settings_io");

if ModConfigMenu then
    require("scripts.bettercurseapi.mod_config_menu_setup");
end

print("Loaded " .. mod.MOD_NAME .. " Version " .. mod.MOD_VERSION);

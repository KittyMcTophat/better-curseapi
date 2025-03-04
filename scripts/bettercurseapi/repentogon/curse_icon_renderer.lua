local mod = require("scripts.bettercurseapi");

local curse_icon_renderer = {};

curse_icon_renderer.icons = {};

function curse_icon_renderer:addIcon(curse_id, curse_icon)
    curse_icon_renderer.icons[curse_id] = curse_icon;
    if mod.DEBUG then print(mod.MOD_NAME_SHORT .. ": curse_icon_renderer.icons = " .. tostring(curse_icon_renderer.icons)) end;
end

function curse_icon_renderer:renderCurseIcons()
    local icons_to_render = {};

    for curse_id, curse_icon in ipairs(curse_icon_renderer.icons) do
        if mod:curseIsActive(curse_id) then
            table.insert(icons_to_render, curse_icon);
        end;
    end

    -- Implement renderCurseIcons
end

-- renderCurseIcons is not yet implemented
-- mod:AddCallback(ModCallbacks.MC_HUD_RENDER, curse_icon_renderer.renderCurseIcons);

return curse_icon_renderer;

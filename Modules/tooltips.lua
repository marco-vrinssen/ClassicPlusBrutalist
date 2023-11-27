local function TooltipUpdate(tooltip, parent)
    if tooltip:GetAnchorType() ~= "ANCHOR_CURSOR" then
        tooltip:ClearAllPoints()
        tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -16, 16)
    end
    GameTooltipStatusBar:Hide()
end


hooksecurefunc("GameTooltip_SetDefaultAnchor", TooltipUpdate)
GameTooltip:HookScript("OnTooltipSetUnit", TooltipUpdate)
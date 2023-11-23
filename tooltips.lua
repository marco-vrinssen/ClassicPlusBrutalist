local function TooltipAnchorUpdate(tooltip, parent)
    if tooltip:GetAnchorType() ~= "ANCHOR_CURSOR" then
        tooltip:ClearAllPoints()
        tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -16, 16)
    end
    GameTooltipStatusBar:Hide()
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", TooltipAnchorUpdate)
GameTooltip:HookScript("OnTooltipSetUnit", TooltipAnchorUpdate)
local function PlayerAurasUpdate()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOP", UIParent, "TOP", 0, -16)
    BuffFrame:SetHeight(8)
end

local PlayerAurasEventFrame = CreateFrame("Frame")
PlayerAurasEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerAurasEventFrame:RegisterEvent("ZONE_CHANGED")
PlayerAurasEventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
PlayerAurasEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
PlayerAurasEventFrame:SetScript("OnEvent", PlayerAurasUpdate)
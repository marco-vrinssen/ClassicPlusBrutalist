local function PlayerAurasUpdate()
    
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOP", UIParent, "TOP", 0, -16)
    BuffFrame:SetHeight(16)

end

local PlayerAurasEventFrame = CreateFrame("FRAME")
PlayerAurasEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerAurasEventFrame:SetScript("OnEvent", PlayerAurasUpdate)
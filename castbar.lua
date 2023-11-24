local CastingBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
CastingBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -2, 4)
CastingBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 2, -4)
CastingBarBackdrop:SetBackdrop({
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 14
})
CastingBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
CastingBarBackdrop:SetFrameStrata("HIGH")

local function CastingBarUpdate()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 20)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 50)
    CastingBarFrame:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:SetTexture(nil)
    CastingBarFrame.Flash:SetTexture(nil)
    
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 10)
end

local CastingBarEventFrame = CreateFrame("Frame")
CastingBarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CastingBarEventFrame:SetScript("OnEvent", CastingBarUpdate)
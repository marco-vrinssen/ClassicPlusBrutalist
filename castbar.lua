local CastBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
CastBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -2, 4)
CastBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 2, -4)
CastBarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
CastBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
CastBarBackdrop:SetFrameStrata("HIGH")

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

local CastBarEventFrame = CreateFrame("Frame")
CastBarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CastBarEventFrame:SetScript("OnEvent", CastingBarUpdate) 
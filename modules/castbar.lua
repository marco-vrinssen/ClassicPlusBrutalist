local CastbarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
CastbarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -2, 3)
CastbarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 2, -3)
CastbarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
CastbarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
CastbarBackdrop:SetFrameStrata("HIGH")

local function CastbarUpdate()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 24)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 202)
    CastingBarFrame:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    CastingBarFrame:SetStatusBarColor(0, 1, 0, 1)

    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:SetTexture(nil)
    CastingBarFrame.Flash:SetTexture(nil)
    
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 10)
end

local CastbarEventFrame = CreateFrame("Frame")
CastbarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CastbarEventFrame:SetScript("OnEvent", CastbarUpdate)
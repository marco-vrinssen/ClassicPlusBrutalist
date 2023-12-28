local function XPUpdate()
    CharacterModelFrameRotateLeftButton:Hide()
    CharacterModelFrameRotateRightButton:Hide()

    CharacterLevelText:ClearAllPoints()
    CharacterLevelText:SetPoint("TOP", CharacterFrame, "TOP", 0, -44)

    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local missingXP = maxXP - currentXP
    local restedXP = GetXPExhaustion() or 0
    local xpPercent = floor((currentXP / maxXP) * 100)
    local restedPercent = floor((restedXP / maxXP) * 100)
    local characterLevel = UnitLevel("player")  

    local xpText = string.format("Level: |cffFFFFFF%d|r / Progress: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r\nLevel Up: |cffFFFFFF+%d|r / Rested: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r",
        characterLevel, xpPercent, currentXP, missingXP, restedPercent, restedXP)

    CharacterLevelText:SetText(xpText)
end

CharacterFrame:SetScript("OnShow", XPUpdate)

local XPEventFrame = CreateFrame("Frame")
XPEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
XPEventFrame:RegisterEvent("PLAYER_LEVEL_UP")
XPEventFrame:RegisterEvent("PLAYER_XP_UPDATE")
XPEventFrame:RegisterEvent("UPDATE_EXHAUSTION")
XPEventFrame:SetScript("OnEvent", XPUpdate)
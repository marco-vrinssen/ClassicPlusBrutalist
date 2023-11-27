local PlayerFrameBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
PlayerFrameBackdrop:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 48)
PlayerFrameBackdrop:SetPoint("BOTTOMRIGHT", MultiBarBottomLeftButton3, "TOPRIGHT", 0, 48)
PlayerFrameBackdrop:SetHeight(48)
PlayerFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
PlayerFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PlayerFrameBackdrop:SetFrameStrata("HIGH")


local PlayerPortraitBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
PlayerPortraitBackdrop:SetPoint("RIGHT", PlayerFrameBackdrop, "LEFT", -4, 0)
PlayerPortraitBackdrop:SetSize(48 ,48)
PlayerPortraitBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
PlayerPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PlayerPortraitBackdrop:SetFrameStrata("HIGH")


local function PlayerFrameUpdate()
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT", PlayerPortraitBackdrop, "TOPLEFT", 0, 0)
    PlayerFrame:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", 0, 0)

    PlayerFrameBackground:ClearAllPoints()
    PlayerFrameBackground:SetPoint("TOPLEFT", PlayerFrameBackdrop, "TOPLEFT", 2, -2)
    PlayerFrameBackground:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", -2, 4)

    PlayerFrameTexture:SetTexture(nil)
    PlayerStatusGlow:SetAlpha(0)
    PlayerStatusTexture:Hide()
    PlayerStatusTexture:SetTexture(nil)
    PlayerAttackBackground:SetTexture(nil)
    PlayerAttackGlow:SetTexture(nil)
    PlayerAttackIcon:SetTexture(nil)
    PlayerRestGlow:SetTexture(nil)
    PlayerRestIcon:SetTexture(nil)
    PlayerPVPIcon:SetAlpha(0)
    PlayerPVPTimerText:Hide()

    PlayerLeaderIcon:ClearAllPoints()
    PlayerLeaderIcon:SetPoint("BOTTOM", PlayerPortraitBackdrop, "TOP", 0, 0)

    PlayerFrameGroupIndicator:Hide()
    PlayerFrameGroupIndicator.Show = PlayerFrameGroupIndicator.Hide

    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOP", PlayerFrameBackdrop, "TOP", 0, -6)
    PlayerName:SetFont(STANDARD_TEXT_FONT, 10)
    PlayerName:SetTextColor(1, 1, 1, 1)

    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetSize(PlayerFrameBackground:GetWidth(), 16)
    PlayerFrameHealthBar:SetPoint("BOTTOM", PlayerFrameManaBar, "TOP", 0, 0)
    PlayerFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 4)
    PlayerFrameManaBar:SetSize(PlayerFrameBackground:GetWidth(), 8)
    PlayerFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
    PlayerFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -4, 0)
    PlayerFrameHealthBarTextRight:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 4, 0)
    PlayerFrameHealthBarTextLeft:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

    PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
    PlayerFrameManaBarText:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextLeft:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 4, 0)
    PlayerFrameManaBarTextLeft:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextRight:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -4, 0)
    PlayerFrameManaBarTextRight:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")

    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint("CENTER", PlayerPortraitBackdrop, "CENTER", 0, 0)
    PlayerPortrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
    PlayerPortrait:SetSize(PlayerPortraitBackdrop:GetHeight()-6, PlayerPortraitBackdrop:GetHeight()-6)
    
    PlayerFrame:UnregisterEvent( "UNIT_COMBAT" )

    PlayerLevelText:SetPoint("TOP", PlayerPortraitBackdrop, "BOTTOM", 0, -4)
    PlayerLevelText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerLevelText:SetTextColor(1, 1, 1, 1)

    if UnitLevel("player") == 60 then
        PlayerLevelText:Hide()
    end
end


hooksecurefunc("PlayerFrame_Update", PlayerFrameUpdate)


local PlayerFrameEventFrame = CreateFrame("Frame")
PlayerFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerFrameEventFrame:RegisterEvent("PLAYER_LOGIN")
PlayerFrameEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
PlayerFrameEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
PlayerFrameEventFrame:SetScript("OnEvent", PlayerFrameUpdate)


local PetFrameBackdrop = CreateFrame("Frame", nil, PetFrame, "BackdropTemplate")
PetFrameBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", -4, 0)
PetFrameBackdrop:SetSize(48, 24)
PetFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 12})
PetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PetFrameBackdrop:SetFrameStrata("HIGH")


local function PetFrameUpdate()
    PetFrame:ClearAllPoints()
    PetFrame:SetPoint("CENTER", PetFrameBackdrop, "CENTER", 0, 0)

    PetFrameTexture:Hide()
    PetAttackModeTexture:SetTexture(nil)

    PetName:ClearAllPoints()
    PetName:SetPoint("BOTTOM", PetFrameBackdrop, "TOP", 0, 4)
    PetName:SetTextColor(1, 1, 1, 1)

    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
    PetFrameHealthBar:SetPoint("TOP", PetFrameBackdrop, "TOP", 0, -2)
    PetFrameHealthBar:SetWidth(PetFrameBackdrop:GetWidth()-6)
    PetFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("BOTTOM", PetFrameBackdrop, "BOTTOM", 0, 2)
    PetFrameManaBar:SetHeight(8)
    PetFrameManaBar:SetWidth(PetFrameBackdrop:GetWidth()-6)
    PetFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    
    PetFrameHealthBarText:SetAlpha(0)
    PetFrameHealthBarTextLeft:SetAlpha(0)
    PetFrameHealthBarTextRight:SetAlpha(0)

    PetFrameManaBarText:SetAlpha(0)
    PetFrameManaBarTextLeft:SetAlpha(0)
    PetFrameManaBarTextRight:SetAlpha(0)

    PetPortrait:Hide()
    PetFrame:UnregisterEvent("UNIT_COMBAT")

    PetFrameHappiness:ClearAllPoints()
    PetFrameHappiness:SetPoint("RIGHT", PetFrameBackdrop, "LEFT", 0, 0)
end


hooksecurefunc("PetFrame_Update", PetFrameUpdate)


local PetFrameEventFrame = CreateFrame("Frame")
PetFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PetFrameEventFrame:RegisterEvent("UNIT_PET")
PetFrameEventFrame:RegisterEvent("PET_UI_UPDATE")
PetFrameEventFrame:SetScript("OnEvent", PetFrameUpdate)
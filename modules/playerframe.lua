local PlayerFrameBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", -190, 200)
PlayerFrameBackdrop:SetSize(124, 48)
PlayerFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
PlayerFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PlayerFrameBackdrop:SetFrameStrata("HIGH")

PlayerFrameBackdrop:SetAttribute("unit", "player")
PlayerFrameBackdrop:RegisterForClicks("AnyUp")
PlayerFrameBackdrop:SetAttribute("type1", "target")
PlayerFrameBackdrop:SetAttribute("type2", "togglemenu")

local PlayerPortraitBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerPortraitBackdrop:SetPoint("RIGHT", PlayerFrameBackdrop, "LEFT", 0, 0)
PlayerPortraitBackdrop:SetSize(48 ,48)
PlayerPortraitBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
PlayerPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PlayerPortraitBackdrop:SetFrameStrata("HIGH")

PlayerPortraitBackdrop:SetAttribute("unit", "player")
PlayerPortraitBackdrop:RegisterForClicks("AnyUp")
PlayerPortraitBackdrop:SetAttribute("type1", "target")
PlayerPortraitBackdrop:SetAttribute("type2", "togglemenu")

local function PlayerFrameUpdate()
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT", PlayerPortraitBackdrop, "TOPLEFT", 0, 0)
    PlayerFrame:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", 0, 0)

    PlayerFrameBackground:ClearAllPoints()
    PlayerFrameBackground:SetPoint("TOPLEFT", PlayerFrameBackdrop, "TOPLEFT", 2, -2)
    PlayerFrameBackground:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", -2, 2)

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
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 2)
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
PlayerFrameEventFrame:RegisterEvent("PLAYER_LOGIN")
PlayerFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerFrameEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
PlayerFrameEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
PlayerFrameEventFrame:SetScript("OnEvent", PlayerFrameUpdate)




local PlayerBuffContainer = CreateFrame("Frame", "MyBuffFrame", UIParent)
PlayerBuffContainer:SetSize(40, 40)
PlayerBuffContainer:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "TOPRIGHT", 0, 84)

local function PlayerBuffUpdate(index, buff)
    local icon = PlayerBuffContainer["buff" .. index]
    
    if not icon then
        icon = CreateFrame("Frame", nil, PlayerBuffContainer)
        icon:SetSize(32, 32)
        icon.texture = icon:CreateTexture(nil, "BACKGROUND")
        icon.texture:SetAllPoints(icon)
        icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
        icon.cooldown:SetAllPoints(icon)
        icon.cooldown:SetDrawSwipe(false)
        PlayerBuffContainer["buff" .. index] = icon
    end

    icon.texture:SetTexture(buff.icon)
    if index == 1 then
        icon:SetPoint("RIGHT", PlayerBuffContainer, "RIGHT", 0, 0)
    else
        icon:SetPoint("RIGHT", PlayerBuffContainer["buff" .. (index - 1)], "LEFT", -4, 0)
    end
    icon.cooldown:SetCooldown(buff.expirationTime - buff.duration, buff.duration)
    icon:Show()
end

local function PlayerFrameBuffUpdate()
    local MAX_BUFFS = 32
    local visibleBuffCount = 0

    for i = 1, MAX_BUFFS do
        local name, icon, _, _, duration, expirationTime, caster = UnitBuff("player", i)
        
        if name and caster == "player" and duration and duration > 0 and duration <= 60 then
            visibleBuffCount = visibleBuffCount + 1
            local buff = { icon = icon, duration = duration, expirationTime = expirationTime }
            PlayerBuffUpdate(visibleBuffCount, buff)
        end
    end

    for i = visibleBuffCount + 1, MAX_BUFFS do
        local icon = PlayerBuffContainer["buff" .. i]
        if icon then
            icon:Hide()
        end
    end
end

local PlayerFrameAuraEventFrame = CreateFrame("Frame")
PlayerFrameAuraEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerFrameAuraEventFrame:RegisterEvent("UNIT_AURA")
PlayerFrameAuraEventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "UNIT_AURA" and arg1 == "player" then
        PlayerFrameBuffUpdate()
    elseif event == "PLAYER_ENTERING_WORLD" then
        PlayerFrameBuffUpdate()
    end
end)




local PetFrameBackdrop = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PetFrameBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
PetFrameBackdrop:SetSize(64, 24)
PetFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 12})
PetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PetFrameBackdrop:SetFrameStrata("HIGH")

PetFrameBackdrop:SetAttribute("unit", "pet")
PetFrameBackdrop:RegisterForClicks("AnyUp")
PetFrameBackdrop:SetAttribute("type1", "target")
PetFrameBackdrop:SetAttribute("type2", "togglemenu")

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
    PetFrameHealthBar:SetWidth(PetFrameBackdrop:GetWidth()-4)
    PetFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("BOTTOM", PetFrameBackdrop, "BOTTOM", 0, 2)
    PetFrameManaBar:SetHeight(8)
    PetFrameManaBar:SetWidth(PetFrameBackdrop:GetWidth()-4)
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
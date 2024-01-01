local XPBarBackdrop = CreateFrame("Frame", nil, MainMenuExpBar, "BackdropTemplate")
XPBarBackdrop:SetPoint("TOPLEFT", MainMenuExpBar, "TOPLEFT", -2, 2)
XPBarBackdrop:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "BOTTOMRIGHT", 2, -2)
XPBarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 8})
XPBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
XPBarBackdrop:SetFrameStrata(HIGH)

local function XPBarUpdate()
    if UnitLevel("player") == 60 then
        MainMenuExpBar:Hide()  -- Hides the XP bar
        XPBarBackdrop:Hide()   -- Hides the backdrop of the XP bar
        return                 -- Exit the function early
    else
        MainMenuExpBar:Show()  -- Shows the XP bar
        XPBarBackdrop:Show()   -- Shows the backdrop of the XP bar
    end

    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("TOP", UIParent, "TOP", 0, -16)
    MainMenuExpBar:SetSize(120, 16)
    MainMenuExpBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    MainMenuXPBarTexture0:Hide()
    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()

    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local missingXP = maxXP - currentXP
    local restedXP = GetXPExhaustion() or 0
    local xpPercent = floor((currentXP / maxXP) * 100)
    local restedPercent = floor((restedXP / maxXP) * 100)

    local xpText = string.format("XP: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r\nMissing: |cffFFFFFF+%d|r\nRested: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r",
        xpPercent, currentXP, missingXP, restedPercent, restedXP)

    MainMenuExpBar:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(xpText, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    MainMenuExpBar:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local XPBarEventFrame = CreateFrame("Frame")
XPBarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
XPBarEventFrame:RegisterEvent("PLAYER_LEVEL_UP")
XPBarEventFrame:RegisterEvent("PLAYER_XP_UPDATE")
XPBarEventFrame:RegisterEvent("UPDATE_EXHAUSTION")
XPBarEventFrame:SetScript("OnEvent", XPBarUpdate)




local ReputationBarBackdrop = CreateFrame("Frame", nil, ReputationWatchBar.StatusBar, "BackdropTemplate")
ReputationBarBackdrop:SetPoint("TOPLEFT", ReputationWatchBar.StatusBar, "TOPLEFT", -2, 2)
ReputationBarBackdrop:SetPoint("BOTTOMRIGHT", ReputationWatchBar.StatusBar, "BOTTOMRIGHT", 2, -2)
ReputationBarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 8})
ReputationBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
ReputationBarBackdrop:SetFrameStrata(HIGH)

local function ReputationBarUpdate()
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint("TOP", MainMenuExpBar, "BOTTOM", 0, -8)
    ReputationWatchBar.StatusBar:SetSize(120, 16)
    ReputationWatchBar.StatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    ReputationWatchBar.StatusBar.WatchBarTexture0:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()
end

ReputationWatchBar.StatusBar:HookScript("OnShow", ReputationBarUpdate)
ReputationWatchBar.StatusBar:HookScript("OnUpdate", ReputationBarUpdate)

local ReputationBarEventFrame = CreateFrame("Frame")
ReputationBarEventFrame:RegisterEvent("UPDATE_FACTION")
ReputationBarEventFrame:SetScript("OnEvent", ReputationBarUpdate)
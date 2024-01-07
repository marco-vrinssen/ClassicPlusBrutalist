local function ActionbarUpdate()
    MainMenuBar:SetWidth(512)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -2, 64)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)

    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 110)
    MultiBarBottomLeft:SetMovable(true)
    MultiBarBottomLeft:SetUserPlaced(true)

    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 24)
    MultiBarBottomRight:SetMovable(true)
    MultiBarBottomRight:SetUserPlaced(true)
    MultiBarBottomRight:SetScale(0.8)

    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()

    MainMenuBarPageNumber:Hide()
    ActionBarUpButton:Hide()
    ActionBarDownButton:Hide()

    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()

    MainMenuMaxLevelBar0:Hide()
    MainMenuMaxLevelBar1:Hide()
    MainMenuMaxLevelBar2:Hide()
    MainMenuMaxLevelBar3:Hide()
    MainMenuBarMaxLevelBar:Hide()
    
    MainMenuBarOverlayFrame:Hide()

    MainMenuBarPerformanceBarFrame:Hide()
    MainMenuBarPerformanceBarFrameButton:Hide()
end

local ActionbarsEventFrame = CreateFrame("Frame")
ActionbarsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionbarsEventFrame:SetScript("OnEvent", ActionbarUpdate)




local function RepositionVehicleLeaveButton()
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", RepositionVehicleLeaveButton)




function ActionbarsRangeCheck(self)
    if self.action then
        local inRange = IsActionInRange(self.action)
        local isUsable = IsUsableAction(self.action)
        
        if not isUsable then
            self.icon:SetVertexColor(0.5, 0.5, 0.5, 1)
        elseif inRange == false then
            self.icon:SetVertexColor(0.5, 0.5, 0.5, 1)
        else
            self.icon:SetVertexColor(1, 1, 1, 1)
        end
    end
end

hooksecurefunc("ActionButton_Update", ActionbarsRangeCheck)
hooksecurefunc("ActionButton_OnUpdate", ActionbarsRangeCheck)




local function ClassActionsBarsUpdate()
    SlidingActionBarTexture0:Hide()
    SlidingActionBarTexture1:Hide()
    
    StanceBarFrame:ClearAllPoints()
    StanceBarFrame:SetAlpha(0)

    PossessBarFrame:Hide()
    PossessBarFrame.Show = PossessBarFrame.Hide

    PetActionBarFrame:Hide()
    PetActionBarFrame.Show = PetActionBarFrame.Hide
end

local ClassActionbarEventFrame = CreateFrame("Frame")
ClassActionbarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ClassActionbarEventFrame:RegisterEvent("PET_BAR_UPDATE")
ClassActionbarEventFrame:SetScript("OnEvent", ClassActionsBarsUpdate)




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




local function MicroMenuButtonUpdate()
    CharacterMicroButton:Hide()
    TalentMicroButton:Hide()
    TalentMicroButton.Show = TalentMicroButton.Hide
    SpellbookMicroButton:Hide()
    QuestLogMicroButton:Hide()
    WorldMapMicroButton:Hide()
    SocialsMicroButton:Hide()
    MainMenuMicroButton:Hide()
    HelpMicroButton:Hide()
end

local MicroMenuEventFrame = CreateFrame("Frame")
MicroMenuEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MicroMenuEventFrame:SetScript("OnEvent", MicroMenuButtonUpdate)




local XPBarBackdrop = CreateFrame("Frame", nil, MainMenuExpBar, "BackdropTemplate")
XPBarBackdrop:SetPoint("TOPLEFT", MainMenuExpBar, "TOPLEFT", -2, 2)
XPBarBackdrop:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "BOTTOMRIGHT", 2, -2)
XPBarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 8})
XPBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
XPBarBackdrop:SetFrameStrata(HIGH)

local function XPBarUpdate()
    if UnitLevel("player") == 60 then
        MainMenuExpBar:Hide()
        XPBarBackdrop:Hide()
        return          
    else
        MainMenuExpBar:Show()
        XPBarBackdrop:Show()
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
    local xpPercent = floor((currentXP / maxXP) * 100)
    local restedXP = GetXPExhaustion() or 0
    local restedPercent = floor((restedXP / maxXP) * 100)

    local xpText = string.format("|cff808080Total:|r |cffFFFFFF%d|r\n|cff808080Current:|r |cffFFFFFF%d|r\n|cff808080Missing:|r |cffFFFFFF%d|r\n|cff808080Progress:|r |cffFFFFFF%d%%|r\n|cff808080Rested:|r |cffFFFFFF%d%%|r",
        maxXP, currentXP, missingXP, xpPercent, restedPercent)

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
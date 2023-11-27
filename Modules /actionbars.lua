local function ActionbarsUpdate()
    MainMenuBar:SetWidth(512)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -2, 68)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)

    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 116)
    MultiBarBottomLeft:SetMovable(true)
    MultiBarBottomLeft:SetUserPlaced(true)

    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 20)
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

    CharacterMicroButton:Hide()
    SpellbookMicroButton:Hide()
    QuestLogMicroButton:Hide()
    SocialsMicroButton:Hide()
    WorldMapMicroButton:Hide()
    MainMenuMicroButton:Hide()
    HelpMicroButton:Hide()

    TalentMicroButton:UnregisterAllEvents()
    TalentMicroButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", 10000, 0)

    MainMenuBarPerformanceBarFrame:Hide()
    MainMenuBarPerformanceBarFrameButton:Hide()

    MainMenuExpBar:Hide()
    MainMenuExpBar:UnregisterAllEvents()
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", 10000, 0)

    ReputationWatchBar:Hide()
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar:UnregisterAllEvents()
    ReputationWatchBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", 10000, 0)

    StanceBarFrame:ClearAllPoints()
    StanceBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 0, 8)
    StanceBarFrame:SetScale(0.8)    
    StanceBarFrame:SetMovable(true)
    StanceBarFrame:SetUserPlaced(true)

    PossessBarFrame:Hide()
    PossessBarFrame.Show = PossessBarFrame.Hide

    PetActionBarFrame:Hide()
    PetActionBarFrame.Show = PetActionBarFrame.Hide

    MainMenuBarVehicleLeaveButton:Hide()
    MainMenuBarVehicleLeaveButton.Show = MainMenuBarVehicleLeaveButton.Hide
end


local ActionbarsEventFrame = CreateFrame("Frame")
ActionbarsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionbarsEventFrame:SetScript("OnEvent", ActionbarsUpdate)




function ActionbarsRangeCheck(self)
    if self.action then
        local inRange = IsActionInRange(self.action)
        if inRange == false then
            self.icon:SetVertexColor(0.5, 0.5, 0.5, 1)
        else
            self.icon:SetVertexColor(1, 1, 1, 1)
        end
    end
end


hooksecurefunc("ActionButton_OnUpdate", ActionbarsRangeCheck)
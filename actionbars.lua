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

    MainMenuExpBar:Hide()
    MainMenuExpBar:UnregisterAllEvents()
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", 10000, 0)

    ReputationWatchBar:Hide()
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar:UnregisterAllEvents()
    ReputationWatchBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", 10000, 0)
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
        
        -- Set colors based on usability and range
        if not isUsable then
            -- Ability is not usable (gray color)
            self.icon:SetVertexColor(0.5, 0.5, 0.5, 1)
        elseif inRange == false then
            -- Ability is usable but out of range (red color)
            self.icon:SetVertexColor(1, 0.5, 0.5, 1)
        else
            -- Ability is usable and in range (normal color)
            self.icon:SetVertexColor(1, 1, 1, 1)
        end
    end
end

hooksecurefunc("ActionButton_Update", ActionbarsRangeCheck)




local function ClassActionsBarsUpdate()
    SlidingActionBarTexture0:Hide()
    SlidingActionBarTexture1:Hide()
    
    StanceBarFrame:ClearAllPoints()
    StanceBarFrame:SetMovable(true)
    StanceBarFrame:SetUserPlaced(true)
    StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 40)
    StanceBarFrame:SetScale(0.8)

    PossessBarFrame:Hide()
    PossessBarFrame.Show = PossessBarFrame.Hide

    PetActionBarFrame:Hide()
    PetActionBarFrame.Show = PetActionBarFrame.Hide
end

local ClassActionbarEventFrame = CreateFrame("Frame")
ClassActionbarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ClassActionbarEventFrame:RegisterEvent("PET_BAR_UPDATE")
ClassActionbarEventFrame:SetScript("OnEvent", ClassActionsBarsUpdate)
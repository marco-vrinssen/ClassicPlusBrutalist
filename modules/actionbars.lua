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

    MainMenuBarVehicleLeaveButton:Hide()
    MainMenuBarVehicleLeaveButton.Show = MainMenuBarVehicleLeaveButton.Hide
end

local ActionbarsEventFrame = CreateFrame("Frame")
ActionbarsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionbarsEventFrame:SetScript("OnEvent", ActionbarUpdate)




local function StanceBarUpdate()
    SlidingActionBarTexture0:Hide()
    SlidingActionBarTexture1:Hide()

    StanceBarFrame:ClearAllPoints()
    StanceBarFrame:SetPoint("TOPLEFT", MainMenuBar, "TOPLEFT", 0, 72)
    StanceBarFrame:SetScale(0.8)

    PossessBarFrame:Hide()
    PossessBarFrame.Show = PossessBarFrame.Hide
end

local function PetActionbarUpdate()
    PetActionBarFrame:Hide()
end

local function ClassActionbarUpdate()
    StanceBarUpdate()
    PetActionbarUpdate()
    --C_Timer.After(0.2, PetActionbarUpdate)
end

local ClassActionbarEventFrame = CreateFrame("Frame")
ClassActionbarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ClassActionbarEventFrame:RegisterEvent("PET_BAR_UPDATE")
ClassActionbarEventFrame:SetScript("OnEvent", ClassActionbarUpdate)




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




local function ActionbarsConfig()
    local interfaceOptions = "InterfaceOptionsActionBarsPanel"
    local bottom = "Bottom"
    local actionBars = {
        _G[interfaceOptions .. bottom .. "Left"],
        _G[interfaceOptions .. bottom .. "Right"]
    }

    for i, bar in ipairs(actionBars) do
        if not bar:GetChecked() then
            bar:SetChecked(true)
            bar:GetScript("OnClick")(bar)
        end
    end
end

local ActionbarsConfigEventFrame = CreateFrame("Frame")
ActionbarsConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionbarsConfigEventFrame:SetScript("OnEvent", ActionbarsConfig)
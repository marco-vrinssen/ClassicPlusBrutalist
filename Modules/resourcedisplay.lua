local StatusBarContainer = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
StatusBarContainer:SetSize(160, 28)
StatusBarContainer:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
StatusBarContainer:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
StatusBarContainer:SetBackdropBorderColor(0.5, 0.5, 0.5)
StatusBarContainer:SetAlpha(0)


local HealthStatusBar = CreateFrame("StatusBar", nil, StatusBarContainer)
HealthStatusBar:SetSize(156, 12)
HealthStatusBar:SetPoint("TOP", StatusBarContainer, "TOP", 0, -4)
HealthStatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
HealthStatusBar:SetFrameStrata("LOW")


local PowerStatusBar = CreateFrame("StatusBar", nil, StatusBarContainer)
PowerStatusBar:SetSize(156, 10)
PowerStatusBar:SetPoint("BOTTOM", StatusBarContainer, "BOTTOM", 0, 2)
PowerStatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
PowerStatusBar:SetFrameStrata("LOW")


local function SetContainerVisibility(isVisible)
    local alpha = isVisible and 1 or 0
    if isVisible then
        UIFrameFadeIn(StatusBarContainer, 0.5, StatusBarContainer:GetAlpha(), alpha)
    else
        UIFrameFadeOut(StatusBarContainer, 0.25, StatusBarContainer:GetAlpha(), alpha)
    end
end


local fadeOutTimer = nil

local function DelayedFadeOut()
    if fadeOutTimer then
        fadeOutTimer:Cancel()
    end
    fadeOutTimer = C_Timer.NewTimer(4, function()
        SetContainerVisibility(false)
    end)
end


local function ResourceDisplayUpdate()
    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    HealthStatusBar:SetMinMaxValues(0, maxHealth)
    HealthStatusBar:SetValue(health)

    local resource = UnitPower("player")
    local maxResource = UnitPowerMax("player")
    PowerStatusBar:SetMinMaxValues(0, maxResource)
    PowerStatusBar:SetValue(resource)

    if health / maxHealth <= 0.2 then
        HealthStatusBar:SetStatusBarColor(1, 0, 0)
    else
        HealthStatusBar:SetStatusBarColor(0, 1, 0)
    end

    local resourceType = UnitPowerType("player")
    if resourceType == Enum.PowerType.Mana then
        PowerStatusBar:SetStatusBarColor(0, 0, 1)
    elseif resourceType == Enum.PowerType.Rage then
        PowerStatusBar:SetStatusBarColor(1, 0, 0)
    elseif resourceType == Enum.PowerType.Energy then
        PowerStatusBar:SetStatusBarColor(1, 1, 0)
    end
end


local ResourceDisplayEventFrame = CreateFrame("Frame")
ResourceDisplayEventFrame:RegisterUnitEvent("UNIT_HEALTH", "player")
ResourceDisplayEventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
ResourceDisplayEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")  -- Entering combat
ResourceDisplayEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")   -- Exiting combat
ResourceDisplayEventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_REGEN_DISABLED" then
        SetContainerVisibility(true)
    elseif event == "PLAYER_REGEN_ENABLED" then
        SetContainerVisibility(false)  -- Hide immediately when exiting combat
    elseif event == "UNIT_POWER_UPDATE" and arg1 == "player" then
        ResourceDisplayUpdate()
    elseif event == "UNIT_HEALTH" and arg1 == "player" then
        ResourceDisplayUpdate()
    end
end)

ResourceDisplayUpdate()


local _, playerClass = UnitClass("player")
if playerClass ~= "ROGUE" and playerClass ~= "DRUID" then
    return
end


local function CustomComboPointSetup()
    local comboPoints = GetComboPoints("player", "target") or 0
    for i = 1, 5 do
        local comboPointFrame = _G["CustomComboPoint" .. i]
        if not comboPointFrame then
            comboPointFrame = CreateFrame("Frame", "CustomComboPoint" .. i, UIParent)
            comboPointFrame:SetSize(24, 24)

            comboPointFrame.texture = comboPointFrame:CreateTexture(nil, "ARTWORK")
            comboPointFrame.texture:SetAllPoints(comboPointFrame)
            comboPointFrame.texture:SetTexture("Interface/COMMON/Indicator-Yellow")

            if i == 1 then
                comboPointFrame:SetPoint("TOP", StatusBarContainer, "BOTTOM", -56, -16)
            else
                local previousFrame = _G["CustomComboPoint" .. (i - 1)]
                comboPointFrame:SetPoint("LEFT", previousFrame, "RIGHT", 4, 0)
            end
        end

        if i <= comboPoints then
            comboPointFrame.texture:SetVertexColor(1, 0, 0, 1)
            UIFrameFadeIn(comboPointFrame, 0.5, comboPointFrame:GetAlpha(), 1)
        else
            comboPointFrame.texture:SetVertexColor(0.25, 0.25, 0.25, 0.5)
            if comboPoints == 0 then
                UIFrameFadeOut(comboPointFrame, 0.5, comboPointFrame:GetAlpha(), 0)
            else
                UIFrameFadeIn(comboPointFrame, 0.5, comboPointFrame:GetAlpha(), 1)
            end
        end
    end
    ComboFrame:UnregisterAllEvents()
    ComboFrame:Hide()
end


local CustomComboPointListener = CreateFrame("Frame")
CustomComboPointListener:RegisterEvent("PLAYER_TARGET_CHANGED")
CustomComboPointListener:RegisterEvent("UNIT_POWER_UPDATE")
CustomComboPointListener:SetScript("OnEvent", function(self, event, ...)
    local unit = ...
    if event == "UNIT_POWER_UPDATE" and unit == "player" then
        CustomComboPointSetup()
    elseif event == "PLAYER_TARGET_CHANGED" then
        CustomComboPointSetup()
    end
end)
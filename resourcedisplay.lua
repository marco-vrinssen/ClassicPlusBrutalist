local ResourceDisplayContainer = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
ResourceDisplayContainer:SetSize(160,28)
ResourceDisplayContainer:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
ResourceDisplayContainer:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
ResourceDisplayContainer:SetBackdropBorderColor(0.5, 0.5, 0.5)
ResourceDisplayContainer:SetAlpha(0)  -- Initially hidden

local HealthBar = CreateFrame("StatusBar", nil, ResourceDisplayContainer)
HealthBar:SetSize(156, 12)
HealthBar:SetPoint("TOP", ResourceDisplayContainer, "TOP", 0, -4)
HealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
HealthBar:SetFrameStrata("LOW")

local ResourceBar = CreateFrame("StatusBar", nil, ResourceDisplayContainer)
ResourceBar:SetSize(156, 10)
ResourceBar:SetPoint("BOTTOM", ResourceDisplayContainer, "BOTTOM", 0, 2)
ResourceBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
ResourceBar:SetFrameStrata("LOW")


local function SetContainerVisibility(isVisible)
    local alpha = isVisible and 1 or 0
    if isVisible then
        UIFrameFadeIn(ResourceDisplayContainer, 0.5, ResourceDisplayContainer:GetAlpha(), alpha)
    else
        UIFrameFadeOut(ResourceDisplayContainer, 0.25, ResourceDisplayContainer:GetAlpha(), alpha)
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
    HealthBar:SetMinMaxValues(0, maxHealth)
    HealthBar:SetValue(health)

    local resource = UnitPower("player")
    local maxResource = UnitPowerMax("player")
    ResourceBar:SetMinMaxValues(0, maxResource)
    ResourceBar:SetValue(resource)

    if health / maxHealth <= 0.2 then
        HealthBar:SetStatusBarColor(1, 0, 0)
    else
        HealthBar:SetStatusBarColor(0, 1, 0)
    end

    local resourceType = UnitPowerType("player")
    if resourceType == Enum.PowerType.Mana then
        ResourceBar:SetStatusBarColor(0, 0, 1)
    elseif resourceType == Enum.PowerType.Rage then
        ResourceBar:SetStatusBarColor(1, 0, 0)
    elseif resourceType == Enum.PowerType.Energy then
        ResourceBar:SetStatusBarColor(1, 1, 0)
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
        DelayedFadeOut()
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
                comboPointFrame:SetPoint("TOP", ResourceDisplayContainer, "BOTTOM", -56, -16)
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

local ComboPointsListener = CreateFrame("Frame")
ComboPointsListener:RegisterEvent("PLAYER_TARGET_CHANGED")
ComboPointsListener:RegisterEvent("UNIT_POWER_UPDATE")
ComboPointsListener:SetScript("OnEvent", function(self, event, ...)
    local unit = ...
    if event == "UNIT_POWER_UPDATE" and unit == "player" then
        CustomComboPointSetup()
    elseif event == "PLAYER_TARGET_CHANGED" then
        CustomComboPointSetup()
    end
end)
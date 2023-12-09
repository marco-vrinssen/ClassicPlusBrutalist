local ResourceDisplayBackdrop = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
ResourceDisplayBackdrop:SetSize(164, 32)
ResourceDisplayBackdrop:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
ResourceDisplayBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
ResourceDisplayBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
ResourceDisplayBackdrop:SetAlpha(0)

local ResourceHealthbar = CreateFrame("StatusBar", nil, ResourceDisplayBackdrop)
ResourceHealthbar:SetSize(156, 16)
ResourceHealthbar:SetPoint("TOP", ResourceDisplayBackdrop, "TOP", 0, -4)
ResourceHealthbar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
ResourceHealthbar:SetFrameStrata("LOW")

local ResourcePowerbar = CreateFrame("StatusBar", nil, ResourceDisplayBackdrop)
ResourcePowerbar:SetSize(156, 10)
ResourcePowerbar:SetPoint("BOTTOM", ResourceDisplayBackdrop, "BOTTOM", 0, 2)
ResourcePowerbar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
ResourcePowerbar:SetFrameStrata("LOW")

local function ResourceDisplayToggle(isVisible)
    local alpha = isVisible and 1 or 0
    if isVisible then
        UIFrameFadeIn(ResourceDisplayBackdrop, 0.2, ResourceDisplayBackdrop:GetAlpha(), alpha)
    else
        UIFrameFadeOut(ResourceDisplayBackdrop, 4, ResourceDisplayBackdrop:GetAlpha(), alpha)
    end
end

local function ResourceDisplayUpdate()
    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    ResourceHealthbar:SetMinMaxValues(0, maxHealth)
    ResourceHealthbar:SetValue(health)

    local resource = UnitPower("player")
    local maxResource = UnitPowerMax("player")
    ResourcePowerbar:SetMinMaxValues(0, maxResource)
    ResourcePowerbar:SetValue(resource)

    if health / maxHealth <= 0.2 then
        ResourceHealthbar:SetStatusBarColor(1, 0, 0)
    else
        ResourceHealthbar:SetStatusBarColor(0, 1, 0)
    end

    local resourceType = UnitPowerType("player")
    if resourceType == Enum.PowerType.Mana then
        ResourcePowerbar:SetStatusBarColor(0, 0, 1)
    elseif resourceType == Enum.PowerType.Rage then
        ResourcePowerbar:SetStatusBarColor(1, 0, 0)
    elseif resourceType == Enum.PowerType.Energy then
        ResourcePowerbar:SetStatusBarColor(1, 1, 0)
    end
end

local ResourceDisplayEventFrame = CreateFrame("Frame")
ResourceDisplayEventFrame:RegisterUnitEvent("UNIT_HEALTH", "player")
ResourceDisplayEventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
ResourceDisplayEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
ResourceDisplayEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
ResourceDisplayEventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_REGEN_DISABLED" then
        ResourceDisplayToggle(true)
    elseif event == "PLAYER_REGEN_ENABLED" then
        ResourceDisplayToggle(false)  -- Hide immediately when exiting combat
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

local comboPointDisplay = CreateFrame("Frame", "ComboPointDisplay", UIParent)
comboPointDisplay:SetSize(50, 50)  -- Adjust size as needed
if ResourceDisplayBackdrop then
    comboPointDisplay:SetPoint("TOP", ResourceDisplayBackdrop, "BOTTOM", 0, -16)  -- Adjust position as needed
else
    comboPointDisplay:SetPoint("CENTER", UIParent, "CENTER", 0, 0)  -- Fallback position
end

comboPointDisplay.fontString = comboPointDisplay:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
comboPointDisplay.fontString:SetPoint("CENTER")
comboPointDisplay.fontString:SetText("")

-- Set font, size, and outline for the fontString
local fontPath = STANDARD_TEXT_FONT  -- Default font path, you can replace it with another if you like
local fontSize = 30  -- Adjust font size as needed
local fontOutline = "OUTLINE"  -- You can use "OUTLINE", "THICKOUTLINE", or "" for no outline
comboPointDisplay.fontString:SetFont(fontPath, fontSize, fontOutline)

local function UpdateComboPoints()
    local comboPoints = GetComboPoints("player", "target") or 0
    if comboPoints > 0 then
        comboPointDisplay.fontString:SetText(comboPoints)
        comboPointDisplay.fontString:SetTextColor(1, 0, 0, 1)  -- Active color
        comboPointDisplay:Show()
    else
        comboPointDisplay:Hide()
    end

    -- Hide default combo points
    ComboFrame:UnregisterAllEvents()
    ComboFrame:Hide()
end

local ComboPointDisplayEventFrame = CreateFrame("Frame")
ComboPointDisplayEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ComboPointDisplayEventFrame:RegisterEvent("UNIT_POWER_UPDATE")
ComboPointDisplayEventFrame:SetScript("OnEvent", function(self, event, ...)
    local unit = ...
    if event == "UNIT_POWER_UPDATE" and unit == "player" then
        UpdateComboPoints()
    elseif event == "PLAYER_TARGET_CHANGED" then
        UpdateComboPoints()
    end
end)

-- Initialize display
UpdateComboPoints()









--[[

local _, playerClass = UnitClass("player")
if playerClass ~= "ROGUE" and playerClass ~= "DRUID" then
    return
end

local function ComboPointDisplay()
    local comboPoints = GetComboPoints("player", "target") or 0
    for i = 1, 5 do
        local comboPointFrame = _G["CustomComboPoint" .. i]
        if not comboPointFrame then
            comboPointFrame = CreateFrame("Frame", "CustomComboPoint" .. i, UIParent)
            comboPointFrame:SetSize(16, 16)

            comboPointFrame.texture = comboPointFrame:CreateTexture(nil, "ARTWORK")
            comboPointFrame.texture:SetAllPoints(comboPointFrame)
            comboPointFrame.texture:SetTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

            comboPointFrame.mask = comboPointFrame:CreateMaskTexture()
            comboPointFrame.mask:SetTexture("Interface/CharacterFrame/TempPortraitAlphaMaskSmall")
            comboPointFrame.mask:SetAllPoints(comboPointFrame.texture)
            comboPointFrame.texture:AddMaskTexture(comboPointFrame.mask)

            if i == 1 then
                comboPointFrame:SetPoint("TOP", ResourceDisplayBackdrop, "BOTTOM", -40, -16)
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

local ComboPointDisplayEventFrame = CreateFrame("Frame")
ComboPointDisplayEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ComboPointDisplayEventFrame:RegisterEvent("UNIT_POWER_UPDATE")
ComboPointDisplayEventFrame:SetScript("OnEvent", function(self, event, ...)
    local unit = ...
    if event == "UNIT_POWER_UPDATE" and unit == "player" then
        ComboPointDisplay()
    elseif event == "PLAYER_TARGET_CHANGED" then
        ComboPointDisplay()
    end
end)

]]--
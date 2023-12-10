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
comboPointDisplay:SetSize(24, 24)  -- Adjust size as needed
if ResourceDisplayBackdrop then
    comboPointDisplay:SetPoint("TOP", ResourceDisplayBackdrop, "BOTTOM", 0, -8)  -- Adjust position as needed
else
    comboPointDisplay:SetPoint("CENTER", UIParent, "CENTER", 0, 0)  -- Fallback position
end

comboPointDisplay.fontString = comboPointDisplay:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
comboPointDisplay.fontString:SetPoint("CENTER")
comboPointDisplay.fontString:SetText("")

-- Set font, size, and outline for the fontString
local fontPath = STANDARD_TEXT_FONT  -- Default font path, you can replace it with another if you like
local fontSize = 24  -- Adjust font size as needed
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
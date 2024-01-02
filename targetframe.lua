local TargetFrameBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", 190, 200)
TargetFrameBackdrop:SetSize(124, 48)
TargetFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetFrameBackdrop:SetFrameStrata("HIGH")

TargetFrameBackdrop:SetAttribute("unit", "target")
TargetFrameBackdrop:RegisterForClicks("AnyUp")
TargetFrameBackdrop:SetAttribute("type1", "target")
TargetFrameBackdrop:SetAttribute("type2", "togglemenu")

local TargetPortraitBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 0, 0)
TargetPortraitBackdrop:SetSize(48 ,48)
TargetPortraitBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetPortraitBackdrop:SetFrameStrata("HIGH")

TargetPortraitBackdrop:SetAttribute("unit", "target")
TargetPortraitBackdrop:RegisterForClicks("AnyUp")
TargetPortraitBackdrop:SetAttribute("type1", "target")
TargetPortraitBackdrop:SetAttribute("type2", "togglemenu")

local function TargetFrameUpdate()
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "BOTTOMLEFT", 0, 0)
    TargetFrame:SetPoint("TOPRIGHT", TargetPortraitBackdrop, "TOPRIGHT", 0, 0)

    TargetFrame:SetAttribute("unit", "target")
    TargetFrame:RegisterForClicks("AnyUp")
    TargetFrame:SetAttribute("type1", "target")
    TargetFrame:SetAttribute("type2", "togglemenu")

    TargetFrameBackground:ClearAllPoints()
    TargetFrameBackground:SetPoint("TOPLEFT", TargetFrameBackdrop, "TOPLEFT", 2, -2)
    TargetFrameBackground:SetPoint("BOTTOMRIGHT", TargetFrameBackdrop, "BOTTOMRIGHT", -2, 2)

    TargetFrameNameBackground:Hide()
    TargetFrameTextureFrameTexture:Hide()
    TargetFrameTextureFramePVPIcon:SetAlpha(0)
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
    TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
    TargetFrameTextureFrameRaidTargetIcon:SetSize(32, 32)
    TargetFrameTextureFrameDeadText:Hide()

    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint("TOP", TargetFrameBackdrop, "TOP", 0, -6)
    TargetFrameTextureFrameName:SetFont(STANDARD_TEXT_FONT, 10)
    TargetFrameTextureFrameName:SetTextColor(1, 1, 1, 1)

    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(TargetFrameBackground:GetWidth(), 16)
    TargetFrameHealthBar:SetPoint("BOTTOM", TargetFrameManaBar, "TOP", 0, 0)
    TargetFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    
    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth()-2, 8)
    TargetFrameManaBar:SetPoint("BOTTOM", TargetFrameBackdrop, "BOTTOM", 0, 4)
    TargetFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    TargetFramePortrait:ClearAllPoints()
    TargetFramePortrait:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
    TargetFramePortrait:SetSize(TargetPortraitBackdrop:GetHeight() - 6, TargetPortraitBackdrop:GetHeight() - 6)

    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
    TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

    TargetFrameTextureFrameHighLevelTexture:Hide()
    TargetFrameTextureFrameHighLevelTexture.Show = TargetFrameTextureFrameHighLevelTexture.Hide

    if UnitLevel("target") > 60 then
        TargetFrameTextureFrameLevelText:SetText("High")
        TargetFrameTextureFrameLevelText:SetTextColor(1, 0.5, 0)
    end
end

hooksecurefunc("TargetFrame_Update", TargetFrameUpdate)

local TargetFrameEventFrame = CreateFrame("Frame")
TargetFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameEventFrame:SetScript("OnEvent", TargetFrameUpdate)




local TargetHealthText = TargetFrameHealthBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TargetHealthText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
TargetHealthText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
TargetHealthText:SetTextColor(1, 1, 1, 1)
TargetHealthText:SetShadowOffset(0, 0)

local function TargetHealthUpdate()
    if UnitExists("target") then
        local currentHealth = UnitHealth("target")
        local maxHealth = UnitHealthMax("target")
        TargetHealthText:SetText(currentHealth .. " / " .. maxHealth)
    else
        TargetHealthText:SetText("")
    end
end

local TargetHealthEventFrame = CreateFrame("Frame")
TargetHealthEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetHealthEventFrame:RegisterEvent("UNIT_HEALTH")
TargetHealthEventFrame:RegisterEvent("UNIT_HEALTH_FREQUENT")
TargetHealthEventFrame:RegisterEvent("UNIT_MAXHEALTH")
TargetHealthEventFrame:SetScript("OnEvent", TargetHealthUpdate)




local function TargetPortraitUpdate(frame)
    if frame.unit == "target" and frame.portrait then
        if UnitIsPlayer(frame.unit) then
            local t = CLASS_ICON_TCOORDS[select(2, UnitClass(frame.unit))]
            if t then
                frame.portrait:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")
                local left, right, top, bottom = unpack(t)
                local newLeft = left + (right - left) * 0.15
                local newRight = right - (right - left) * 0.15
                local newTop = top + (bottom - top) * 0.15
                local newBottom = bottom - (bottom - top) * 0.15
                frame.portrait:SetTexCoord(newLeft, newRight, newTop, newBottom)
                frame.portrait:SetDrawLayer("BACKGROUND", -1)
            end
        else
            frame.portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        end
    end
end

hooksecurefunc("UnitFramePortrait_Update", TargetPortraitUpdate)




local function ToTFrameUpdate()
    TargetFrameToT:Hide()
end

local ToTFrameEventFrame = CreateFrame("Frame")
ToTFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ToTFrameEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ToTFrameEventFrame:SetScript("OnEvent", ToTFrameUpdate)




local CustomDebuffContainer = CreateFrame("Frame", "MyDebuffFrame", UIParent)
CustomDebuffContainer:SetSize(40, 40)
CustomDebuffContainer:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 0, 80)

local function CustomDebuffIcon(index, debuff)
    local icon = CustomDebuffContainer["debuff" .. index]

    if not icon then
        icon = CreateFrame("Frame", nil, CustomDebuffContainer)
        icon:SetSize(32, 32)
        icon.texture = icon:CreateTexture(nil, "BACKGROUND")
        icon.texture:SetAllPoints(icon)

        icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
        icon.cooldown:SetAllPoints(icon)
        icon.cooldown:SetDrawSwipe(false)

        icon.stackText = icon:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        icon.stackText:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
        icon.stackText:SetFont("GameFontNormal", 12, "OUTLINE")

        CustomDebuffContainer["debuff" .. index] = icon
    end

    icon.texture:SetTexture(debuff.icon)
    icon:SetPoint("LEFT", CustomDebuffContainer, "LEFT", (index - 1) * 36, 0)
    icon.cooldown:SetCooldown(debuff.expirationTime - debuff.duration, debuff.duration)

    if debuff.count and debuff.count > 0 then
        icon.stackText:SetText(debuff.count)
    else
        icon.stackText:SetText("")  -- Clear text if no stacks
    end
    
    icon:Show()
end

local function CustomDebuffUpdate()
    local MAX_DEBUFFS = 32
    local debuffCount = 0

    for i = 1, MAX_DEBUFFS do
        local name, icon, count, _, duration, expirationTime, caster = UnitDebuff("target", i)
        if name and caster == "player" then
            CustomDebuffIcon(debuffCount + 1, {icon = icon, count = count, duration = duration, expirationTime = expirationTime})
            debuffCount = debuffCount + 1
        end
    end

    for i = debuffCount + 1, MAX_DEBUFFS do
        local icon = CustomDebuffContainer["debuff" .. i]
        if icon then
            icon:Hide()
        end
    end
end

hooksecurefunc("TargetFrame_Update", CustomDebuffUpdate)
hooksecurefunc("TargetFrame_UpdateAuras", CustomDebuffUpdate)

local TargetFrameAuraEventFrame = CreateFrame("Frame")
TargetFrameAuraEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameAuraEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameAuraEventFrame:SetScript("OnEvent", CustomDebuffUpdate)




local function TargetAuraUpdate()
    local AURA_OFFSET_Y = 2  -- Vertical offset
    local DEBUFF_OFFSET_X = 2  -- Horizontal offset for debuffs

    local firstBuff = _G["TargetFrameBuff1"]
    if firstBuff then
        firstBuff:ClearAllPoints()
        firstBuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 2, AURA_OFFSET_Y)
    end

    local firstDebuff = _G["TargetFrameDebuff1"]
    if firstDebuff then
        firstDebuff:ClearAllPoints()
        if firstBuff then
            firstDebuff:SetPoint("BOTTOMLEFT", firstBuff, "TOPLEFT", 0, AURA_OFFSET_Y)
        else
            firstDebuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", DEBUFF_OFFSET_X, AURA_OFFSET_Y)
        end
    end
end

hooksecurefunc("TargetFrame_Update", TargetAuraUpdate)
hooksecurefunc("TargetFrame_UpdateAuras", TargetAuraUpdate)

local TargetFrameAuraEventFrame = CreateFrame("Frame")
TargetFrameAuraEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameAuraEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameAuraEventFrame:SetScript("OnEvent", TargetAuraUpdate)




local TargetFrameSpellbarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
TargetFrameSpellbarBackdrop:SetPoint("TOPLEFT", TargetFrameBackdrop, "BOTTOMLEFT", 0, -2)
TargetFrameSpellbarBackdrop:SetPoint("TOPRIGHT", TargetFrameBackdrop, "BOTTOMRIGHT", 0, -2)
TargetFrameSpellbarBackdrop:SetHeight(24)
TargetFrameSpellbarBackdrop:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14 })
TargetFrameSpellbarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetFrameSpellbarBackdrop:SetFrameStrata("HIGH")

local function TargetFrameSpellbarUpdate()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrameSpellbarBackdrop, "TOPLEFT", 3, -2)
    TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", TargetFrameSpellbarBackdrop, "BOTTOMRIGHT", -3, 2)
    TargetFrameSpellBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    TargetFrameSpellBar.Border:SetTexture(nil)
    TargetFrameSpellBar.Flash:SetTexture(nil)
    TargetFrameSpellBar.Spark:SetTexture(nil)

    TargetFrameSpellBar.Icon:SetSize(TargetFrameSpellbarBackdrop:GetHeight() - 4, TargetFrameSpellbarBackdrop:GetHeight() - 4)

    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("CENTER", TargetFrameSpellbarBackdrop, "CENTER", 0, 0)
    TargetFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 10)
end

TargetFrameSpellBar:HookScript("OnShow", TargetFrameSpellbarUpdate)
TargetFrameSpellBar:HookScript("OnUpdate", TargetFrameSpellbarUpdate)

local TargetFrameSpellbarEventFrame = CreateFrame("Frame")
TargetFrameSpellbarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameSpellbarEventFrame:SetScript("OnEvent", TargetFrameSpellbarUpdate)




local TargetFrameClassificationText = TargetFrame:CreateFontString(nil, "OVERLAY")
TargetFrameClassificationText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
TargetFrameClassificationText:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 4)

local function TargetFrameClassificationUpdate()
    local classification = UnitClassification("target")
    if classification == "worldboss" then
        TargetFrameClassificationText:SetText("Boss")
        TargetFrameClassificationText:SetTextColor(1, 0.5, 0, 1)
        TargetFrameBackdrop:SetBackdropBorderColor(1, 0.5, 0, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(1, 0.5, 0, 1)
        TargetFrameTextureFrameName:SetTextColor(1, 0.5, 0, 1)
    elseif classification == "elite" then
        TargetFrameClassificationText:SetText("Elite")
        TargetFrameClassificationText:SetTextColor(1, 0.8, 0, 1)
        TargetFrameBackdrop:SetBackdropBorderColor(1, 0.8, 0, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(1, 0.8, 0, 1)
        TargetFrameTextureFrameName:SetTextColor(1, 0.8, 0, 1)
    elseif classification == "rare" then
        TargetFrameClassificationText:SetText("Rare")
        TargetFrameClassificationText:SetTextColor(0.5, 0.5, 0.5, 1)
        TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        TargetFrameTextureFrameName:SetTextColor(0.5, 0.5, 0.5, 1)
    else
        TargetFrameClassificationText:SetText("")
        TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    end
end

hooksecurefunc("TargetFrame_Update", TargetFrameClassificationUpdate)

local TargetFrameClassificationEventFrame = CreateFrame("Frame")
TargetFrameClassificationEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameClassificationEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameClassificationEventFrame:SetScript("OnEvent", TargetFrameClassificationUpdate)




local TargetFrameThreatText = TargetFrameThreatText or TargetFrame:CreateFontString(nil, "OVERLAY")
TargetFrameThreatText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
TargetFrameThreatText:SetPoint("BOTTOM", TargetFrameClassificationText, "TOP", 0, 4)

local function TargetFrameThreatTextUpdate()
    if not UnitExists("target") or UnitIsDead("target") or not UnitCanAttack("player", "target") then
        TargetFrameThreatText:Hide()
        return
    end

    local isTanking, status, threatPercentage = UnitDetailedThreatSituation("player", "target")
    if threatPercentage then
        TargetFrameThreatText:SetText(string.format("%.0f%%", threatPercentage))
        TargetFrameThreatText:Show()
        if isTanking or (status and status >= 2) then
            TargetFrameThreatText:SetTextColor(1, 0, 0)
        elseif status == 1 then
            TargetFrameThreatText:SetTextColor(1, 0.5, 0)
        else
            TargetFrameThreatText:SetTextColor(0.5, 0.5, 0.5)
        end
    else
        TargetFrameThreatText:Hide()
    end
end

TargetFrame:HookScript("OnShow", TargetFrameThreatTextUpdate)
TargetFrame:HookScript("OnEvent", TargetFrameThreatTextUpdate)
TargetFrame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
TargetFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
TargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")




local TargetFrameConfigFrame = CreateFrame("Frame")
TargetFrameConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameConfigFrame:SetScript("OnEvent", function()
    SetCVar("showTargetCastbar", 1)
    SetCVar("showTargetOfTarget", "0")
    TARGET_FRAME_BUFFS_ON_TOP = true
end)
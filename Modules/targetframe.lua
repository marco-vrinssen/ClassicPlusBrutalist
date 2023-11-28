local TargetFrameBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton10, "TOPLEFT", 0, 48)
TargetFrameBackdrop:SetPoint("BOTTOMRIGHT", MultiBarBottomLeftButton12, "TOPRIGHT", 0, 48)
TargetFrameBackdrop:SetHeight(48)
TargetFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetFrameBackdrop:SetFrameStrata("HIGH")


local TargetPortraitBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 4, 0)
TargetPortraitBackdrop:SetSize(48 ,48)
TargetPortraitBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetPortraitBackdrop:SetFrameStrata("HIGH")


local function TargetFrameUpdate()
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "BOTTOMLEFT", -16, -16)
    TargetFrame:SetPoint("TOPRIGHT", TargetPortraitBackdrop, "TOPRIGHT", 16, 16)

    TargetFrameBackground:ClearAllPoints()
    TargetFrameBackground:SetPoint("TOPLEFT", TargetFrameBackdrop, "TOPLEFT", 2, -2)
    TargetFrameBackground:SetPoint("BOTTOMRIGHT", TargetFrameBackdrop, "BOTTOMRIGHT", -2, 4)

    TargetFrameNameBackground:Hide()
    TargetFrameTextureFrameTexture:Hide()
    TargetFrameTextureFramePVPIcon:SetAlpha(0)
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", PlayerPortraitBackdrop, "TOP", 0, 0)
    TargetFrameTextureFrameRaidTargetIcon:SetPoint("LEFT", TargetPortraitBackdrop, "RIGHT", 8, 0)
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
    TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth(), 8)
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
        TargetFrameTextureFrameLevelText:Hide()
    end
end


hooksecurefunc("TargetFrame_Update", TargetFrameUpdate)


local TargetFrameEventFrame = CreateFrame("Frame")
TargetFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameEventFrame:SetScript("OnEvent", TargetFrameUpdate)


local TargetHealthOverlay = TargetFrameHealthBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TargetHealthOverlay:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
TargetHealthOverlay:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
TargetHealthOverlay:SetTextColor(1, 1, 1, 1)
TargetHealthOverlay:SetShadowOffset(0, 0)


local function UpdateHealthDisplay()
    if UnitExists("target") then
        local currentHealth = UnitHealth("target")
        local maxHealth = UnitHealthMax("target")
        TargetHealthOverlay:SetText(currentHealth .. " / " .. maxHealth)
    else
        TargetHealthOverlay:SetText("")
    end
end


local TargetHealthEventFrame = CreateFrame("Frame")
TargetHealthEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetHealthEventFrame:RegisterEvent("UNIT_HEALTH")
TargetHealthEventFrame:RegisterEvent("UNIT_HEALTH_FREQUENT")
TargetHealthEventFrame:RegisterEvent("UNIT_MAXHEALTH")
TargetHealthEventFrame:SetScript("OnEvent", UpdateHealthDisplay)


local function TargetFramePlayerPortraitUpdate(frame)
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


hooksecurefunc("UnitFramePortrait_Update", TargetFramePlayerPortraitUpdate)




--[[
local function TargetFrameAuraUpdate()
    local buffCount = 0
    local debuffCount = 0

    for i = 1, MAX_TARGET_BUFFS do
        local buff = _G["TargetFrameBuff" .. i]
        if buff then
            buff:Hide()
        end
    end

    for i = 1, MAX_TARGET_DEBUFFS do
        local name, _, _, _, _, _, unitCaster = UnitDebuff("target", i)
        local debuff = _G["TargetFrameDebuff" .. i]

        if debuff and unitCaster == "player" then
            debuff:SetSize(28, 28)
            local xOffset = (debuffCount * 32)
            debuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", xOffset, 8)
            debuff:Show()
            debuffCount = debuffCount + 1
        elseif debuff then
            debuff:Hide()
        end
    end
end
]]




local myDebuffFrame = CreateFrame("Frame", "MyDebuffFrame", UIParent)
myDebuffFrame:SetSize(40, 40) -- Width, Height
myDebuffFrame:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 0, 84) -- Adjusted Position

local function CreateOrUpdateDebuffIcon(index, debuff)
    local icon = myDebuffFrame["debuff" .. index]
    
    if not icon then
        icon = CreateFrame("Frame", nil, myDebuffFrame)
        icon:SetSize(32, 32) -- Width, Height of the icon
        icon.texture = icon:CreateTexture(nil, "BACKGROUND")
        icon.texture:SetAllPoints(icon)
        icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
        icon.cooldown:SetAllPoints(icon)
        icon.cooldown:SetDrawSwipe(false) -- Optional: Set to false if you don't want the swipe effect
        myDebuffFrame["debuff" .. index] = icon
    end

    icon.texture:SetTexture(debuff.icon)
    icon:SetPoint("LEFT", myDebuffFrame, "LEFT", (index - 1) * 36, 0)
    icon.cooldown:SetCooldown(debuff.expirationTime - debuff.duration, debuff.duration)
    icon:Show()
end


local function TargetFrameAuraUpdate()

    local MAX_BUFFS = 32
    local MAX_DEBUFFS = 32

    for i = 1, MAX_BUFFS do
        local buff = _G["TargetFrameBuff"..i]
        if buff then
            buff:ClearAllPoints()
            buff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", (i - 1) * 24, 4) -- Using direct values for offset
        end
    end

    local visibleDebuffCount = 0

    for i = 1, MAX_DEBUFFS do
        local name, icon, _, _, _, _, caster = UnitDebuff("target", i)
        local debuffFrame = _G["TargetFrameDebuff"..i]
    
        if debuffFrame then
            local debuffTexture = debuffFrame:GetRegions() -- Assuming the texture is the first region of the frame
            if debuffTexture and debuffTexture.SetTexture then
                if name and caster == "player" then
                    debuffFrame:Hide()
                else
                    if name then  -- Make sure there is a debuff to show
                        debuffTexture:SetTexture(icon)  -- Set the correct texture
                        debuffFrame:ClearAllPoints()
                        debuffFrame:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", visibleDebuffCount * 24, 4)
                        debuffFrame:Show()
                        visibleDebuffCount = visibleDebuffCount + 1
                    else
                        debuffFrame:Hide()
                    end
                end
            end
        end
    end
    

    --[[
    for i = 1, MAX_DEBUFFS do
        local debuff = _G["TargetFrameDebuff"..i]
        if debuff then
            debuff:ClearAllPoints()
            debuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", (i - 1) * 24, 4) -- 32 = 4 (offset) + 28 (icon size)
        end
    end
    ]]
        

    local debuffCount = 0
    for i = 1, MAX_DEBUFFS do
        local name, icon, count, debuffType, duration, expirationTime, unitCaster = UnitDebuff("target", i)
        if name and unitCaster == "player" then
            CreateOrUpdateDebuffIcon(debuffCount + 1, {name = name, icon = icon, duration = duration, expirationTime = expirationTime})
            debuffCount = debuffCount + 1
        end
    end

    for i = debuffCount + 1, MAX_DEBUFFS do
        local icon = myDebuffFrame["debuff" .. i]
        if icon then
            icon:Hide()
        end
    end
end


hooksecurefunc("TargetFrame_Update", TargetFrameAuraUpdate)
hooksecurefunc("TargetFrame_UpdateAuras", TargetFrameAuraUpdate)

local TargetFrameAuraEventFrame = CreateFrame("Frame")
TargetFrameAuraEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameAuraEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameAuraEventFrame:SetScript("OnEvent", TargetFrameAuraUpdate)




local TargetFrameSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
TargetFrameSpellBarBackdrop:SetPoint("TOPLEFT", TargetFrameBackdrop, "BOTTOMLEFT", 0, -2)
TargetFrameSpellBarBackdrop:SetPoint("TOPRIGHT", TargetFrameBackdrop, "BOTTOMRIGHT", 0, -2)
TargetFrameSpellBarBackdrop:SetHeight(24)
TargetFrameSpellBarBackdrop:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14 })
TargetFrameSpellBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetFrameSpellBarBackdrop:SetFrameStrata("HIGH")


local function TargetFrameSpellBarUpdate()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrameSpellBarBackdrop, "TOPLEFT", 2, -4)
    TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", TargetFrameSpellBarBackdrop, "BOTTOMRIGHT", -2, 4)
    TargetFrameSpellBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    TargetFrameSpellBar.Border:SetTexture(nil)
    TargetFrameSpellBar.Flash:SetTexture(nil)
    TargetFrameSpellBar.Spark:SetTexture(nil)

    TargetFrameSpellBar.Icon:SetSize(TargetFrameSpellBarBackdrop:GetHeight() - 4, TargetFrameSpellBarBackdrop:GetHeight() - 4)

    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("CENTER", TargetFrameSpellBarBackdrop, "CENTER", 0, 0)
    TargetFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 10)
end


TargetFrameSpellBar:HookScript("OnShow", TargetFrameSpellBarUpdate)
TargetFrameSpellBar:HookScript("OnUpdate", TargetFrameSpellBarUpdate)


local TargetFrameSpellBarFrame = CreateFrame("Frame")
TargetFrameSpellBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameSpellBarFrame:SetScript("OnEvent", TargetFrameSpellBarUpdate)


local ClassificationText = TargetFrame:CreateFontString(nil, "OVERLAY")
ClassificationText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
ClassificationText:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 4)


local function TargetFrameClassification()
    local classification = UnitClassification("target")
    if classification == "worldboss" then
        ClassificationText:SetText("Boss")
        ClassificationText:SetTextColor(1, 0.5, 0, 1)
        TargetFrameBackdrop:SetBackdropBorderColor(1, 0.5, 0, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(1, 0.5, 0, 1)
        TargetFrameTextureFrameName:SetTextColor(1, 0.5, 0, 1)
    elseif classification == "elite" then
        ClassificationText:SetText("Elite")
        ClassificationText:SetTextColor(1, 0.8, 0, 1)
        TargetFrameBackdrop:SetBackdropBorderColor(1, 0.8, 0, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(1, 0.8, 0, 1)
        TargetFrameTextureFrameName:SetTextColor(1, 0.8, 0, 1)
    elseif classification == "rare" then
        ClassificationText:SetText("Rare")
        ClassificationText:SetTextColor(1, 0.5, 0, 1)
        TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    else
        ClassificationText:SetText("")
        TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    end
end


hooksecurefunc("TargetFrame_Update", TargetFrameClassification)


local TargetFrameClassificationEventFrame = CreateFrame("Frame")
TargetFrameClassificationEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameClassificationEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameClassificationEventFrame:SetScript("OnEvent", TargetFrameClassification)


local ThreatText = ThreatText or TargetFrame:CreateFontString(nil, "OVERLAY")
ThreatText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
ThreatText:SetPoint("BOTTOM", ClassificationText, "TOP", 0, 4)


local function UpdateThreatText()
    if not UnitExists("target") or UnitIsDead("target") or not UnitCanAttack("player", "target") then
        ThreatText:Hide()
        return
    end

    local isTanking, status, threatPercentage = UnitDetailedThreatSituation("player", "target")
    if threatPercentage then
        ThreatText:SetText(string.format("%.0f%%", threatPercentage))
        ThreatText:Show()
        if isTanking or (status and status >= 2) then
            ThreatText:SetTextColor(1, 0.5, 0)
        elseif status == 1 then
            ThreatText:SetTextColor(1, 1, 0)
        else
            ThreatText:SetTextColor(0.5, 0.5, 0.5)
        end
    else
        ThreatText:Hide()
    end
end




TargetFrame:HookScript("OnShow", UpdateThreatText)
TargetFrame:HookScript("OnEvent", UpdateThreatText)
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
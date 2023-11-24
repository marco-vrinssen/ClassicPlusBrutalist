local function NameplateTextureUpdate(nameplate)
    local unitFrame = nameplate and nameplate.UnitFrame
    if not unitFrame then return end

    local healthBar = unitFrame.healthBar
    if not healthBar then return end

    local texture = healthBar:GetStatusBarTexture()
    texture:SetTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    if not healthBar.backdrop then
        healthBar.backdrop = CreateFrame("Frame", nil, healthBar, "BackdropTemplate")
        healthBar.backdrop:SetPoint("TOPLEFT", healthBar, -2, 2)
        healthBar.backdrop:SetPoint("BOTTOMRIGHT", healthBar, 2, -2)
        healthBar.backdrop:SetFrameStrata("HIGH")
        healthBar.backdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 10})
        healthBar.backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
    end

    healthBar.border:Hide()
    unitFrame.LevelFrame:Hide()

    healthBar:ClearAllPoints()
    healthBar:SetPoint("CENTER", unitFrame, "CENTER", 0, 0)
    healthBar:SetWidth(unitFrame:GetWidth())

    unitFrame.name:ClearAllPoints()
    unitFrame.name:SetPoint("BOTTOM", healthBar, "TOP", 0, 8)
    unitFrame.name:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    unitFrame.name:SetTextColor(1, 1, 1, 1)
end



local function NameplateReactionUpdate(nameplate, unitID)
    local healthBar = nameplate.UnitFrame and nameplate.UnitFrame.healthBar
    if not healthBar then return end

    local reaction = UnitReaction("player", unitID)
    local threatStatus = UnitThreatSituation("player", unitID)

    if threatStatus and threatStatus >= 2 then
        healthBar:SetStatusBarColor(1, 0.5, 0) -- Bright orange for aggro
        healthBar.backdrop:SetBackdropBorderColor(1, 0.5, 0) -- Bright orange border
    else
        if reaction then
            if reaction >= 5 then
                healthBar:SetStatusBarColor(0, 1, 0) -- Friendly NPC or player: Green
            elseif reaction == 4 then
                healthBar:SetStatusBarColor(1, 1, 0) -- Neutral NPC: Yellow
            else
                healthBar:SetStatusBarColor(1, 0, 0) -- Hostile NPC or player: Red
            end
        end
        healthBar.backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5) -- Default border color
    end
end



local MAX_DEBUFFS = 12

local function NameplateDebuffsUpdate(nameplate, unitID)
    if not nameplate then return end  -- Ensure nameplate is not nil

    if not nameplate.debuffIcons then
        nameplate.debuffIcons = {}
    end

    local activeDebuffs = {}

    for i = 1, 40 do
        local name, icon, _, _, duration, expirationTime, caster = UnitDebuff(unitID, i)
        if name and icon and caster == "player" then
            table.insert(activeDebuffs, {name, icon, duration, expirationTime})
        end
    end

    for i = 1, MAX_DEBUFFS do
        local debuffFrame = nameplate.debuffIcons[i]
        if not debuffFrame then
            debuffFrame = CreateFrame("Frame", nil, nameplate)
            debuffFrame:SetSize(28, 28)
            debuffFrame.texture = debuffFrame:CreateTexture(nil, "BORDER")
            debuffFrame.texture:SetAllPoints(debuffFrame)
            debuffFrame.cooldown = CreateFrame("Cooldown", nil, debuffFrame, "CooldownFrameTemplate")
            debuffFrame.cooldown:SetAllPoints(debuffFrame)
            nameplate.debuffIcons[i] = debuffFrame
            debuffFrame.cooldown:SetDrawSwipe(false)
        end

        local debuff = activeDebuffs[i]
        if debuff then
            local name, icon, duration, expirationTime = unpack(debuff)
            debuffFrame.texture:SetTexture(icon)
            debuffFrame.cooldown:SetCooldown(expirationTime - duration, duration)
            debuffFrame:Show()
        else
            debuffFrame:Hide()
        end
    end

    for i = 1, MAX_DEBUFFS do
        if nameplate.debuffIcons[i] and nameplate.debuffIcons[i]:IsShown() then
            if i == 1 then
                nameplate.debuffIcons[i]:SetPoint("BOTTOMLEFT", nameplate, "TOPLEFT", 0, 16)
            else
                nameplate.debuffIcons[i]:SetPoint("LEFT", nameplate.debuffIcons[i-1], "RIGHT", 4, 0)
            end
        end
    end
end


local function NameplateSpecificUpdate(unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate then
        NameplateTextureUpdate(nameplate)
        NameplateReactionUpdate(nameplate, unitID)
        NameplateDebuffsUpdate(nameplate, unitID)
    end
end


local NameplatesEventFrame = CreateFrame("Frame")
NameplatesEventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplatesEventFrame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
NameplatesEventFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
NameplatesEventFrame:RegisterEvent("UNIT_AURA")
NameplatesEventFrame:SetScript("OnEvent", function(self, event, unitID)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
        if nameplate then
            NameplateSpecificUpdate(unitID)
        end
    elseif event == "UNIT_THREAT_SITUATION_UPDATE" or event == "UNIT_THREAT_LIST_UPDATE" then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
        if nameplate then
            NameplateReactionUpdate(nameplate, unitID)
        end
    elseif event == "UNIT_AURA" then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
        if nameplate then
            NameplateDebuffsUpdate(nameplate, unitID)
        end
    end
end)
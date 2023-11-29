local function NameplateCastbarSetup(namePlate)
    local healthBar = namePlate.UnitFrame.healthBar

    namePlate.castBar = CreateFrame("StatusBar", nil, namePlate)
    namePlate.castBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill")
    namePlate.castBar:SetSize(healthBar:GetWidth(), 10)
    namePlate.castBar:SetPoint("TOP", healthBar, "BOTTOM", 0, -5)
    namePlate.castBar:SetMinMaxValues(0, 1)
    namePlate.castBar:SetValue(0)

    namePlate.castBar.backdrop = CreateFrame("Frame", nil, namePlate.castBar, "BackdropTemplate")
    namePlate.castBar.backdrop:SetPoint("TOPLEFT", namePlate.castBar, -2, 2)
    namePlate.castBar.backdrop:SetPoint("BOTTOMRIGHT", namePlate.castBar, 2, -2)
    namePlate.castBar.backdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 10})
    namePlate.castBar.backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
    namePlate.castBar.backdrop:SetFrameLevel(namePlate.castBar:GetFrameLevel() + 1)

    namePlate.castBar.text = namePlate.castBar:CreateFontString(nil, "OVERLAY")
    namePlate.castBar.text:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    namePlate.castBar.text:SetPoint("CENTER", namePlate.castBar)

    namePlate.castBar:SetScript("OnUpdate", function(self, elapsed)
        if self.casting or self.channeling then
            local currentTime = GetTime()
            if currentTime > self.maxValue then
                self:SetValue(self.maxValue)
                self.casting = false
                self.channeling = false
                self:Hide()
                self.backdrop:Hide()
            else
                self:SetValue(currentTime)
                self.backdrop:Show() -- Show the backdrop while casting
            end
        end
    end)

    namePlate.castBar:Hide()
    namePlate.castBar.backdrop:Hide()
end


local function NameplateCastbarUpdate(namePlate, unit)
    local name, _, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(unit)
    local channelName, _, _, channelStartTime, channelEndTime = UnitChannelInfo(unit)

    if name or channelName then
        local castBar = namePlate.castBar
        local duration = (endTime or channelEndTime) / 1000
        local current = GetTime()

        castBar:SetMinMaxValues((startTime or channelStartTime) / 1000, duration)
        castBar:SetValue(current)

        if notInterruptible then
            castBar:SetStatusBarColor(0.5, 0.5, 0.5) -- Grey for non-interruptible
        else
            castBar:SetStatusBarColor(0, 1, 0)
        end

        castBar.casting = name ~= nil
        castBar.channeling = channelName ~= nil
        castBar.maxValue = duration
        castBar.text:SetText(name or channelName)
        castBar:Show()
        castBar.backdrop:Show() -- Show the backdrop when the cast bar is updated
    else
        namePlate.castBar:Hide()
        namePlate.castBar.backdrop:Hide()
    end
end




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
        healthBar.backdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 10})
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
end




local function NameplateReactionUpdate(nameplate, unitID)
    local healthBar = nameplate.UnitFrame and nameplate.UnitFrame.healthBar
    if not healthBar then return end

    local reaction = UnitReaction("player", unitID)
    local threatStatus = UnitThreatSituation("player", unitID)

    if threatStatus and threatStatus >= 2 then
        healthBar:SetStatusBarColor(1, 0.5, 0) -- Bright orange for aggro
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




local function NameplateDebuffsUpdate(nameplate, unitID)
    
    local MAX_DEBUFFS = 12

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
        if not nameplate.castBar then
            NameplateCastbarSetup(nameplate)
        end
        NameplateCastbarUpdate(nameplate, unitID)
    end
end




local NameplatesEventFrame = CreateFrame("Frame")
NameplatesEventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplatesEventFrame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
NameplatesEventFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
NameplatesEventFrame:RegisterEvent("UNIT_AURA")
NameplatesEventFrame:RegisterEvent("UNIT_SPELLCAST_START")
NameplatesEventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
NameplatesEventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
NameplatesEventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

NameplatesEventFrame:SetScript("OnEvent", function(self, event, unitID)
    if event == "NAME_PLATE_UNIT_ADDED" or event == "UNIT_SPELLCAST_START" or 
       event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_START" or 
       event == "UNIT_SPELLCAST_CHANNEL_STOP" then
        NameplateSpecificUpdate(unitID)
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
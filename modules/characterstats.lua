local function CharacterStatsUpdate()
    CharacterModelFrameRotateLeftButton:Hide()
    CharacterModelFrameRotateRightButton:Hide()

    CharacterAttackFrame:SetScript("OnEnter", nil)
    CharacterAttackPowerFrame:SetScript("OnEnter", nil)
    CharacterDamageFrame:SetScript("OnEnter", nil)
    CharacterRangedAttackFrame:SetScript("OnEnter", nil)
    CharacterRangedAttackPowerFrame:SetScript("OnEnter", nil)
    CharacterRangedDamageFrame:SetScript("OnEnter", nil)

    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local missingXP = maxXP - currentXP
    local restedXP = GetXPExhaustion() or 0
    local xpPercent = floor((currentXP / maxXP) * 100)
    local restedPercent = floor((restedXP / maxXP) * 100)
    local characterLevel = UnitLevel("player")  

    local xpText = string.format("Level: |cffFFFFFF%d|r / Progress: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r\nLevel Up: |cffFFFFFF+%d|r / Rested: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r",
        characterLevel, xpPercent, currentXP, missingXP, restedPercent, restedXP)

    CharacterLevelText:SetText(xpText)

    local baseAP, posBuffAP, negBuffAP = UnitAttackPower("player")
    local meleeAP = baseAP + posBuffAP + negBuffAP
    local meleeCrit = GetCritChance()
    local meleeHit = GetHitModifier()

    local spellBonusDamage = {}
    local maxSpellPower = 0
    local schoolNames = {"Physical", "Holy", "Fire", "Nature", "Frost", "Shadow", "Arcane"}
    for i, schoolName in ipairs(schoolNames) do
        local schoolSpellPower = GetSpellBonusDamage(i)
        if i > 1 and schoolSpellPower > maxSpellPower then -- Skip "Physical" and find the max
            maxSpellPower = schoolSpellPower
        end
        table.insert(spellBonusDamage, string.format("%s: %d", schoolName, schoolSpellPower))
    end

    local bonusHealing = GetSpellBonusHealing()

    CharacterAttackFrameLabel:SetText("Attack Power")
    CharacterAttackFrameStatText:SetText(string.format(meleeAP))

    CharacterAttackPowerFrameLabel:SetText("Physical Crit")
    CharacterAttackPowerFrameStatText:SetText(string.format("%.1f%%", meleeCrit))

    CharacterDamageFrameLabel:SetText("Physical Hit")
    CharacterDamageFrameStatText:SetText(string.format("%.1f%%", meleeHit))

    CharacterRangedAttackFrameLabel:SetText("Spell Power")
    CharacterRangedAttackFrameStatText:SetText(string.format(maxSpellPower))
    CharacterRangedAttackFrame:SetScript("OnEnter", function()
        GameTooltip:SetOwner(CharacterRangedAttackFrame, "ANCHOR_RIGHT")
        for _, schoolPower in ipairs(spellBonusDamage) do
            local schoolName, spellPowerValue = strsplit(":", schoolPower)
            if schoolName ~= "Physical" then
                if schoolName == "Holy" then
                    -- Replace "Bonus Healing" with "Healing"
                    GameTooltip:AddDoubleLine("Healing", tostring(bonusHealing), 1, 0.8, 0, 1, 1, 1)
                else
                    GameTooltip:AddDoubleLine(schoolName, spellPowerValue, 1, 0.8, 0, 1, 1, 1)
                end
            end
        end
        GameTooltip:Show()
    end)
    
    CharacterRangedAttackPowerFrameLabel:SetText("Spell Crit")
    CharacterRangedAttackPowerFrameStatText:SetText(string.format("%.1f%%", GetSpellCritChance(2)))

    CharacterRangedDamageFrameLabel:SetText("Spell Hit")
    CharacterRangedDamageFrameStatText:SetText(string.format("%d%%", GetSpellHitModifier()))
end


CharacterFrame:SetScript("OnShow", CharacterStatsUpdate)


local StatsEventFrame = CreateFrame("Frame")
StatsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
StatsEventFrame:RegisterEvent("PLAYER_LEVEL_UP")
StatsEventFrame:RegisterEvent("PLAYER_XP_UPDATE")
StatsEventFrame:RegisterEvent("UPDATE_EXHAUSTION")
StatsEventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
StatsEventFrame:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_INVENTORY_CHANGED" and unit == "player" then
        C_Timer.After(0.2, CharacterStatsUpdate)
    elseif event ~= "UNIT_INVENTORY_CHANGED" then
        CharacterStatsUpdate()
    end
end)
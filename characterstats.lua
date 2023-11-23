local function CharacterFrameUpdate()

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
    
    local xpText = string.format("Level: |cffFFFFFF%d|r / Progress: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r\nLevel Up: |cffFFFFFF+%d|r / Rested: |cffFFFFFF%d%%|r |cffFFFFFF(%d)|r", characterLevel, xpPercent, currentXP, missingXP, restedPercent, restedXP)
    CharacterLevelText:SetText(xpText)
    
    local baseAP, posBuffAP, negBuffAP = UnitAttackPower("player")
    local meleeAP = baseAP + posBuffAP + negBuffAP
    local meleeCrit = GetCritChance()
    local meleeHit = GetHitModifier()
    local spellCrit = GetSpellCritChance(2)
    local spellHit = GetSpellHitModifier()

    local maxSpellPower = GetSpellBonusDamage(2)
    for i = 3, 7 do
        maxSpellPower = max(maxSpellPower, GetSpellBonusDamage(i))
    end
    spellPower = maxSpellPower

    CharacterAttackFrameLabel:SetText("Attack Power")
    CharacterAttackFrameStatText:SetText(string.format(meleeAP))

    CharacterAttackPowerFrameLabel:SetText("Melee Crit")
    CharacterAttackPowerFrameStatText:SetText(string.format("%.1f%%", meleeCrit))

    CharacterDamageFrameLabel:SetText("Melee Hit")
    CharacterDamageFrameStatText:SetText(string.format("%.1f%%", meleeHit))

    CharacterRangedAttackFrameLabel:SetText("Spell Power")
    CharacterRangedAttackFrameStatText:SetText(string.format(spellPower))

    CharacterRangedAttackPowerFrameLabel:SetText("Spell Crit")
    CharacterRangedAttackPowerFrameStatText:SetText(string.format("%.1f%%", spellCrit))

    CharacterRangedDamageFrameLabel:SetText("Spell Hit")
    CharacterRangedDamageFrameStatText:SetText(string.format("%.1f%%", spellHit))

end

CharacterFrame:SetScript("OnShow", CharacterFrameUpdate)

local CharacterFrameEventFrame = CreateFrame("Frame")
CharacterFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CharacterFrameEventFrame:RegisterEvent("PLAYER_LEVEL_UP")
CharacterFrameEventFrame:RegisterEvent("PLAYER_XP_UPDATE")
CharacterFrameEventFrame:RegisterEvent("UPDATE_EXHAUSTION")
CharacterFrameEventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
CharacterFrameEventFrame:SetScript("OnEvent", CharacterFrameUpdate)
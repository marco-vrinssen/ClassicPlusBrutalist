local function PlayerAuraUpdate(auraType, size, spacing, yOffset)
    local numAuras = 0
    local actualDisplay = auraType == "Buff" and BUFF_ACTUAL_DISPLAY or DEBUFF_ACTUAL_DISPLAY

    for i = 1, actualDisplay do
        local aura = _G[auraType .. "Button" .. i]
        if aura and aura:IsShown() then
            numAuras = numAuras + 1
        end
    end

    local totalWidth = (size + spacing) * numAuras - spacing
    local startX = -totalWidth / 2

    for i = 1, numAuras do
        local aura = _G[auraType .. "Button" .. i]
        if aura and aura:IsShown() then
            aura:ClearAllPoints()
            if i == 1 then
                aura:SetPoint("TOP", UIParent, "TOP", startX, yOffset)
            else
                aura:SetPoint("LEFT", _G[auraType .. "Button" .. (i - 1)], "RIGHT", spacing, 0)
            end
        end
    end
end


local function PlayerAuraUpdateAll()
    PlayerAuraUpdate("Buff", 30, 2, -10)
    PlayerAuraUpdate("Debuff", 30, 2, -120)
end


hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", PlayerAuraUpdateAll)


local PlayerAuraEventFrame = CreateFrame("Frame")
PlayerAuraEventFrame:RegisterEvent("PLAYER_LOGIN")
PlayerAuraEventFrame:RegisterEvent("UNIT_AURA")
PlayerAuraEventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
PlayerAuraEventFrame:SetScript("OnEvent", function(self, event, ...)
    local unit = ...
    if event == "UNIT_AURA" and unit ~= "player" then return end
    PlayerAuraUpdateAll()
end)


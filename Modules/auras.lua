local function UpdateBuffPosition()
    local BUFF_SIZE = 30
    local BUFF_SPACING = 2

    local numBuffs = 0
    for i = 1, BUFF_ACTUAL_DISPLAY do
        local buff = _G["BuffButton" .. i]
        if buff and buff:IsShown() then
            numBuffs = numBuffs + 1
        end
    end

    local totalWidth = (BUFF_SIZE + BUFF_SPACING) * numBuffs - BUFF_SPACING

    local startX = -totalWidth / 2

    for i = 1, numBuffs do
        local buff = _G["BuffButton" .. i]
        if buff and buff:IsShown() then
            buff:ClearAllPoints()
            if i == 1 then
                buff:SetPoint("TOP", UIParent, "TOP", startX, -10)
            else
                buff:SetPoint("LEFT", _G["BuffButton" .. (i - 1)], "RIGHT", BUFF_SPACING, 0)
            end
        end
    end
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UNIT_AURA")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")  -- Add this event to handle group changes

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" or event == "UNIT_AURA" or event == "GROUP_ROSTER_UPDATE" then
        local unit = ...
        if event == "UNIT_AURA" and unit ~= "player" then return end

        UpdateBuffPosition()
    end
end)


hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffPosition)
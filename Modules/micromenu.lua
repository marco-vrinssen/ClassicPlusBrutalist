local function SetupMicroMenuButtons()
    SocialsMicroButton:Hide()
    MainMenuMicroButton:Hide()
    HelpMicroButton:Hide()

    local buttons = {
        CharacterMicroButton,
        TalentMicroButton,
        SpellbookMicroButton,
        QuestLogMicroButton,
        WorldMapMicroButton
    }

    for _, button in ipairs(buttons) do
        button:ClearAllPoints()
        button:SetParent(UIParent)
        button:SetAlpha(0.25)
    end

    buttons[1]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -480, 12)

    for i = 2, #buttons do
        buttons[i]:SetPoint("LEFT", buttons[i - 1], "RIGHT", 0, 0)
    end

    local function ShowButtons()
        for _, button in ipairs(buttons) do
            UIFrameFadeIn(button, 0.25, button:GetAlpha(), 1)
        end
    end

    local function HideButtons()
        for _, button in ipairs(buttons) do
            UIFrameFadeOut(button, 0.25, button:GetAlpha(), 0.25)
        end
    end

    local hoverFrame = CreateFrame("Frame", nil, UIParent)
    hoverFrame:SetFrameStrata("BACKGROUND")
    hoverFrame:SetPoint("TOPLEFT", buttons[#buttons], "TOPLEFT")
    hoverFrame:SetPoint("BOTTOMRIGHT", buttons[1], "BOTTOMRIGHT")
    hoverFrame:SetScript("OnEnter", ShowButtons)
    hoverFrame:SetScript("OnLeave", HideButtons)

    for _, button in ipairs(buttons) do
        button:SetScript("OnEnter", ShowButtons)
        button:SetScript("OnLeave", HideButtons)
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        SetupMicroMenuButtons()
    end
end)

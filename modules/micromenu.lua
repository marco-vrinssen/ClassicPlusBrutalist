local function MicroMenuButtonAlpha(buttons, targetAlpha)
    for _, button in ipairs(buttons) do
        UIFrameFadeIn(button, 0.25, button:GetAlpha(), targetAlpha)
    end
end


local function MicroMenuButtonFrame(buttons)
    for i, button in ipairs(buttons) do
        button:ClearAllPoints()
        button:SetParent(UIParent)
        button:SetAlpha(0.2)
        if i == 1 then
            button:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -480, 16)
        else
            button:SetPoint("LEFT", buttons[i - 1], "RIGHT", 0, 0)
        end
    end
end


local function MicroMenuButtonUpdate()
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

    MicroMenuButtonFrame(buttons)

    local MicroHoverFrame = CreateFrame("Frame", nil, UIParent)
    MicroHoverFrame:SetFrameStrata("BACKGROUND")
    MicroHoverFrame:SetPoint("TOPLEFT", buttons[#buttons], "TOPLEFT")
    MicroHoverFrame:SetPoint("BOTTOMRIGHT", buttons[1], "BOTTOMRIGHT")
    
    MicroHoverFrame:SetScript("OnEnter", function() MicroMenuButtonAlpha(buttons, 1) end)
    MicroHoverFrame:SetScript("OnLeave", function() MicroMenuButtonAlpha(buttons, 0.25) end)

    for _, button in ipairs(buttons) do
        button:SetScript("OnEnter", function() MicroMenuButtonAlpha(buttons, 1) end)
        button:SetScript("OnLeave", function() MicroMenuButtonAlpha(buttons, 0.25) end)
    end
end


local MicroMenuEventFrame = CreateFrame("Frame")
MicroMenuEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MicroMenuEventFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        MicroMenuButtonUpdate()
    end
end)
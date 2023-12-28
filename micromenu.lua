local function MicroMenuButtonUpdate()
    CharacterMicroButton:Hide()
    TalentMicroButton:Hide()
    SpellbookMicroButton:Hide()
    QuestLogMicroButton:Hide()
    WorldMapMicroButton:Hide()
    SocialsMicroButton:Hide()
    MainMenuMicroButton:Hide()
    HelpMicroButton:Hide()
end

local MicroMenuEventFrame = CreateFrame("Frame")
MicroMenuEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MicroMenuEventFrame:SetScript("OnEvent", MicroMenuButtonUpdate)
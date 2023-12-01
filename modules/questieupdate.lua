local function QuestieUpdate()
    if IsAddOnLoaded("Questie") then
        Questie.db.profile.nameplateTargetFrameX = 24
        Questie.db.profile.nameplateTargetFrameY = 0
        Questie.db.profile.nameplateX = -24
        Questie.db.profile.nameplateY = 0
    end
end

local QuestieEventFrame = CreateFrame("Frame")
QuestieEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
QuestieEventFrame:SetScript("OnEvent", QuestieUpdate)
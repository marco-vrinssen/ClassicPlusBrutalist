local function GameSettingsUpdate()
    SetCVar("scriptErrors", 1)
    SetCVar("rawMouseEnable", 1)
    SetCVar("WorldTextScale", 1.5)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxGlow", 0)
end

local GameSettingsEventFrame = CreateFrame("Frame")
GameSettingsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
GameSettingsEventFrame:SetScript("OnEvent", GameSettingsUpdate)




local function SoundUpdate()
    SetCVar("Sound_OutputDriverIndex", 0)

    MuteSoundFile(555124) -- Mechastrider Loop
    MuteSoundFile(567677) -- Bow Pullback 1
    MuteSoundFile(567675) -- Bow Pullback 2
    MuteSoundFile(567676) -- Bow Pullback 3
    MuteSoundFile(567719) -- Gun Loading 1
    MuteSoundFile(567720) -- Gun Loading 2
    MuteSoundFile(567723) -- Gun Loading 3
    MuteSoundFile(567462) -- Keyring Open
    MuteSoundFile(567523) -- Keyring Close
end

local SoundEventFrame = CreateFrame("Frame")
SoundEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
SoundEventFrame:SetScript("OnEvent", SoundUpdate)




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
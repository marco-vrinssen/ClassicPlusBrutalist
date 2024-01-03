local function ConfigUpdate()
    SetCVar("scriptErrors", 1)
    SetCVar("rawMouseEnable", 1)
    SetCVar("WorldTextScale", 1.5)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxGlow", 0)

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

local ConfigEventFrame = CreateFrame("Frame")
ConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ConfigEventFrame:SetScript("OnEvent", ConfigUpdate)
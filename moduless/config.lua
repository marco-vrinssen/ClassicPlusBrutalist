local function ConfigUpdate()
    SetCVar("scriptErrors", 0)
    SetCVar("rawMouseEnable", 1)
    SetCVar("cursorSizePreferred", 0)
    SetCVar("WorldTextScale", 1.5)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxGlow", 0)
end


local function SoundUpdate()
    local soundFilesToMute = {555124, 567719, 567720, 567723, 567675, 567676, 567677}
    for _, soundFile in ipairs(soundFilesToMute) do
        MuteSoundFile(soundFile)
    end
end


local ConfigEventFrame = CreateFrame("Frame")
ConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ConfigEventFrame:SetScript("OnEvent", function()
    ConfigUpdate()
    SoundUpdate()
end)
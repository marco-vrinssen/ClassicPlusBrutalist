local function ConfigValueUpdate()
    SetCVar("scriptErrors", 1)
    SetCVar("rawMouseEnable", 1)
    SetCVar("cursorSizePreferred", 0)
    SetCVar("WorldTextScale", 1.5)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxGlow", 0)
    SetCVar("gxMaxFrameLatency", 1)
end




local function SoundFileMuteUpdate()
    local soundFilesToMute = {555124, 567719, 567720, 567723, 567675, 567676, 567677}
    for _, soundFile in ipairs(soundFilesToMute) do
        MuteSoundFile(soundFile)
    end
end




local function IntroMessage()
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFF Classic+ Pro loaded.|r")
    DEFAULT_CHAT_FRAME:AddMessage("|cFFE6CCCC Type /procommands to learn about chat commands.|r") 
end




local ConfigEventFrame = CreateFrame("Frame")
ConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ConfigEventFrame:SetScript("OnEvent", function()
    ConfigValueUpdate()
    SoundFileMuteUpdate()
    IntroMessage()
end)




local commandMessages = {
    "/healthcheck: To toggle the health check reminder for the current session.",
    "/post MESSAGE: Broadcasts MESSAGE in all joined and active chat channels.",
    "/spam MESSAGE: Sends MESSAGE to all players currently visible in the active /who list.",
    "/filter KEYWORD: Scans all active chats for a specified KEYWORD and shares matching messages in the main chat tab.",
    "/recruit MESSAGE: Delivers MESSAGE and a guild invitation to unaffiliated players listed in the active /who list.",
    "/leave: Enables quick exit from the current party or raid."
}

SLASH_PROCOMMANDS1 = "/procommands"
SlashCmdList["PROCOMMANDS"] = function()
    for _, message in ipairs(commandMessages) do
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFF" .. message .. "|r") -- Your original style
    end
end
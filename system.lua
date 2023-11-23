local function SystemUpdate()
    SetCVar("scriptErrors", 1)
    SetCVar("rawMouseEnable", 1)
    SetCVar("cursorSizePreferred", 0)
    SetCVar("WorldTextScale", 1.5)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxGlow", 0)
    SetCVar("gxMaxFrameLatency", 1)
    
    MuteSoundFile(555124)
    MuteSoundFile(567719)
    MuteSoundFile(567720)
    MuteSoundFile(567723)
    MuteSoundFile(567675)
    MuteSoundFile(567676)
    MuteSoundFile(567677)

    local messages = {
        "/post MESSAGE: Broadcasts MESSAGE in all joined and active chat channels.",
        "/spam MESSAGE: Sends MESSAGE to all players currently visible in the active /who list.",
        "/recruit MESSAGE: Delivers MESSAGE and a guild invitation to unaffiliated players listed in the active /who list.",
        "/leave: Enables quick exit from the current party or raid.",
        "/filter KEYWORD: Scans all active chats for a specified KEYWORD and shares matching messages in the main chat tab."
    }

    local style = "|cffffffbf %s|r"

    for _, message in ipairs(messages) do
        DEFAULT_CHAT_FRAME:AddMessage(string.format(style, message))
    end
end

local SystemEventFrame = CreateFrame("Frame")
SystemEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
SystemEventFrame:SetScript("OnEvent", SystemUpdate)
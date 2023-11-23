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
        "1. /leave: Leave your party or raid.",
        "2. /post MESSAGE: Sends the MESSAGE across all active channels.",
        "3. /spam MESSAGE: Sends the MESSAGE to all players currently displayed in an open /who window.",
        "4. /recruit MESSAGE: Sends the MESSAGE and guild invite to all players who are not in a guild and are currently displayed in an open /who window.",
        "5. /filter KEYWORD: Filters all channels for the specific KEYWORD and resends the appropriate message when a match is found."
    }

    local style = "|cffffffbf %s|r"

    for _, message in ipairs(messages) do
        DEFAULT_CHAT_FRAME:AddMessage(string.format(style, message))
    end
end

local SystemEventFrame = CreateFrame("Frame")
SystemEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
SystemEventFrame:SetScript("OnEvent", SystemUpdate)
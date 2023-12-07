local function CommandInfo()
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFF Classic+ Pro loaded.|r")
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFF Type /procmd for chat commands.|r") 
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFF Press B to open all Bags.|r") 
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFF Autolooting enabled.|r")
end

local CommandEventFrame = CreateFrame("Frame")
CommandEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CommandEventFrame:SetScript("OnEvent", CommandInfo)




local commandMessages = {
    "/healthcheck: To toggle the health check reminder for the current session.",
    "/post MESSAGE: Broadcasts MESSAGE in all joined and active chat channels.",
    "/spam MESSAGE: Sends MESSAGE to all players currently visible in the active /who list.",
    "/filter KEYWORD: Scans all active chats for a specified KEYWORD and shares matching messages in the main chat tab.",
    "/recruit MESSAGE: Delivers MESSAGE and a guild invitation to unaffiliated players listed in the active /who list.",
    "/leave: Enables quick exit from the current party or raid."
}

SLASH_PROCMD1 = "/procmd"
SlashCmdList["PROCMD"] = function()
    for _, message in ipairs(commandMessages) do
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFFFF" .. message .. "|r") -- Your original style
    end
end




local FilterKeywords = {}
SlashCmdList["FILTER"] = function(msg)
    if msg == "" then
        print("Current filter keywords:")
        for i, keyword in ipairs(FilterKeywords) do
            print(i .. ". " .. keyword)
        end
    elseif msg == "clear" then
        wipe(FilterKeywords)
        print("|cffffff00Filter cleared.|r")
    else
        table.insert(FilterKeywords, msg)
        print("|cffffff00Filtering for \"" .. msg .. "\" in all channels.|r")
    end
end
SLASH_FILTER1 = "/filter"

local ChatFilterEventFrame = CreateFrame("FRAME")
ChatFilterEventFrame:RegisterEvent("CHAT_MSG_CHANNEL")
ChatFilterEventFrame:SetScript("OnEvent", function(self, event, msg, playerName, languageName, channelName, ...)
    if next(FilterKeywords) ~= nil and strmatch(channelName, "%d+") then
        local channelNumber = tonumber(strmatch(channelName, "%d+"))
        if channelNumber and channelNumber >= 1 and channelNumber <= 5 then
            for _, keyword in ipairs(FilterKeywords) do
                if strfind(strlower(msg), strlower(keyword)) then
                    local playerLink = "|Hplayer:" .. playerName .. "|h|cffffff00[" .. playerName .. "]|h|r"
                    local filteredMsg = playerLink .. ": |cffffffbf" .. msg .. "|r"
                    DEFAULT_CHAT_FRAME:AddMessage(filteredMsg)
                    PlaySound("3081")
                    break
                end
            end
        end
    end
end)




local function ChannelPost(msg)
    if msg ~= "" then
        for i = 2, 10 do
            SendChatMessage(msg, "CHANNEL", nil, i)
        end
    end
end

SLASH_POST1 = "/post"
SlashCmdList["POST"] = ChannelPost




local function WhisperSpam(msg)
    if msg ~= "" then
        local numWhos, totalCount = C_FriendList.GetNumWhoResults()
        for i = 1, numWhos do
            local info = C_FriendList.GetWhoInfo(i)
            if info and info.fullName then
                SendChatMessage(msg, "WHISPER", nil, info.fullName)
            end
        end
    end
end

SLASH_SPAM1 = "/spam"
SlashCmdList["SPAM"] = WhisperSpam




local function CloseWhisperWindows()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        local chatFrame = _G[chatFrameName]
        if chatFrame and chatFrame.isTemporary then
            FCF_Close(chatFrame)
        end
    end
end

SLASH_CLEAN1 = "/clean"
SlashCmdList["CLEAN"] = CloseWhisperWindows




function GroupLeave()
    if IsInGroup() or IsInRaid() then
        LeaveParty()
    end
end

SLASH_QUIT1 = "/q"
SlashCmdList["QUIT"] = GroupLeave
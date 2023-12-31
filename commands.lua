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




local visibleWhoCount = nil  -- Global variable to store the count of visible /who entries

local function WhoFilterUpdate(maxCount)
    visibleWhoCount = maxCount  -- Update the global variable with the new count
    local numWhos = C_FriendList.GetNumWhoResults()

    for i = maxCount + 1, numWhos do
        local button = _G["WhoFrameButton"..i]
        if button then
            button:Hide()
        end
    end
end

SLASH_REDUCE1 = '/reduce'
SlashCmdList["REDUCE"] = function(msg)
    if WhoFrame:IsShown() then
        local count = tonumber(msg)
        if not count or count < 1 then
            print("Invalid number. Please enter a valid number after /reduce.")
            return
        end
        WhoFilterUpdate(count)
    else
        print("Please open the /who list first.")
    end
end




local function WhisperSpam(msg)
    if msg ~= "" then
        local numWhos = visibleWhoCount or C_FriendList.GetNumWhoResults()  -- Use the global variable if set
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

SLASH_CLEAR1 = "/clear"
SlashCmdList["CLEAR"] = CloseWhisperWindows




function GroupLeave()
    if IsInGroup() or IsInRaid() then
        LeaveParty()
    end
end

SLASH_QUIT1 = "/q"
SlashCmdList["QUIT"] = GroupLeave
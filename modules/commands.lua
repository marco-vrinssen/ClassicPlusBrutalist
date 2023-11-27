
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

local ChatFilter = CreateFrame("FRAME")
ChatFilter:RegisterEvent("CHAT_MSG_CHANNEL")
ChatFilter:SetScript("OnEvent", function(self, event, msg, playerName, languageName, channelName, ...)
    if next(FilterKeywords) ~= nil and strmatch(channelName, "%d+") then
        local channelNumber = tonumber(strmatch(channelName, "%d+"))
        if channelNumber and channelNumber >= 1 and channelNumber <= 5 then
            for _, keyword in ipairs(FilterKeywords) do
                if strfind(strlower(msg), strlower(keyword)) then
                    -- Format the player name as a clickable hyperlink with color
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




local function PostChannel(msg)
    if msg ~= "" then
        for i = 2, 10 do
            SendChatMessage(msg, "CHANNEL", nil, i)
        end
    end
end

SLASH_POST1 = "/post"
SlashCmdList["POST"] = PostChannel




local function WhoWhisper(msg)
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
SlashCmdList["SPAM"] = WhoWhisper




local function WhisperGuildinvite(msg)
    if msg ~= "" then
        local numWhos, totalCount = C_FriendList.GetNumWhoResults()
        for i = 1, numWhos do
            local info = C_FriendList.GetWhoInfo(i)
            if info and info.fullName and (not info.fullGuildName or info.fullGuildName == "") then
                SendChatMessage(msg, "WHISPER", nil, info.fullName)
                GuildInvite(info.fullName)
            end
        end
    end
end

SLASH_RECRUIT1 = "/recruit"
SlashCmdList["RECRUIT"] = WhisperGuildinvite




function LeaveGroup()
    if IsInGroup() or IsInRaid() then
        LeaveParty()
    end
end

SLASH_LEAVEPARTY1 = "/leave"
SlashCmdList["LEAVEPARTY"] = LeaveGroup
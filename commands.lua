local function Broadcast(msg)
    if msg ~= "" then
        local numWhos = visibleWhoCount or C_FriendList.GetNumWhoResults()
        if numWhos and numWhos > 0 then
            for i = 1, numWhos do
                local info = C_FriendList.GetWhoInfo(i)
                if info and info.fullName then
                    SendChatMessage(msg, "WHISPER", nil, info.fullName)
                end
            end
        else
            for i = 2, 10 do
                SendChatMessage(msg, "CHANNEL", nil, i)
            end
        end
    end
end

SLASH_BC1 = "/bc"
SlashCmdList["BC"] = Broadcast




local function ClearChatTabs()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        local chatFrame = _G[chatFrameName]
        if chatFrame and chatFrame.isTemporary then
            FCF_Close(chatFrame)
        end
    end
end

SLASH_CLEAR1 = "/c"
SlashCmdList["CLEAR"] = ClearChatTabs




function LeaveGroup()
    if IsInGroup() or IsInRaid() then
        LeaveParty()
    end
end

SLASH_QUIT1 = "/q"
SlashCmdList["QUIT"] = LeaveGroup
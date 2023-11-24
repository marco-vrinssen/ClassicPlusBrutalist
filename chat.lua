local function ChatFrameHideElements(frame, elements)
    for _, element in ipairs(elements) do
        local chatElement = _G[frame:GetName() .. element]
        if chatElement then
            chatElement:Hide()
        end
    end
end


local function ChatFrameHideTextures(frame)
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region:IsObjectType("Texture") then
            region:SetTexture(nil)
        end
    end
end


local function ChatFrameCustomization(chatFrame)
    chatFrame:SetSize(320, 160)
    chatFrame:SetClampedToScreen(false)
    chatFrame:SetPoint("BOTTOMLEFT", 24, 48)
    chatFrame:SetMovable(true)
    chatFrame:SetUserPlaced(true)

    ChatFrameHideElements(chatFrame, {"ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight"})
    ChatFrameHideTextures(chatFrame)
    ChatFrameMenuButton:Hide()
    ChatFrameChannelButton:Hide()

    local tab = _G[chatFrame:GetName() .. "Tab"]
    ChatFrameHideTextures(tab)
    local tabFontString = tab:GetFontString()
    if tabFontString then
        tabFontString:SetFont(STANDARD_TEXT_FONT, 14)
    end
end


local function ChatFrameUpdate()
    for i = 1, NUM_CHAT_WINDOWS do
        ChatFrameCustomization(_G["ChatFrame" .. i])
    end
end


local ChatEventFrame = CreateFrame("Frame")
ChatEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatEventFrame:RegisterEvent("PLAYER_LOGIN")
ChatEventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
ChatEventFrame:RegisterEvent("UI_SCALE_CHANGED")
ChatEventFrame:SetScript("OnEvent", function(self, event)
    ChatFrameUpdate()
end)


local function ScrollToBottom(chatFrame)
    if not chatFrame then return end
    chatFrame:ScrollToBottom()
end


local function HookChatTab(tab)
    if not tab then return end
    tab:HookScript("OnClick", function() 
        ScrollToBottom(SELECTED_DOCK_FRAME) 
    end)
end


local function CustomizeAndHookChatTabs()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            ChatFrameCustomization(chatFrame)
            HookChatTab(_G[chatFrame:GetName() .. "Tab"])
        end
    end

    hooksecurefunc("FCF_OpenTemporaryWindow", function(chatType)
        if chatType ~= "WHISPER" and chatType ~= "BN_WHISPER" then return end
        local chatFrame = FCF_GetCurrentChatFrame()
        if chatFrame then
            ChatFrameCustomization(chatFrame)
            HookChatTab(_G[chatFrame:GetName() .. "Tab"])
        end
    end)
end


CustomizeAndHookChatTabs()


local function ChatConfig()
    SetCVar("chatClassColorOverride", "0")
    if ChatFrame2 then
        FCF_Close(ChatFrame2)
    end
end


local ChatConfigEventFrame = CreateFrame("Frame")
ChatConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatConfigEventFrame:SetScript("OnEvent", ChatConfig)


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
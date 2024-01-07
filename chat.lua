local function HookChatTab(tab)
    if not tab or tab.isHooked then return end
    tab.isHooked = true
    tab:HookScript("OnClick", function() 
        if SELECTED_DOCK_FRAME then 
            SELECTED_DOCK_FRAME:ScrollToBottom() 
        end
    end)
end

local function ChatElementUpdate(frame)
    local elementsToHide = {"ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight", "EditBoxHeaderSuffix"}
    for _, element in ipairs(elementsToHide) do
        local chatElement = _G[frame:GetName() .. element]
        if chatElement then
            chatElement:Hide()
        end
    end
end

local function ChatTextureUpdate(frame)
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region:IsObjectType("Texture") then
            region:SetTexture(nil)
        end
    end
end

local function ChatFrameUpdate(chatFrame)
    chatFrame:ClearAllPoints()
    chatFrame:SetSize(320, 160)
    chatFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 32, 48)
    chatFrame:SetClampedToScreen(false)

    ChatElementUpdate(chatFrame)
    ChatTextureUpdate(chatFrame)

    ChatFrameMenuButton:Hide()
    ChatFrameChannelButton:Hide()

    local tab = _G[chatFrame:GetName() .. "Tab"]
    ChatTextureUpdate(tab)
    local tabFontString = tab:GetFontString()
    if tabFontString then
        tabFontString:SetFont(STANDARD_TEXT_FONT, 14)
    end
end

local function ChatUpdate()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        ChatFrameUpdate(chatFrame)
        HookChatTab(_G["ChatFrame" .. i .. "Tab"])
    end
end

local function OnTemporaryWindowOpen(chatType)
    if chatType ~= "WHISPER" and chatType ~= "BN_WHISPER" then return end
    local chatFrame = FCF_GetCurrentChatFrame()
    ChatFrameUpdate(chatFrame)
    HookChatTab(_G[chatFrame:GetName() .. "Tab"])
end

local ChatEventFrame = CreateFrame("Frame")
ChatEventFrame:RegisterEvent("PLAYER_LOGIN")
ChatEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatEventFrame:RegisterEvent("UI_SCALE_CHANGED")
ChatEventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
ChatEventFrame:SetScript("OnEvent", ChatUpdate)

hooksecurefunc("FCF_OpenTemporaryWindow", OnTemporaryWindowOpen)

local function ChatConfigUpdate()
    if ChatFrame2 then
        FCF_Close(ChatFrame2)
    end
end

local ChatConfigEventFrame = CreateFrame("Frame")
ChatConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatConfigEventFrame:SetScript("OnEvent", ChatConfigUpdate)




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

SLASH_LIMIT1 = '/limit'
SlashCmdList["LIMIT"] = function(msg)
    if WhoFrame:IsShown() then
        local count = tonumber(msg)
        if not count or count < 1 then
            return
        end
        WhoFilterUpdate(count)
    end
end




local function PostMessage(msg)
    if msg ~= "" then
        for i = 2, 10 do
            SendChatMessage(msg, "CHANNEL", nil, i)
        end
    end
end

SLASH_BROADCAST1 = "/post"
SlashCmdList["BROADCAST"] = PostMessage




local function SpamPlayers(msg)
    if msg ~= "" then
        local numWhos = visibleWhoCount or C_FriendList.GetNumWhoResults()
        if numWhos and numWhos > 0 then
            for i = 1, numWhos do
                local info = C_FriendList.GetWhoInfo(i)
                if info and info.fullName then
                    SendChatMessage(msg, "WHISPER", nil, info.fullName)
                end
            end
        end
    end
end

SLASH_SPAM1 = "/spam"
SlashCmdList["SPAM"] = SpamPlayers




local function ClearChatTabs()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        local chatFrame = _G[chatFrameName]
        if chatFrame and chatFrame.isTemporary then
            FCF_Close(chatFrame)
        end
    end
end

SLASH_CLEAR1 = "/clear"
SlashCmdList["CLEAR"] = ClearChatTabs




function LeaveGroup()
    if IsInGroup() or IsInRaid() then
        LeaveParty()
    end
end

SLASH_QUIT1 = "/q"
SlashCmdList["QUIT"] = LeaveGroup
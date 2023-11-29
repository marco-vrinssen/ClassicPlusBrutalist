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
    chatFrame:SetPoint("BOTTOMLEFT", 16, 48)
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




local function ChatConfigUpdate()
    SetCVar("chatClassColorOverride", "0")
    if ChatFrame2 then
        FCF_Close(ChatFrame2)
    end
end


local ChatConfigEventFrame = CreateFrame("Frame")
ChatConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatConfigEventFrame:SetScript("OnEvent", ChatConfigUpdate)
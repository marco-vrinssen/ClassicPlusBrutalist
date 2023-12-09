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




local function ChatUpdate()
    local elementsToHide = {"ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight"}

    local function HideChatElements(frame)
        for _, element in ipairs(elementsToHide) do
            local chatElement = _G[frame:GetName() .. element]
            if chatElement then
                chatElement:Hide()
            end
        end
    end

    local function HideChatTextures(frame)
        for i = 1, frame:GetNumRegions() do
            local region = select(i, frame:GetRegions())
            if region:IsObjectType("Texture") then
                region:SetTexture(nil)
            end
        end
    end

    local function CustomizeChatFrame(chatFrame)
        chatFrame:ClearAllPoints()
        chatFrame:SetSize(320, 160)
        chatFrame:SetPoint("BOTTOMLEFT", 24, 48)
        chatFrame:SetClampedToScreen(false)

        HideChatElements(chatFrame)
        HideChatTextures(chatFrame)

        ChatFrameMenuButton:Hide()
        ChatFrameChannelButton:Hide()

        local tab = _G[chatFrame:GetName() .. "Tab"]
        HideChatTextures(tab)
        local tabFontString = tab:GetFontString()
        if tabFontString then
            tabFontString:SetFont(STANDARD_TEXT_FONT, 14)
        end
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        CustomizeChatFrame(chatFrame)
        HookChatTab(_G["ChatFrame" .. i .. "Tab"])
    end

    hooksecurefunc("FCF_OpenTemporaryWindow", function(chatType)
        if chatType ~= "WHISPER" and chatType ~= "BN_WHISPER" then return end
        local chatFrame = FCF_GetCurrentChatFrame()
        CustomizeChatFrame(chatFrame)
        HookChatTab(_G[chatFrame:GetName() .. "Tab"])
    end)

end

local ChatEventFrame = CreateFrame("Frame")
ChatEventFrame:RegisterEvent("PLAYER_LOGIN")
ChatEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatEventFrame:RegisterEvent("UI_SCALE_CHANGED")
ChatEventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
ChatEventFrame:SetScript("OnEvent", ChatUpdate)

hooksecurefunc("FCF_OpenTemporaryWindow", ChatUpdate)




local function ChatConfigUpdate()
    if ChatFrame2 then
        FCF_Close(ChatFrame2)
    end
end

local ChatConfigEventFrame = CreateFrame("Frame")
ChatConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatConfigEventFrame:SetScript("OnEvent", ChatConfigUpdate)
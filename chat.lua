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
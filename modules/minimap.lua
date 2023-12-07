local CustomMinimapBackdrop = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
CustomMinimapBackdrop:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -4, 4)
CustomMinimapBackdrop:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, -4)
CustomMinimapBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
CustomMinimapBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
CustomMinimapBackdrop:SetFrameStrata("LOW")

local function MinimapUpdate()
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
    Minimap:SetSize(140, 140)
    Minimap:SetMaskTexture("Interface/ChatFrame/ChatFrameBackground") 

    GameTimeFrame:Hide()
    MinimapCompassTexture:SetTexture(nil)
    MinimapZoneTextButton:Hide()
    MinimapToggleButton:Hide()
    MinimapBorderTop:Hide()
    MinimapBackdrop:Hide()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()

    if MinimapTrackingFrame then
        MinimapTrackingFrame:ClearAllPoints()
        MinimapTrackingFrame:SetPoint("CENTER", UIParent, "TOPLEFT", -8, 0)
        self:SetScript("OnUpdate", nil)
    end

    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 0)
    TimeManagerClockButton:SetScale(1.5)

    for i = 1, TimeManagerClockButton:GetNumRegions() do
        local region = select(i, TimeManagerClockButton:GetRegions())
        if region and region:IsObjectType("Texture") then
            region:SetTexture(nil)
        end
    end

    MiniMapMailBorder:Hide()
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -8, -4)

    MiniMapBattlefieldBorder:Hide()
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 8, 0)
end

local MinimapEventFrame = CreateFrame("Frame")
MinimapEventFrame:RegisterEvent("PLAYER_LOGIN")
MinimapEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapEventFrame:RegisterEvent("ZONE_CHANGED")
MinimapEventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
MinimapEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MinimapEventFrame:SetScript("OnEvent", MinimapUpdate)




local function MinimapZoom(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

local MinimapZoomEventFrame = CreateFrame("Frame", nil, Minimap)
MinimapZoomEventFrame:SetAllPoints(Minimap)
MinimapZoomEventFrame:EnableMouseWheel(true)
MinimapZoomEventFrame:SetScript("OnMouseWheel", MinimapZoom)




local function MinimapConfigUpdate()
    SetCVar("rotateMinimap", 0)

    function GetMinimapShape()
        return "SQUARE"
    end
end

local MinimapConfigEventFrame = CreateFrame("Frame")
MinimapConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapConfigEventFrame:SetScript("OnEvent", MinimapConfigUpdate)
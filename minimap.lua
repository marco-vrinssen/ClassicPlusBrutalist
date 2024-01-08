local function MinimapUpdate()
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
    Minimap:SetSize(140, 140)

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
    TimeManagerClockButton:SetScale(1.25)

    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("CENTER", Minimap, "BOTTOM", -40, 0)

    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetPoint("CENTER", Minimap, "BOTTOM", 40, 0)

    for i = 1, TimeManagerClockButton:GetNumRegions() do
        local region = select(i, TimeManagerClockButton:GetRegions())
        if region and region:IsObjectType("Texture") then
            region:SetTexture(nil)
        end
    end

    function GetMinimapShape()
        return "ROUND"
    end
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
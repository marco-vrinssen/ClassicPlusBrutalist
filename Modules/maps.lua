local CustomMinimapBackdrop = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
CustomMinimapBackdrop:SetSize(140, 140)
CustomMinimapBackdrop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
CustomMinimapBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14})
CustomMinimapBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
CustomMinimapBackdrop:SetFrameStrata("HIGH")


local function MinimapUpdate()
    Minimap:ClearAllPoints()
    Minimap:SetClampedToScreen(false)
    Minimap:SetMaskTexture("Interface/BUTTONS/WHITE8X8")
    Minimap:SetPoint("TOPLEFT", CustomMinimapBackdrop, "TOPLEFT", 4, -4)
    Minimap:SetPoint("BOTTOMRIGHT", CustomMinimapBackdrop, "BOTTOMRIGHT", -4, 4)

    function GetMinimapShape()
        return "SQUARE"
    end

    GameTimeFrame:Hide()
    MinimapCompassTexture:SetTexture(nil)
    MinimapZoneTextButton:Hide()
    MinimapToggleButton:Hide()
    MinimapBorderTop:Hide()
    MinimapBackdrop:Hide()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()

    TimeManagerClockButton:Hide()
    TimeManagerClockButton.Show =  TimeManagerClockButton.Hide
 
    TimeManagerClockTicker:ClearAllPoints()
    TimeManagerClockTicker:SetParent(Minimap)
    TimeManagerClockTicker:SetPoint("TOP", CustomMinimapBackdrop, "BOTTOM", 0, -8)

    SetCVar("timeMgrUseMilitaryTime", "1")

    MiniMapMailBorder:Hide()
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("TOP", TimeManagerClockTicker, "BOTTOM", 0, -2)

    MiniMapBattlefieldBorder:Hide()
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetPoint("RIGHT", TimeManagerClockTicker, "LEFT", -4, 0)
end


local MinimapEventFrame = CreateFrame("Frame")
MinimapEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapEventFrame:RegisterEvent("ZONE_CHANGED")
MinimapEventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
MinimapEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MinimapEventFrame:SetScript("OnEvent", MinimapUpdate)
local function BagsUpdate()

    MainMenuBarBackpackButton:Hide()
    CharacterBag0Slot:ClearAllPoints()
    CharacterBag0Slot:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -16, 16)
    CharacterBag0Slot:SetParent(ContainerFrame1)
    CharacterBag1Slot:ClearAllPoints()
    CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -8, 0)
    CharacterBag1Slot:SetParent(ContainerFrame1)
    CharacterBag2Slot:ClearAllPoints()
    CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -8, 0)
    CharacterBag2Slot:SetParent(ContainerFrame1)
    CharacterBag3Slot:ClearAllPoints()
    CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -8, 0)
    CharacterBag3Slot:SetParent(ContainerFrame1)

    ContainerFrame1:ClearAllPoints()
    ContainerFrame2:ClearAllPoints()
    ContainerFrame3:ClearAllPoints()
    ContainerFrame4:ClearAllPoints()
    ContainerFrame5:ClearAllPoints()
    ContainerFrame6:ClearAllPoints()
    ContainerFrame1:SetPoint("BOTTOMRIGHT", CharacterBag0Slot, "TOPRIGHT", 6, 8)
    ContainerFrame2:SetPoint("TOPRIGHT", ContainerFrame1, "TOPLEFT", 0, 0)
    ContainerFrame3:SetPoint("TOPRIGHT", ContainerFrame2, "TOPLEFT", 0, 0)
    ContainerFrame4:SetPoint("BOTTOM", ContainerFrame2, "TOP", 0, 8)
    ContainerFrame5:SetPoint("BOTTOM", ContainerFrame3, "TOP", 0, 8)
    
    ContainerFrame1AddSlotsButton:Hide()
    ContainerFrame1AddSlotsButton.Show = ContainerFrame1AddSlotsButton.Hide
    ContainerFrame1AddSlotsButton.SetShown = ContainerFrame1AddSlotsButton.Hide

    KeyRingButton:Hide()
    KeyRingButton.Show = KeyRingButton.Hide
    KeyRingButton.SetShown = KeyRingButton.Hide
   
end


hooksecurefunc("UpdateContainerFrameAnchors", BagsUpdate)


local BagsEventFrame = CreateFrame("Frame")
BagsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
BagsEventFrame:RegisterEvent("MERCHANT_SHOW")
BagsEventFrame:RegisterEvent("MERCHANT_CLOSED")
BagsEventFrame:SetScript("OnEvent", function()
    BagsUpdate()
end)




local BagsConfigFrame = CreateFrame("Frame")
BagsConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
BagsConfigFrame:SetScript("OnEvent", function()
    C_Container.SetInsertItemsLeftToRight(true)
end)
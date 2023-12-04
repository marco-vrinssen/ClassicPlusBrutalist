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

    ContainerFrame1AddSlotsButton:Hide()
    ContainerFrame1AddSlotsButton.Show = ContainerFrame1AddSlotsButton.Hide

    KeyRingButton:ClearAllPoints()
    KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -8, -1)
    KeyRingButton:SetParent(ContainerFrame1)

    ContainerFrame1:ClearAllPoints()
    ContainerFrame1:SetPoint("BOTTOMRIGHT", CharacterBag0Slot, "TOPRIGHT", 6, 8)

    ContainerFrame2:ClearAllPoints()
    ContainerFrame2:SetPoint("TOPRIGHT", ContainerFrame1, "TOPLEFT", 0, 0)

    ContainerFrame3:ClearAllPoints()
    ContainerFrame3:SetPoint("TOPRIGHT", ContainerFrame2, "TOPLEFT", 0, 0)

    ContainerFrame4:ClearAllPoints()
    ContainerFrame4:SetPoint("BOTTOM", ContainerFrame2, "TOP", 0, 8)

    ContainerFrame5:ClearAllPoints()
    ContainerFrame5:SetPoint("TOPRIGHT", ContainerFrame4, "TOPLEFT", 0, 0)

    local mainBagIsOpen = IsBagOpen(0)
    local keyringIsOpen = IsBagOpen(KEYRING_CONTAINER)

    if not mainBagIsOpen and keyringIsOpen then
        ToggleBag(KEYRING_CONTAINER)
    end

    if ContainerFrame6:GetID() == KEYRING_CONTAINER then
        ContainerFrame6:ClearAllPoints()
        ContainerFrame6:SetPoint("BOTTOM", ContainerFrame1, "TOP", 0, 8)
    end
end


hooksecurefunc("ToggleBackpack", BagsUpdate)
hooksecurefunc("UpdateContainerFrameAnchors", BagsUpdate)


local BagsEventFrame = CreateFrame("Frame")
BagsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
BagsEventFrame:RegisterEvent("BAG_UPDATE")
BagsEventFrame:RegisterEvent("MERCHANT_SHOW")
BagsEventFrame:RegisterEvent("MERCHANT_CLOSED")
BagsEventFrame:SetScript("OnEvent", BagsUpdate)








local function BagsConfigUpdate()
    C_Container.SetInsertItemsLeftToRight(true)
    SetBinding("B", "OPENALLBAGS")
    SaveBindings(2)
end


local BagsConfigEventFrame = CreateFrame("Frame")
BagsConfigEventFrame:RegisterEvent("PLAYER_LOGIN")
BagsConfigEventFrame:SetScript("OnEvent", BagsConfigUpdate)
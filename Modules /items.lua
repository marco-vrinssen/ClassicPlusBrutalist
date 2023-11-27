local function AutoLootUpdate()
    if GetNumLootItems() > 0 then
        for i = 1, GetNumLootItems() do
            LootSlot(i)
        end
    end
end


local AutoLootEventFrame = CreateFrame("Frame")
AutoLootEventFrame:RegisterEvent("LOOT_READY")
AutoLootEventFrame:SetScript("OnEvent", AutoLootUpdate)


local LootConfigEventFrame = CreateFrame("Frame")
LootConfigEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
LootConfigEventFrame:SetScript("OnEvent", function()
    SetCVar("autoLootDefault", 1)
    SetCVar("lootUnderMouse", 0)
end)


local function MerchantUpdate()
    local repairCost, totalSold = 0, 0
    local CanMerchantRepair, RepairAllItems, GetRepairAllCost = CanMerchantRepair, RepairAllItems, GetRepairAllCost
    local GetContainerNumSlots, GetContainerItemLink, UseContainerItem = C_Container.GetContainerNumSlots, C_Container.GetContainerItemLink, C_Container.UseContainerItem
    local GetItemInfo = GetItemInfo

    if CanMerchantRepair() then
        repairCost = GetRepairAllCost()
        if repairCost > 0 then
            RepairAllItems()
            DEFAULT_CHAT_FRAME:AddMessage("Items repaired for " .. GetCoinTextureString(repairCost), 1, 1, 0)
        end
    end

    for bagIndex = 0, 4 do
        for slotIndex = 1, GetContainerNumSlots(bagIndex) do
            local itemLink = GetContainerItemLink(bagIndex, slotIndex)
            if itemLink then
                local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink)
                if itemRarity == 0 and itemSellPrice ~= 0 then
                    totalSold = totalSold + itemSellPrice
                    UseContainerItem(bagIndex, slotIndex)
                end
            end
        end
    end

    if totalSold > 0 then
        DEFAULT_CHAT_FRAME:AddMessage("Trash sold for " .. GetCoinTextureString(totalSold), 1, 1, 0)
    end
end


local MerchantEventFrame = CreateFrame("Frame")
MerchantEventFrame:RegisterEvent("MERCHANT_SHOW")
MerchantEventFrame:SetScript("OnEvent", MerchantUpdate)
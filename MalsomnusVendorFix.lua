local ADDON, data = ...

hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
    if (MerchantFrame:IsVisible() == false) then return end

    local numMerchantItems = GetMerchantNumItems()
    --ChatFrame1:AddMessage(numMerchantItems .. ' items')
   
    local name, price, numAvailable, isPurchasable, isUsable, extendedCost, currencyID;
 
    for i = 1, MERCHANT_ITEMS_PER_PAGE do
        local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
        if index > numMerchantItems then break end

        name, _, price, _, numAvailable, isPurchasable, isUsable, extendedCost, currencyID = GetMerchantItemInfo(index);
        if ( extendedCost and (price <= 0) ) then
            --print('---')
            --print(name, 'can afford:', CanAffordMerchantItem(index))
         
            local numberOfPriceItems = GetMerchantItemCostInfo(index);
         
            if numberOfPriceItems > 0 then
                for j=1, MAX_ITEM_COST do
                    local _, amountRequired, itemLink, currencyName = GetMerchantItemCostItem(index, j)
                   
                    local isCurrency = not (currencyName == nil)
               
                    if (itemLink) then 
                        local itemId = itemLink:match("item:(%d+)")
                        local amountAvailable 
                        if (isCurrency) then
                            local info = C_CurrencyInfo.GetCurrencyInfoFromLink(itemLink)
                            amountAvailable = info.quantity
                        else
                            amountAvailable = GetItemCount(itemId, true)
                        end
                  
                        if (amountAvailable < amountRequired) then
                            _G["MerchantItem" .. i .. "AltCurrencyFrameItem" .. j].Text:SetTextColor(0.5, 0.5, 0.5)
                        else
                            _G["MerchantItem" .. i .. "AltCurrencyFrameItem" .. j].Text:SetTextColor(1, 1, 1)
                        end
                    end
                end
            else
                -- Nothing to do if there are no price items
            end
        end
    end
end)

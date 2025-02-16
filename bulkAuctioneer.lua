-- Function to count available items in bags
local function CountItemInBags(itemName)
    local count = 0
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link and string.find(link, itemName, 1, true) then
                local _, itemCount = GetContainerItemInfo(bag, slot)
                count = count + itemCount
            end
        end
    end
    return count
end

-- Function to queue auctions safely
local function QueueAuction(stackSize, stackAmount, startPrice, buyoutPrice, duration)
    local itemName = GetAuctionSellItemInfo()
    if not itemName then 
        print("No item selected in auction slot!")
        return
    end  

    local availableCount = CountItemInBags(itemName)
    local maxStacks = math.floor(availableCount / stackSize)

    if maxStacks < stackAmount then
        print("Not enough items! You can only post " .. maxStacks .. " stacks of " .. stackSize)
        stackAmount = maxStacks  -- Reduce stack amount to what’s possible
    end

    if stackAmount == 0 then
        print("You don’t have enough items to post any auctions!")
        return
    end

    for i = 1, stackAmount do
        table.insert(auctionQueue, {
            startPrice = startPrice,
            buyoutPrice = buyoutPrice,
            duration = duration,
            stackSize = stackSize
        })
    end

    print("Queued " .. stackAmount .. " stacks of " .. itemName .. " (" .. stackSize .. " per stack)")
end

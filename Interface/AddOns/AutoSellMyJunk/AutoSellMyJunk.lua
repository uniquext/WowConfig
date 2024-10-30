-- Author      : Ryura13
-- Create Date : 3/29/2018 10:18:27 AM
--Updated to include autorepair: 9/23/2018
function oncall()
	autosell:RegisterEvent("MERCHANT_SHOW");

end


	function AutoSell()
	--to sell junk items at a vendor when vendor window is opened... also lists sold items in chat
	 local p,N,c,n=0 for b=0,4 do for s=1,C_Container.GetContainerNumSlots (b) do n=C_Container.GetContainerItemLink(b,s) 
                if n and string.find(n,"9d9d9d") then N={GetItemInfo(n)} 
                c=GetItemCount(n) p=p+(N[11]*c)C_Container.UseContainerItem(b,s) --print(n) 
	 end end end 
         if p ~= 0 then print(GetCoinText(p))  end

	 --code for auotrepair 
	 -- check to see if guild funds will cover Repair armor costs, if not, then pay out-of pocket.
	        if(CanMerchantRepair()) then
                local cost = GetRepairAllCost()
                if cost > 0 then
                        local money = GetMoney()
                        if IsInGuild() then
                                local guildMoney = GetGuildBankWithdrawMoney()
                                if guildMoney > GetGuildBankMoney() then
                                        guildMoney = GetGuildBankMoney()
                                end
                                if guildMoney > cost and CanGuildBankRepair() then
                                        RepairAllItems(1)
                                        --print(format("|cfff07100Repair cost covered by G-Bank: %.1fg|r", cost * 0.0001))
                                        print(("|cfff07100Repair cost covered by G-Bank: %dg %ds %dc"):format(cost / 100 / 100, (cost / 100) % 100, cost % 100))

                                        return
                                end
                        end
                        if money > cost then
                                RepairAllItems()
                                --print(format("|cffead000Repair cost: %.1fg|r", cost * 0.0001))
                                --print(("Repaired %dg %ds %dc"):format(cost / 100 / 100, (cost / 100) % 100, cost % 100));
                                print(("|cffead000Repair cost: %dg %ds %dc"):format(cost / 100 / 100, (cost / 100) % 100, cost % 100))
                        else
                                print("Not enough gold to cover the repair cost.")
                        end
                end
        end

SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
    SlashCmdList.RELOADUI = ReloadUI;

    --SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
    --SlashCmdList.FRAMESTK = function()
        --LoadAddOn("Blizzard_DebugTools");
        --FrameStackTooltip_Toggle();
end

--end
	--end
--/dump select(4, GetBuildInfo())



local L = LibStub("AceLocale-3.0"):GetLocale("ProspectButton")
local ProspectButton = CreateFrame("CheckButton","ProspectButton",UIParent,"SecureActionButtonTemplate")
ProspectButton:SetAttribute("type","macro")
local item_ore = GetItemSubClassInfo(LE_ITEM_CLASS_TRADEGOODS, 7) --Simple way to get ingame localized ItemType "Metal and Stone" through Auctionshouseframe translation
psn = 31252
prospect_spell = GetSpellInfo(psn) --SpellID for Prospecting


local function findore()
for bag=0,4 do	--search only in our bags for herbs 0=default bag 1 to 4 additional bagslots
		for slot=1,GetContainerNumSlots(bag) do			--start at slot 1
			local itemID = GetContainerItemID(bag, slot)
			local _, count = GetContainerItemInfo(bag, slot)
			if itemID then
				local itemName, itemLink, _, _, _, _, itemType = GetItemInfo(itemID)
				for i = 1, #ProspectButtonExpansions do
					if (ProspectButtonDB[itemID]) and count >= 5 then
						return bag, slot
					end
				end
				for i = 1, #ProspectButtonExpansions do
					if itemType==item_ore and ProspectButtonDB[itemID]==false and ProspectButtonSettings.extended==true then
					local itemName, itemLink, _, _, _, _, itemType = GetItemInfo(itemID)
						DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00ProspectButton: |r"..count.."x "..itemLink.." "..L["skipped"])
					end
				end
			end
		end
	end
end

function ProspectButtonSetup()
	local bag, slot = findore()
	if (not bag or not slot) or LootFrame:IsVisible() or CastingBarFrame:IsVisible() or UnitCastingInfo("player") then
	-- do nothing if no ore, if looting or casting
		ProspectButton:SetAttribute("macrotext","")
		if not bag then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00ProspectButton: |r"..L["error"])
		end
	else
		ProspectButton:SetAttribute("macrotext","/"..L["macro_cast"].." "..prospect_spell.."\n/"..L["macro_use"].." "..bag.." "..slot)
	end
end
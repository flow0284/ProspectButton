local L = LibStub("AceLocale-3.0"):GetLocale("ProspectButton")

ProspectButton_Dev = {
	debug = false
};

--[[ Optionstable ]]
ProspectButton_DefaultOptions = {
	extended = false,	--für die Optionale Chatausgabe der übersrpungenen Kräuter (entfällt evtl.)
	macroID = nil,		--falls man sich entscheiden sollte das generierte macro nicht mehr nutzen zu wollen muss es über die gespeicherte macroID gelöscht werden
};

--[[ Expansiontable ]]
ProspectButtonExpansions = {
	"Classic",
	"BC",
	"WotLK",
	"Cata",
	"MoP",
	"Legion",
	"BfA",
	"Shadowlands",
};

--[[ Expansion Logos ]]
ProspectButtonExpansionLogos = {
	[[Interface\Addons\ProspectButton\gfx\Classic]],
	[[Interface\Addons\ProspectButton\gfx\BC]],
	[[Interface\Addons\ProspectButton\gfx\WotLK]],
	[[Interface\Addons\ProspectButton\gfx\Cata]],
	[[Interface\Addons\ProspectButton\gfx\MoP]],
	[[Interface\Addons\ProspectButton\gfx\Legion]],
	[[Interface\Addons\ProspectButton\gfx\BfA]],
	[[Interface\Addons\ProspectButton\gfx\Shadowlands]],
};

--[[ Macronames ]]
macronames = {
	"ProspectButtonMacro", 
	"ProspectButton",
	"prospectButton",
	"prospectbutton",
	"Prospectbutton",
};

--[[ register some events]]
ADDON, Addon = ...
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("SKILL_LINES_CHANGED")
frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ProspectButton" then
		if ProspectButtonDB == nil then			
			ProspectButtonDB = {}
			DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00ProspectButton: |r Default settings loaded")
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00ProspectButton: |r Settings loaded")		
		end
		if ProspectButtonSettings == nil then
			ProspectButtonSettings = ProspectButton_DefaultOptions
		end
	end		
end)

Options = CreateFrame("Frame", ADDON.."Options", InterfaceOptionsFramePanelContainer)
	Options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
	InterfaceOptions_AddCategory(Options)
	Addon.OptionsPanel = Options
	
		Options:SetScript("OnShow", function()
			optionshown = 1
			local Title = Options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
			Title:SetPoint("TOPLEFT", 16, -16)
			Title:SetText(Options.name)
			
			local Notes = Options:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
			Notes:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
			Notes:SetPoint("RIGHT", -32, 0)
			Notes:SetHeight(8)
			Notes:SetJustifyH("LEFT")
			Notes:SetJustifyV("TOP")
			Notes:SetText("Version: "..GetAddOnMetadata(ADDON, "Version"))
			
			local OptionPanel = CreateFrame("Frame", nil, Options, BackdropTemplateMixin and "BackdropTemplate")
			OptionPanel:SetPoint("TOPLEFT", Notes, "BOTTOMLEFT", 0, -24)
			OptionPanel:SetPoint("BOTTOMRIGHT", Options, -16, 16)
			OptionPanel:SetBackdrop({
				bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true, tileSize = 16, edgeSize = 16,
				insets= { left = 3, right = 3, top = 5, bottom = 3 }
			})
			OptionPanel:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
			OptionPanel:SetBackdropBorderColor(0.4, 0.4, 0.4)
			
			local myCheckButton = CreateFrame("CheckButton", "myCheckButton_GlobalName", OptionPanel, "ChatConfigCheckButtonTemplate")
			myCheckButton:SetPoint("TOPLEFT", 16, -10)
			myCheckButton_GlobalNameText:SetText(" ProspectButton extended")
			--myCheckButton.tooltip = "This is where you place MouseOver Text."
			myCheckButton:SetScript("OnClick", function(self)
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				if self:GetChecked() == true then 
					ProspectButtonSettings.extended = self:GetChecked()
					if ProspectButton_Dev.debug == true then
						print(ProspectButtonSettings.extended)
					end
				else
					ProspectButtonSettings.extended = nil
					if ProspectButton_Dev.debug == true then
						print(ProspectButtonSettings.extended)
					end
				end			
			end)
			myCheckButton:SetChecked(ProspectButtonSettings.extended)

			local myButton0 = CreateFrame("Button", "MyButton0", OptionPanel, "UIPanelButtonTemplate")
			myButton0:SetText(L["toggle_minimapicon"])
			twidth = myButton0:GetTextWidth()
			myButton0:SetSize(twidth+20, 22)
			myButton0:SetPoint("TOPLEFT", 16, -40)
			myButton0:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				addon:ComMbtnMiniMapIcn()
			end)
		
			--Let's create the ProspectButton Macro
			local myButton1 = CreateFrame("Button", "MyButton1", OptionPanel, "UIPanelButtonTemplate")
			myButton1:SetText(L["create_macro"])
			twidth = myButton1:GetTextWidth()
			myButton1:SetSize(twidth+20, 22)
			myButton1:SetPoint("TOPLEFT", 16, -70)
			myButton1:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				CreateMacro("ProspectButtonMacro", "inv_misc_gem_bloodgem_01", "#showtooltip "..prospect_spell.."\n/run ProspectButtonSetup()\n/click ProspectButton", 1, 1)
				index = GetMacroIndexByName("ProspectButtonMacro")	--get macroid
				PickupMacro(index)								--Pickup the new macro for the user to place it on a actionbar			
				MyButton1:Disable()
				MyButton2:Enable()
				
			end)
			
			--Let's delete the ProspectButton Macro
			local myButton2 = CreateFrame("Button", "MyButton2", OptionPanel, "UIPanelButtonTemplate")
			myButton2:SetText(L["delete_macro"])
			twidth = myButton2:GetTextWidth()
			myButton2:SetSize(twidth+20, 22)
			myButton2:SetPoint("TOPLEFT", 140, -70)
			myButton2:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				foreach(macronames, function()			
					for i = 1, #macronames do
						mID = GetMacroIndexByName(macronames[i])
						if mID ~= 0 then
							DeleteMacro(mID)
						else
							MyButton1:Enable()
							MyButton2:Disable()
						end
					end
				end)
			end)
			
			foreach(macronames, function()
				for i = 1, #macronames do
					mID = GetMacroIndexByName(macronames[i])
					if mID == 0 then
						return
					end
					if mID > 0 then
						MyButton1:Disable()
						MyButton2:Enable()
					else
						MyButton1:Enable()
						MyButton2:Disable()
					end
				end
			end)
			
			for i = 1, #ProspectButtonExpansions do
				-- Make a child panel
				local Options_Child = CreateFrame("Frame", ADDON.."Child", Options)
				Options_Child.name = ProspectButtonExpansions[i]
				Options_Child.id = i+1
				-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
				Options_Child.parent = Options.name
				-- Add the child to the Interface Options
				InterfaceOptions_AddCategory(Options_Child)
				
				local texframe = CreateFrame("Frame", nil, Options_Child)
				texframe:SetWidth(200)
				texframe:SetHeight(100)
				texframe:SetPoint("TOPLEFT", 16, -8)
				texframe.texture = texframe:CreateTexture(nil, "OVERLAY")
				texframe.texture:SetAllPoints(texframe)
				texframe.texture:SetTexture(ProspectButtonExpansionLogos[i],1)
				
				local SubOptionPanel = CreateFrame("Frame", nil, Options_Child, BackdropTemplateMixin and "BackdropTemplate")
				SubOptionPanel:SetPoint("TOPLEFT", texframe, "BOTTOMLEFT", 0, 0)
				SubOptionPanel:SetPoint("BOTTOMRIGHT", Options_Child, -16, 16)
				SubOptionPanel:SetBackdrop({
					bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
					tile = true, tileSize = 16, edgeSize = 16,
					insets= { left = 3, right = 3, top = 5, bottom = 3 }
				})
				SubOptionPanel:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
				SubOptionPanel:SetBackdropBorderColor(0.4, 0.4, 0.4)
				
				Options_Child:SetScript("OnShow",
					function(self)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
					--checkboxes begin
					local expansion = Options_Child.name
					--wenn noch keine checkboxen vorhanden dann erstmal erstellen
					if not self.oreCheckboxes or self.oreCheckboxes then
						self.oreCheckboxes = {}
						--ankerpunkt für die erste checkbox
						local tAnchorPointY = -120
						local tAnchorPointX  = 30
						local tAnchorPointCount  = 0
						--alle kräuter der jeweiligen untertabelle durchgehen und jeweils eine checkbox erstellen
						for itemID, optionValue in pairs(ProspectButton_OreList[expansion]) do
							
							--name des krauts für das label der checkbox holen
							local itemName = L[tostring(itemID)]
							local itemcount = GetItemCount(itemID, true)
							--checkbox erstellen (siehe helper function unten) und für späteren zugriff referenz auf checkbox-objekt mit itemid vom kraut als index in oreCheckboxes speichern
							self.oreCheckboxes[itemID] = Addon:CreateOptionsCheckButton(self, itemName, itemID, itemcount)
							self.oreCheckboxes[itemID].itemID = itemID
							table.sort(self.oreCheckboxes[itemID])
							--passend anordnen
							self.oreCheckboxes[itemID]:SetPoint("TOPLEFT", self, "TOPLEFT", tAnchorPointX, tAnchorPointY)
							--ankerpunkt für die nächste checkbox
							tAnchorPointY = tAnchorPointY - self.oreCheckboxes[itemID]:GetHeight()
							tAnchorPointCount = tAnchorPointCount + 1
							if tAnchorPointCount > 16 then
								tAnchorPointX = tAnchorPointX + 200
								tAnchorPointY = -120
								tAnchorPointCount = 0
							end 
						end
					end
					--alle inhalte self.oreCheckboxes durchgehen und den aktuellen wert (checked/nicht checked bzw. true/false) für die checkbox entsprechend der db festlegen
					for itemID, checkboxObj in pairs(self.oreCheckboxes) do
						
						--wert der checkbox entsprechend der tabelle festlegen
						if ProspectButtonDB[itemID]==true then
							if ProspectButton_Dev.debug == true then
								print("DB_expansion: "..expansion)
								print("DB_itemID: "..itemID)
							end
							checkboxObj:SetChecked(ProspectButtonDB[itemID])
						else
							if ProspectButton_Dev.debug == true then
								print("HL_expansion: "..expansion)
							end
							checkboxObj:SetChecked(ProspectButton_OreList[expansion][itemID])
						end
						
						--bei wertänderung auf true in der db speichern
						checkboxObj:SetScript("OnClick", function(self)
							PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
							if ProspectButton_Dev.debug == true then
								print(self:GetParent().name)
								print(self.itemID)
							end
							if self:GetChecked() == true then
								ProspectButtonDB[self.itemID] = self:GetChecked()
							end
							if self:GetChecked() == false then
								ProspectButtonDB[self.itemID] = nil
							end
						end)
					end
					--checkboxes end
				end)
			end
			Options:SetScript("OnShow", nil)
		end)
	
SLASH_PROSPECTBUTTON1 = "/prospectbutton"
SLASH_PROSPECTBUTTON2 = "/pbtn"
SlashCmdList.PROSPECTBUTTON = function() InterfaceOptionsFrame_OpenToCategory(Options) end

--[ Checkbox HELPERS Beginn ]
function Addon:CreateOptionsCheckButton(pParentFrame, pLabelText, pLabelID, pItemCount)
	local name = "CBF"..pLabelID
    local tCheckBoxFrame = CreateFrame("CheckButton", name, pParentFrame, "ChatConfigCheckButtonTemplate")
    tCheckBoxFrame:SetWidth(25)
    tCheckBoxFrame:SetHeight(25)
    tCheckBoxFrame:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
    tCheckBoxFrame:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
    tCheckBoxFrame:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
    tCheckBoxFrame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
    tCheckBoxFrame:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
    tCheckBoxFrame:SetFrameStrata("HIGH")
	_G[name.."Text"]:SetText(" "..pLabelText.." ("..pItemCount..")")
    tCheckBoxFrame:Show()
	
	--[[ should be obsolete ]]
	--[[
	local tFS = tCheckBoxFrame:CreateFontString(nil, "ARTWORK")
    tCheckBoxFrame.fontstring = tFS
    --tFS:SetFont("Fonts\\ARIALN.TTF", 12)
    tFS:SetFontObject(GameFontNormal)
	tFS:SetText(pLabelText)
    tFS:SetTextColor(1, 1, 1, 1)
    tFS:SetJustifyH("LEFT")
    tFS:SetJustifyV("TOP")
    tFS:SetPoint("LEFT", tCheckBoxFrame, "RIGHT", 0, 0)
    tFS:Show()
	]]
	
	tCheckBoxFrame:SetScript("OnEnter", function(self)			
		if ( IsModifierKeyDown() ) then
			GameTooltip_SetDefaultAnchor( GameTooltip, UIParent )
			GameTooltip:SetItemByID(pLabelID)
			GameTooltip:Show()
		end
	end)
	tCheckBoxFrame:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
    return tCheckBoxFrame
end
--[ Checkbox HELPERS Ende ]

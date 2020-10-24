addon = LibStub("AceAddon-3.0"):NewAddon("ProspectButton", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ProspectButton")
local ProspectButtonLDB = LibStub("LibDataBroker-1.1"):NewDataObject("ProspectButtonIcon", {
	type = "launcher",
	text = "ProspectButton",
	icon = "Interface\\Icons\\inv_misc_gem_bloodgem_01",
	OnClick = function(_, button) 
		if button == "LeftButton" then
			if InterfaceOptionsFrame:IsVisible() then
				InterfaceOptionsFrame:Hide()
				-- Hide the UI panel behind blizz options.
				HideUIPanel(GameMenuFrame)
			else
			InterfaceOptionsFrame_OpenToCategory("ProspectButton")
			Options:SetScript("OnShow", nil)
			end
		end
	end,
	OnTooltipShow = function(tooltip)
		tooltip:SetText("ProspectButton")
		tooltip:AddLine(GetAddOnMetadata(ADDON, "Version"),1,1,1)
		tooltip:AddLine(" ")
		tooltip:AddLine(L["l_mouse1"]..": |cFFFFFFFF"..L["l_mouse2"].."|r")
		tooltip:Show()
	end
})

local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ProspectButtonMinimap", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})
	icon:Register("ProspectButtonIcon", ProspectButtonLDB, self.db.profile.minimap)
	self:RegisterChatCommand("pbtnmmap", "ComPbtnMiniMapIcn")
end

function addon:ComPbtnMiniMapIcn()
	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
	if self.db.profile.minimap.hide then
		icon:Hide("ProspectButtonIcon")
	else
		icon:Show("ProspectButtonIcon")
	end
end
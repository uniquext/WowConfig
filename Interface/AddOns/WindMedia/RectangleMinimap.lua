local E, L, V, P, G = unpack(ElvUI)
local RM = E:NewModule("RectangleMinimap")
local M = E:GetModule("Minimap")

local _G = _G

local function SetRectangleMinimap()
    if not E.private.general.minimap.enable then
		_G.Minimap:SetMaskTexture("Textures\\MinimapMask")
		return
	end
	
    local Minimap = _G.Minimap
    local MMHolder = _G.MMHolder
	
    Minimap:SetMaskTexture("Interface\\Skin\\BG\\rectangle")
	
    Minimap.backdrop:Hide()
    Minimap:SetHitRectInsets(0, 0, E.MinimapSize / 8, E.MinimapSize / 8)
    Minimap:SetClampedToScreen(true)
    Minimap:SetClampRectInsets(0, 0, 0, 0)
	
    MMHolder:Height((Minimap:GetHeight() + E.Border + E.Spacing * 3) * .75)
    local temp = Minimap:GetHeight() - ((Minimap:GetHeight() + E.Border + E.Spacing * 3) * .75)
    Minimap:ClearAllPoints()
    Minimap:Point("TOPRIGHT", MMHolder, "TOPRIGHT", 0, temp / 2)
end

function RM:Initialize()
    hooksecurefunc(M, "UpdateSettings", SetRectangleMinimap)
end

local function InitializeCallback()
    RM:Initialize()
end

E:RegisterModule(RM:GetName(), InitializeCallback)